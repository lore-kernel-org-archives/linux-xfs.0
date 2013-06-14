Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5450B7F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 11:15:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D68F304070
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 09:15:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WJqDfs0zfVTdx7rZ for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 09:15:42 -0700 (PDT)
Message-ID: <51BB41AD.4050303@sandeen.net>
Date: Fri, 14 Jun 2013 11:15:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: don't shutdown log recovery on validation errors
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-2-git-send-email-david@fromorbit.com>
	<20130613010441.GX20932@sgi.com> <20130613020827.GG29338@dastard>
	<20130613220903.GA20932@sgi.com> <20130614001306.GM29338@dastard>
	<20130614160940.GA32736@sgi.com>
In-Reply-To: <20130614160940.GA32736@sgi.com>
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

On 6/14/13 11:09 AM, Ben Myers wrote:
> Hey,
> 
> On Fri, Jun 14, 2013 at 10:13:06AM +1000, Dave Chinner wrote:
>> On Thu, Jun 13, 2013 at 05:09:03PM -0500, Ben Myers wrote:
>>> Hi Dave,
>>>
>>> On Thu, Jun 13, 2013 at 12:08:27PM +1000, Dave Chinner wrote:
>>>> On Wed, Jun 12, 2013 at 08:04:41PM -0500, Ben Myers wrote:
>>>>> On Wed, Jun 12, 2013 at 12:19:06PM +1000, Dave Chinner wrote:
>>>>>> From: Dave Chinner <dchinner@redhat.com>
>>>>>>
>>>>>> Unfortunately, we cannot guarantee that items logged multiple times
>>>>>> and replayed by log recovery do not take objects back in time. When
>>>>>> theya re taken back in time, the go into an intermediate state which
>>>>>> is corrupt, and hence verification that occurs on this intermediate
>>>>>> state causes log recovery to abort with a corruption shutdown.
>>>>>>
>>>>>> Instead of causing a shutdown and unmountable filesystem, don't
>>>>>> verify post-recovery items before they are written to disk. This is
>>>>>> less than optimal, but there is no way to detect this issue for
>>>>>> non-CRC filesystems If log recovery successfully completes, this
>>>>>> will be undone and the object will be consistent by subsequent
>>>>>> transactions that are replayed, so in most cases we don't need to
>>>>>> take drastic action.
>>>>>>
>>>>>> For CRC enabled filesystems, leave the verifiers in place - we need
>>>>>> to call them to recalculate the CRCs on the objects anyway. This
>>>>>> recovery problem canbe solved for such filesystems - we have a LSN
>>>>>> stamped in all metadata at writeback time that we can to determine
>>>>>> whether the item should be replayed or not. This is a separate piece
>>>>>> of work, so is not addressed by this patch.
>>>>>
>>>>> Is there a test case for this one?  How are you reproducing this?
>>>>
>>>> The test case was Dave Jones running sysrq-b on a hung test machine.
>>>> The machine would occasionally end up with a corrupt home directory.
>>>>
>>>> http://oss.sgi.com/pipermail/xfs/2013-May/026759.html
>>>>
>>>> Analysis from a metdadump provided by Dave:
>>>>
>>>> http://oss.sgi.com/pipermail/xfs/2013-June/026965.html
>>>>
>>>> And Cai also appeared to be hitting this after a crash on 3.10-rc4,
>>>> as it's giving exactly the same "verifier failed during log recovery"
>>>> stack trace:
>>>>
>>>> http://oss.sgi.com/pipermail/xfs/2013-June/026889.html
>>>
>>> Thanks.  It appears that the verifiers have found corruption due to a
>>> flaw in log recovery, and the fix you are proposing is to stop using
>>> them.  If we do that, we'll have no way of detecting the corruption and
>>> will end up hanging users of older kernels out to dry.
>>
>> We've never detected it before, and it's causing regressions for
>> multiple people. We *can't fix it* because we can't detect the
>> situation sanely, and we are not leaving people with old kernels
>> hanging out to dry. The opposite is true: we are fucking over
>> current users by preventing log recovery on filesystems that will
>> recovery perfectly OK and have almost always recovered just fine in
>> the past.
>>
>>> I think your suggestion that non-debug systems could warn instead of
>>> fail is a good one, but removing the verifier altogether is
>>> inappropriate.
>>
>> Changing every single verifier in a non-trivial way is not something
>> I'm about to do for a -rc6 kernel. Removing the verifiers from log
>> recovery just reverts to the pre-3.8 situation, so is perfectly
>> acceptable short term solution while we do the more invasive verify
>> changes.
>>
>>> Can you make the metadump available?  I need to understand this better
>>> before I can sign off.  Also:  Any idea how far back this one goes?
>>
>> No, I can't make the metadump available to you - it was provided
>> privately and not obfuscated and so you'd have to ask Dave for it.
> 
> Dave (Jones), could you make the metadump available to me?  I'd like to
> understand this a little bit better.  I'm a bit uncomfortable with the
> proposition that we should corrupt silently in this case...

Ben, isn't it the case that the corruption would only happen if
log replay failed for some reason (as has always been the case,
verifier or not), but with the verifier in place, it kills replay
even w/o other problems due to a logical problem with the
(recently added) verifiers?

IOW - this seems like an actual functional regression due to the
addition of the verifier, and dchinner's patch gets us back
to the almost-always-fine state we were in prior to the change.

As we're at -rc6, it seems quite reasonable to me as a quick
fix to just short-circuit it for now.

If you have time to analyze dave's metadump that's cool, but
this seems like something that really needs to be addressed
before 3.10 gets out the door.

Whenever you're ready, you can also add:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(And dchinner, should this cc: stable for 3.9?)

Thanks,
-Eric

> Thanks,
> 	Ben
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
