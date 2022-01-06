Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DBBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 21:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244313AbiAFVkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244184AbiAFVkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 16:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EF2C061245
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 13:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1768461D0D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 21:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68566C36AE3;
        Thu,  6 Jan 2022 21:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641505234;
        bh=ewEwzdvT3Qq/Dcd1yXZ4CiRHZuzRKc8iRMpy8tcJXYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e6iY2KdMlynQ7t41gLf4r4ehuqdR9Dx8bP0LxAnzOS+sRC6NMBCX+DcCbmYZLQo22
         rQFtxp80PJvh0M92+tgrU+jtDlwTjKwhbUdO91Z2IVweE8f73NTDDREVG5OMWxxryY
         yFbpL8WKRp+uoZX0RiNIx7myo3HiM4tucIRmU0xySlhBGf/cThguz/P7KE22a8TrgK
         8vdjcg7sSUobDIB/ySoAUPtK1lfmOo4vmSq2jf6q0tHIstqk5PRroBgTK47YwZTqOS
         ExvDbD/PfY7b5GEPDWDa5rzFKwFD8FYcvey6Q0zx+gDd9mldJy6REElNYWKSebfcj/
         9hpAi9+YyBZ2A==
Date:   Thu, 6 Jan 2022 13:40:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: xlog_write rework and CIL scalability
Message-ID: <20220106214033.GR656707@magnolia>
References: <20211210000956.GO449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210000956.GO449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 11:09:56AM +1100, Dave Chinner wrote:
> Hi Darrick,
> 
> Can you please pull the following changes from the tag listed below
> for the XFS dev tree?

Hi Dave,

I tried, but the regressions with generic/017 persist.  It trips the
ticket reservation pretty consistently within 45-60 seconds of starting,
at least on the OCI VM that I created.  /dev/sd[ab] are (software
defined) disks that can sustain reads of ~50MB/s and ~5000iops; and
writes of about half those numbers.

 run fstests generic/017 at 2022-01-06 13:18:59
 XFS (sda4): Mounting V5 Filesystem
 XFS (sda4): Ending clean mount
 XFS (sda4): Quotacheck needed: Please wait.
 XFS (sda4): Quotacheck: Done.
 XFS (sda4): ctx ticket reservation ran out. Need to up reservation
 XFS (sda4): ticket reservation summary:
 XFS (sda4):   unit res    = 548636 bytes
 XFS (sda4):   current res = -76116 bytes
 XFS (sda4):   original count  = 1
 XFS (sda4):   remaining count = 1
 XFS (sda4): Log I/O Error (0x2) detected at xlog_write+0x5ee/0x660 [xfs] (fs/xfs/xfs_log.c:2499).  Shutting down filesystem.
 XFS (sda4): Please unmount the filesystem and rectify the problem(s)
 XFS (sda3): Unmounting Filesystem
 XFS (sda4): Unmounting Filesystem

blockdev/fs configuration:

# xfs_info /opt
meta-data=/dev/sda4              isize=512    agcount=4, agsize=2183680 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=8734720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =/dev/sdb2              bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# lsblk /dev/sda4 /dev/sdb2
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda4   8:4    0 33.3G  0 part /opt
sdb2   8:18   0  128M  0 part 

