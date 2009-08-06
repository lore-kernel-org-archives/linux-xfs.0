Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n760bii9017220
	for <linux-xfs@oss.sgi.com>; Wed, 5 Aug 2009 19:37:46 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C22BE145F890
	for <linux-xfs@oss.sgi.com>; Wed,  5 Aug 2009 17:38:35 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id FStar5Y3mcKnMZ9o for <linux-xfs@oss.sgi.com>;
	Wed, 05 Aug 2009 17:38:35 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MYr02-0002lx-VP
	for linux-xfs@oss.sgi.com; Thu, 06 Aug 2009 00:38:30 +0000
Received: from adsl-71-147-53-109.dsl.emhril.sbcglobal.net ([71.147.53.109])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 06 Aug 2009 00:38:30 +0000
Received: from kononov by adsl-71-147-53-109.dsl.emhril.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 06 Aug 2009 00:38:30 +0000
From: Roman Kononov <kononov@ftml.net>
Subject: Re: failed assertion related to realtime section
Date: Wed, 05 Aug 2009 19:38:18 -0500
Message-ID: <4A7A25FA.4050201@ftml.net>
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

Olaf Weber wrote:
> A quick test on an available system
> running a (much) older kernel runs to completion, so this appears to
> be a regression.

Did you have the XFS_DEBUG option on? Without it, the filesystem with 
realtime does not die right away, but hangs or crashes later.

> 
>> With which kernel version did you run the test?
> 
> Heavily-patched 2.6.16, which is what I had readily available at that
> point.  But most or all of those patches + additional changes should
> be in current XFS.
> 

Vanilla 2.6.16.19 without the lazy-counters option:

Assertion failed: ((tp)->t_blk_res) > 0, file: 
/home/rk/linux-2.6.16.19/fs/xfs/xfs_bmap.c, line: 5452

Call Trace:
<ffffffff801e4b3f>{xfs_bunmapi+1335}
<ffffffff8020c5c0>{xfs_itruncate_finish+769}
<ffffffff8022be3c>{xfs_inactive_free_eofblocks+420}
<ffffffff8022bf40>{xfs_release+190}
<ffffffff80232e27>{linvfs_release+26}
<ffffffff80169c60>{__fput+189}
<ffffffff8016733a>{filp_close+93}
<ffffffff801673db>{sys_close+150}
<ffffffff8010aa2a>{system_call+126}

It looks like it never worked.

Any hope? :-(

Roman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
