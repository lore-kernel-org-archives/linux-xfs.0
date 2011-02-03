Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1347ZQB109344 for <xfs@oss.sgi.com>; Wed, 2 Feb 2011 22:07:36 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56EAB2A8915
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 20:10:04 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id ObcvpOAv2Fi3VbGf for
	<xfs@oss.sgi.com>; Wed, 02 Feb 2011 20:10:04 -0800 (PST)
Message-ID: <4D4A2A9B.6090803@sandeen.net>
Date: Wed, 02 Feb 2011 22:10:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs pagefault when removed storage during operation
References: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>
In-Reply-To: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>
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
Cc: xfs@oss.sgi.com

On 2/1/11 5:06 AM, Ajeet Yadav wrote:
> We are testing mkfs.xfs and xfs_repair stability to look for crashes
> and other issues specially with removable devices.
> And unfortunately crashes does occur.
> Code inspection shows in most cases the caller does not handle
> libxfs_readbuf() for error cases i.e when return value = NULL.
> 
> Now I need your suggestion.
> We should fix all such cases or the simplest way is to exit... if
> read() or write() fails with EIO errorno in libxfs_readbufr() and
> libxfs_writebufr().

I see very little reason to gracefully handle all error cases
during mkfs. It would be prettier, yes, but if mkfs fails, with
or without an error, with or without a segfault, you have to 
just start it over anyway, right?

I think there are better places to focus effort.

-Eric

> Fortunately these function already support exit, if we use flag
> LIBXFS_EXIT_ON_FAILURE, LIBXFS_B_EXIT but they are used selectively.
> 
> The current problem is related to function libxfs_trans_read_buf()
> 
>        bp = libxfs_readbuf(dev, blkno, len, flags);
> #ifdef XACT_DEBUG
>         fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
> #endif
>         xfs_buf_item_init(bp, tp->t_mountp);
>         bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
>         bip->bli_recur = 0;
>         xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> 
>         /* initialise b_fsprivate2 so we can find it incore */
>         XFS_BUF_SET_FSPRIVATE2(bp, tp);
>         *bpp = bp;
>         return 0;
> 
> if  libxfs_readbuf() fails due to device removal or other error, bp = NULL.
> In function xfs_buf_item_init(bp, tp->t_mountp) as soon as bp is
> dereferenced occurs
> 
> mkfs.xfs: unhandled page fault (11) at 0x00000070, code 0x017
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
