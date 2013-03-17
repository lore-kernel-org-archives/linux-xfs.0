Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 912EA7F6B
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 18:53:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7479B304051
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 16:53:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mpbA7TrwwrxOXnNA for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 16:53:28 -0700 (PDT)
Date: Mon, 18 Mar 2013 10:53:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix ASSERTION failure in xfs_vm_write_failed()
Message-ID: <20130317235302.GL6369@dastard>
References: <5145DAB4.40007@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5145DAB4.40007@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Mar 17, 2013 at 11:01:08PM +0800, Jeff Liu wrote:
> Hello,
> 
> Yesterday, Michael reported that ran xfstest-078 got kernel panic when growing a
> small partition to a huge size(64-bit) on 32-bit system, this issue can be easily
> reproduced on the latest upstream 38 to 39-rc2 if CONFIG_XFS_DEBUG is enabled.
> According to my investigation, if the request pos offset exceeding 32-bit integer
> range, evaluate block_offset with pos & PAGE_MASK will cause overflows so that
> it most likely that the assert is not true.

Hi Jeff,

Nice work finding the root of the problem, but I think your fix
is wrong. Here's how I look at the problem - all the parameters are
loff_t, so everything should validate cleanly as 64 bit values.

typedef __kernel_loff_t         loff_t
typedef long long       __kernel_loff_t;

So there shouldn't be any overflows occurring that need masking like
this:

> This patch fix it by checking "block_offset + from == (pos & ~0UL)" instead.

So, what's the real problem?

#define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
#define PAGE_MASK       (~(PAGE_SIZE-1))

On a 32 bit system, PAGE_MASK = 0xfffff000, as an unsigned long.

And so this:

loff_t                  block_offset = pos & PAGE_MASK;

is also masking off the high 32 bits in pos.

That's why:

> +	/*
> +	 * Evaluate block_offset via (pos & PAGE_MASK) on 32-bit system
> +	 * can cause overflow if the request pos is 64-bit.  Hence we
> +	 * have to verify the write offset with (pos & ~0UL) to avoid it.
> +	 */
> +	ASSERT(block_offset + from == (pos & ~0UL));

Masking off the high bits of pos here makes the ASSERT failure go
away.  However, it doesn't fix the problem - it just shuts up the
warning that there's a problem.

The bug is that block_offset is passed into
xfs_vm_kill_delalloc_range(), and from above we now know that
block_offset doesn't have the correct value. This is a
potential data corruption bug, and catching this problem was the
reason the ASSERT() was placed in the code. i.e. ensuring we are
punching at the correct block offset into the file.

IOWs, the intention of the code is that block_offset should be a 64
bit value with the lower 12 bits masked out. Something like this:

	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;

Will clear the lower 12 bits, and then the ASSERT() should evaluate
correctly and the correct offset get passed to
xfs_vm_kill_delalloc_range(), fixing the bug....

i.e. whenever an ASSERT() fires, you need to look at the code for
bugs - more often than not the ASSERT() is correct and the fact that
it fired is indicative of a bug in the code. Hence changing the
ASSERT to stop it firing is almost always the wrong "fix". :)

Cheers,

Dave.


is telling us we have a bug in the code, not that the ASSERT needs
fixing.

i.e.

So, there's no overflow here - PAGE_MASK just doesn't work on 64 bit
offsets.

>  
>  	head = page_buffers(page);
>  	block_start = 0;
> -- 
> 1.7.9.5
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
