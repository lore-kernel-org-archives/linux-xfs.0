Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 522417F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 11:06:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4152D304039
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:06:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fwVA8fCJtDkdT4Ep for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 09:06:55 -0700 (PDT)
Message-ID: <52387E1A.5020108@sandeen.net>
Date: Tue, 17 Sep 2013 11:06:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: xfs directory unbalance assert test
References: <20130917145946.124195107@sgi.com>
	<20130917145959.333796933@sgi.com>
	<52387831.5010205@sandeen.net> <52387C1B.6090203@sgi.com>
In-Reply-To: <52387C1B.6090203@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 9/17/13 10:58 AM, Mark Tinguely wrote:
> On 09/17/13 10:41, Eric Sandeen wrote:
>> On 9/17/13 9:59 AM, Mark Tinguely wrote:
>>> This tests triggers an assert in the XFS directory unbalance code.
>>> This test originally written by Brian Foster and suggestions
>>> from Micheal Semon.
>>
>> cool, thanks.  Comments below.
>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>>   tests/generic/319     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/generic/319.out |    2 +
>>>   tests/generic/group   |    1
>>>   3 files changed, 65 insertions(+)
>>>
>>> Index: b/tests/generic/319
>>> ===================================================================
>>> --- /dev/null
>>> +++ b/tests/generic/319
>>> @@ -0,0 +1,62 @@
>>> +#! /bin/bash
>>> +# FS QA Test No. 319
>>> +#
>>> +# Test directory code correctly handles fsstress filling the filesystem
>>> +#
>>> +#-----------------------------------------------------------------------
>>> +# Copyright (c) 2013 SGI.  All Rights Reserved.
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
>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>> +#-----------------------------------------------------------------------
>>> +#
>>> +
>>> +seq=`basename $0`
>>> +seqres=$RESULT_DIR/$seq
>>> +echo "QA output created by $seq"
>>> +
>>> +here=`pwd`
>>> +tmp=/tmp/$$
>>> +status=1    # failure is the default!
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +_cleanup()
>>> +{
>>> +    cd /
>>> +}
>>
>> That seems pointless; usually it's done w/ rm -f $tmp.*
>> right after, but we have no tmpfile, so...
> 
> Yeah, no cleanup is needed.
> 
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +_require_scratch
>>> +
>>> +# real QA test starts here
>>> +
>>> +_supported_fs generic
>>> +_supported_os IRIX Linux
>>> +
>>> +_scratch_unmount>  /dev/null 2>&1
>>
>> Aside:
>>
>> I see this done both ways - is it required to unmount scratch at the beginning
>> of a test?  I don't think so (I know it's done in many tests, though, but
>> again, C&P&  cargo cult?  Or not?  I'm not sure :( )
>>
>> I guess it doesn't hurt, but at some point I'd like to get it straight
>> about who's required to umount scratch, and when (if at all).
> 
> Have to unmount for the mkfs, as noted by Eryu, it is already done. I
> would rather manually unmount it than be surprised when someone
> changes the common files.

If that happens, tons of tests will break.  I'd really just remove it
for clarity, but *shrug*

>>
>>> +_scratch_mkfs_sized 11g>>  $seqres.full 2>&1
>>
>> _scratch_mkfs_sized doesn't take units like this ('g'), so the above fails to
>> actually make an 11g fs:
>>
>> # Create fs of certain size on scratch device
>> # _scratch_mkfs_sized<size in bytes>  [optional blocksize]
>> _scratch_mkfs_sized()
>>
>> so we get this in 319.full:
>>
>> expr: non-numeric argument
>> ./common/rc: line 576: [: 11g: integer expression expected
>>
>> but then it seems like mkfs carries on anyway w/ defaults.  :(
>>
>> Apparently the mkfs 11g part isn't actually critical? ;)
> 
> it works on xfs because mkfs.xfs size can take those values, but yes it breaks on other filesystem. my bad.

One other nitpick in this area, please remove $seqres.full before you start so it doesn't grow each time the test is run.

(hm maybe we should add that to ./check or something; so many tests miss this)



But - no, it doesn't work for xfs either, at least not in all cases, because
it doesn't do the device size check.  Here's xfs output on a < 11G device:

expr: non-numeric argument
./common/rc: line 582: [: 11g: integer expression expected
** mkfs failed with extra mkfs options added to "-bsize=4096" by test 319 **
** attempting to mkfs using only test 319 options: -d size=11g -b size=4096 **
size 11g specified for data subvolume is too large, maximum is 1048241 blocks
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
...

and w/o error checking (2>&1 and no || _fail) the test just carries on w/o a
fresh mkfs, on whatever size it happens to be.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
