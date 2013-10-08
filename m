Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A44107F7B
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 14:57:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82CFD8F8089
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 12:57:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 05SpFomjuAy28AOA for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 12:57:31 -0700 (PDT)
Message-ID: <525463A9.9020000@sandeen.net>
Date: Tue, 08 Oct 2013 14:57:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<20131008005317.GU4446@dastard> <52535864.8020503@sandeen.net>
	<525414D9.10308@sgi.com> <20131008192701.GZ4446@dastard>
In-Reply-To: <20131008192701.GZ4446@dastard>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On 10/8/13 2:27 PM, Dave Chinner wrote:
> On Tue, Oct 08, 2013 at 09:21:13AM -0500, Rich Johnston wrote:
>> On 10/07/2013 07:57 PM, Eric Sandeen wrote:
>>> On 10/7/13 7:53 PM, Dave Chinner wrote:
>>>> Two tests, please. move all the common parts into common/dump, and
>>>> write them as two separate tests. That way we can easily track what
>>>> test is failing just by looking at what harness test is failing...
>>>
>>> I'm not quite convinced that it's 2 separate tests, TBH.
>>>
>>> It's the same root cause; I guess there is a slightly different
>>> outcome because if you hit the same root cause enough times,
>>> you'll segfault.
>>
>>
>> Multiple DMF offline files are successfully restored but the attrs
>> are lost. I wanted to show/test that case.
>>
>> I agree with Eric that it is the same  root cause but because can
>> occur with successful dumps and does not segfault,  Thats why the 2
>> tests.
> 
> Ok, the problem might be triggering the same root cause, but in the
> case of unit tests that is usually irrelevant. That is each individual test
> should be independently tracked by the test harness regardless of
> the bug it triggers.
> 
> And reading on #xfs, the problem isn't clearly understood yet as
> both you and Eric are not sure exactly why there are differences in
> behaviour between different tests yet. e.g:
> 
> [09/10/13 02:13] <rjohnston1> Ahh OK but my DMF test case had several wholly-sparse (offline files) and the dump succeeded. 
> [09/10/13 02:18] <sandeen> tbh there is one thing I'm not clear on here, why a 1t sparse file behaves differently from a 1k sparse file
> [09/10/13 02:18] <sandeen> that seems . .  wrong
> [09/10/13 02:19] <sandeen> but I guess it must just key on i_size, not blocks
> [09/10/13 02:19] <sandeen> so anyway, maybe your dmf testcase had smaller file sizes?
> [09/10/13 02:19] <sandeen> sorry, I have to run & get missed homework to my kid @ school, bbiab.  Grr.
> [09/10/13 02:20] <rjohnston1> NP, yes they were smaller.
> [09/10/13 02:22] <rjohnston1> 100 10MB files no segfault, just trashed attrs.

But that's a testcase not yet written.  ;)  

I do understand why there is a difference between Rich's 1-file test and the 4-file test.  If you'd like to review the patch that fixes the root cause it might be more cleaer.

Between the 1 file & 4 files, the difference is that if we hit the root bug enough times, it will fill the partial-completion array, run out of slots, and return an error.  That error isn't handled and we get a segfault; I guess that's enough of a separate bug to warrant 2 tests.  One to be sure we handle the sparse files, and a second to test the error handling from this function if we hit the first bug enough times & return an error.

I _don't_ know how Rich/SGI managed to hit it with only 10MB files - I'm not clear on when xfsdump splits across streams.
Since that's Rich's bug I'll let him work that out.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
