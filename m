Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B992129DF9
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 16:07:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D180AC007
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 14:07:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lvzwQpFM6CW0cD6L for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 14:07:18 -0800 (PST)
Date: Fri, 22 Nov 2013 09:07:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS umount with IO errors seems to lead to memory corruption
Message-ID: <20131121220713.GB6502@dastard>
References: <CAOcd+r3i0mDK2vAnZ-0s6VGnSsJwWxnEB2uMrcz+WSJAxx2bmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r3i0mDK2vAnZ-0s6VGnSsJwWxnEB2uMrcz+WSJAxx2bmA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

[cc'd the correct xfs list. PLease use xfs@oss.sgi.com in future.]

On Thu, Nov 21, 2013 at 08:04:36PM +0200, Alex Lyakas wrote:
> Greetings,
> I am using stock XFS from kernel 3.8.13, compiled with kmemleak
> enabled. I am testing a particular scenario, in which the underlying
> block device returns IO errors during XFS umount. Almost in all cases
> this results in kernel crashes in various places, and sometimes
> kmemleak complains, and sometimes CPU soft lockup happens. It always
> happens after XFS messages like:

What testing are you doing?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

>  kernel: [  600.190509] XFS (dm-22): metadata I/O error: block
> 0x7600030 ("xlog_iodone") error 125 numblks 64
>  kernel: [  600.192267] XFS (dm-22): xfs_do_force_shutdown(0x2) called
> from line 1115 of file
> /mnt/compile/linux-stable/source/fs/xfs/xfs_log.c.  Return address =3D
> 0xffffffffa05cffa1
>  kernel: [  600.192319] XFS (dm-22): Log I/O Error Detected.  Shutting
> down filesystem
>  kernel: [  600.192392] XFS (dm-22): Unable to update superblock
> counters. Freespace may not be correct on next mount.
>  kernel: [  600.192398] XFS (dm-22): xfs_log_force: error 5 returned.
>  kernel: [  600.193687] XFS (=90=BA.Z): Please umount the filesystem and
> rectify the problem(s)
> =

> you can see here the garbage that XFS prints instead of the block device =
name.
> In [1] and [2] I am attaching more kernel log from two such crashes.

So, something is corrupting memory and stamping all over the XFS
structures.

What's error 125?

#define ECANCELED       125     /* Operation Canceled */

I can't find an driver that actually returns that error to
filesystems, which....


>  kernel: [  600.227881] Modules linked in: xfs raid1 xfrm_user
> xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 scst_vdisk(O)
> iscsi_scst(O) scst(O) dm_zcache(O) dm_btrfs(O) btrfs(O) libcrc32c
> dm_iostat(O)

.... given you have a bunch of out of tree modules loaded (and some which
are experiemental) suggests that you have a problem with your
storage...

So, something is corrupting memory across a large number of
subsystems, and the trigger is some custom code to run error
injection. Can you reproduce the problem with something like
dm-faulty?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
