Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755220AbcIUWHR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Sep 2016 18:07:17 -0400
Subject: Re: [PATCH] fstests: test xfs_copy V5 XFS without -d option
References: <1474455620-25982-1-git-send-email-zlang@redhat.com>
 <20160921213729.GN340@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4b37d061-43b5-74f6-b544-0f97693270c5@sandeen.net>
Date: Wed, 21 Sep 2016 17:07:15 -0500
MIME-Version: 1.0
In-Reply-To: <20160921213729.GN340@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On 9/21/16 4:37 PM, Dave Chinner wrote:
> On Wed, Sep 21, 2016 at 07:00:20PM +0800, Zorro Lang wrote:
>> From linux v4.3 and xfsprogs v4.2, xfs_copy support to copy a V5 XFS.
>> Before that, copy a V5 XFS will cause target fs corruption, and only
>> use "-d" option can resolve that problem.
> 
> What has the kernel version got to do with xfs_copy support?
> 
> What matters is whether xfsprogs supports a specific feature bit in
> the XFS superblock - that is what indicates whether xfs_copy
> requires the "-d" option or not....

For V5, xfs_copy went through a few stages:

1) Corrupted the filesystem without -d
2) Refused to run without -d
3) Used meta_uuid to run without -d
4) Fixed a bug with multiple targets

So it probably comes down to tests identifying /broken/ xfs_copy
instances.

( 2) wasn't broken, it was just intentionally crippled, so I'm not sure
how tests should handle that case.)

Anyway, skip down ...

>> +# Make sure xfs_copy full support to copy V5 XFS, due to old xfs_copy can't
>> +# yet copy V5 xfs without '-d'. But if xfs_copy can't copy V4 XFS, that's a
>> +# bug.
>> +_require_xfs_copy()
>> +{
>> +	_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
>> +	. $tmp.mkfs
>> +
>> +	${XFS_COPY_PROG} $SCRATCH_DEV $tmp.copy >/dev/null 2>&1
>> +	local rc=$?
>> +
>> +	rm -f $tmp.mkfs
>> +	rm -f $tmp.copy 2>/dev/null
>> +	if [ $rc -ne 0 ]; then
>> +		if [ $_fs_has_crcs -eq 1 ]; then
>> +			_notrun "This test requires xfs_copy support to copy V5 xfs without -d"
>> +		else
>> +			_fail "xfs_copy can't copy a V4 xfs"
>> +		fi
>> +	fi
>> +}
> 
> Far too over engineered - the regression tests check whether the
> functionality works correctly, not the _requires* check. The
> _requires* check are just for determining whether the operation is
> supported or not.
> 
> As I said above, xfs_copy on v5 filesystems do not require the
> "-d" option if xfs_admin can change the UUID on v5 filesystems.
> i.e. if this works:
> 
> # xfs_admin -U generate /dev/pmem1
> Clearing log and setting UUID
> writing all SBs
> new UUID = b4e22c8b-1bfb-4307-a3f2-4f55b5c9d61d
> # echo $?
> 0
> #

"works," meaning "doesn't corrupt" I guess, right?  3.2.2 actually
allowed it to proceed, but corrupted the filesystem.  Then later it,
too, was restricted on v5 filesystems, and later those restrictions
were lifted.

Honestly, (and Dave helped push me in this direction as well), I think
the addition of "-d" should just be removed; we now have a binary that
/works/ and there's no reason to avoid running broken binaries - the
whole point of testing is to find out whether what you're testing works,
or if it's broken.  Skipping tests because they might fail leaves you with
missing information about the environment you're testing.

-Eric
