Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1792609EC;
	Thu,  1 May 2025 23:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746143918; cv=none; b=nUVb9EVigPg7mKDrYn23zKfsaoOosIsHKTOQGZm9UQoHGBXpfBuAFquDUZFHryrF7DlWk6glvnSe8VyzSGcx4pXCPO+zo3RXjr3bQBExn4za0wVLKAqmzit61pd4F7g+ZPyxd2ekJMxb1pD9aaXwmvDy51+0CsopQmnvVA9OkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746143918; c=relaxed/simple;
	bh=HAHwLaAzx4ZbdiMXM1+psW/QTXDMEoyo+ipEXG8FSq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=opkdl1kXNknU9lVaeSTWNG7XDyFeWrbGvzNKG1i3zl21SErscRMDPFbKP9rOOBlbq9o+fa+T9JyfvuKwbj1Z/qKZybwdccz91O/HTJg0CASTtP3Cn4P2veNO4ocmln5W9zQUSjUmY9ZtEtkIJT4wqkUB/Gw/HOVHqaBOvK2owkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pV3Wcwux; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pV3Wcwux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=gllwsGzDq3jA2ddJFMfVgZDKSyUZMTwmjn+v8MWPgFs=;
	b=pV3WcwuxAwQjvXI0yJprGBllAHQ2IhNer84LSLhnlwjDqhQeP2g45GWMA5AObS
	do+MDTgFNvlonjcUUAlYomq1tjcsW5F3Ys/h/n4K6KZi8bg+eLvKrM6YeCzUaVp+
	3hIryzlltAVw+8lk+7/hcQfTiSM6PKzN0qer+13DZgiRY=
Received: from [192.168.0.109] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wCH3iOHChRothmhDw--.5760S2;
	Fri, 02 May 2025 07:58:01 +0800 (CST)
Message-ID: <395042eb-3986-45c1-88c1-482b750303c7@163.com>
Date: Fri, 2 May 2025 07:57:59 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Implement concurrent buffered write with folio
 lock
To: Dave Chinner <david@fromorbit.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20250425103841.3164087-1-chizhiling@163.com>
 <aBGFfpyGtYQnK411@dread.disaster.area>
 <040637ad-54ac-4695-8e49-b4a3c643b056@163.com>
 <aBK2HAnoRacuO0CO@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <aBK2HAnoRacuO0CO@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCH3iOHChRothmhDw--.5760S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3AF1xur1fXF4fJr1Duw1rWFg_yoW3Jw1kpF
	ZYkasrGr4kXr18ur4kt3Wjvr15Kw4IgrW7Cr15Wwn7Zwn8Xr12qr1IvFyF9FWjvrsav3yq
	vF4jk348Z345AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U20PhUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgB1AnWgT+uzbEgAAsk

On 2025/5/1 07:45, Dave Chinner wrote:
> On Wed, Apr 30, 2025 at 05:03:51PM +0800, Chi Zhiling wrote:
>> On 2025/4/30 10:05, Dave Chinner wrote:
>>> On Fri, Apr 25, 2025 at 06:38:39PM +0800, Chi Zhiling wrote:
>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>
>>>> This is a patch attempting to implement concurrent buffered writes.
>>>> The main idea is to use the folio lock to ensure the atomicity of the
>>>> write when writing to a single folio, instead of using the i_rwsem.
>>>>
>>>> I tried the "folio batch" solution, which is a great idea, but during
>>>> testing, I encountered an OOM issue because the locked folios couldn't
>>>> be reclaimed.
>>>>
>>>> So for now, I can only allow concurrent writes within a single block.
>>>> The good news is that since we already support BS > PS, we can use a
>>>> larger block size to enable higher granularity concurrency.
>>>
>>> I'm not going to say no to this, but I think it's a short term and
>>> niche solution to the general problem of enabling shared buffered
>>> writes. i.e. I expect that it will not exist for long, whilst
>>
>> Hi, Dave,
>>
>> Yes, it's a short-term solution, but it's enough for some scenarios.
>> I would also like to see better idea.
>>
>>> experience tells me that adding special cases to the IO path locking
>>> has a fairly high risk of unexpected regressions and/or data
>>> corruption....
>>
>> I can't say there is definitely no data corruption, but I haven't seen
>> any new errors in xfstests.
> 
> Yeah, that's why they are "unexpected regressions" - testing looks
> fine, but once it gets out into complex production workloads....
> 
>> We might need to add some assertions in the code to check for the risk
>> of data corruption, not specifically for this patch, but for the current
>> XFS system in general. This would help developers avoid introducing new
>> bugs, similar to the lockdep tool.
> 
> I'm not sure what you invisage here or what problems you think we
> might be able to catch - can you describe what you are thinking
> about here?

I'm just say it casually.

I mean, is there a way to check for data corruption risks, rather than
waiting for it to happen and then reporting an error? Just like how
lockdep detects deadlock risks in advance.

I guess not.

