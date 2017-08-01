Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64800 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751049AbdHAWvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 18:51:48 -0400
Date: Wed, 2 Aug 2017 08:51:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Locking problems with Linux 4.9 and 4.11 with NFSD and
 `fs/iomap.c`
Message-ID: <20170801225144.GP17762@dastard>
References: <de171adc29600902515d1424fd800678@molgen.mpg.de>
 <20170508131843.GB29840@bfoster.bfoster>
 <20170509090534.GB2378@lst.de>
 <7ae18b0d-38e3-9b12-0989-ede68956ad43@molgen.mpg.de>
 <358037e8-6784-ebca-9fbb-ec7eef3977d6@molgen.mpg.de>
 <20170510171757.GA10534@localhost.localdomain>
 <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
 <979473d1-9e8a-51ba-28d9-9ace63f8105b@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <979473d1-9e8a-51ba-28d9-9ace63f8105b@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, it+linux-nfs@molgen.mpg.de, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

On Tue, Aug 01, 2017 at 07:49:50PM +0200, Paul Menzel wrote:
> Dear Brian, dear Christoph,
> 
> 
> On 06/27/17 13:59, Paul Menzel wrote:
> 
> >Just a small update that we were hit by the problem on a different
> >machine (identical model) with Linux 4.9.32 and the exact same
> >symptoms.
> >
> >```
> >$ sudo cat /proc/2085/stack
> >[<ffffffff811f920c>] iomap_write_begin+0x8c/0x120
> >[<ffffffff811f982b>] iomap_zero_range_actor+0xeb/0x210
> >[<ffffffff811f9a82>] iomap_apply+0xa2/0x110
> >[<ffffffff811f9c58>] iomap_zero_range+0x58/0x80
> >[<ffffffff8133c7de>] xfs_zero_eof+0x4e/0xb0
> >[<ffffffff8133c9dd>] xfs_file_aio_write_checks+0x19d/0x1c0
> >[<ffffffff8133ce89>] xfs_file_buffered_aio_write+0x79/0x2d0
> >[<ffffffff8133d17e>] xfs_file_write_iter+0x9e/0x150
> >[<ffffffff81198dc0>] do_iter_readv_writev+0xa0/0xf0
> >[<ffffffff81199fba>] do_readv_writev+0x18a/0x230
> >[<ffffffff8119a2ac>] vfs_writev+0x3c/0x50
> >[<ffffffffffffffff>] 0xffffffffffffffff
> >```
> >
> >We haven’t had time to set up a test system yet to analyze that further.
> 
> Today, two systems with Linux 4.9.23 exhibited the problem of `top`
> showing that `nfsd` is at 100 %. Restarting one machine into Linux
> *4.9.38* showed the same problem. One of them with a 1 GBit/s
> network device got traffic from a 10 GBit/s system, so the
> connection was saturated.

So the question is this: is there IO being issued here, is the page
cache growing, or is it in a tight loop doing nothing? Details of
your hardware, XFS config and NFS server config is kinda important
here, too.

For example, if the NFS server IO patterns trigger a large
speculative delayed allocation, then the client does a write at the
end of the speculative delalloc range, we will zero the entire
speculative delalloc range. That could be several GB of zeros that
need to be written here. It's sub-optimal, yes, and but large
zeroing is rare enough that we haven't needed to optimise it by
allocating unwritten extents instead.  It would be really handy to
know what application the NFS client is running as that might give
insight into the trigger behaviour and whether you are hitting this
case.

Also, if the NFS client is only writing to one file, then all the
other writes that are on the wire will end up being serviced by nfsd
threads that then block waiting for the inode lock. If the client
issues more writes on the wire thant he NFS server has worker
threads, the client side write will starve the NFS server of
worker threads until the zeroing completes. This is the behaviour
you are seeing - it's a common server side config error that's been
known for at least 15 years...

FWIW, it used to be that a linux NFS client could have 16 concurrent
outstanding NFS RPCs to a server at a time - I don't know if that
limit still exists or whether it's been increased. However, the
typical knfsd default is (still) only 8 worker threads, meaning a
single client and server using default configs can cause the above
server DOS issue. e.g on a bleeding edge debian distro install:

$ head -2 /etc/default/nfs-kernel-server
# Number of servers to start up
RPCNFSDCOUNT=8
$

So, yeah, distros still only configure the nfs server with 8 worker
thread by default. If it's a dedicated NFS server, then I'd be using
somewhere around 64 NFSD threads *per CPU* as a starting point for
the server config...

At minimum, you need to ensure that the NFS server has at least
double the number of server threads as the largest client side
concurrent RPC count so that a single client can't DOS the NFS
server with a single blocked write stream.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
