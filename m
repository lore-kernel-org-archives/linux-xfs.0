Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5AC17F72
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 23:13:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8BBB30405F
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 21:13:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mcyP3N1P8Sr1WjOr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 21:12:59 -0700 (PDT)
Message-ID: <5146943F.5080003@oracle.com>
Date: Mon, 18 Mar 2013 12:12:47 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix ASSERTION failure in xfs_vm_write_failed()
References: <5145DAB4.40007@oracle.com> <20130317235302.GL6369@dastard>
In-Reply-To: <20130317235302.GL6369@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

On 03/18/2013 07:53 AM, Dave Chinner wrote:
> On Sun, Mar 17, 2013 at 11:01:08PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> Yesterday, Michael reported that ran xfstest-078 got kernel panic when growing a
>> small partition to a huge size(64-bit) on 32-bit system, this issue can be easily
>> reproduced on the latest upstream 38 to 39-rc2 if CONFIG_XFS_DEBUG is enabled.
>> According to my investigation, if the request pos offset exceeding 32-bit integer
>> range, evaluate block_offset with pos & PAGE_MASK will cause overflows so that
>> it most likely that the assert is not true.
> 
> Hi Jeff,
> 
> Nice work finding the root of the problem, but I think your fix
> is wrong. Here's how I look at the problem - all the parameters are
> loff_t, so everything should validate cleanly as 64 bit values.
> 
> typedef __kernel_loff_t         loff_t
> typedef long long       __kernel_loff_t;
> 
> So there shouldn't be any overflows occurring that need masking like
> this:
> 
>> This patch fix it by checking "block_offset + from == (pos & ~0UL)" instead.
> 
> So, what's the real problem?
> 
> #define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
> #define PAGE_MASK       (~(PAGE_SIZE-1))
> 
> On a 32 bit system, PAGE_MASK = 0xfffff000, as an unsigned long.
> 
> And so this:
> 
> loff_t                  block_offset = pos & PAGE_MASK;
> 
> is also masking off the high 32 bits in pos.
Exactly.  It's not an overflow as the block_offset is 64-bit, but the
original evaluated value missing the high 32-bits of pos.
> 
> That's why:
> 
>> +	/*
>> +	 * Evaluate block_offset via (pos & PAGE_MASK) on 32-bit system
>> +	 * can cause overflow if the request pos is 64-bit.  Hence we
>> +	 * have to verify the write offset with (pos & ~0UL) to avoid it.
>> +	 */
>> +	ASSERT(block_offset + from == (pos & ~0UL));
> 
> Masking off the high bits of pos here makes the ASSERT failure go
> away.  However, it doesn't fix the problem - it just shuts up the
> warning that there's a problem.
> 
> The bug is that block_offset is passed into
> xfs_vm_kill_delalloc_range(), and from above we now know that
> block_offset doesn't have the correct value. This is a
> potential data corruption bug, and catching this problem was the
> reason the ASSERT() was placed in the code. i.e. ensuring we are
> punching at the correct block offset into the file.
> 
> IOWs, the intention of the code is that block_offset should be a 64
> bit value with the lower 12 bits masked out. Something like this:
> 
> 	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
> 
> Will clear the lower 12 bits, and then the ASSERT() should evaluate
> correctly and the correct offset get passed to
> xfs_vm_kill_delalloc_range(), fixing the bug....
Yep. so we figure the 'from' out with the lower 12 bits in pos only, and
have block_offset with left higher bits in this way.
I will resent a patch according to your comments.
> 
> i.e. whenever an ASSERT() fires, you need to look at the code for
> bugs - more often than not the ASSERT() is correct and the fact that
> it fired is indicative of a bug in the code. Hence changing the
> ASSERT to stop it firing is almost always the wrong "fix". :)
Thanks for your teaching!

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
