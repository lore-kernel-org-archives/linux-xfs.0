Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2C2262FFC
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 04:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755491985; cv=none; b=DPEIyEHbr/rsrHzGBC/qjC8dcOebI74cIct4iek2ebTCJtagIH5FCd7FNLOmGKheE+jvmlZv9p9TmvLSn2KxtU1aH2KmCnPPE0RvA+lTdv7mCN/Knzc2bI9RlecYu043S/h1wP8ddV2XUCtpX6JzSyK9yfjCDqiwBECE9YcL1r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755491985; c=relaxed/simple;
	bh=j5jUXmKwmVr0PX4jsuZao2RLlrtVKECt1joJJRP43Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wjq/wxfyEsw14LUZd6ago2uW/z15jYm1nZdqSF+w/XUZDZcoSVoEIECEw8IfiUG8wti09ErSknvEWZBSKDYVLShV65tCfoF7EEWQWa1J5t/5PrxPb5D41FFb9NlgynzxVSJ1I0spf0/MqI6c0Olv7u7iBisVASGcpPK4djNJGTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9723167373; Mon, 18 Aug 2025 06:39:29 +0200 (CEST)
Date: Mon, 18 Aug 2025 06:39:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux@treblig.org
Cc: dave@treblig.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH] man: Fix XFS_IOC_GETPARENTS ioctl example
Message-ID: <20250818043928.GA14427@lst.de>
References: <20250816002842.112518-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816002842.112518-1-linux@treblig.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Aug 16, 2025 at 01:28:42AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Fix various typos that stopped the example building.
> Add perror calls everywhere so it doesn't fail silently
> and mysteriously.
> 
> Now builds cleanly with -Wpedantic.
> 
> Fixes: a24294c2 ("man: document the XFS_IOC_GETPARENTS ioctl")
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  man/man2/ioctl_xfs_getparents.2 | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
> index 5bb9b96a..63926016 100644
> --- a/man/man2/ioctl_xfs_getparents.2
> +++ b/man/man2/ioctl_xfs_getparents.2
> @@ -119,7 +119,7 @@ If the name is a zero-length string, the file queried has no parents.
>  Calling programs should allocate a large memory buffer, initialize the head
>  structure to zeroes, set gp_bufsize to the size of the buffer, and call the
>  ioctl.
> -The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_flags when there are no
> +The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_oflags when there are no
>  more parent pointers to be read.
>  The below code is an example of XFS_IOC_GETPARENTS usage:
>  
> @@ -142,16 +142,20 @@ int main() {
>  		perror("malloc");
>  		return 1;
>  	}
> -	gp->gp_bufsize = 65536;
> +	gp.gp_bufsize = 65536;
>  
> -	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
> -	if (fd  == -1)
> +	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT, 0666);
> +	if (fd  == -1) {
> +    perror("open");
>  		return errno;
> +  }

Formatting looks really weird here, probably because of a mix of
tabs and space an different tabstop settings for the original version
of the code and your edits.

The technical changes look good to me.
