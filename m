Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3D617F37
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 10:07:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AC06AC002
	for <xfs@oss.sgi.com>; Sat, 13 Jul 2013 08:07:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id R8vGeNiat0TZRLD0 for
	<xfs@oss.sgi.com>; Sat, 13 Jul 2013 08:07:04 -0700 (PDT)
Date: Sat, 13 Jul 2013 11:06:50 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
	fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130713150650.GA31035@redhat.com>
References: <20130712023930.GA6473@redhat.com> <20130713020030.GG3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130713020030.GG3438@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
 > On Thu, Jul 11, 2013 at 10:39:30PM -0400, Dave Jones wrote:
 > > Just saw this during boot after an unclean shutdown. It hung afterwards.
 > > 
 > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
 > ....
 > > [   97.173730]  [<ffffffffa0076953>] xfs_dir2_sf_addname+0x43/0x760 [xfs]
 > > [   97.173743]  [<ffffffffa0067cfc>] xfs_dir_createname+0x15c/0x1b0 [xfs]
 > > [   97.173754]  [<ffffffffa002f2dc>] xfs_create+0x4cc/0x710 [xfs]
 > > [   97.173764]  [<ffffffffa00278ca>] xfs_vn_mknod+0x9a/0x1c0 [xfs]
 > > [   97.173773]  [<ffffffffa0027a03>] xfs_vn_create+0x13/0x20 [xfs]
 > > [   97.173776]  [<ffffffff811d100d>] vfs_create+0x9d/0x100
 > > [   97.173778]  [<ffffffff811d1995>] do_last+0x925/0xe00
 > > [   97.173780]  [<ffffffff811d1f2e>] path_openat+0xbe/0x6f0
 > > [   97.173783]  [<ffffffff8109e33f>] ? local_clock+0x3f/0x50
 > > [   97.173785]  [<ffffffff811e1b5f>] ? __alloc_fd+0xaf/0x200
 > > [   97.173787]  [<ffffffff811d2c3a>] do_filp_open+0x3a/0x90
 > > [   97.173789]  [<ffffffff811e1b5f>] ? __alloc_fd+0xaf/0x200
 > > [   97.173790]  [<ffffffff811c0ddb>] do_sys_open+0x10b/0x200
 > > [   97.173792]  [<ffffffff81010578>] ? syscall_trace_enter+0x18/0x290
 > > [   97.173794]  [<ffffffff811c0eee>] SyS_open+0x1e/0x20
 > > 
 > > This trace repeated a few times, then the same assertion was triggered from sys_renameat.
 > 
 > That's rather curious. What this means is that there is either an
 > EIO or EEXIST error being returned from xfs_dir2_sf_lookup() when a
 > we're about to add the new entry. There are two things here - EIO
 > can only be returned if a shutdown has occurred - are there any
 > signs of a shutdown in the logs?

not that I recall (machine is off, and remote right now).
1st time it was during boot (above), and 2nd time I hit it
the machine kept fuzzing for a while afterwards.

I'll see if I can reproduce it again on monday, and if so I'll
grab an xfsdump for you to stare at.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
