Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdJaM1s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 08:27:48 -0400
Subject: Re: [PATCH 1/2] initial fiemap test
References: <1509107832-22286-1-git-send-email-nborisov@suse.com>
 <1509107832-22286-3-git-send-email-nborisov@suse.com>
 <20171027124414.GX3235@eguan.usersys.redhat.com>
 <ff61b10a-4284-ccd3-2f1d-40d3683fe611@suse.com>
 <20171031093245.GK17339@eguan.usersys.redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c7949854-d71b-a262-3bea-d42be2667486@suse.com>
Date: Tue, 31 Oct 2017 14:27:44 +0200
MIME-Version: 1.0
In-Reply-To: <20171031093245.GK17339@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 31.10.2017 11:32, Eryu Guan wrote:
> On Tue, Oct 31, 2017 at 11:22:48AM +0200, Nikolay Borisov wrote:
>>
>>
>> On 27.10.2017 15:44, Eryu Guan wrote:
>>> On Fri, Oct 27, 2017 at 03:37:10PM +0300, Nikolay Borisov wrote:
>>>> Test various range queries of fiemap and ensure they produce expected output. 
>>>>
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> ---
>>>>  tests/xfs/900     |  96 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/xfs/900.out | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 214 insertions(+)
>>>>  create mode 100755 tests/xfs/900
>>>>  create mode 100644 tests/xfs/900.out
>>>>
>>>> diff --git a/tests/xfs/900 b/tests/xfs/900
>>>> new file mode 100755
>>>> index 0000000..e535820
>>>> --- /dev/null
>>>> +++ b/tests/xfs/900
>>>> @@ -0,0 +1,96 @@
>>>> +#! /bin/bash
>>>> +# FS QA Test No. 900
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>> +# Copyright (c) 2017 SUSE Linux Products GmbH.  All Rights Reserved.
>>>> +#
>>>> +# This program is free software; you can redistribute it and/or
>>>> +# modify it under the terms of the GNU General Public License as
>>>> +# published by the Free Software Foundation.
>>>> +#
>>>> +# This program is distributed in the hope that it would be useful,
>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +# GNU General Public License for more details.
>>>> +#
>>>> +# You should have received a copy of the GNU General Public License
>>>> +# along with this program; if not, write the Free Software Foundation,
>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>> +#-----------------------------------------------------------------------
>>>> +#
>>>> +
>>>> +seq=`basename $0`
>>>> +seqres=$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +here=`pwd`
>>>> +tmp=/tmp/$$
>>>> +status=1	# failure is the default!
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +	cd /
>>>> +	rm -f $tmp.*
>>>> +}
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/punch
>>>> +
>>>> +# remove previous $seqres.full before test
>>>> +rm -f $seqres.full
>>>> +
>>>> +# real QA test starts here
>>>> +
>>>> +# Modify as appropriate.
>>>> +_supported_fs generic
>>>> +_supported_os Linux
>>>> +_require_scratch
>>>> +_require_xfs_io_command "falloc"
>>>> +_require_xfs_io_command "fiemap"
>>>
>>> I haven't run the test yet, but from a quick look, it looks like test
>>> fails with old xfs_io without fiemap range support. Not sure adding
>>> range param to _require_xfs_io_command helps, e.g.
>>>
>>> _require_xfs_io_command "fiemap" "0 4k"
>>
>> Apparently it doesn't :
>> ./io/xfs_io -c "fiemap 0 2k" ../xfstests-dev/trace.dat
>> ../xfstests-dev/trace.dat:
>> 	0: [0..6095]: 18477056..18483151
> 
> Looks like fiemap ignores all non-option arguments..
> 
>>
>>
>> the xfs_io is just v4.13.1 HEAD. One other things that comes to mind is
>> to play tricks with the xfs_io -c "help fiemap" invocation and parse the
>> first line. If the range param is supported then it will be present in
>> the one-line help if not, it won't be. Do you think that's acceptable ?
> 
> I'm fine with it, we do have similar code to do such check on help
> message.

This is what I got I just want to run it past you before resending the whole series with the fixes incorporated: 

diff --git a/common/rc b/common/rc
index e2a8229..673f9ef 100644
--- a/common/rc
+++ b/common/rc
@@ -2053,8 +2053,15 @@ _require_xfs_io_command()
                        -c "$command 4k 8k" $testfile 2>&1`
                ;;
        "fiemap")
+               if [ ! -z "$param" ]
+               then
+                       $XFS_IO_PROG -c "help fiemap" | head -n 1 | grep -q "[offset [len]]" || \
+                               _notrun "xfs_io $command range param support is missing"
+               fi
+
                testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
                        -c "fiemap -v $param" $testfile 2>&1`
+
                param_checked=1
                ;;
        "flink" )



> 
> Thanks,
> Eryu
> 
