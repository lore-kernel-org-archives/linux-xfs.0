Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48C077F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 14:54:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37B708F804B
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 12:54:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kkvcpgWIKK3wNl4i for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 12:54:25 -0700 (PDT)
Message-ID: <51BB74F0.7040406@sandeen.net>
Date: Fri, 14 Jun 2013 14:54:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com> <20130613020827.GG29338@dastard>
	<20130613220903.GA20932@sgi.com> <20130614001306.GM29338@dastard>
	<20130614160940.GA32736@sgi.com> <51BB41AD.4050303@sandeen.net>
	<20130614190850.GB20932@sgi.com> <51BB6C7C.6050300@sandeen.net>
	<20130614194453.GC20932@sgi.com>
In-Reply-To: <20130614194453.GC20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On 6/14/13 2:44 PM, Ben Myers wrote:
> Hey Eric,
> 
> On Fri, Jun 14, 2013 at 02:18:20PM -0500, Eric Sandeen wrote:
>> On 6/14/13 2:08 PM, Ben Myers wrote:
>>> On Fri, Jun 14, 2013 at 11:15:41AM -0500, Eric Sandeen wrote:
>>>> Ben, isn't it the case that the corruption would only happen if
>>>> log replay failed for some reason (as has always been the case,
>>>> verifier or not), but with the verifier in place, it kills replay
>>>> even w/o other problems due to a logical problem with the
>>>> (recently added) verifiers?
>>>
>>> It seems like the verifier prevented corruption from hitting disk during
>>> log replay.  
>>
>> It detected a an inconsistent *interim* state during replay, which is
>> always made correct by log replay completion.  But it *stopped* that log
>> replay completion.  And caused log replay to fail.  And mount to fail.
>> This is *new* behavior, and bad.
>>
>> As I understand it.
>>
>>> It is enforcing a partial replay up to the point where the
>>> corruption occurred.  Now you should be able to zero the log and the
>>> filesystem is not corrupted.
>>>
>>>> IOW - this seems like an actual functional regression due to the
>>>> addition of the verifier, and dchinner's patch gets us back
>>>> to the almost-always-fine state we were in prior to the change.
>>>
>>> Oh, the spin doctor is *in*!
>>
>> This is not spin.
>>
>>> This isn't a logical problem with the verifier, it's a logical problem
>>> with log replay.  We need to find a way for recovery to know whether a
>>> given transaction should be replayed.  Fixing that is nontrivial.
>>
>> Right.
>>
>> And it's been around for years.  The verifier now detects that
>> interim state, and makes things *worse* than they would be had log
>> replay been allowed to continue.
>>
>> Fixing the interim state may be nontrivial; allowing log replay
>> to continue to a consistent state as it always has *is* trivial,
>> it's what's done in Dave's small patch.
>>
>>>> As we're at -rc6, it seems quite reasonable to me as a quick
>>>> fix to just short-circuit it for now.
>>>
>>> If we're talking about a short term fix, that's fine.  This should be
>>> conditional on CONFIG_XFS_DEBUG and marked as such.
>>>
>>> Long term, removing the verifiers is the wrong thing to do here.  We
>>> need to fix the recovery bug and then remove this temporary workaround.  
>>>
>>>> If you have time to analyze dave's metadump that's cool, but
>>>> this seems like something that really needs to be addressed
>>>> before 3.10 gets out the door.
>>>
>>> If this really is a day one bug then it's been out the door almost
>>> twenty years.  And you want to hurry now?  ;)
>>
>> We seem to be talking past each other.
>>
>> The corrupted interim state has been around for years.  Up until
>> now, log replay completion left things in perfect state.
>>
>> The verifier now *breaks replay* at that interim point.
>> Were it allowed to continue, everything would be fine.
>>
>> As things stand, it is not fine, and this is a recent change
>> which Dave is trying to correct.
>>
>> Leaving it in place will cause filesystems which were replaying
>> logs just fine until recently to now fail with no good way out.
> 
> That is consistent with my understanding of the problem...
> 
> Unfortunately log replay is broken.  The verifier has detected this and stopped
> replay.  Ideally the solution would be to fix log replay, but that is going to
> take some time.  So, in the near term we're just going to disable the verifier
> to allow replay to complete.

Right, that's what we're hoping - for 3.10 right?

Maybe the talking-past-each-other was only that part.  I thought you didn't
want to disable it for now.

> I'm suggesting that this disabling be done conditionally on CONFIG_XFS_DEBUG so
> that developers still have a chance at hitting the log replay problem, 

so that real-world users will still feel the pain ...?

Or did you say that backwards (really only *disabling* it under debug?)

Ok, confirmed on IRC you mean to disable it if *NOT* debug, enable it
under debug.

> and a
> comment should be added explaining that we've disabled the verifier due to a
> specific bug as a temporary workaround and we'll re-enable the verifier once
> it's fixed.  I'll update the patch and repost.

Maybe if the verifiers were *on* under debug that'd make sense.

I think putting it under the config is overkill, since anyone who wants
to fix it is surely capable of re-enabling it in the code.  But if that
avoids an impasse, I don't much care.

> Are you guys arguing that the log replay bug should not be fixed?

Speaking for myself, I'm not arguing that, not at all.
(not that I know how to fix it, either)

-Eric

> -Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
