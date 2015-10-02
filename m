Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5349F29DF9
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48E998F8033
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:25:32 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	0sJo6FssWrHR47i6 for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 11:25:29 -0700 (PDT)
Date: Fri, 2 Oct 2015 12:12:50 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: two failing xfstests using xfs (no DAX)
Message-ID: <20151002181250.GA12659@linux.intel.com>
References: <20151002174941.GA25082@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151002174941.GA25082@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 02, 2015 at 11:49:41AM -0600, Ross Zwisler wrote:
> Recently I've been trying to get a stable baseline for my DAX testing using
> various filesystems, and in doing so I noticed a pair of tests that were
> behaving badly when run on XFS without DAX.  These test failures happen in
> both v4.2 and v4.3-rc3, though the signatures may vary a bit.
> 
> My testing setup is a kvm virtual machine with 8 GiB of its 16GiB of memory
> reserved for PMEM using the mmap parameter (memmap=8G!8G) and with the
> CONFIG_X86_PMEM_LEGACY config option enabled.  I've attached my full kernel
> config to this mail.

Sorry, one more detail - I have my test setup so that both my scratch device
and my test device are partitions on my PMEM ramdisk.

export TEST_DEV=/dev/pmem0p1
export TEST_DIR=/mnt/xfstests_test
export SCRATCH_DEV=/dev/pmem0p2
export SCRATCH_MNT=/mnt/xfstests_scratch

function xfstests_init {
        parted -s $xfstests_dev mktable msdos
        parted -s -a optimal $xfstests_dev mkpart Primary 1 4GiB
        parted -s -a optimal $xfstests_dev mkpart Primary 4GiB 7GiB

        if [[ $test_fs == "xfs" ]]; then
                mkfs.xfs -f $TEST_DEV
                mkfs.xfs -f $SCRATCH_DEV
        elif [[ $test_fs == "ext4" ]]; then
                mkfs.ext4 -F $TEST_DEV
                mkfs.ext4 -F $SCRATCH_DEV
        elif [[ $test_fs == "ext2" ]]; then
                mkfs.ext2 -F $TEST_DEV
                mkfs.ext2 -F $SCRATCH_DEV
        else
                echo "Invalid test fs '$test_fs'"
        fi
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