# lsblk -O -J /dev/sda4 /dev/sdb2
{
  "blockdevices": [
    {
      "name": "sda4",
      "kname": "sda4",
      "path": "/dev/sda4",
      "maj:min": "8:4",
      "fsavail": null,
      "fssize": null,
      "fstype": "xfs",
      "fsused": null,
      "fsuse%": null,
      "mountpoint": null,
      "label": null,
      "uuid": "6a8ac780-016a-4970-b357-cbe7bf05bca5",
      "ptuuid": "39357d95-9980-b546-b64b-0deac1bd0d1c",
      "pttype": "gpt",
      "parttype": "0fc63daf-8483-4772-8e79-3d69d8477de4",
      "partlabel": "SCRATCH_DEV",
      "partuuid": "2a8ccc9e-c9d0-3542-8fce-ce819dd0d601",
      "partflags": null,
      "ra": 2048,
      "ro": false,
      "rm": false,
      "hotplug": false,
      "model": null,
      "serial": null,
      "size": "33.3G",
      "state": null,
      "owner": "root",
      "group": "disk",
      "mode": "brw-rw----",
      "alignment": 0,
      "min-io": 4096,
      "opt-io": 1048576,
      "phy-sec": 4096,
      "log-sec": 512,
      "rota": true,
      "sched": "bfq",
      "rq-size": 256,
      "type": "part",
      "disc-aln": 0,
      "disc-gran": "0B",
      "disc-max": "0B",
      "disc-zero": false,
      "wsame": "0B",
      "wwn": "0x6024f38ce0184097914648e6d5e1ac3a",
      "rand": true,
      "pkname": "sda",
      "hctl": null,
      "tran": null,
      "subsystems": "block:scsi:virtio:pci",
      "rev": null,
      "vendor": null,
      "zoned": "none"
    },
    {
      "name": "sdb2",
      "kname": "sdb2",
      "path": "/dev/sdb2",
      "maj:min": "8:18",
      "fsavail": null,
      "fssize": null,
      "fstype": "xfs_external_log",
      "fsused": null,
      "fsuse%": null,
      "mountpoint": null,
      "label": null,
      "uuid": null,
      "ptuuid": "007b1bcb-34a8-8342-a655-1e69030e5db5",
      "pttype": "gpt",
      "parttype": "0fc63daf-8483-4772-8e79-3d69d8477de4",
      "partlabel": "SCRATCH_LOGDEV",
      "partuuid": "7a47a7f1-6d59-f943-a06f-b4600d32f20a",
      "partflags": null,
      "ra": 2048,
      "ro": false,
      "rm": false,
      "hotplug": false,
      "model": null,
      "serial": null,
      "size": "128M",
      "state": null,
      "owner": "root",
      "group": "disk",
      "mode": "brw-rw----",
      "alignment": 0,
      "min-io": 4096,
      "opt-io": 1048576,
      "phy-sec": 4096,
      "log-sec": 512,
      "rota": true,
      "sched": "bfq",
      "rq-size": 256,
      "type": "part",
      "disc-aln": 0,
      "disc-gran": "0B",
      "disc-max": "0B",
      "disc-zero": false,
      "wsame": "0B",
      "wwn": "0x60dcbb518a874fe99abcb8399b82c740",
      "rand": true,
      "pkname": "sdb",
      "hctl": null,
      "tran": null,
      "subsystems": "block:scsi:virtio:pci",
      "rev": null,
      "vendor": null,
      "zoned": "none"
    }
  ]
}

fstests config:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 oci-mtr24 5.16.0-rc5-djwx #rc5 SMP PREEMPT Wed Dec 15 12:33:55 PST 2021
MKFS_OPTIONS  -- -f -llogdev=/dev/sdb2 /dev/sda4
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, -ologdev=/dev/sdb2 /dev/sda4 /opt

I bisected this to "xfs: implement percpu cil space used calculation".
Not sure what's really going on there, though everything up through
"xfs: rework per-iclog header CIL reservation" seems solid enough.

--D

