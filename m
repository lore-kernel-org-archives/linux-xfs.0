Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4UAhgoj130791 for <xfs@oss.sgi.com>; Sat, 30 May 2009 05:43:46 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF0DF2BE5DD
	for <xfs@oss.sgi.com>; Sat, 30 May 2009 03:43:57 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id fmG2AQ5O6kTNnRLt for
	<xfs@oss.sgi.com>; Sat, 30 May 2009 03:43:57 -0700 (PDT)
Subject: Re: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
From: Andi Kleen <andi@firstfloor.org>
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
	<1243620631-10749-2-git-send-email-felixb@sgi.com>
	<20090529192529.GA1599@infradead.org>
Date: Sat, 30 May 2009 12:43:54 +0200
In-Reply-To: <20090529192529.GA1599@infradead.org> (Christoph Hellwig's
	message of "Fri, 29 May 2009 15:25:29 -0400")
Message-ID: <87d49qeuqd.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:
>> 
>> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
>> index af6843c..d8d2321 100644
>> --- a/fs/xfs/linux-2.6/kmem.h
>> +++ b/fs/xfs/linux-2.6/kmem.h
>> @@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
>>  static inline int
>>  kmem_shake_allow(gfp_t gfp_mask)
>>  {
>> -	return (gfp_mask & __GFP_WAIT) != 0;
>> +	return ((gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS) != 0;
>
> Looks good to me.  But this could be written simpler as:
>
> 	return ((gfp_mask & (__GFP_WAIT|__GFP_FS)) != 0;

That's actually not equivalent. You would need to write

(gfp_mask & (__GFP_WAIT|__GFP_FS)) == (__GFP_WAIT|__GFP_FS)

which is not simpler. 

BTW you can usually trust gcc to do all the obvious logical
simplifications, so it's best to just write the most readable code
(like Felix's original version) And also it can depend on the target
what is actually better in machine language, and gcc has more
knowledge about that than the programmer.

int f(int x)
{
        return x & 1 && x & 2;  
}

gives for gcc 4.3

 andl    $3, %edi
 xorl    %eax, %eax
 cmpl    $3, %edi
 sete    %al
 ret

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
