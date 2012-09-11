Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BKvq8S153274 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:57:52 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BoQQNpRyRhfhHJag for <xfs@oss.sgi.com>;
	Tue, 11 Sep 2012 13:58:56 -0700 (PDT)
Date: Wed, 12 Sep 2012 06:58:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Internal error xfs_trans_cancel at line 1467 of file
	fs/xfs/xfs_trans.c
Message-ID: <20120911205827.GD11511@dastard>
References: <CADDYkjRbji4swSOm7gz907-iXFoZwEycLgUGgDV3JZtQaBbieg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDYkjRbji4swSOm7gz907-iXFoZwEycLgUGgDV3JZtQaBbieg@mail.gmail.com>
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 11, 2012 at 09:47:49AM +0200, Jacek Luczak wrote:
> Hi All,
> 
> got this during heavy IO (parallel checkout of few large projects from SVN):
> 
> XFS (dm-8): Corruption detected. Unmount and run xfs_repair
> XFS (dm-8): Internal error xfs_trans_cancel at line 1467 of file
> fs/xfs/xfs_trans.c.  Caller 0xffffffffa03c9974
> 
> Pid: 11930, comm: svn Not tainted 3.4.10-1 #1
> Call Trace:
>  [<ffffffffa03f758b>] ? xfs_trans_cancel+0x56/0xd7 [xfs]
>  [<ffffffffa03c9974>] ? xfs_create+0x467/0x4cf [xfs]
>  [<ffffffffa03c1777>] ? xfs_vn_mknod+0xcb/0x160 [xfs]
>  [<ffffffff81101a30>] ? vfs_create+0x6e/0xc7
>  [<ffffffff81102487>] ? do_last+0x3a5/0x745
>  [<ffffffff811028f5>] ? path_openat+0xce/0x35f
>  [<ffffffff81102c53>] ? do_filp_open+0x2c/0x72
>  [<ffffffffa03ca5d7>] ? xfs_release+0x1ac/0x1cc [xfs]
>  [<ffffffff8110c169>] ? alloc_fd+0x69/0xf2
>  [<ffffffff810f588e>] ? do_sys_open+0x107/0x18e
>  [<ffffffff813cb3f9>] ? system_call_fastpath+0x16/0x1b

That won't tell us what caused the problem. FWIW:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

i.e. mount options, filesystem size, geometry, space usage on the
filesystem, etc are all relevant.

Indeed, this issue is often caused by fragmented free space andnot
being able to allocate inodes, though that usually just results in
ENOSPC.  Use the xfs_db "freespace" command to dump the freespace
histogram when the error occurs and you've unmounted the filesystem.

> Is it a known issue? I have not - yet - enabled this host in CI thus
> can't tell if this can be reproduced.
> 
> I've done repair but did not saved output.

Were there any errors that were fixed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
