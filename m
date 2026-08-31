Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1132E06EF
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 07:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160245; cv=none; b=t2TN5+DC6mI3VfpQkstiVSgU7hJqUi8oAk0b4LAB9TaXg0qjzMiPtBgRpd/KLkeveA6SMAiTbgNbgD7a/nJMM57HTnNAxinnpHrcFznR4ibWnzYoG6PVZd2rQpfuYmgo5czf5Gv2kvatb3hbwb7PqMw3w/dfuANZnsz5x6NfrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160245; c=relaxed/simple;
	bh=yVNyCl1ct4ONOvjEXxJ8TmRIBxMahMJC0dMTW7eOsds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjordEdYvgeoeCvisFp/1kJ06Um9NXgKV+s+L1x+cVnrNcWnbOCCtoU2CxJiLbE07YL1y5fjEyu7JqyHRc9QPtIEFk7uONnfwLONC6rg7tKlY88j3gWJ0x2A9tgpNs3rZEELs76MpA2eF7L7O1ognK2Ll+hayJqmJPR0+nl1hDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C43568BFE; Mon, 31 Aug 2026 09:10:40 +0200 (CEST)
Date: Mon, 31 Aug 2026 09:10:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	hch@lst.de, djwong@kernel.org
Subject: Re: [PATCH] libxfs: report device open errors during topology
 probing
Message-ID: <20260831071039.GA25070@lst.de>
References: <20260827112855.70037-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827112855.70037-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 27, 2026 at 01:28:55PM +0200, Hans Holmberg wrote:
> mkfs probes the device topology before libxfs_init opens the target.
> If blkid cannot open the device, blkid_new_probe_from_filename returns
> NULL and leaves the topology sector sizes initialized to zero.  This
> causes mkfs to report the misleading error "illegal sector size 0".
> 
> Report the underlying open error immediately so that permission
> failures are diagnosed correctly. For example:
> 
> cannot probe device topology for device /dev/nvme1n1: Permission denied

Did you also accidentally run mkfs as a regular users? :)  That's how
I ran into this, but didn't get around fixing it.

> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
>  libxfs/topology.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index dc2aaa17..5571c9d8 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -230,8 +230,12 @@ blkid_get_topology(
>  	blkid_probe pr;
>  
>  	pr = blkid_new_probe_from_filename(device);
> -	if (!pr)
> -		return;
> +	if (!pr) {
> +		fprintf(stderr,
> +			_("cannot probe device topology for device %s: %s\n"),
> +			device, strerror(errno));
> +		exit(EXIT_FAILURE);
> +	}

I wonder if there are any valid failures from blkid_new_probe_from_filename
where we'd want to continue?  Probably not as it doesn't really have an
obvious failure path, but so far we continue here.  So the print is useful
for sure, but I wonder if failing here might cause regressions in some
really odd use case (containers without sysfs?  Although we'd run into
trouble with that quickly in other places).

