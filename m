Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40913 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfFCGRb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 02:17:31 -0400
MIME-Version: 1.0
References: <20190527172655.9287-1-amir73il@gmail.com> <20190528202659.GA12412@mit.edu>
 <CAOQ4uxgo5jmwQbLAKQre9=7pLQw=CwMgDaWPaJxi-5NGnPEVPQ@mail.gmail.com>
 <CAOQ4uxgj94WR82iHE4PDGSD0UDxG5sCtr+Sv+t1sOHHmnXFYzQ@mail.gmail.com>
 <20190531164136.GA3066@mit.edu> <20190531224549.GF29573@dread.disaster.area>
 <20190531232852.GG29573@dread.disaster.area> <CAOQ4uxi99NDYMrz-Q7xKta4beQiYFX3-MipZ_RxFNktFTA=vMA@mail.gmail.com>
 <20190603042540.GH29573@dread.disaster.area>
In-Reply-To: <20190603042540.GH29573@dread.disaster.area>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Jun 2019 09:17:19 +0300
Message-ID: <CAOQ4uxhqJJvr=uHmn_vPPPwZDCQoL2GFug30quFScNORT5Fw=w@mail.gmail.com>
Subject: Re: [RFC][PATCH] link.2: AT_ATOMIC_DATA and AT_ATOMIC_METADATA
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, Chris Mason <clm@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>

> > Actually, one of my use cases is "atomic rename" of files with
> > no data (looking for atomicity w.r.t xattr and mtime), so this "atomic rename"
> > thread should not be interfering with other workloads at all.
>
> Which should already guaranteed because a) rename is supposed to be
> atomic, and b) metadata ordering requirements in journalled
> filesystems. If they lose xattrs across rename, there's something
> seriously wrong with the filesystem implementation.  I'm really not
> sure what you think filesystems are actually doing with metadata
> across rename operations....
>

Dave,

We are going in circles so much that my head is spinning.
I don't blame anyone for having a hard time to keep up with the plot, because
it spans many threads and subjects, so let me re-iterate:

- I *do* know that rename provides me the needed "metadata barrier"
  w.r.t. xattr on xfs/ext4 today.
- I *do* know the sync_file_range()+rename() callback provides the
"data barrier"
  I need on xfs/ext4 today.
- I *do* use this internal fs knowledge in my applications
- I even fixed up sync_file_range() per your suggestion, so I won't need to use
  the FIEMAP_FLAG_SYNC hack
- At attempt from CrashMonkey developers to document this behavior was
  "shot down" for many justified reasons
- Without any documentation nor explicit API with a clean guarantee, users
  cannot write efficient applications without being aware of the filesystem
  underneath and follow that filesystem development to make sure behavior
  has not changed
- The most recent proposal I have made in LSF, based on Jan's suggestion is
  to change nothing in filesystem implementation, but use a new *explicit* verb
  to communicate the expectation of the application, so that
filesystems are free
  the change behavior in the future in the absence of the new verb

Once again, ATOMIC_METADATA is a noop in preset xfs/ext4.
ATOMIC_DATA is sync_file_range() in present xfs/ext4.
The APIs I *need* from the kernel *do* exist, but the filesystem developers
(except xfs) are not willing to document the guarantee that the existing
interfaces provide in the present.

[...]
> So, in the interests of /informed debate/, please implement what you
> want using batched AIO_FSYNC + rename/linkat completion callback and
> measure what it acheives. Then implement a sync_file_range/linkat
> thread pool that provides the same functionality to the application
> (i.e. writeback concurrency in userspace) and measure it. Then we
> can discuss what the relative overhead is with numbers and can
> perform analysis to determine what the cause of the performance
> differential actually is.
>

Fare enough.

> Neither of these things require kernel modifications, but you need
> to provide the evidence that existing APIs are insufficient.

APIs are sufficient if I know which filesystem I am running on.
btrfs needs a different set of syscalls to get the same thing done.

> Indeed, we now have the new async ioring stuff that can run async
> sync_file_range calls, so you probably need to benchmark replacing
> AIO_FSYNC with that interface as well. This new API likely does
> exactly what you want without the journal/device cache flush
> overhead of AIO_FSYNC....
>

Indeed, I am keeping a close watch on io_uring.

Thanks,
Amir.
