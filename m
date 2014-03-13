Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCEA37F4E
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 09:02:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8605DAC00A
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 07:02:34 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id BGgmvp1sUKbnvGF5
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 07:02:32 -0700 (PDT)
Message-ID: <5321BA5A.3010800@fb.com>
Date: Thu, 13 Mar 2014 10:02:02 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] xfstests/btrfs: add stress test for btrfs quota
	operations
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1394423051-17356-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<531E171B.8090204@fb.com> <20140313031217.GC4263@dastard>
In-Reply-To: <20140313031217.GC4263@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>

On 03/12/2014 11:12 PM, Dave Chinner wrote:
> On Mon, Mar 10, 2014 at 03:48:43PM -0400, Josef Bacik wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 03/09/2014 11:44 PM, Wang Shilong wrote:
>>> So this is a stress test for btrfs quota operations. it can also 
>>> detect the following commit fixed problem:
>>>
>>> 4082bd3d73(Btrfs: fix oops when writting dirty qgroups to disk)
>>>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com> --- 
>>> v1->v2: switch into new helper _run_btrfs_util_prog() --- 
>>> tests/btrfs/043     | 76
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++ 
>>> tests/btrfs/043.out |  2 ++ tests/btrfs/group   |  1 + 3 files
>>> changed, 79 insertions(+) create mode 100755 tests/btrfs/043 create
>>> mode 100644 tests/btrfs/043.out
>>>
>>> diff --git a/tests/btrfs/043 b/tests/btrfs/043 new file mode
>>> 100755 index 0000000..d6c4bf3 --- /dev/null +++ b/tests/btrfs/043 
>>> @@ -0,0 +1,76 @@ +#! /bin/bash +# FS QA Test No. 043 +# +#
>>> stresstest for btrfs quota operations. we run fsstress and quota +#
>>> operations concurrently. +# 
>>> +#-----------------------------------------------------------------------
>>>
>>>
>> +# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
>>> +# +# This program is free software; you can redistribute it
>>> and/or +# modify it under the terms of the GNU General Public
>>> License as +# published by the Free Software Foundation. +# +# This
>>> program is distributed in the hope that it would be useful, +# but
>>> WITHOUT ANY WARRANTY; without even the implied warranty of +#
>>> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the +#
>>> GNU General Public License for more details. +# +# You should have
>>> received a copy of the GNU General Public License +# along with
>>> this program; if not, write the Free Software Foundation, +# Inc.,
>>> 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 
>>> +#-----------------------------------------------------------------------
>>>
>>>
>> +#
>>> + +seq=`basename $0` +seqres=$RESULT_DIR/$seq +echo "QA output
>>> created by $seq" + +here=`pwd` +tmp=/tmp/$$ +status=1	# failure is
>>> the default! +trap "_cleanup; exit \$status" 0 1 2 3 15 + 
>>> +_cleanup() +{ +	cd / +	rm -f $tmp.* +} + +# get standard
>>> environment, filters and checks +. ./common/rc +. ./common/filter 
>>> + +_supported_fs btrfs +_supported_os Linux +_require_scratch + +rm
>>> -f $seqres.full + +_quota_enabled_background() +{ +	i=1 +	while [
>>> $i -le 5 ] +	do +		_run_btrfs_util_prog quota enable $SCRATCH_MNT +
>>> _run_btrfs_util_prog quota disable $SCRATCH_MNT +		i=$(($i+1)) +
>>> sleep 1 +	done +} + +MKFS_SIZE=$((1024 * 1024 * 1024)) +run_check
>>> _scratch_mkfs_sized $MKFS_SIZE +run_check _scratch_mount + 
>>> +_quota_enabled_background & +run_check $FSSTRESS_PROG -d
>>> $SCRATCH_MNT -w -p 5 -n 1000 \ +	$FSSTRESS_AVOID + +run_check
>>> _scratch_unmount +_check_scratch_fs +
>>
>> You should probably be doing something to make sure the background
>> quota stuff exits properly before your script exits, my fio box can
>> run the fsstress in way less than 5 seconds.  Thanks,
> 
> josef - you might want to have a look at what your mailer is doing
> to quoted email ad fix it... ;)

Eesh I think it's enigmail, I'll turn it off.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
