Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563127;
	b=q3NayLMsSKwIYEV39tx+31GRSWaTz+EAQoXZpsC4mUewaRX/hJBxoeyuP2MVG5qrBI+F
	 UBFZKUMkbjCrDNTguFT8vlH6oZY4A4JOXppS6JDjrkJGA91j0f65vJDlZpEBW7C470gRC
	 w4yTOX1drep28dfOWn5oTo8Y17uHIfR2hgdjqU3Gjo61JDw17Wjbu4mNCEfozf4Yd1bBw
	 sPH2BWiKXukG2jaH9hYzTnwTbFv086H6ToGV7WiUrh82f0QCYKYkn4q6JPTGCBSCi6niK
	 RpArxFFFVUNhpINvVsJUehVQT/2bI2hyLgdN7sSevh/gCArFxvUkMFIPf53s8Dbgpzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563127;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=9maGvXRQaCNT3iGa6KnlcrBKjyNiCGaT2SKE8+5ppl4=;
	b=jcG6wqCnTFN07zkDAREoXVT0ymngjm6dS8BJ6dCpbRVQ2zoE8c+M/h1WB5SSmYOULdvu
	 Pmh4V+9WBrsRHZSQ8zGbdNgfRbRBauP3osyNzFcFm0Qb8epoOifjzQddBni+cf0sJqVJk
	 epu8jxPDwLdokkRHZo3uc1NFTlOgcCJgkvMQ0xrdZ5B6wp3u7v5X7caDxh5zgdCUEH0OA
	 eGs3Xwbgh4JMCvNmBTqg7d4khqoTHDvRYsUb4Xs0EXSD9m5j3zgEXHlLu+rQQ9rQRk5mk
	 7H/JUxLFU53uUxFBsC/i6TCw+lmD3SLvPjukdv9YIrNQHF/rsHIitqTTLUVMjMV0Rnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qiRvbgt+;
	arc=none smtp.remote-ip=91.218.175.153
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC496606A31C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 09:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC496606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qiRvbgt+
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tIt5W2yVysz0C6c0WiAUoXuFquyWfvrCJVtGSZUAG24=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794563124; v=1; x=1795167924;
 b=qiRvbgt+WArrQiV/nnu8BZ5Bo/+4rHtjLw5LzgpOYdLydJxq2+9N0jX0IpcLhE4w9YCYo7rs
 u+m0KJ5FlVyCksjJVu7Jppo7aNaT7VS6a5xnqNgBOfKPpwErDAEGzMmOorRcnUr3K5OYVRstugq
 v0sti7pAAce060uhB0nnRAkE=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 3056ac4d99aaa11e;
	Fri, 13 Nov 2026 09:45:23 +0000
X-Mizu-Trace-ID: 3056ac4d99aaa11e
X-Migadu-Flow: FLOW_OUT
Message-ID: <b34aac03-0d43-4ed1-9561-cb6e0e9c582f@linux.dev>
Date: Fri, 13 Nov 2026 09:45:22 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (2) [PATCH v2] xfs: check the disk address for hardware atomic
 writes
To: daejun7.park@samsung.com, Carlos Maiolino <cem@kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Pankaj Raghav Partha Sarathy <p.raghav@samsung.com>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
 <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
 <CGME20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe@epcms2p5>
 <20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 02:55, Daejun Park wrote:
> On Thu, Nov 12, 2026 at 08:29:42AM +0000, John Garry wrote:
>> On 11/12/26 00:41, Daejun Park via B4 Relay wrote:
> [...]
>>> -	if (!IS_ALIGNED(imap->br_startblock, imap->br_blockcount))
>> Is there anywhere else in which we do an alignment check on
>> br_startblock that relies on the group size to be a multiple of the HW
>> awu max?
> No, I did not find another one. This is the only check of the start
> block for the REQ_ATOMIC path. Two other places depend on the group
> alignment, but neither checks br_startblock:
> 
> - xfs_get_atomic_write_max_opt() already caps max_opt at
>    xfs_calc_group_awu_align_max(), the largest power-of-two factor of
>    the group size (from ec8f62cc109a).
> - The allocator aligns the AG block number, not the disk address,
>    for example for XFS_BMAPI_EXTSZALIGN in
>    xfs_atomic_write_cow_iomap_begin(). In an unaligned AG, that extent
>    can still be misaligned on disk. With this patch, the next atomic
>    write to it goes through COW instead of failing.

hmm.. I am still not confident that this the best fix. And if it is, 
then I think that we should still change the size pre-check in 
xfs_file_dio_write_atomic(). Here's a combined change which I am 
thinking of:

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -776,7 +776,7 @@ xfs_file_dio_write_atomic(
          * HW offload should be faster, so try that first if it is already
          * known that the write length is not too large.
          */
-       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
+       if (ocount > xfs_get_atomic_write_max_opt())
                 dops = &xfs_atomic_write_cow_iomap_ops;
         else
                 dops = &xfs_direct_write_iomap_ops;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d5..c54aaa4b8816 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -863,7 +863,7 @@ xfs_bmap_hw_atomic_write_possible(
         /*
          * The ->iomap_begin caller should ensure this, but check anyway.
          */
-       return len <= xfs_inode_buftarg(ip)->bt_awu_max;
+       return len <= xfs_get_atomic_write_max_opt();
  }

bt_awu_max is the HW max, and you are saying that it is not aligned with 
the AG size (and so need a disk alignment check). However, opt max 
should be (aligned to AG size), so we could check that vs size instead.

Note that I am just using xfs_get_atomic_write_max_opt() for 
illustrative purposes and we could save this value in xfs_inode_buftarg().

BTW, with your proposed change, since HW size is not aligned to AG size 
and we only check the size vs HW size for HW offload, it is in theory 
possible to have an atomic write which straddles the AG and is rejected, 
right?

Thanks,
John
