Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11B42E2182435 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 05:04:02 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A1682A25F2
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 03:06:29 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	W2dIHOPzCyNSVZxI for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 03:06:29 -0800 (PST)
Received: by qyk12 with SMTP id 12so7341435qyk.5
	for <xfs@oss.sgi.com>; Tue, 01 Feb 2011 03:06:29 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 20:06:29 +0900
Message-ID: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>
Subject: mkfs.xfs pagefault when removed storage during operation
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: xfs@oss.sgi.com

We are testing mkfs.xfs and xfs_repair stability to look for crashes
and other issues specially with removable devices.
And unfortunately crashes does occur.
Code inspection shows in most cases the caller does not handle
libxfs_readbuf() for error cases i.e when return value = NULL.

Now I need your suggestion.
We should fix all such cases or the simplest way is to exit... if
read() or write() fails with EIO errorno in libxfs_readbufr() and
libxfs_writebufr().
Fortunately these function already support exit, if we use flag
LIBXFS_EXIT_ON_FAILURE, LIBXFS_B_EXIT but they are used selectively.

The current problem is related to function libxfs_trans_read_buf()

       bp = libxfs_readbuf(dev, blkno, len, flags);
#ifdef XACT_DEBUG
        fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
#endif
        xfs_buf_item_init(bp, tp->t_mountp);
        bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
        bip->bli_recur = 0;
        xfs_trans_add_item(tp, (xfs_log_item_t *)bip);

        /* initialise b_fsprivate2 so we can find it incore */
        XFS_BUF_SET_FSPRIVATE2(bp, tp);
        *bpp = bp;
        return 0;

if  libxfs_readbuf() fails due to device removal or other error, bp = NULL.
In function xfs_buf_item_init(bp, tp->t_mountp) as soon as bp is
dereferenced occurs

mkfs.xfs: unhandled page fault (11) at 0x00000070, code 0x017

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
