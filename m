Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfBGFVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 00:21:19 -0500
Date: Wed, 6 Feb 2019 21:21:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/3]: Extreme fragmentation ahoy!
Message-ID: <20190207052114.GA7991@magnolia>
References: <20190207050813.24271-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207050813.24271-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 04:08:10PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> I've just finished analysing an IO trace from a application
> generating an extreme filesystem fragmentation problem that started
> with extent size hints and ended with spurious ENOSPC reports due to
> massively fragmented files and free space. While the ENOSPC issue
> looks to have previously been solved, I still wanted to understand
> how the application had so comprehensively defeated extent size
> hints as a method of avoiding file fragmentation.
> 
> The key behaviour that I discovered was that specific "append write
> only" files that had extent size hints to prevent fragmentation
> weren't actually write only.  The application didn't do a lot of
> writes to the file, but it kept the file open and appended to the
> file (from the traces I have) in chunks of between ~3000 bytes and
> ~160000 bytes. This didn't explain the problem. I did notice that
> the files were opened O_SYNC, however.
> 
> I then found was another process that, once every second, opened the
> log file O_RDONLY, read 28 bytes from offset zero, then closed the
> file. Every second. IOWs, between every appending write that would
> allocate an extent size hint worth of space beyond EOF and then
> write a small chunk of it, there were numerous open/read/close
> cycles being done on the same file.
> 
> And what do we do on close()? We call xfs_release() and that can
> truncate away blocks beyond EOF. For some reason the close wasn't
> triggering the IDIRTY_RELEASE heuristic that preventd close from
> removing EOF blocks prematurely. Then I realised that O_SYNC writes
> don't leave delayed allocation blocks behind - they are always
> converted in the context of the write. That's why it wasn't
> triggering, and that meant that the open/read/close cycle was
> removing the extent size hint allocation beyond EOF prematurely.
> beyond EOF prematurely.

<urk>

> Then it occurred to me that extent size hints don't use delalloc
> either, so they behave the same was as O_SYNC writes in this
> situation.
> 
> Oh, and we remove EOF blocks on O_RDONLY file close, too. i.e. we
> modify the file without having write permissions.

Yikes!

> I suspect there's more cases like this when combined with repeated
> open/<do_something>/close operations on a file that is being
> written, but the patches address just these ones I just talked
> about. The test script to reproduce them is below. Fragmentation
> reduction results are in the commit descriptions. It's running
> through fstests for a couple of hours now, no issues have been
> noticed yet.
> 
> FWIW, I suspect we need to have a good hard think about whether we
> should be trimming EOF blocks on close by default, or whether we
> should only be doing it in very limited situations....
> 
> Comments, thoughts, flames welcome.
> 
> -Dave.
> 
> 
> #!/bin/bash
> #
> # Test 1

Can you please turn these into fstests to cause the maintainer maximal
immediate pain^W^W^Wmake everyone pay attention^W^W^W^Westablish a basis
for regression testing and finding whatever other problems we can find
from digging deeper? :)

--D

> #
> # Write multiple files in parallel using synchronous buffered writes. Aim is to
> # interleave allocations to fragment the files. Synchronous writes defeat the
> # open/write/close heuristics in xfs_release() that prevent EOF block removal,
> # so this should fragment badly.
> 
> workdir=/mnt/scratch
> nfiles=8
> wsize=4096
> wcnt=1000
> 
> echo
> echo "Test 1: sync write fragmentation counts"
> echo
> write_sync_file()
> {
> 	idx=$1
> 
> 	for ((cnt=0; cnt<$wcnt; cnt++)); do
> 		xfs_io -f -s -c "pwrite $((cnt * wsize)) $wsize" $workdir/file.$idx
> 	done
> }
> 
> rm -f $workdir/file*
> for ((n=0; n<$nfiles; n++)); do
> 	write_sync_file $n > /dev/null 2>&1 &
> done
> wait
> 
> sync
> 
> for ((n=0; n<$nfiles; n++)); do
> 	echo -n "$workdir/file.$n: "
> 	xfs_bmap -vp $workdir/file.$n | wc -l
> done;
> 
> 
> # Test 2
> #
> # Same as test 1, but instead of sync writes, use extent size hints to defeat
> # the open/write/close heuristic
> 
> extent_size=16m
> 
> echo
> echo "Test 2: Extent size hint fragmentation counts"
> echo
> 
> write_extsz_file()
> {
> 	idx=$1
> 
> 	xfs_io -f -c "extsize $extent_size" $workdir/file.$idx
> 	for ((cnt=0; cnt<$wcnt; cnt++)); do
> 		xfs_io -f -c "pwrite $((cnt * wsize)) $wsize" $workdir/file.$idx
> 	done
> }
> 
> rm -f $workdir/file*
> for ((n=0; n<$nfiles; n++)); do
> 	write_extsz_file $n > /dev/null 2>&1 &
> done
> wait
> 
> sync
> 
> for ((n=0; n<$nfiles; n++)); do
> 	echo -n "$workdir/file.$n: "
> 	xfs_bmap -vp $workdir/file.$n | wc -l
> done;
> 
> 
> 
> # Test 3
> #
> # Same as test 2, but instead of extent size hints, use open/read/close loops
> # on the files to remove EOF blocks.
> 
> echo
> echo "Test 3: Open/read/close loop fragmentation counts"
> echo
> 
> write_file()
> {
> 	idx=$1
> 
> 	xfs_io -f -s -c "pwrite -b 64k 0 50m" $workdir/file.$idx
> }
> 
> read_file()
> {
> 	idx=$1
> 
> 	for ((cnt=0; cnt<$wcnt; cnt++)); do
> 		xfs_io -f -r -c "pread 0 28" $workdir/file.$idx
> 	done
> }
> 
> rm -f $workdir/file*
> for ((n=0; n<$((nfiles * 4)); n++)); do
> 	write_file $n > /dev/null 2>&1 &
> 	read_file $n > /dev/null 2>&1 &
> done
> wait
> 
> sync
> 
> for ((n=0; n<$nfiles; n++)); do
> 	echo -n "$workdir/file.$n: "
> 	xfs_bmap -vp $workdir/file.$n | wc -l
> done;
> 
> 
