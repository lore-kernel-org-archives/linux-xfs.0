Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:35551 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752830AbdHWBB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 21:01:58 -0400
Date: Wed, 23 Aug 2017 11:01:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] libxfs: handle 0 blocksize or sectorsize in cvtnum
Message-ID: <20170823010153.GZ21024@dastard>
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
 <2e0acf4a-a863-8304-65d3-5027368c69e2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e0acf4a-a863-8304-65d3-5027368c69e2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 22, 2017 at 04:12:48PM -0500, Eric Sandeen wrote:
> Blocksize and sectorsize are unique in that they must
> be provided, unlike every other suffix which can be
> calculated from constants.
> 
> Nothing protects against unspecified block & sector size,
> so catch it if it happens and return a parsing error.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> index 7a69dc1..7b86225 100644
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -330,8 +330,12 @@ cvtnum(
>  	c = tolower(*sp);
>  	switch (c) {
>  	case 'b':
> +		if (!blocksize)
> +			return -1LL;
>  		return i * blocksize;
>  	case 's':
> +		if (!sectorsize)
> +			return -1LL;
>  		return i * sectorsize;
>  	case 'k':
>  		return KILOBYTES(i);

With this you could have mkfs call the generic function, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
