Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9BD67F52
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 10:51:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 557C2AC005
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:51:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aY65dBYZUot7poqL for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 08:51:36 -0700 (PDT)
Message-ID: <52387A86.9000201@sandeen.net>
Date: Tue, 17 Sep 2013 10:51:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: xfs directory unbalance assert test
References: <20130917145946.124195107@sgi.com>
	<20130917145959.333796933@sgi.com>
	<20130917152852.GA9550@dhcp-13-216.nay.redhat.com>
	<523879DE.1020302@sgi.com>
In-Reply-To: <523879DE.1020302@sgi.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>, xfs@oss.sgi.com

On 9/17/13 10:48 AM, Mark Tinguely wrote:
> On 09/17/13 10:28, Eryu Guan wrote:
>> On Tue, Sep 17, 2013 at 09:59:47AM -0500, Mark Tinguely wrote:
> ...
> 
>>> +_scratch_unmount>  /dev/null 2>&1
>>
>> This is not necessary, _require_scratch has done the unmount work.
> 
> okay, stole that from other tests.
> 
>>
>>> +_scratch_mkfs_sized 11g>>  $seqres.full 2>&1
>>
>> _scratch_mkfs_sized expects fssize in bytes, 11g is not a valid value
>> The comments in common/rc about _scratch_mkfs_sized say
>>
>> # _scratch_mkfs_sized<size in bytes>  [optional blocksize]
> 
> That was a shortcut for xfs. Looking in common/rc. I see that it breaks the other filesystems that need the size in blocks.

at least mkfs.extN also understands "11g" but the helper does not, because
it causes a failure in the device size check, (for any fs):

        [ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
> ...
> 
>>> @@ -0,0 +1,2 @@
>>> +QA output created by 319
>>> +--- silence is golden ---
>>> Index: b/tests/generic/group
>>> ===================================================================
>>> --- a/tests/generic/group
>>> +++ b/tests/generic/group
>>> @@ -121,3 +121,4 @@
>>>   316 auto quick
>>>   317 auto metadata quick
>>>   318 acl attr auto quick
>>> +319 stress
>>
>> Should be in auto group too I guess.
> 
> It takes a very long time to run to completion, don't know if people want this in the auto run.

how long is long?  We do have "quick" for people who want quick.  I think auto is probably
ok.  Maybe we should add a "slow" group, and you can "-x slow" :)

-Eric

>> Thanks,
>> Eryu Guan
> 
> Thanks for the feedback
> 
> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
