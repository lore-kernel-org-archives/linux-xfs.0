Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G6mUCM179107 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 01:48:30 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id ziR7bZwhrQ9XquNC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 23:48:28 -0700 (PDT)
Message-ID: <4F8BC0B9.90604@profihost.ag>
Date: Mon, 16 Apr 2012 08:48:25 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: XFS blocked task in xlog_cil_force_lsn
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
To: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Philipp Herz - Profihost AG <p.herz@profihost.ag>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

today i've seen this call trace / block in XFS while running 3.0.27.

INFO: task xfsaild/sdc3:1818 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsaild/sdc3    D ffff88041f374dc8     0  1818      2 0x00000000
ffff88041edd3d30 0000000000000046 ffff8803ecaa8dc0 ffff88041f23fe28
ffff88041f374860 0000000000010800 ffff88041edd3fd8 ffff88041edd2010
ffff88041edd3fd8 0000000000010800 ffff88041f15c860 ffff88041f374860
Call Trace:
 [<ffffffff8159c94a>] schedule+0x3a/0x60
 [<ffffffff812763a9>] xlog_cil_force_lsn+0xe9/0x110
 [<ffffffff8104caf0>] ? try_to_wake_up+0x2a0/0x2a0
 [<ffffffff81273922>] _xfs_log_force+0x62/0x250
 [<ffffffff81273d23>] xfs_log_force+0x13/0x40
 [<ffffffff81281ac7>] ? xfs_trans_ail_cursor_next+0x27/0x30
 [<ffffffff81282237>] xfsaild+0x447/0x460
 [<ffffffff81281df0>] ? xfs_trans_ail_init+0xb0/0xb0
 [<ffffffff8106f646>] kthread+0x96/0xa0
 [<ffffffff815a0214>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106f5b0>] ? kthread_worker_fn+0x130/0x130
 [<ffffffff815a0210>] ? gs_change+0xb/0xb

Is there a known fix / patch available?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
