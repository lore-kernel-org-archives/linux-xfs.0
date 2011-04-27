Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R55ZZw199499 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:05:35 -0500
Date: Wed, 27 Apr 2011 15:08:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110427050850.GG12436@dastard>
References: <20110423224403.5fd1136a@neptune.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110423224403.5fd1136a@neptune.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Sat, Apr 23, 2011 at 10:44:03PM +0200, Bruno Pr=E9mont wrote:
> Hi,
> =

> Running 2.6.39-rc3+ and now again on 2.6.39-rc4+ (I've not tested -rc1
> or -rc2) I've hit a "dying machine" where processes writing to disk end
> up in D state.
> From occurrence with -rc3+ I don't have logs as those never hit the disk,
> for -rc4+ I have the following (sysrq+t was too big, what I have of it
> misses a dozen of kernel tasks - if needed, please ask):
> =

> The -rc4 kernel is at commit 584f79046780e10cb24367a691f8c28398a00e84
> (+ 1 patch of mine to stop disk on reboot),
> full dmesg available if needed; kernel config attached (only selected
> options). In case there is something I should do at next occurrence
> please tell. Unfortunately I have no trigger for it and it does not
> happen very often.
> =

> Thanks,
> Bruno
> =

> [    0.000000] Linux version 2.6.39-rc4-00120-g73b5b55 (kbuild@neptune) (=
gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #12 Thu Apr 21 19:28:45 =
CEST 2011
> =

> =

> [32040.120055] INFO: task flush-8:0:1665 blocked for more than 120 second=
s.
> [32040.120068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [32040.120077] flush-8:0       D 00000000  4908  1665      2 0x00000000
> [32040.120099]  f55efb5c 00000046 00000000 00000000 00000000 00000001 e03=
82924 00000000
> [32040.120118]  f55efb0c f55efb5c 00000004 f629ba70 572f01a2 00001cfe f62=
9ba70 ffffffc0
> [32040.120135]  f55efc68 f55efb30 f889d7f8 f55efb20 00000000 f55efc68 e03=
82900 f55efc94
> [32040.120153] Call Trace:
> [32040.120220]  [<f889d7f8>] ? xfs_bmap_search_multi_extents+0x88/0xe0 [x=
fs]
> [32040.120239]  [<c109ce1d>] ? kmem_cache_alloc+0x2d/0x110
> [32040.120294]  [<f88c88ca>] ? xlog_space_left+0x2a/0xc0 [xfs]
> [32040.120346]  [<f88c85cb>] xlog_wait+0x4b/0x70 [xfs]
> [32040.120359]  [<c102ca00>] ? try_to_wake_up+0xc0/0xc0
> [32040.120411]  [<f88c948b>] xlog_grant_log_space+0x8b/0x240 [xfs]
> [32040.120464]  [<f88c936e>] ? xlog_grant_push_ail+0xbe/0xf0 [xfs]
> [32040.120516]  [<f88c99db>] xfs_log_reserve+0xab/0xb0 [xfs]
> [32040.120571]  [<f88d6dc8>] xfs_trans_reserve+0x78/0x1f0 [xfs]

Hmmmmm. That may be caused by the conversion of the xfsaild to a
work queue. Can you post the output of "xfs_info <mntpt>" and the
mount options (/proc/mounts) used on you system?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
