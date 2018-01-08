Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755966AbeAHMGS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 07:06:18 -0500
Date: Mon, 8 Jan 2018 12:06:17 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: statfs b_avail & b_free different if the filesystem is mounted
 readonly
Message-ID: <20180108120617.GW2787@redhat.com>
References: <20180108084450.GU2787@redhat.com>
 <20180108114305.GA16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180108114305.GA16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 08, 2018 at 10:43:05PM +1100, Dave Chinner wrote:
> On Mon, Jan 08, 2018 at 08:44:50AM +0000, Richard W.M. Jones wrote:
> > We had a question[1] posed by a libguestfs user who wondered why the
> > output of ‘virt-df’ and ‘df’ differ for an XFS filesystem.  After
> > looking into the details it turns out that the statfs(2) system call
> > gives slightly different answers if the filesystem is mounted
> > read-write vs read-only.
> > 
> >   ><rescue> mount /dev/sda1 /sysroot
> >   ><rescue> stat -f /sysroot
> >     File: "/sysroot"
> >       ID: 80100000000 Namelen: 255     Type: xfs
> >   Block size: 4096       Fundamental block size: 4096
> >   Blocks: Total: 24713      Free: 23347      Available: 23347
> >   Inodes: Total: 51136      Free: 51133
> > 
> > vs:
> > 
> >   ><rescue> mount -o ro /dev/sda1 /sysroot
> >   ><rescue> stat -f /sysroot
> >     File: "/sysroot"
> >       ID: 80100000000 Namelen: 255     Type: xfs
> >   Block size: 4096       Fundamental block size: 4096
> >   Blocks: Total: 24713      Free: 24653      Available: 24653
> >   Inodes: Total: 51136      Free: 51133
> > 
> > ‘virt-df’ uses ‘-o ro’ and in the ‘df’ case the user had the
> > filesystem mounted read-write, hence different results.
> > 
> > I looked into the kernel code and it's all pretty complicated.  I
> > couldn't see exactly where this difference could come from.
> 
> Pretty simple when you know what to look for :P
> 
> This is off the top of my head, but the difference is mostly going
> to be the ENOSPC reserve pool (xfs_reserve_blocks(), IIRC). it's
> size is min(%5 total, 8192) blocks, and it's not reserved on a
> read-only mount because it's only required for certain modifications
> at ENOSPC that can't be reserved ahead of time (e.g. btree blocks
> for an extent split during unwritten extent conversion at ENOSPC).
> 
> The numbers above will be slightly more than 5%, because total
> blocks reported in fsstat doesn't include things like th space used
> by the journal, whereas the reserve pool sizing just works from raw
> sizes in the on-disk superblock.
> 
> So total fs size is at least 24713 blocks. 5% of that is 1235.6
> blocks. The difference in free blocks is 24653 - 23347 = 1306
> blocks. It's right in the ballpark I'd expect....
> 
> > My questions are: Is there a reason for this difference, and is one of
> > the answers more correct than the other?
> 
> Yes, there's a reason. No, both are correct. :P

That makes a lot of sense, thanks.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
