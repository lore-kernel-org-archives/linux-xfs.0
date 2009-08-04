Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74L3wvg192911
	for <linux-xfs@oss.sgi.com>; Tue, 4 Aug 2009 16:04:03 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 256823A5DBC
	for <linux-xfs@oss.sgi.com>; Tue,  4 Aug 2009 14:04:48 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id WJ55EpgdmQbLoQnO for <linux-xfs@oss.sgi.com>;
	Tue, 04 Aug 2009 14:04:48 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MYRBc-0005w0-Hh
	for linux-xfs@oss.sgi.com; Tue, 04 Aug 2009 21:04:44 +0000
Received: from adsl-75-61-228-198.dsl.chcgil.sbcglobal.net ([75.61.228.198])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 04 Aug 2009 21:04:44 +0000
Received: from kononov by adsl-75-61-228-198.dsl.chcgil.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 04 Aug 2009 21:04:44 +0000
From: Roman Kononov <kononov@ftml.net>
Subject: Re: failed assertion related to realtime section
Date: Tue, 04 Aug 2009 16:04:32 -0500
Message-ID: <4A78A260.1040501@ftml.net>
References: <h3gd94$clb$1@ger.gmane.org>	<bzyzlb6p239.fsf@fransum.emea.sgi.com>
	<4A5E7109.7000808@ftml.net> <bzyfxcxgd3z.fsf@fransum.emea.sgi.com>
Mime-Version: 1.0
In-Reply-To: <bzyfxcxgd3z.fsf@fransum.emea.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

On 2009-07-16 05:02, Olaf Weber wrote:
> A quick test on an available system
> running a (much) older kernel runs to completion, so this appears to
> be a regression.

With which kernel version did you run the test?

> Figuring out exactly when/where this regressed will take time.

I went back to 2.6.23 and the same assfail happened with somewhat different 
call trace:

Assertion failed: xfs_trans_get_block_res(tp) > 0, file: 
/home/rk/linux-2.6.23/fs/xfs/xfs_bmap.c, line: 5523

Call Trace:
  [<ffffffff80356a08>] xfs_bunmapi+0x8e8/0x1060
  [<ffffffff80227d2a>] dequeue_entity+0x7a/0xb0
  [<ffffffff80380608>] xfs_itruncate_finish+0x398/0x5c0
  [<ffffffff803a2323>] xfs_free_eofblocks+0x263/0x2b0
  [<ffffffff803a4838>] xfs_release+0x118/0x1e0
  [<ffffffff803ae42a>] xfs_file_release+0x1a/0x30
  [<ffffffff802827cd>] __fput+0xcd/0x1e0
  [<ffffffff8027f5c4>] filp_close+0x54/0x90
  [<ffffffff80280e3d>] sys_close+0x9d/0x110
  [<ffffffff8020bc9e>] system_call+0x7e/0x83

I tried to go back to 2.6.22.19 and older, and the test did not run at all 
failing to mount:

XFS: bad version
XFS: SB validate failed

Any suggestions?

Roman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
