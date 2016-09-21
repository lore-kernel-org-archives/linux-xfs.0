Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2530 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755850AbcIUVhe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 17:37:34 -0400
Date: Thu, 22 Sep 2016 07:37:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fstests: test xfs_copy V5 XFS without -d option
Message-ID: <20160921213729.GN340@dastard>
References: <1474455620-25982-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474455620-25982-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 21, 2016 at 07:00:20PM +0800, Zorro Lang wrote:
> From linux v4.3 and xfsprogs v4.2, xfs_copy support to copy a V5 XFS.
> Before that, copy a V5 XFS will cause target fs corruption, and only
> use "-d" option can resolve that problem.

What has the kernel version got to do with xfs_copy support?

What matters is whether xfsprogs supports a specific feature bit in
the XFS superblock - that is what indicates whether xfs_copy
requires the "-d" option or not....

> +# Make sure xfs_copy full support to copy V5 XFS, due to old xfs_copy can't
> +# yet copy V5 xfs without '-d'. But if xfs_copy can't copy V4 XFS, that's a
> +# bug.
> +_require_xfs_copy()
> +{
> +	_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> +	. $tmp.mkfs
> +
> +	${XFS_COPY_PROG} $SCRATCH_DEV $tmp.copy >/dev/null 2>&1
> +	local rc=$?
> +
> +	rm -f $tmp.mkfs
> +	rm -f $tmp.copy 2>/dev/null
> +	if [ $rc -ne 0 ]; then
> +		if [ $_fs_has_crcs -eq 1 ]; then
> +			_notrun "This test requires xfs_copy support to copy V5 xfs without -d"
> +		else
> +			_fail "xfs_copy can't copy a V4 xfs"
> +		fi
> +	fi
> +}

Far too over engineered - the regression tests check whether the
functionality works correctly, not the _requires* check. The
_requires* check are just for determining whether the operation is
supported or not.

As I said above, xfs_copy on v5 filesystems do not require the
"-d" option if xfs_admin can change the UUID on v5 filesystems.
i.e. if this works:

# xfs_admin -U generate /dev/pmem1
Clearing log and setting UUID
writing all SBs
new UUID = b4e22c8b-1bfb-4307-a3f2-4f55b5c9d61d
# echo $?
0
#

Then xfs_copy does not require "-d" option. This works for both v4
and v5 filesystems, so this check can be done when setting up the
$XFS_COPY_PROG variable - there is no need for a _requires rule to
check this in every test.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
