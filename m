Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F2F27CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 22:38:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2ACFF8F8039
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 20:38:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id e8IAFxmXikTCRczP for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 20:38:51 -0700 (PDT)
Message-ID: <5191B1CA.8040009@sandeen.net>
Date: Mon, 13 May 2013 22:38:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfstests: fail test if it causes a kernel taint
References: <51916146.80308@redhat.com> <20130514011501.GR32675@dastard>
	<51919ACD.4040903@sandeen.net> <20130514031517.GV24635@dastard>
In-Reply-To: <20130514031517.GV24635@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 5/13/13 10:15 PM, Dave Chinner wrote:
> On Mon, May 13, 2013 at 09:00:45PM -0500, Eric Sandeen wrote:
>> On 5/13/13 8:15 PM, Dave Chinner wrote:
>>> On Mon, May 13, 2013 at 04:55:18PM -0500, Eric Sandeen wrote:
>>>> This should, in theory, fail a test if it introduces one of
>>>> a handful of "serious" kernel taints.  I mask on a few taint
>>>> values because using an out of tree module or a non-GPL module
>>>> should never fail a test, for example.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> I like the idea - it should catch lockdep failures and other such
>>> problems.
>>>
>>>> ---
>>>>
>>>> diff --git a/check b/check
>>>> index a79747e..a9cac4e 100755
>>>> --- a/check
>>>> +++ b/check
>>>> @@ -446,6 +445,11 @@ do
>>>>  	fi
>>>>  	rm -f core $seqres.notrun
>>>>  
>>>> +	if [ "$HOSTOS" == "Linux" ]; then
>>>> +		tainted=`sysctl -n kernel.tainted`
>>>> +		let "tainted &= $TAINT_FAIL"
>>>> +	fi
>>>> +
>>>>  	start=`_wallclock`
>>>>  	$timestamp && echo -n "	["`date "+%T"`"]"
>>>>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
>>>> @@ -507,6 +511,19 @@ do
>>>>  			 "entire diff)"
>>>>  		    err=true
>>>>  		fi
>>>> +
>>>> +		# See if this run tainted the kernel due to oops, etc
>>>> +		if [ "$HOSTOS" == "Linux" ]
>>>> +		then
>>>> +			tainted2=`sysctl -n kernel.tainted`
>>>> +			let "tainted2 &= $TAINT_FAIL"
>>>> +			if [ "$tainted" != "$tainted2" ]
>>>> +			then
>>>> +				echo " Kernel taint changed from $tainted to $tainted2."
>>>> +				echo " See dmesg for details."
>>>> +				err=true
>>>> +			fi
>>>
>>> Should we dump the last 100 lines of dmesg into the output file
>>> here? And then rely on the golden image match failing to fail the
>>> test?
>>
>> Or into $seq.full . .  I dunno.  It's hard to know how much dmesg you'd need to get the right bits.
>>
>> Dumping all of it into $seq.full might be best; it only trips when it's a new taint, so won't
>> fire for every test.
> 
> Only problem with $seqres.full is that it is internal to the test
> and so many tests will not remove one that is there before the test
> starts. Hence you'll get growing files the never get removed from
> repeated failures. 

Oh, I see what you mean, yeah.

> Even just dumping the above error message into
> the output file would be sufficient, I think, as the 10 line diff
> output will state it pretty clearly as the first difference....

*shrug* I don't see the advantage of failing the test explicitly vs.
breaking it via output, but if you like that better I don't really mind,
I can change it to do that.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
