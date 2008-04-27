Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 21:18:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3R4HwAD003759
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 21:17:59 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 591F710C0B3B
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 21:18:38 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157]) by cuda.sgi.com with ESMTP id 6FSsjlDdAsk6lYM5 for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 21:18:38 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so3742055fga.8
        for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 21:18:37 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] vfs: reduce stack usage by shrinking struct kiocb
Date: Sun, 27 Apr 2008 06:17:36 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_g5/EI0ZahsCaZ9p"
Message-Id: <200804270617.36629.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Benjamin LaHaise <bcrl@kvack.org>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org

--Boundary-00=_g5/EI0ZahsCaZ9p
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al, Benjamin, David,

struct kiocb is placed on stack by, for example, do_sync_write().
Eventually it contributes to xfs writeout path's stack usage, among others.
This is *the* path which causes 4k stack overflows on i386 with xfs.

This patch trivially reorders fields of this structure,
and makes some of them smaller.

Reordering helps 64-bit architectures:
int, void*, int, void* - bad,
int, int, void*, void* - better.

These fields are made smaller:
ki_flags: long -> short: possible values are 0,1,2, so short is enough.
ki_nr_segs: ulong -> uint: nobody uses 4 billion element writev's
                           (and it would not work anyway)
ki_cur_seg: same

For 32bit x86, it makes this struct only 4 bytes smaller.
This isn't much, but it helps not only xfs, but all filesystems.

For 64-bit case savings are a bit more significant,
as ulong -> uint actually makes a difference, and reordering
of 64-bit fields eliminates some padding.

Only compile tested. Observed stack reductions on 32 bits:

-sock_recvmsg [vmlinux]:                        196
-sock_sendmsg [vmlinux]:                        196
+sock_recvmsg [vmlinux]:                        192
+sock_sendmsg [vmlinux]:                        192
-do_sync_write [vmlinux]:                       140
-do_sync_read [vmlinux]:                        140
+do_sync_write [vmlinux]:                       136
+do_sync_read [vmlinux]:                        136
-do_sync_readv_writev [vmlinux]:                132
+do_sync_readv_writev [vmlinux]:                128

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_g5/EI0ZahsCaZ9p
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk4.diff"

diff -urpN linux-2.6-xfs1/include/linux/aio.h linux-2.6-xfs1.stk4/include/linux/aio.h
--- linux-2.6-xfs1/include/linux/aio.h	2008-03-30 03:27:54.000000000 +0200
+++ linux-2.6-xfs1.stk4/include/linux/aio.h	2008-04-27 05:47:09.000000000 +0200
@@ -86,7 +86,8 @@ struct kioctx;
  */
 struct kiocb {
 	struct list_head	ki_run_list;
-	unsigned long		ki_flags;
+	unsigned short		ki_flags; /* range: 0..2 */
+	unsigned short		ki_opcode;
 	int			ki_users;
 	unsigned		ki_key;		/* id of this request */
 
@@ -102,23 +103,22 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
+	wait_queue_t		ki_wait;
 
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
+	/*unsigned short	ki_opcode; - moved up for denser packing */
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
 	size_t			ki_left; 	/* remaining bytes */
+	unsigned		ki_nr_segs;
+	unsigned		ki_cur_seg;
 	struct iovec		ki_inline_vec;	/* inline vector */
+	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
  	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying file* to deliver event to.

--Boundary-00=_g5/EI0ZahsCaZ9p--
