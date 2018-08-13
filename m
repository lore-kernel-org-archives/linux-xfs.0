Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39366 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeHMKs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:48:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id h10-v6so13413900wre.6
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 01:07:18 -0700 (PDT)
Date: Mon, 13 Aug 2018 10:07:15 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] iomap: fix WARN_ON_ONCE on uninitialized variable
Message-ID: <20180813080715.tl4hoidzlpdh2kr7@odin.usersys.redhat.com>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400172814.27471.988480858889151684.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400172814.27471.988480858889151684.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 9dc55f1389f9569 ("iomap: add support for sub-pagesize buffered
> I/O without buffer heads") we moved the initialization of poff (it's
> computed from pos) into a separate helper function.  Inline data only
> ever deals with pos == 0, hence the WARN_ON_ONCE, but now we're testing
> an uninitialized variable.
> 
> Therefore, change the test to check the parameter directly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 8bd54c08deee..8a18163dc432 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -290,7 +290,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  	sector_t sector;
>  
>  	if (iomap->type == IOMAP_INLINE) {
> -		WARN_ON_ONCE(poff);
> +		WARN_ON_ONCE(pos);
>  		iomap_read_inline_data(inode, page, iomap);
>  		return PAGE_SIZE;
>  	}
> 

-- 
Carlos
