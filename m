Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p181EbJU080953 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 19:14:37 -0600
Subject: Re: [patch] xfsprogs: unhandled error check in libxfs_trans_read_buf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <AANLkTim2nm9SXPmpRUmK8eWxXYFkPcrzc-gw2ceJ-m2-@mail.gmail.com>
References: <AANLkTim2nm9SXPmpRUmK8eWxXYFkPcrzc-gw2ceJ-m2-@mail.gmail.com>
Date: Mon, 07 Feb 2011 19:17:03 -0600
Message-ID: <1297127823.2078.24.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, 2011-02-03 at 15:17 +0900, Ajeet Yadav wrote:
> xfsprogs: unhandled error check in libxfs_trans_read_buf

Sorry you didn't get a response earlier.  Reporting
problems like this--especially if they come with a
proposed fix--is always appreciated.

> libxfs_trans_read_buf() is used in both mkfs.xfs & xfs_repair.
> During stability testing we found some time occur pagefault in mkfs.xfs,
> code inspection shows that if libxfs_readbuf() fails then occurs a
> page fault in xfs_buf_item_init() called in libxfs_trans_read_buf().
> 
> mkfs.xfs: unhandled page fault (11) at 0x00000070, code 0x017
> 
> Added NULL check and errno handling.

I expect there are other similar problems lurking in
the libxfs code.

I think your change looks good, with one exception,
noted below.  I will gladly adjust your patch for
you if you consent to the change I suggest.

					-Alex

> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> 
> diff -Nurp xfsprogs/libxfs/rdwr.c xfsprogs-dirty/libxfs/rdwr.c
> --- xfsprogs/libxfs/rdwr.c      2011-01-28 20:22:11.000000000 +0900
> +++ xfsprogs-dirty/libxfs/rdwr.c        2011-02-02 16:59:16.000000000 +0900
> @@ -207,10 +207,11 @@ libxfs_trace_readbuf(const char *func, c
>  {
>         xfs_buf_t       *bp = libxfs_readbuf(dev, blkno, len, flags);
> 
> -       bp->b_func = func;
> -       bp->b_file = file;
> -       bp->b_line = line;
> -
> +       if (bp){
> +               bp->b_func = func;
> +               bp->b_file = file;
> +               bp->b_line = line;
> +       }
>         return bp;
>  }
> 
> @@ -485,6 +486,7 @@ libxfs_readbuf(dev_t dev, xfs_daddr_t bl
>                 error = libxfs_readbufr(dev, blkno, bp, len, flags);
>                 if (error) {
>                         libxfs_putbuf(bp);
> +                       errno = error;

I think that libxfs_readbuf() simply returns the
value of the special global "errno" if there is
an error.  And I believe that at this point it
will not have been changed, so there's no need
to assign it here.

In other words, I'd like to remove this one piece
of your patch.

>                         return NULL;
>                 }
>         }
> diff -Nurp xfsprogs/libxfs/trans.c xfsprogs-dirty/libxfs/trans.c
> --- xfsprogs/libxfs/trans.c     2011-01-28 20:22:11.000000000 +0900
> +++ xfsprogs-dirty/libxfs/trans.c       2011-02-02 17:00:42.000000000 +0900
> @@ -508,6 +508,10 @@ libxfs_trans_read_buf(
>         }
> 
>         bp = libxfs_readbuf(dev, blkno, len, flags);
> +       if (!bp){
> +               *bpp = NULL;
> +               return errno;
> +       }
>  #ifdef XACT_DEBUG
>         fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
>  #endif
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