> Cheers,
> 
> Dave.
> 
> The following changes since commit 0fcfb00b28c0b7884635dacf38e46d60bf3d4eb1:
> 
>   Linux 5.16-rc4 (2021-12-05 14:08:22 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-cil-scale-3-tag
> 
> for you to fetch changes up to 3b5181b310e0f2064f2aafb6143cdb0e920f5858:
> 
>   xfs: expanding delayed logging design with background material (2021-12-09 10:22:36 +1100)
> 
> ----------------------------------------------------------------
> xfs: CIL and log scalability improvements
> 
> xlog_write() is code that causes severe eye bleeding. It's extremely
> difficult to understand the way it is structured, and extremely easy
> to break because of all the weird parameters it passes between
> functions that do very non-obvious things. state is set in
> xlog_write_finish_copy() that is carried across both outer and inner
> loop iterations that is used by xlog_write_setup_copy(), which also
> sets state that xlog_write_finish_copy() needs. The way iclog space
> was obtained affects the accounting logic that ends up being passed
> to xlog_state_finish_copy(). The code that handles commit iclogs is
> spread over multiple functions and is obfuscated by the set/finish
> copy code.
> 
> It's just a mess.
> 
> It's also extremely inefficient.
> 
> That's why I've rewritten the code. I think the code I've written is
> much easier to understand and there's less of it.  The compiled code
> is smaller and faster. It has much fewer subtleties and outside
> dependencies, and is easier to reason about and modify.
> 
> Built on top of this is the CIL scalability improvements. My 32p
> machine hits lock contention limits in xlog_cil_commit() at about
> 700,000 transaction commits a section. It hits this at 16 thread
> workloads, and 32 thread workloads go no faster and just burn CPU on
> the CIL spinlocks.
> 
> This patchset gets rid of spinlocks and global serialisation points
> in the xlog_cil_commit() path. It does this by moving to a
> combination of per-cpu counters, unordered per-cpu lists and
> post-ordered per-cpu lists, and is built upon the xlog_write()
> simplifications introduced earlier in the rewrite of that function.
> 
> This results in transaction commit rates exceeding 2 million
> commits/s under unlink certain workloads, but in general the
> improvements are smaller than this as the scalability limitations
> simply move from xlog_cil_commit() to global VFS lock contexts.
> 
> ----------------------------------------------------------------
> Christoph Hellwig (2):
>       xfs: change the type of ic_datap
>       xfs: remove xlog_verify_dest_ptr
> 
> Dave Chinner (28):
>       xfs: factor out the CIL transaction header building
>       xfs: only CIL pushes require a start record
>       xfs: embed the xlog_op_header in the unmount record
>       xfs: embed the xlog_op_header in the commit record
>       xfs: log tickets don't need log client id
>       xfs: move log iovec alignment to preparation function
>       xfs: reserve space and initialise xlog_op_header in item formatting
>       xfs: log ticket region debug is largely useless
>       xfs: pass lv chain length into xlog_write()
>       xfs: introduce xlog_write_full()
>       xfs: introduce xlog_write_partial()
>       xfs: xlog_write() no longer needs contwr state
>       xfs: xlog_write() doesn't need optype anymore
>       xfs: CIL context doesn't need to count iovecs
>       xfs: use the CIL space used counter for emptiness checks
>       xfs: lift init CIL reservation out of xc_cil_lock
>       xfs: rework per-iclog header CIL reservation
>       xfs: introduce per-cpu CIL tracking structure
>       xfs: implement percpu cil space used calculation
>       xfs: track CIL ticket reservation in percpu structure
>       xfs: convert CIL busy extents to per-cpu
>       xfs: Add order IDs to log items in CIL
>       xfs: convert CIL to unordered per cpu lists
>       xfs: convert log vector chain to use list heads
>       xfs: move CIL ordering to the logvec chain
>       xfs: avoid cil push lock if possible
>       xfs: xlog_sync() manually adjusts grant head space
>       xfs: expanding delayed logging design with background material
> 
>  Documentation/filesystems/xfs-delayed-logging-design.rst | 361 +++++++++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_log_format.h                           |   1 -
>  fs/xfs/xfs_log.c                                         | 809 ++++++++++++++++++++++++++++++++++++----------------------------------------------
>  fs/xfs/xfs_log.h                                         |  58 ++----
>  fs/xfs/xfs_log_cil.c                                     | 550 +++++++++++++++++++++++++++++++++++++++-----------------
>  fs/xfs/xfs_log_priv.h                                    | 103 +++++------
>  fs/xfs/xfs_super.c                                       |   1 +
>  fs/xfs/xfs_trans.c                                       |  10 +-
>  fs/xfs/xfs_trans.h                                       |   1 +
>  fs/xfs/xfs_trans_priv.h                                  |   3 +-
>  10 files changed, 1134 insertions(+), 763 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
