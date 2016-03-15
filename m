Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04B3F7CCD
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 05:16:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A2B0AC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 03:16:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8NYFDDXmXomZUWp3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 03:16:23 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id CB1D7F9E76
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 10:16:22 +0000 (UTC)
Received: from redhat.com (dhcp-26-103.brq.redhat.com [10.34.26.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2FAGITY007794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 06:16:20 -0400
Date: Tue, 15 Mar 2016 11:16:18 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/9] xfs: configurable error behaviour
Message-ID: <20160315101618.GA1539@redhat.com>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454635407-22276-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Hi Dave,

Here are a few comments about it, I didn't finish to review all the patches, so,
for now, it's an implementation review, other than code review.

First, I tend to agree with Brian and Eric in most of their comments.

I don't see any point in having a fail fast/slow/never, if we can configure the
number of retries, so, it just looks redundant to me.

Setting 1, -1 or N for fail fast/never/after N times, looks simpler.

Also, I don't see a point in having a fail_at_unmount option, IMHO it should
always fail at unmount, unless, if we expect the sysadmin to extend the
underlying storage device (let's say here, a thin pool), so that we can flush
all the metadata in AIL and clean unmount.

I'm sorry if I'm wrong here, but, shouldn't xfs_log_force also check for the error
configuration here? Otherwise, if, we set the configuration from fail never
to fail fast, after an unmount has been issued, unmount will be stuck waiting
for xfs_log_worker to finish metadata writeback, which will never happen
since we have no space and, it does not check for the error configuration.

I can easily reproduce this behavior trying to unmount a filesystem, then set
the configuration to fail fast after the unmount.

Unmount will be stuck at:

[<ffffffff8138ad56>] xfs_ail_push_all_sync+0xb6/0x100
[<ffffffff813750ee>] xfs_unmountfs+0x6e/0x1b0
[<ffffffff81377bf0>] xfs_fs_put_super+0x30/0x90
[<ffffffff812193da>] generic_shutdown_super+0x6a/0xf0
[<ffffffff81219747>] kill_block_super+0x27/0x70
[<ffffffff81219a83>] deactivate_locked_super+0x43/0x70
[<ffffffff81219b0c>] deactivate_super+0x5c/0x60
[<ffffffff81236baf>] cleanup_mnt+0x3f/0x90
[<ffffffff81236c42>] __cleanup_mnt+0x12/0x20
[<ffffffff810a49c3>] task_work_run+0x73/0x90
[<ffffffff81002242>] exit_to_usermode_loop+0xc2/0xd0
[<ffffffff81002d11>] syscall_return_slowpath+0xa1/0xb0
[<ffffffff818129cc>] int_ret_from_sys_call+0x25/0x8f
[<ffffffffffffffff>] 0xffffffffffffffff

and kernel will be spinning into:

kworker/3:1H-478   [003] ....   361.187791: xfs_log_force: dev 253:4 lsn 0x0
caller xfs_log_worker


or from dmesg output:

[  103.881961] XFS (dm-4): Unmounting Filesystem
[  103.882824] XFS (dm-4): xfs_do_force_shutdown(0x1) called from line 1134 of
file fs/xfs/xfs_buf_item.c.  Return address = 0xffffffff813818d7
[  103.884101] XFS (dm-4): I/O Error Detected. Shutting down filesystem
[  103.884713] XFS (dm-4): Please umount the filesystem and rectify the
problem(s)
[  121.185786] XFS (dm-4): xfs_log_force: error -5 returned.
[  151.185818] XFS (dm-4): xfs_log_force: error -5 returned.



I'll add more comments as soon as I finish to review the patches.



Btw, while testing it, I found a bug in dm-thin and direct-io code, which return
wrong error information to the filesystem, and actually prevented your patchset
to work as expected, I got a few patches to dm-thin and direct io to test, and
the patches fixed the problem I found, but I'm not sure when they will be posted
upstream. Hopefully today? :)



On Fri, Feb 05, 2016 at 12:23:18PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I need to restart the discussion and review of this patch series.
> There was some discussion of it last time, but nothing really came
> from that. I'm posting what I have in my tree right now - treat it
> as though it's an initial posting of the code because I can't recall
> what I've changed since the first posting.
> 
> What I'd like to have to for the next merge window is all the IO
> error bits sorted out. The final patch (kmem failure behaviour)
> needs more infrastructure (passing mp to every allocation) so that's
> a secondary concern right now and I've only included it to
> demonstrate how to apply this code ot a different subsystem.
> 
> Things that need to be nailed down before I can commit the series:
> 
> 	- sysfs layout
> 	- naming conventions for errors and subsystems in sysfs
> 	- how best to display/change default behaviour
> 
> Things that we can change/implement later:
> 
> 	- default behaviour
> 	- additional error classes
> 	- additional error types
> 	- additional subsystems
> 	- subsystem error handling implementation
> 	- communication with other subsystems to dynamically change
> 	  error behaviour
> 
> IOWs, what is important right now is how we present this to
> userspace, because we can't change that easily once we've decided on
> a presentation structure.
> 
> Modifying the code to classify and handle all the different error
> types is much less important, as we can change that to fix whatever
> problems we have without impacting the presentation to userspace.
> 
> There is definite need for this (e.g. handling of ENOSPC on thin
> provisioned devices), so I want to get quickly to a consensus on the
> userspace facing aspects so that we can get this ball rolling.
> 
> The biggest unsolved issue is how to change the default behaviour
> persistently. There is no infrastructure in this patch series to do
> that, but it is someting that we have to consider so that we don't
> require default behaviour to be changed after every mount of every
> filesystem on a system. My thoughts on this is we store changes to
> the defaults in xattrs on the root inode, but I'm open to ideas here
> as there's no code written for it yet. Solving this problem,
> however, is not necessary before commiting the initial code; it's
> something we can add later once we've worked out all the details.
> 
> Discuss!
> 
> -Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
