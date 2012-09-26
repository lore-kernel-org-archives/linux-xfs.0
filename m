Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QFodBN221563 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 10:50:39 -0500
Date: Wed, 26 Sep 2012 10:51:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 0/8] speculative preallocation inode tracking
Message-ID: <20120926155157.GS25175@sgi.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
	<20120926151923.GB13214@sgi.com> <50632302.2070406@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50632302.2070406@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hey Brian,

On Wed, Sep 26, 2012 at 11:45:06AM -0400, Brian Foster wrote:
> On 09/26/2012 11:19 AM, Ben Myers wrote:
> > On Fri, Sep 14, 2012 at 08:19:47AM -0400, Brian Foster wrote:
> >> This is v3 of the speculative preallocation inode tracking patchset. This
> >> functionality tracks inodes with post-EOF speculative preallocation for the
> >> purpose of background and on-demand trimming.
> >>
> >> Background scanning occurs on a longish interval (5 minutes by default) and in
> >> a best-effort mode (i.e., inodes are skipped due to lock contention or dirty
> >> cache). The intent is to clear up post-EOF blocks on inodes that might have
> >> allocations hanging around due to open-write-close sequences (NFS).
> >>
> >> On demand scanning is provided via a new ioctl and supports various parameters
> >> such as scan mode, filtering by quota id and minimum file size. A pending use
> >> case for on demand scanning is for accurate quota accounting via the gluster
> >> scale out filesystem (i.e., to free up preallocated space when near a usage
> >> limit).
> > 
> > [33084.794491] XFS (sda2): Ending clean mount
> > [33170.400045] XFS: Assertion failed: !atomic_read(&VFS_I(ip)->i_count) || xfs_isilocked(ip, XFS_IOLOCK_EXCL), file: /root/xfs/fs/xfs/xfs_inode.c, line: 1128
> > [33170.41422[    0.000000] Initializing cgroup subsys cpuset
> > [    0.000000] Initializing cgroup subsys cpu
> > [    0.000000] Linux version 3.6.0-rc1-1.2-desktop+ (root@nfs7) (gcc version 4.6.2 (SUSE Linux) ) #26 SMP PREEMPT Fri Sep 21 18:26:16 CDT 2012
> > [    0.000000] e820: BIOS-provided physical RAM map:
> > [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
> > 
> > crash> bt
> > PID: 1289   TASK: f38d71d0  CPU: 1   COMMAND: "kworker/1:2"
> >  #0 [f17c9b88] crash_kexec at c0295045
> >  #1 [f17c9be0] oops_end at c06ab2f2
> >  #2 [f17c9bf8] die at c020539a
> >  #3 [f17c9c10] do_trap at c06aadc1
> >  #4 [f17c9c28] do_invalid_op at c0202eb1
> >  #5 [f17c9cc4] error_code (via invalid_op) at c06aab7c
> >     EAX: 0000008e  EBX: ec3d9400  ECX: 0000071e  EDX: 00000046  EBP: f17c9d18 
> >     DS:  007b      ESI: ec3d9400  ES:  007b      EDI: ef973d00  GS:  2e30
> >     CS:  0060      EIP: f9d1dbb6  ERR: ffffffff  EFLAGS: 00010292 
> >  #6 [f17c9cf8] assfail at f9d1dbb6 [xfs]
> >  #7 [f17c9d1c] xfs_itruncate_extents at f9d6335f [xfs]
> >  #8 [f17c9d98] xfs_free_eofblocks at f9d237d9 [xfs]
> >  #9 [f17c9df8] xfs_inode_free_eofblocks at f9d221b4 [xfs]
> > #10 [f17c9e14] xfs_inode_ag_walk at f9d20ab9 [xfs]
> > #11 [f17c9ee4] xfs_inode_ag_iterator_tag at f9d20d6b [xfs]
> > #12 [f17c9f18] xfs_inodes_free_eofblocks at f9d21c95 [xfs]
> > #13 [f17c9f34] xfs_eofblocks_worker at f9d21cc3 [xfs]
> > #14 [f17c9f40] process_one_work at c0251ea5
> > #15 [f17c9f84] worker_thread at c0252504
> > #16 [f17c9fbc] kthread at c025672b
> > #17 [f17c9fe8] kernel_thread_helper at c06b06f4
> > 
> > It seems that test 133 was running at the time of the crash in two cases.  This
> > is a neat patch set but we need to resolve this before pulling it in.
> > 
> 
> Indeed. It looks like I botched the need_iolock parameter to
> xfs_free_eofblocks() when I migrated to rely on EAGAIN rather than a
> blocking lock. Thanks for the report.
> 
> I'm surprised I didn't reproduce this. I will try and do so before I
> submit an updated set so I can verify a fix. Was this a repeated 133
> test or full xfstests run? Thanks again.

NP.  This is what I was running:

while true
do
./check -g auto
done

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
