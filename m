Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E34F7F47
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 13:29:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F293F304032
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 11:28:58 -0800 (PST)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
	[209.85.216.170]) by cuda.sgi.com with ESMTP id
	ebVtA6FptTQOk7xz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 10 Jan 2015 11:28:57 -0800 (PST)
Received: by mail-qc0-f170.google.com with SMTP id x3so13533298qcv.1
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 11:28:56 -0800 (PST)
Date: Sat, 10 Jan 2015 14:28:52 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150110192852.GD25319@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B03BCC.7040207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello, Eric.

On Fri, Jan 09, 2015 at 02:36:28PM -0600, Eric Sandeen wrote:
> And the xfsalloc / btree split worker is not on any active task.
> Digging further, it's on a queue, but not started.
> 
> The work queue which contains it is this:
> 
> crash> list -H 0xc000000001cd7b18 -o work_struct.entry -s work_struct
> c0000006182ceed8
> struct work_struct {
...
>   func = 0xd000000005c0b570 <xfs_end_io>
> }
> c0000006182c31f0
> struct work_struct {
...
>   func = 0xd000000005c0b570 <xfs_end_io>
> }
> c0000006182c0748
> struct work_struct {
...
>   func = 0xd000000005c0b570 <xfs_end_io>
> }
> c00000003ad030a0
> struct work_struct {
...
>   func = 0xd000000005c58ef0 <xfs_btree_split_worker>
> }
> 
> ...
> 
> so that's our stuck split worker, behind xfs_end_io's.

As long as the split worker is queued on a separate workqueue, it's
not really stuck behind xfs_end_io's.  If the global pool that the
work item is queued on can't make forward progress due to memory
pressure, the rescuer will be summoned and it will pick out that work
item and execute it.

The only reasons that work item would stay there are

* The rescuer is already executing something else from that workqueue
  and that one is stuck.

* The worker pool is still considered to be making forward progress -
  there's a worker which isn't blocked and can burn CPU cycles.
  ie. if you have a busy spinning work item on the per-cpu workqueue,
  it can stall progress.

...
> and xfs_iomap_write_direct() takes the ilock exclusively.
> 
>         xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> before calling xfs_bmapi_write(), so it must be the holder.  Until
> this work item runs, everything else working on this inode is stuck,
> but it's not getting run, behind other items waiting for the lock it
> holds.

Again, if xfs is using workqueue correctly, that work item shouldn't
get stuck at all.  What other workqueues are doing is irrelevant.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
