Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21939 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932243AbeCEWxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 17:53:09 -0500
Date: Tue, 6 Mar 2018 09:53:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180305225306.GH18129@dastard>
References: <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
 <20180227210313.GK19312@magnolia>
 <20180228224351.GA31332@bfoster.bfoster>
 <20180228232032.GK19318@magnolia>
 <20180301172832.GA34164@bfoster.bfoster>
 <20180301205541.GE12763@magnolia>
 <20180302131206.GA38614@bfoster.bfoster>
 <20180303135949.GA2767@bfoster.bfoster>
 <20180305222430.GE18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305222430.GE18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, djwong@kernel.org

On Mon, Mar 05, 2018 at 02:24:30PM -0800, Darrick J. Wong wrote:
> On Sat, Mar 03, 2018 at 08:59:50AM -0500, Brian Foster wrote:
> > On Fri, Mar 02, 2018 at 08:12:07AM -0500, Brian Foster wrote:
> > > On Thu, Mar 01, 2018 at 12:55:41PM -0800, Darrick J. Wong wrote:
> > > > On Thu, Mar 01, 2018 at 12:28:33PM -0500, Brian Foster wrote:
> > > > > On Wed, Feb 28, 2018 at 03:20:32PM -0800, Darrick J. Wong wrote:
> > > > > > On Wed, Feb 28, 2018 at 05:43:51PM -0500, Brian Foster wrote:
> > > > > > > On Tue, Feb 27, 2018 at 01:03:13PM -0800, Darrick J. Wong wrote:
> > > > > > > > On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> > > > > > > > > On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > > > > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > ...
> > > > Going forward, I want the number of unpacked kernels to decrease as
> > > > quickly as possible.  I understand that distro kernel maintainers are
> > > > not willing to apply the packing patch to their kernel until we come up
> > > > with a smooth transition path.
> > > > 
> > > 
> > > I agree wrt to upstream, but note that I don't anticipate including the
> > > padding fix downstream any time soon.
> > > 
> > > > I don't want to support fixing agfls to be 118 units long on 64-bit
> > > > unpacked kernels and 119 units long on 32-bit unpacked kernels, and I
> > > > only want to support the packed kernels with their 119 unit long agfls.
> > > > An AGFL that starts at 0 and ends at flcount-1 is compatible with packed
> > > > and unpacked kernels, so the v2 patch I sent last night removes the
> > > > delicate per-case surgery in favor of a new strategy where the mount
> > > > time and unmount time helpers both look for agfl configurationss that
> > > > are known to cause problems, and solves them all with the same solution:
> > > > moving the agfl list towards the start of the block.
> > > > 
> > > 
> > > The purpose of the patch I sent was not for upstream unpacked support
> > > going forward. Upstream has clearly moved forward with the packed
> > > format. The goal of the patch was to explore a single/generic patch that
> > > could be merged upstream/downstream and handle compatibility cleanly.
> > > 
> > 
> > FWIW, here's a new variant of a bidirectional fixup. It's refactored and
> > polished up a bit into a patch. It basically inspects the agf when first
> > read for any evidence that the on-disk fields reflect a size mismatch
> > with the current kernel and sets a flag if so. agfl gets/puts check the
> > flag and thus the first transaction that attempts to modify a mismatched
> > agfl swaps a block into or out of the gap slot appropriately.
> > 
> > This avoids the need for any new transactions or mount time scan and the
> > (downstream motivated) packed -> unpacked case is only 10 or so lines of
> > additional code. Only spot tested, but I _think_ it covers all of the
> > cases. Hm?
> 
> Just from a quick glance this looks like a reasonable way to fix the
> agfl wrapping to whatever the running kernel expects.  I tried feeding
> it to the xfstest I wrote to exercise my agfl fixer[1], but even with
> changing the test to fill the fs to enospc and delete everything I
> couldn't get it to trigger reliably.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/commit/?h=djwong-experimental&id=f085bb09c839da69daf921da33f5d13c80c9f165

I wrote a script that specifically wrapped the AGFL with xfs_db to
test this. I've attached it below, you'll need to adapt it to
whatever scheme is being used to correct the wrapping now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


#!/bin/bash


do_write()
{
	mount /dev/ram0 /mnt/test 
	echo > /mnt/test/foo
	sync
	umount /mnt/test 
	#xfs_db -x -c "agf 0" -c "p" /dev/ram0
	xfs_repair -n /dev/ram0 > /dev/null 2>&1
	xfs_repair /dev/ram0 > /dev/null 2>&1
	mount /dev/ram0 /mnt/test 
	echo > /mnt/test/bar
	umount /mnt/test 
	xfs_repair /dev/ram0 > /dev/null 2>&1
}

agfl_copy()
{
	source=$1
	dest=$2

	agbno=`xfs_db -x -c "agfl 0" -c "p bno[$source]" /dev/ram0 | \
		cut -d "=" -f 2`
	if [ "$agbno" == " null" ]; then
		agbno="0xffffffff"
	fi
	echo agbno "$agbno"
	xfs_db -x -c "agfl 0" -c "write -d bno[$source] 0xffffffff" /dev/ram0 > /dev/null
	xfs_db -x -c "agfl 0" -c "write -d bno[$dest] $agbno" /dev/ram0 > /dev/null
}

run_test()
{
	fltail=$1
	flhead=$2
	flcount=$3
	urk=$4

sleep 2

	echo "Testing fltail=$fltail flhead=$flhead flcount=$flcount...." > /dev/kmsg
	echo "Expecting $urk to occur...." > /dev/kmsg
	echo "Testing fltail=$fltail flhead=$flhead flcount=$flcount...."
	mkfs.xfs -f -s size=512 /dev/ram0 > /dev/null
	xfs_db -x -c "agf 0"			\
		-c "write -d flfirst $fltail"	\
		-c "write -d fllast $flhead"	\
		-c "write -d flcount $flcount"	\
		/dev/ram0

	# we need to write a bunch of block numbers into the new part
	# of the AGFL. So we just copy 0 -> fltail and so on.
	let i=0
	while (($flcount - $i > 0)) ; do
		dst=$((fltail + i))
		if [ $dst -ge 118 ]; then
			dst=$((dst - 118))
		fi
		agfl_copy $i $dst
		i=$((i + 1))
	done

	do_write
}

# run_test fltail flhead flcount
#
# mkfs default on 512 byte sectors is "0 3 4" w/ size 118
# hence 118 should be the first invalid index, and the number
# filesystems with the agfl header packing bug use.
#
# We want to test corrections for:
#	fltail being oversize w/ matching flcount
run_test 118 3 5 correction
#	flhead being oversize w/ matching flcount
run_test 114 118 5 correction
#	fltail/flast being in range w/ oversize flcount
run_test 117 3 6 correction

#
# We want to test corruption detection for:
# where "non-matching flcount" exercises both too small and too large
#	fltail being oversize w/ non-matching flcount
run_test 118 3 4 correction	# because tail gets fixed first
run_test 118 3 3 corruption
run_test 118 3 6 corruption
#	flhead being oversize w/ non-matching flcount
run_test 114 118 4 correction	# because head gets fixed first
run_test 114 118 3 corruption
run_test 114 118 6 corruption
#	fltail/flast being in range w/ non-matching flcount
run_test 117 3 4 corruption
run_test 117 3 7 corruption


