Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42332 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbeEKGje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 02:39:34 -0400
Date: Thu, 10 May 2018 23:39:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: stop using buffer heads in xfs and iomap
Message-ID: <20180511063925.GH11261@magnolia>
References: <20180509074830.16196-1-hch@lst.de>
 <20180510151303.GW11261@magnolia>
 <20180511062208.GC7962@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511062208.GC7962@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Fri, May 11, 2018 at 08:22:08AM +0200, Christoph Hellwig wrote:
> On Thu, May 10, 2018 at 08:13:03AM -0700, Darrick J. Wong wrote:
> > I ran xfstests on this for fun last night but hung in g/095:
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 submarine-djwong-mtr01 4.17.0-rc4-djw
> > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024, /dev/sdf
> > MOUNT_OPTIONS -- /dev/sdf /opt
> > 
> > FWIW the stock v4 and the 'v5 with everything and 4k blocks' vms
> > passed, so I guess there's a bug somewhere in the sub-page block size
> > code paths...
> 
> I haven't seen that in my -b size 1024 -m relink test  I'll try your above
> exact setup, too.  Is this disk or SSD?  How much memory and how many
> CPUs?

4 CPUs in a VM on a Nehalem-era machine, 2GB RAM, two 2.3GB virtio-scsi
disks...

...the VM host itself is a quad-core Nehalem, 24G RAM, atop an ext4 fs
on spinning rust in a raid1.

> Btw, I think the series might be worthwhile even if we have to delay
> the sub-page blocksize support - the blocksize == pagesize code is
> basically entirely separate and already very useful.  Only the last
> three patches contain the small blocksize support, without that we'll
> just continue using buffer heads for that case for now.

<shrug> I'll keep reading, it seemed generally ok until I hit the
sub-page part and my eyes glazed over. :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
