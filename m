Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n75NL3bk013834
	for <linux-xfs@oss.sgi.com>; Wed, 5 Aug 2009 18:21:04 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C601612AFF4E
	for <linux-xfs@oss.sgi.com>; Wed,  5 Aug 2009 16:31:23 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id zz1OgWFkmaypDEGr for <linux-xfs@oss.sgi.com>;
	Wed, 05 Aug 2009 16:31:23 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MYpnp-00007J-Gg
	for linux-xfs@oss.sgi.com; Wed, 05 Aug 2009 23:21:49 +0000
Received: from adsl-71-147-53-109.dsl.emhril.sbcglobal.net ([71.147.53.109])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 05 Aug 2009 23:21:49 +0000
Received: from kononov by adsl-71-147-53-109.dsl.emhril.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 05 Aug 2009 23:21:49 +0000
From: Roman Kononov <kononov@ftml.net>
Subject: Re: failed assertion related to realtime section
Date: Wed, 05 Aug 2009 18:21:37 -0500
Message-ID: <4A7A1401.7030100@ftml.net>
References: <h3gd94$clb$1@ger.gmane.org>	<bzyzlb6p239.fsf@fransum.emea.sgi.com>
	<4A5E7109.7000808@ftml.net>	<bzyfxcxgd3z.fsf@fransum.emea.sgi.com>
	<4A78A260.1040501@ftml.net> <bzyiqh21oab.fsf@fransum.emea.sgi.com>
Mime-Version: 1.0
In-Reply-To: <bzyiqh21oab.fsf@fransum.emea.sgi.com>
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
Cc: Roman Kononov <kononov@ftml.net>

Olaf Weber wrote:
> Roman Kononov writes:
> 
>> On 2009-07-16 05:02, Olaf Weber wrote:
>>> A quick test on an available system
>>> running a (much) older kernel runs to completion, so this appears to
>>> be a regression.
> 
>> With which kernel version did you run the test?
> 
> Heavily-patched 2.6.16, which is what I had readily available at that
> point.  But most or all of those patches + additional changes should
> be in current XFS.
> 
>>> Figuring out exactly when/where this regressed will take time.
> 
>> I went back to 2.6.23 and the same assfail happened with somewhat
>> different call trace:
> 
>> Assertion failed: xfs_trans_get_block_res(tp) > 0, file:
>> /home/rk/linux-2.6.23/fs/xfs/xfs_bmap.c, line: 5523
> 
>> Call Trace:
>>  [<ffffffff80356a08>] xfs_bunmapi+0x8e8/0x1060
>>  [<ffffffff80227d2a>] dequeue_entity+0x7a/0xb0
>>  [<ffffffff80380608>] xfs_itruncate_finish+0x398/0x5c0
>>  [<ffffffff803a2323>] xfs_free_eofblocks+0x263/0x2b0
>>  [<ffffffff803a4838>] xfs_release+0x118/0x1e0
>>  [<ffffffff803ae42a>] xfs_file_release+0x1a/0x30
>>  [<ffffffff802827cd>] __fput+0xcd/0x1e0
>>  [<ffffffff8027f5c4>] filp_close+0x54/0x90
>>  [<ffffffff80280e3d>] sys_close+0x9d/0x110
>>  [<ffffffff8020bc9e>] system_call+0x7e/0x83
> 
>> I tried to go back to 2.6.22.19 and older, and the test did not run at
>> all failing to mount:
> 
>> XFS: bad version
>> XFS: SB validate failed
> 
>> Any suggestions?
> 
> For that I had the advantage of being able to just build a fresh XFS
> filesystem for the purpose.  If that is what you're doing as well,
> look at disabling the lazy-counters option at mkfs time.
> 

I removed lazy-counters as you suggested, and under 2.6.22.19 it mounts 
successfully. But still crushes in the same place:

Assertion failed: ((tp)->t_blk_res) > 0, file: 
/home/rk/xbase/linux/linux-2.6.22.19/fs/xfs/xfs_bmap.c, line: 5515 


Call Trace: 
 

  [<ffffffff8034ef86>] xfs_bunmapi+0x8e6/0x1050
  [<ffffffff80208042>] __switch_to+0x42/0x310
  [<ffffffff80377dc8>] xfs_itruncate_finish+0x398/0x5c0
  [<ffffffff803989c1>] xfs_inactive_free_eofblocks+0x221/0x260
  [<ffffffff802782c7>] cache_free_debugcheck+0xc7/0x1d0
  [<ffffffff8039aee7>] xfs_release+0xc7/0x110
  [<ffffffff803a497a>] xfs_file_release+0x1a/0x30
  [<ffffffff8027f02d>] __fput+0xcd/0x1e0
  [<ffffffff8027bf54>] filp_close+0x54/0x90
  [<ffffffff8027d68d>] sys_close+0x9d/0x110
  [<ffffffff80209c0e>] system_call+0x7e/0x83

I will try older versions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
