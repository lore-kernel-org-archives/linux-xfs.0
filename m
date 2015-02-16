Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1838A7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 11:35:53 -0600 (CST)
Message-ID: <54E22A76.40106@sgi.com>
Date: Mon, 16 Feb 2015 11:35:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
References: <1423782857-11800-1-git-send-email-david@fromorbit.com>	<54DE8B6D.8010401@sgi.com>
	<20150214232951.GW4251@dastard> <54E16667.1050200@gmail.com>
In-Reply-To: <54E16667.1050200@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 02/15/15 21:39, Michael L. Semon wrote:
> On 02/14/15 18:29, Dave Chinner wrote:
>> On Fri, Feb 13, 2015 at 05:40:29PM -0600, Mark Tinguely wrote:
>>> On 02/12/15 17:14, Dave Chinner wrote:
>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>
>>>> Test generic/224 is failing with a corruption being detected on one
>>>> of Michael's test boxes.  Debug that Michael added is indicating
>>>> that the minleft trimming is resulting in an underflow:
>>>>
>>>> .....
>>>>   before fixup:              rlen          1  args->len          0
>>>>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>>>>   before goto out_nominleft: rlen          1  args->len          0
>>>>   before fixup:              rlen          1  args->len          0
>>>>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>>>>   after fixup:               rlen          1  args->len          1
>>>>   before fixup:              rlen          1  args->len          0
>>>>   after xfs_alloc_fix_len  : rlen          1  args->len          1
>>>>   after fixup:               rlen 4294967295  args->len 4294967295
>>>>   XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_alloc.c, line: 1424
>>>>
>>>> The "goto out_nominleft:" indicates that we are getting close to
>>>> ENOSPC in the AG, and a couple of allocations later we underflow
>>>> and the corruption check fires in xfs_alloc_ag_vextent_size().
>>>>
>>>> The issue is that the extent length fixups comaprisons are done
>>>> with variables of xfs_extlen_t types. These are unsigned so an
>>>> underflow looks like a really big value and hence is not detected
>>>> as being smaller than the minimum length allowed for the extent.
>>>> Hence the corruption check fires as it is noticing that the returned
>>>> length is longer than the original extent length passed in.
>>>>
>>>> This can be easily fixed by ensuring we do the underflow test on
>>>> signed values, the same way xfs_alloc_fix_len() prevents underflow.
>>>> So we realise in future that these casts prevent underflows from
>>>> going undetected, add comments to the code indicating this.
>>>>
>>>> Reported-by: Michael L. Semon<mlsemon35@gmail.com>
>>>> Tested-by: Michael L. Semon<mlsemon35@gmail.com>
>>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>>> ---
>>>>   fs/xfs/libxfs/xfs_alloc.c | 4 +++-
>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>>
>>> int diff = be32_to_cpu(agf->agf_freeblks)
>>>               - args->len - args->minleft;
>>>
>>
>> Preconditions:
>>
>> 	agf->agf_freeblks = 1
>> 	args->len = 1
>> 	args->minleft = 2
>>
>> Therefore, diff = -2
>>
>>>> @@ -286,7 +287,8 @@ xfs_alloc_fix_minleft(
>>>>   	if (diff>= 0)
>>>>   		return 1;
>>>
>>> If the diff math was done correctly, wouldn't it get caught here?
>>
>> No, diff<  0.

Hee, what was I thinking? sdrawkcab ylsouivbO
>>
>>
>>>>   	args->len += diff;		/* shrink the allocated space */
>>
>> 1 += -2
>>    = -1
>>
>>>> -	if (args->len>= args->minlen)
>>
>> 	if (0xffffffff>= 1)
>>
>> broken.
>>
>>>> +	/* casts to (int) catch length underflows */
>>>> +	if ((int)args->len >= (int)args->minlen)
>>
>> 	if (-1>= 1)
>>
>> correct.
>>
>>>>   		return 1;
>>>>   	args->agbno = NULLAGBLOCK;
>>>>   	return 0;
>>>
>>> We can and should fix the wrap in xfs_alloc_fix_minleft() but this
>>> also points to the fact that xfs_alloc_fix_freelist() is incorrectly
>>> choosing AGs that will later fail the allocation alignment, minlen,
>>> and minleft requirements.
>>
>> I don't think there's a problem there. At least, not the problem I
>> think you trying to describe.
>>
>>> You can connect the dots to see how this can lead to a deadlock with
>>> extent frees. We have seen them. I hacked the XFS code to lead to
>>> this situation.
>>
>> You should post the test cases and the patch that exposes the issues
>> you are concerned about. Otherwise we have no real idea of what
>> problems you are talking about, and certainly can't reproduce them.
>>
>>> Also bad is xfs_alloc_vextent() will temporally ignore the minleft
>>> for the xfs_alloc_fix_freelist() but makes the ag allocator enforce
>>> the minleft.
>>
>> Hmmm - I suspect you haven't understood the underlying reason for
>> setting minleft to zero for the call to xfs_alloc_fix_freelist().
>> There's are two places we do this: single AG constrainted
>> allocation, and the "any AG, but near ENOSPC" allocation.
>>
>> For single AG constrained allocation, minleft is something we can
>> ignore because we must select that AG for allocation.  minleft is
>> applied against the total allocation requirement, not the minimum
>> length of allocation that can be done. Hence we might be able to do
>> a minlen allocation, but we'd reject it because we can't do a maxlen
>> allocation due to minleft requirements.
>>
>> Hence we switch off minleft in that case when doing freelist checks
>> so that we don't reject allocations that could do a minlen
>> allocation successfully. This requires the low level allocator to be
>> able to trim back the selected extent from whatever length it finds
>> to repesect minleft, and if it can't then fail the allocation.
>> That is the function of xfs_alloc_fix_minleft() - constrain the
>> allocated extent to the required minleft or fail the allocation.
>>
>> And for the lowspace algorithm, the reasoning is similar. After two
>> attempts to allocate in AGs that have enough space for a maxlen
>> allocation, we switch off minleft so that we only constrain the AG
>> search to AGs that can definitely satisfy a minlen allocation, hence
>> improving the chance we can do an allocation successfully near
>> ENOSPC.
>>
>> Cheers,
>>
>> Dave.
>
> I took something out of Mark's argument.  The original condition was
> hit using fstests generic/224 on RAID-0, while sizing up an old Core
> 2 PC for a new purpose.  With Mark mentioning AGs, I looked around a
> little bit.  The case can be hit more easily with this test on 16-GB
> $TEST_DEV and $SCRATCH_DEV:
>
> while true; do MKFS_OPTIONS='-d agcount=16' ./check generic/224; done
>
> That may not mean anything--a 50 MB/s Caviar SE on a SATA-1 controller
> may just make the original test too slow for my patience--but the
> extra AGs do make things seem rather repeatable.
>
> I'll be happy to leave both the Core 2 PC and the i686 Pentium 4 PC
> in an unpatched state, should you or Mark want me to fetch more
> values via printk debugging.  Everything else XFS is in pretty good
> shape for the "small or few" purposes here.
>
> Thanks!
>
> Michael


Thanks Michael, you don't need to hold your test box for me. I do have a 
way to recreate these ABBA AGF buffer allocation deadlocks and 
understand the whys and hows very well. I don't have a community way to 
make a xfstest for it but I think your test is getting close.

I am certain that with Dave's patch alone, and pushed long enough you 
will hit the ABBA AGF buffer deadlock. It needs to do that allocation to 
the last AG while freeing an extent to that AG.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
