Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD4337CA7
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F5E2304039
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CdOmtiw6rSwitION for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:28:00 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/6] xfs: sort out the AGFL size mess
Date: Fri,  2 Sep 2016 12:27:31 +1000
Message-Id: <1472783257-15941-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Hi folks,

This patchset attempts to address the overall pproblem with the AGFL
size in the v5 format. The underlying problemis that I screwed up
when defining the AGFL header by not padding it correctly for 32/64
bit system sanity, and so it changed size depending on compiler
padding. This then changes the number of entries in the AGFL, and
that can lead to problems when moving a filesysetm between different
platforms.

What this patchset does is fix the size of the AGFL to be consistent
across all platforms and architectures, and then detects the
off-by-one condition that occurs when a filesystem has a size
mismatch on a wrapped AGFL. It then automatically corrects the
off-by-one so the user does not need to even know that this problem
existed when upgrading their kernel. If there is more than an
off-by-one error, the kernel will flag a corruption in the usual way
(i.e. shutdown) and that is left to repair to fix up.

As the userspace tools always rebuild the AGFL when required, they
do not expose the problematic wrapping condition to the kernel.
Hence we only really need this set of automatic fixups for kernel
upgrade situations. And because we always use the smaller, valid
AGFL size, we can remove the growfs hack we put inplace to prevent
initialising the new AGFL indexes to an invalid index.

I think I've caught all the conditions we need to here. I've been
testing with the script attached below (requires an xfs_db patch I
posted a couple of days ago) to exercise the "detect and correct
oversize AGFL indexes" case. If I run this on an unmodified kernel,
it crashes and burns. With this patch set, it either corrects the
problem automatically or flags corruption. I'll need to turn this
into an xfstest but it suffices for the moment.

Thoughts, comments and testing on random platforms welcome!

-Dave.

--
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
	flfirst=$1
	fllast=$2
	flcount=$3
	urk=$4

	echo "Testing flfirst=$flfirst fllast=$fllast flcount=$flcount...."
	mkfs.xfs -f -s size=512 /dev/ram0 > /dev/null
	xfs_db -x -c "agf 0"                    \
		-c "write -d flfirst $flfirst"  \
		-c "write -d fllast $fllast"    \
		-c "write -d flcount $flcount"  \
		/dev/ram0

	# we need to write a bunch of block numbers into the new part
	# of the AGFL. So we just copy 0 -> flfirst and so on.
	let i=0
	while (($flcount - $i > 0)) ; do
		dst=$((flfirst + i))
		if [ $dst -ge 118 ]; then
			dst=$((dst - 118))
		fi
		agfl_copy $i $dst
		i=$((i + 1))
	done

	do_write
}

# run_test flfirst fllast flcount
#
# mkfs default on 512 byte sectors is "0 3 4" w/ size 118
# hence 118 should be the first invalid index, and the number
# filesystems with the agfl header packing bug use.
#
# We want to test corrections for:
#       flfirst being oversize w/ matching flcount
run_test 118 3 5
#       fllast being oversize w/ matching flcount
run_test 114 118 5
#       flfirst/flast being in range w/ oversize flcount
run_test 117 3 6

#
# We want to test corruption detection for:
# where "non-matching flcount" exercises both too small and too large
#       flfirst being oversize w/ non-matching flcount
run_test 118 3 4
run_test 118 3 6
#       fllast being oversize w/ non-matching flcount
run_test 114 118 4
run_test 114 118 6
#       flfirst/flast being in range w/ non-matching flcount
run_test 117 3 5
run_test 117 3 7

--


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
