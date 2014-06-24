Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA75F7F5A
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 23:04:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE3298F8033
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 21:04:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IGO5puaieQnWfKM4 for <xfs@oss.sgi.com>;
	Mon, 23 Jun 2014 21:04:37 -0700 (PDT)
Date: Tue, 24 Jun 2014 14:04:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
Message-ID: <20140624040434.GC9508@dastard>
References: <53A8A0AF.9070009@gmail.com> <53A8A578.4070005@sgi.com>
	<53A8A676.80305@sgi.com> <53A8F1AC.90109@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53A8F1AC.90109@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Jun 23, 2014 at 11:34:04PM -0400, Michael L. Semon wrote:
> [ 1068.431391] ------------[ cut here ]------------
> [ 1068.431566] WARNING: CPU: 0 PID: 41 at lib/list_debug.c:59 __list_del_entry+0xce/0x110()
> [ 1068.431596] list_del corruption. prev->next should be db5bf580, but was   (null)

Ok, so the current log item points to a log item that has
null pointers (i.e. not on the list).

> [ 1068.431629] CPU: 0 PID: 41 Comm: kworker/0:1H Not tainted 3.16.0-rc1+ #3
> [ 1068.431656] Hardware name: Dell Computer Corporation       L733r                          /CA810E                         , BIOS A14 09/05/2001
> [ 1068.431697] Workqueue: xfslogd xfs_buf_iodone_work
> [ 1068.431738]  00000000 00000000 de92fc24 c15d4e76 de92fc68 de92fc58 c103ca33 c1737648
> [ 1068.431891]  de92fc84 00000029 c173705a 0000003b c13c3e9e 0000003b c13c3e9e 0000003b
> [ 1068.432115]  db5bf580 00000001 de92fc70 c103cab3 00000009 de92fc68 c1737648 de92fc84
> [ 1068.432267] Call Trace:
> [ 1068.432329]  [<c15d4e76>] dump_stack+0x48/0x60
> [ 1068.432386]  [<c103ca33>] warn_slowpath_common+0x83/0xa0
> [ 1068.432433]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
> [ 1068.432478]  [<c13c3e9e>] ? __list_del_entry+0xce/0x110
> [ 1068.432524]  [<c103cab3>] warn_slowpath_fmt+0x33/0x40
> [ 1068.432569]  [<c13c3e9e>] __list_del_entry+0xce/0x110
> [ 1068.432615]  [<c13c3eeb>] list_del+0xb/0x20
> [ 1068.432674]  [<c126eb4d>] xfs_ail_delete+0x1d/0x60
....
> [ 1068.433567] ---[ end trace 60289514948e4bd7 ]---
> [ 1068.433603] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> [ 1068.433795] IP: [<c126eac8>] xfs_ail_check+0x58/0xc0

And that's trying to dereference a pointer from an item that is not
on the list....

So there's linked list corruption occurring here.

> I can reproduce the oops in kernel 3.15.0, perhaps with xfs-oss/for-next 
> merged, but there's no vmlinux to go with the kernel.  Therefore, I'll have 
> to resort to other means (rebuilt kernel with netconsole, re-attaching the 
> serial cable, etc.) to get the full crash log.

How far back can you reproduce it? If it's a recent occurrence, can
you bisect it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
