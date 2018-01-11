Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932698AbeAKVXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 16:23:12 -0500
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 1/3] xfs/realtime: Add require_no_realtime function
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <20180111041033.GX5602@magnolia>
Date: Thu, 11 Jan 2018 13:22:43 -0800
Content-Transfer-Encoding: 7bit
Message-ID: <B35BED66-8ACD-4F67-9293-432F8E497424@fb.com>
References: <20180111030901.1961285-1-rwareing@fb.com>
 <20180111030901.1961285-2-rwareing@fb.com> <20180111041033.GX5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Wed, Jan 10, 2018 at 07:08:59PM -0800, Richard Wareing wrote:
>> Some tests do not play well with realtime devices, in an effort to
>> produce a stable set of test which exercise the realtime code paths
>> we introduce a _require_no_realtime function to allow tests to opt
>> out of realtime subvolume test runs.
>>
>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> ---
>> Changes since v2:
>> * Fixed tests generic/409-411, _get_mount now honors $SCRATCH_OPTIONS
>> * tests/xfs/202 reverted, the test does indeed work with larger test
>>   device
>> * Added comments explaining why _require_no_realtime was declared
>>
>> Changes since v1:
>> * None
>>
>>  common/rc     | 18 ++++++++++++++++--
>>  tests/xfs/077 |  2 ++
>>  tests/xfs/189 |  1 +
>>  tests/xfs/284 |  2 ++
>>  4 files changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index 9216efd..f5fe739 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -198,8 +198,14 @@ _mount()
>>  _get_mount()
>>  {
>>  	local mnt_point=${!#}
>> +	local mnt_dev=${@:(-2):1}
>> +        local scratch_opts=""
>
> tab/space indentation problem?

Yup my bad, fixing.

>
>> +	if [ "$mnt_dev" == "$SCRATCH_DEV" ]; then
>
> "=" for comparison, not "==" (it's bashism, though we probably don't  
> care...?)
>
>> +		_scratch_options mount
>> +		scratch_opts="$SCRATCH_OPTIONS"
>> +	fi
>>
>> -	_mount $*
>> +	_mount $scratch_opts $*
>>  	if [ $? -eq 0 ]; then
>>  		MOUNTED_POINT_STACK="$mnt_point $MOUNTED_POINT_STACK"
>>  	else
>> @@ -230,7 +236,7 @@ _clear_mount_stack()
>>
>>  _scratch_options()
>>  {
>> -    type=$1
>> +    local type=$1
>>      SCRATCH_OPTIONS=""
>>
>>      if [ "$FSTYP" != "xfs" ]; then
>> @@ -1737,6 +1743,14 @@ _require_realtime()
>>  	_notrun "Realtime device required, skipped this test"
>>  }
>>
>> +# This test requires that a realtime subvolume is not in use
>> +#
>> +_require_no_realtime()
>> +{
>> +    [ -n "$SCRATCH_RTDEV" ] && \
>> +	_notrun "Test not compatible with realtime subvolumes, skipped this  
>> test"
>
> Do we have to check USE_EXTERNAL = yes here too?

Ya that's probably fair, I'll fix this.

>
>> +}
>> +
>>  # this test requires that a specified command (executable) exists
>>  # $1 - command, $2 - name for error message
>>  #
>> diff --git a/tests/xfs/077 b/tests/xfs/077
>> index eba4f08..6d5ac1a 100755
>> --- a/tests/xfs/077
>> +++ b/tests/xfs/077
>> @@ -50,6 +50,8 @@ _cleanup()
>>
>>  _supported_fs xfs
>>  _supported_os Linux
>> +# xfs_copy does not support realtime devices
>
> This seems like more of a bug in xfs_copy to me... :)
>

Agreed, it would be nice to get this fixed.

> --D
>
>> +_require_no_realtime
>>  _require_scratch
>>  _require_xfs_crc
>>  _require_meta_uuid
>> diff --git a/tests/xfs/189 b/tests/xfs/189
>> index 636f6f0..699eb3c 100755
>> --- a/tests/xfs/189
>> +++ b/tests/xfs/189
>> @@ -236,6 +236,7 @@ _putback_scratch_fstab()
>>  _supported_fs xfs
>>  _supported_os Linux
>>
>> +_require_no_realtime
>>  _require_scratch
>>  _require_noattr2
>>
>> diff --git a/tests/xfs/284 b/tests/xfs/284
>> index e3625fe..d0eb5bd 100755
>> --- a/tests/xfs/284
>> +++ b/tests/xfs/284
>> @@ -49,6 +49,8 @@ rm -f $seqres.full
>>  # real QA test starts here
>>  _supported_fs xfs
>>  _supported_os Linux
>> +# xfs_copy does not support realtime devices
>> +_require_no_realtime
>>  _require_test
>>  _require_scratch
>>
>> -- 
>> 2.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


