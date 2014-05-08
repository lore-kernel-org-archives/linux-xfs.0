Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB9E77F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 13:33:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B065430405F
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 11:33:44 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id deRSFmKy1zHJHf0f
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 11:33:40 -0700 (PDT)
Message-ID: <536BCDF7.7070404@fb.com>
Date: Thu, 8 May 2014 14:33:27 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<536A9E73.90802@fb.com> <536AFC3B.7070502@cn.fujitsu.com>
In-Reply-To: <536AFC3B.7070502@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 05/07/2014 11:38 PM, Wang Shilong wrote:
> On 05/08/2014 04:58 AM, Josef Bacik wrote:
>> On 03/09/2014 11:44 PM, Wang Shilong wrote:
>>> Test flow is to run fsstress after triggering quota rescan.
>>> the ruler is simple, we just remove all files and directories,
>>> sync filesystem and see if qgroup's ref and excl are nodesize.
>>>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>> v1->v2:
>>>     switch into new helper _run_btrfs_util_prog()
>>> ---
>>>   tests/btrfs/041     | 76
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/btrfs/041.out |  3 +++
>>>   tests/btrfs/group   |  1 +
>>>   3 files changed, 80 insertions(+)
>>>   create mode 100644 tests/btrfs/041
>>>   create mode 100644 tests/btrfs/041.out
>>>
>>> diff --git a/tests/btrfs/041 b/tests/btrfs/041
>>> new file mode 100644
>>> index 0000000..92bd080
>>> --- /dev/null
>>> +++ b/tests/btrfs/041
>>> @@ -0,0 +1,76 @@
>>> +#! /bin/bash
>>> +# FSQA Test No. btrfs/041
>>> +#
>>> +# Quota rescan stress test, we run fsstress and quota rescan
>>> concurrently
>>> +#
>>> +#-----------------------------------------------------------------------
>>>
>>> +# Copyright (C) 2014 Fujitsu.  All rights reserved.
>>> +#
>>> +# This program is free software; you can redistribute it and/or
>>> +# modify it under the terms of the GNU General Public License as
>>> +# published by the Free Software Foundation.
>>> +#
>>> +# This program is distributed in the hope that it would be useful,
>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> +# GNU General Public License for more details.
>>> +#
>>> +# You should have received a copy of the GNU General Public License
>>> +# along with this program; if not, write the Free Software Foundation,
>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
>>> +#
>>> +#-----------------------------------------------------------------------
>>>
>>> +#
>>> +
>>> +seq=`basename $0`
>>> +seqres=$RESULT_DIR/$seq
>>> +echo "QA output created by $seq"
>>> +
>>> +here=`pwd`
>>> +tmp=/tmp/$$
>>> +status=1
>>> +
>>> +_cleanup()
>>> +{
>>> +    cd /
>>> +    rm -f $tmp.*
>>> +}
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# real QA test starts here
>>> +_need_to_be_root
>>> +_supported_fs btrfs
>>> +_supported_os Linux
>>> +_require_scratch
>>> +
>>> +rm -f $seqres.full
>>> +
>>> +run_check _scratch_mkfs "-b 1g --nodesize 4096"
>>> +run_check _scratch_mount
>>> +
>>
>> Add "-o nospace_cache" here please, otherwise I don't get the same
>> output.
>
> I am little confused why we need specify this mount option explicitly?
> As far as i know, space cache is not included into qgroup accounting space.
>

It is.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
