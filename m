Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E83527F52
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 03:13:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95EDD8F8035
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 01:12:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id U1bq3g6EAGjtGpf5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 01:12:53 -0800 (PST)
Message-ID: <528F200E.6060803@oracle.com>
Date: Fri, 22 Nov 2013 17:12:46 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: xfs/322, verify xfs_quota administrator commands
	against invalid mount path
References: <528F0D82.7010607@oracle.com>
	<20131122085000.GD10132@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20131122085000.GD10132@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/22 2013 16:50, Eryu Guan wrote:
> On Fri, Nov 22, 2013 at 03:53:38PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Introduce xfs/322 to verify xfs_quota administrator commands can
>> deal with invalid XFS mount path properly without NULL pointer
>> dereference issue.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  tests/xfs/322     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/322.out |  2 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 71 insertions(+)
>>  create mode 100755 tests/xfs/322
>>  create mode 100644 tests/xfs/322.out
>>
>> diff --git a/tests/xfs/322 b/tests/xfs/322
>> new file mode 100755
>> index 0000000..9c749a1
>> --- /dev/null
>> +++ b/tests/xfs/322
>> @@ -0,0 +1,68 @@
>> +#! /bin/bash
>> +# FS QA Test No. 322
>> +#
>> +# Test to verify xfs_quota(8) administrator commands can deal with invalid
>> +# storage mount point without NULL pointer dereference problem.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2013 Oracle Inc.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    cd /
>> +    rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
> 
> This comment is not needed.
> 
>> +_supported_fs generic
> 
> Should be "_supported_fs xfs" ?
Oops, exactly. Looks I have to refresh my head after completing a tedious task.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
