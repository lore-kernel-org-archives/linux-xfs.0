Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43C637F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 17:52:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 251298F8040
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:52:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2NAOlK8klCnmf5bf for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 15:52:12 -0800 (PST)
Date: Wed, 2 Dec 2015 10:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failure with xfs, dax and v4.4-rc3
Message-ID: <20151201235158.GF19199@dastard>
References: <20151201224346.GA15684@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151201224346.GA15684@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 01, 2015 at 03:43:46PM -0700, Ross Zwisler wrote:
> I'm seeing a new intermittent xfstests failure with v4.4-rc3 using XFS and
> DAX.  The test that is failing is generic/083, and it fails about 50% of the
> time in my setup.  Here's the output:
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lorwyn 4.4.0-rc3
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2
> /mnt/xfstests_scratch
> 
> generic/083 2s ... 2s
> _check_xfs_filesystem: filesystem on /dev/pmem0p2 is inconsistent (r) (see
> /root/xfstests/results//generic/083.full)
> Ran: generic/083
> Failures: generic/083
> Failed 1 of 1 tests

$ grep 083  tests/xfs/group
083 dangerous_fuzzers
$

Yup, it's expected to fail, and given that it's "dangerous" likely
to hang the filesystem or crash the kernel.

Tests that are expected to pass and act as regression tests are in
the auto group. If a test is not in the auto group, it's usually
because the test is either broken or will not complete due
hanging/crashing. i.e use:

# MOUNT_OPTIONS="-o dax" ./check -g auto

For regression testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
