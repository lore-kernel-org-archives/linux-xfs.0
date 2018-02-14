Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53650 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032282AbeBNQeK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 11:34:10 -0500
Subject: Re: [PATCH 2/4] xfs: skip xfs_check in _check_xfs_filesystem
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
 <151803837117.19313.3481001926133028039.stgit@magnolia>
 <20180208125152.GE18267@eguan.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <62eff3f5-b4fe-3c98-1cd2-c5b2b4ca4c70@sandeen.net>
Date: Wed, 14 Feb 2018 10:34:09 -0600
MIME-Version: 1.0
In-Reply-To: <20180208125152.GE18267@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 2/8/18 6:51 AM, Eryu Guan wrote:
> On Wed, Feb 07, 2018 at 01:19:31PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> xfs_check has been long obsolete, so stop running it automatically
>> after every test.  Tests that explicitly want xfs_check can call it
>> via _scratch_xfs_check or _xfs_check; that part doesn't go away.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'd like to see an ACK on this from XFS community.

So, I thought we still had a local implementation of xfs_check-via-xfs_db
in xfstests as an intentional validation against xfs_repair:

+# xfs_check script is planned to be deprecated. But, we want to
+# be able to invoke "xfs_check" behavior in xfstests in order to
+# maintain the current verification levels.
+_xfs_check()

IOWS, "xfs_check is obsolete" is true for users/admins, but I thought
we were keeping it alive as a developer tool for now, and that it had
a place in xfstests.  No?

(But if it /is/ removed, wouldn't you kill off the _xfs_check() function as
well, to truly nuke it from orbit?)

Anyway, I don't think I understand the justification for this change;
it was explicitly kept alive in xfstests since commit 

	187bccd xfstests: Remove dependence of xfs_check script

and "xfs_check is obsolete for admins" doesn't seem to be sufficient rationale.

What do we gain or lose by removing this from _check_xfs_filesystem?

-Eric

> Thanks,
> Eryu
> 
>> ---
>>  common/xfs |   17 -----------------
>>  1 file changed, 17 deletions(-)
>>
>>
>> diff --git a/common/xfs b/common/xfs
>> index 3dba40d..c63e5dc 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -386,23 +386,6 @@ _check_xfs_filesystem()
>>  		ok=0
>>  	fi
>>  
>> -	# xfs_check runs out of memory on large files, so even providing the test
>> -	# option (-t) to avoid indexing the free space trees doesn't make it pass on
>> -	# large filesystems. Avoid it.


>> -	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
>> -		_xfs_check $extra_log_options $device 2>&1 |\
>> -			_fix_malloc >$tmp.fs_check
>> -	fi
>> -	if [ -s $tmp.fs_check ]; then
>> -		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (c)"
>> -		echo "*** xfs_check output ***"		>>$seqres.full
>> -		cat $tmp.fs_check			>>$seqres.full
>> -		echo "*** end xfs_check output"		>>$seqres.full
>> -
>> -		xfs_metadump $device $seqres.check	>>$seqres.full 2>&1
>> -		ok=0
>> -	fi
>> -
>>  	$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
>>  	if [ $? -ne 0 ]; then
>>  		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (r)"
>>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
