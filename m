Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA63D1E3DC8;
	Mon, 16 Jun 2025 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083618; cv=none; b=sfdFCKK/+lJMoDyLczjOlIwdd++izthZ68Qz2hI35xwPbAQiUPLBOwGwYxBPABHCy4aFFFxLHpA/jOL2qdrMR2Ln6MRov50SyYxdpTdjCRfxjQ1UNgZIFdaPhrC+bBylPA/btmnDP3EGl65icqw8Mm/evZ7fWSMhtJyiuUtP+sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083618; c=relaxed/simple;
	bh=5VWXqZdx5bHEsn2TTU4QzarqvjeYWZnzjhf4oRIXkeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mj9ZhT7/UjsnWBULkNMWuXVuzHQxMm32iGnkitSFIl2fAS0aPANNn+zWDyvjqebadmLlWJ9rICEk7AwXo8SC09bglruaivTZVwbdomBXW7guaTVdSLFsyP03qvydTxBTdbMBOxn/cq7RkvO6uRe2ZJzKb/ZackynDTg7zNUXRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIHfdJNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIHfdJNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EECC4CEED;
	Mon, 16 Jun 2025 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750083618;
	bh=5VWXqZdx5bHEsn2TTU4QzarqvjeYWZnzjhf4oRIXkeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AIHfdJNSkuYgsaxM0qaDazavZaSg2vUfWTZyhyQompAF2X/to5We+7QwEbMhke9kV
	 ZmszBXMrKVRBtS/fZseGYRcHmgT6Ms/YSiP+TV6BavSEsZdVHaHkD9bB1stxFMC/Nz
	 k7inkPZmeH6kEpRUpKe3Li9FZW2kMBmhRqq0UD5E=
Date: Mon, 16 Jun 2025 16:20:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: cem@kernel.org, skhan@linuxfoundation.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] fs/xfs: use scnprintf() in show functions
Message-ID: <2025061610-basics-attendee-cd02@gregkh>
References: <20250616110313.372314-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616110313.372314-1-pranav.tyagi03@gmail.com>

On Mon, Jun 16, 2025 at 04:33:13PM +0530, Pranav Tyagi wrote:
> Replace all snprintf() instances with scnprintf(). snprintf() returns
> the number of bytes that would have been written had there been enough
> space. For sysfs attributes, snprintf() should not be used for the
> show() method. Instead use scnprintf() which returns the number of bytes
> actually written.

No, please use sysfs_emit() if you really want to change this.

> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  fs/xfs/xfs_sysfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 7a5c5ef2db92..f7206e3edea2 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -257,7 +257,7 @@ larp_show(
>  	struct kobject	*kobject,
>  	char		*buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);

There is nothing wrong with the original code here, you could use
sprintf() and it too is ok.  So this type of change is not needed.  But
again, if you really want to, use sysfs_emit() instead.

Same for all the other show() callback changes you just made.

thanks,

greg k-h