> 
>>>> These ideas come from previous discussions:
>>>> https://lore.kernel.org/all/953b0499-5832-49dc-8580-436cf625db8c@163.com/
>>>
>>> In my spare time I've been looking at using the two state lock from
>>> bcachefs for this because it looks to provide a general solution to
>>> the issue of concurrent buffered writes.
>>
>> In fact, I have tried the two state lock, and it does work quite well.
>> However, I noticed some performance degradation in single-threaded
>> scenarios in UnixBench (I'm not sure if it's caused by the memory
>> barrier).
> 
> Please share the patch - I'd like to see how you implemented it and
> how you solved the various lock ordering and wider IO serialisation
> issues. It may be that I've overlooked something and your
> implementation makes me aware of it. OTOH, I might see something in
> your patch that could be improved that mitigates the regression.

I think I haven't solved these problems.

The lock order I envisioned is IOLOCK -> TWO_STATE_LOCK -> MMAP_LOCK ->
ILOCK, which means that when releasing IOLOCK, TWO_STATE_LOCK should
also be released first, including when upgrading IOLOCK_SHARED to
IOLOCK_EXCL. However, I didn't do this.

I missed this part, and although I didn't encounter any issues in the
xfstests, this could indeed lead to a deadlock.


Besides this, is there anything else I have missed?



The patch is as follows, though it's not helpful

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3e7448c2a969..573e31bfef3f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,17 @@

  static const struct vm_operations_struct xfs_file_vm_ops;

+#define TWO_STATE_LOCK(ip, state)		\
+	xfs_two_state_lock(&ip->i_write_lock, state)
+
+#define TWO_STATE_UNLOCK(ip, state)		\
+	xfs_two_state_unlock(&ip->i_write_lock, state)
+
+#define buffered_lock(inode)	TWO_STATE_LOCK(inode, 0)
+#define buffered_unlock(inode)	TWO_STATE_UNLOCK(inode, 0)
+#define direct_lock(inode)	TWO_STATE_LOCK(inode, 1)
+#define direct_unlock(inode)	TWO_STATE_UNLOCK(inode, 1)
+
  /*
   * Decide if the given file range is aligned to the size of the 
fundamental
   * allocation unit for the file.
@@ -263,7 +274,10 @@ xfs_file_dio_read(
  	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
  	if (ret)
  		return ret;
+	direct_lock(ip);
  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, NULL, 0);
+	direct_unlock(ip);
+
  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);

  	return ret;
@@ -598,9 +612,13 @@ xfs_file_dio_write_aligned(
  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
  		iolock = XFS_IOLOCK_SHARED;
  	}
+
+	direct_lock(ip);
  	trace_xfs_file_direct_write(iocb, from);
  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
  			   &xfs_dio_write_ops, 0, NULL, 0);
+	direct_unlock(ip);
+
  out_unlock:
  	if (iolock)
  		xfs_iunlock(ip, iolock);
@@ -676,9 +694,11 @@ xfs_file_dio_write_unaligned(
  	if (flags & IOMAP_DIO_FORCE_WAIT)
  		inode_dio_wait(VFS_I(ip));

+	direct_lock(ip);
  	trace_xfs_file_direct_write(iocb, from);
  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
  			   &xfs_dio_write_ops, flags, NULL, 0);
+	direct_unlock(ip);

  	/*
  	 * Retry unaligned I/O with exclusive blocking semantics if the DIO
@@ -776,9 +796,11 @@ xfs_file_buffered_write(
  	if (ret)
  		goto out;

+	buffered_lock(ip);
  	trace_xfs_file_buffered_write(iocb, from);
  	ret = iomap_file_buffered_write(iocb, from,
  			&xfs_buffered_write_iomap_ops);
+	buffered_unlock(ip);

  	/*
  	 * If we hit a space limit, try to free up some lingering preallocated
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 52210a54fe7e..a8bc8d9737c4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -114,6 +114,7 @@ xfs_inode_alloc(
  	spin_lock_init(&ip->i_ioend_lock);
  	ip->i_next_unlinked = NULLAGINO;
  	ip->i_prev_unlinked = 0;
+	two_state_lock_init(&ip->i_write_lock);

  	return ip;
  }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b91aaa23ea1e..9a8c75feda16 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -8,6 +8,7 @@

  #include "xfs_inode_buf.h"
  #include "xfs_inode_fork.h"
+#include "xfs_lock.h"

  /*
   * Kernel only inode definitions
@@ -92,6 +93,8 @@ typedef struct xfs_inode {
  	spinlock_t		i_ioend_lock;
  	struct work_struct	i_ioend_work;
  	struct list_head	i_ioend_list;
+
+	two_state_lock_t	i_write_lock;
  } xfs_inode_t;

  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)



Thanks

> 
>> Since single-threaded bufferedio is still the primary read-write mode,
>> I don't want to introduce too much impact in single-threaded scenarios.
> 
> I mostly don't care that much about small single threaded
> performance regressions anywhere in XFS if there is some upside for
> scalability or performance. We've always traded off single threaded
> performance for better concurrency and/or scalability in XFS (right
> from the initial design choices way back in the early 1990s), so I
> don't see why we'd treat a significant improvement in buffered IO
> concurrency any differently.
> 
> -Dave.

