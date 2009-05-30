Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4UEvAs8145641 for <xfs@oss.sgi.com>; Sat, 30 May 2009 09:57:10 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B21A304087
	for <xfs@oss.sgi.com>; Sat, 30 May 2009 07:57:23 -0700 (PDT)
Message-Id: <1A09BC73-E1E8-4EF4-AD29-FB93556C3E3B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <87d49qeuqd.fsf@basil.nowhere.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
Date: Sat, 30 May 2009 09:57:20 -0500
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
	<1243620631-10749-2-git-send-email-felixb@sgi.com>
	<20090529192529.GA1599@infradead.org>
	<87d49qeuqd.fsf@basil.nowhere.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com


On May 30, 2009, at 5:43 AM, Andi Kleen wrote:

> Christoph Hellwig <hch@infradead.org> writes:
>>>
>>> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
>>> index af6843c..d8d2321 100644
>>> --- a/fs/xfs/linux-2.6/kmem.h
>>> +++ b/fs/xfs/linux-2.6/kmem.h
>>> @@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_t *,  
>>> unsigned int __nocast);
>>> static inline int
>>> kmem_shake_allow(gfp_t gfp_mask)
>>> {
>>> -	return (gfp_mask & __GFP_WAIT) != 0;
>>> +	return ((gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS) != 0;
>>
>> Looks good to me.  But this could be written simpler as:
>>
>> 	return ((gfp_mask & (__GFP_WAIT|__GFP_FS)) != 0;
>
> That's actually not equivalent. You would need to write
>
> (gfp_mask & (__GFP_WAIT|__GFP_FS)) == (__GFP_WAIT|__GFP_FS)

Indeed.

(gfp_mask & (__GFP_WAIT|__GFP_FS)) != 0 is equivalent to

(gfp_mask & __GFP_WAIT || gfp_mask & __GFP_FS) != 0;

or "if _any_ of the flags set".
In the fix we need "_both_  flags set", which brings us to
equally (IMHO) readable

(gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS)  != 0   or as Andi noted
(gfp_mask & (__GFP_WAIT|__GFP_FS)) == (__GFP_WAIT|__GFP_FS)

I'd prefer the former, as in my original patch.

Also, I accidentally put an extra open brace in a statement. After a
successful build I started playing with braces for more readability,
and left it in inconsistent state.
Seems like the preferred style in the kernel is as following:

return ((gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) != 0;

If there is no objection, I'll use that.

Felix

>
>
> which is not simpler.
>
> BTW you can usually trust gcc to do all the obvious logical
> simplifications, so it's best to just write the most readable code
> (like Felix's original version) And also it can depend on the target
> what is actually better in machine language, and gcc has more
> knowledge about that than the programmer.
>
> int f(int x)
> {
>        return x & 1 && x & 2;
> }
>
> gives for gcc 4.3
>
> andl    $3, %edi
> xorl    %eax, %eax
> cmpl    $3, %edi
> sete    %al
> ret
>
> -Andi
>
>
> -- 
> ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
