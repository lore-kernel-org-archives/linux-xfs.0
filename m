Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.185
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044183;
	b=l/AdbBJ0edViDTJZykUhHrFNrRI33X9aB6kHx0djxdLKz4R1pd/QmW5T2DbPAMrqAEHN
	 az8vYRikLK3eUxzNSVSgTMmtM64eiIJOolqYbc+X9bI4Z1U0Bcemd/ewcTlD/amNkNTNN
	 mS/GDA3KZPs7BbxC/1N+UPsaeSPuDySpp61wEZ4XyNNZs9tg3nACq/8kxhLaki0wCQUYd
	 obZzec98KcHDKGLB7IdW3LD56M3NWIy+A5OVxGvIbMgQmGxlxd9k7DQEm6chdZc+A5i90
	 DLNAxj9KHzL/KJMX2wzWo6VKnb9UGTgyCKuCU6+cQZNu5HGxWvBKQofYLiat0ORy26Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044183;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=s5o1JfZ8s8OZpHikjU8eofXmAg3HiXGsG3uK535DyTU=;
	b=uvcp2r4oGW9srrdr1diUmvqna8+2uZAGKpBUdKHpjpMNREhnpMA6fUp1yngD1IADIzlo
	 E8EWe/SfcElo5lSnEIJQ8DbBhejlxTvIz9JPNjUVLNi9pN6nodV/s6K8Uwhwlq+i0x+L3
	 gQWXTRw3MMHoHF6b4/78XpvsLMf9nmqR9ceR1vC0IIolRXwUNZ/T/5PoAkQ6v6YTqkfgD
	 e9XsQOUFhKfM60goP1ZLgP98xn5p+Ss/ddbfWiatOk7PGOAeLj/Ti9iJP+NX7DCexU9Ru
	 QgB0X2oJ03SSnq4GqbYl7AyBIY7uGuDSv3TBPSuMbe2NEn5rtH1EuRsEVFTh8eZvsAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1Kpo35T;
	arc=none smtp.remote-ip=95.215.58.185
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212A1606A31D
	for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2026 19:49:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 212A1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1Kpo35T
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PjbJJelvVJ6B6cPqisk1DgDrVh3aptAEhIYn4TN7GLU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793044175; v=1; x=1793648975;
 b=p1Kpo35TcU+dvKKO1OILqLn4Ac+xPSxW4VbLgPyK8twr003AqiowVmd19eSOLykKahuAZt8G
 rv3DCRqvRvddEJI8oRSgo84hrpRND4h8nOWoGzfsCeFPOStRuERl/9sm6hF6/7LfcZt/KIcfc7T
 JJr2HxM5YHZqSSzplN5+LOmA=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id efdcd7248784fbba;
	Mon, 26 Oct 2026 19:49:35 +0000
X-Mizu-Trace-ID: efdcd7248784fbba
X-Migadu-Flow: FLOW_OUT
Date: Mon, 26 Oct 2026 20:49:26 +0100
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, da.gomez@kernel.org, 
	gost.dev@samsung.com
Subject: Re: [PATCH] iomap: only follow dio alignment requirement if specified
Message-ID: <at-p1QXETaTvvj_r@quentin>
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>

On Mon, Oct 26, 2026 at 05:18:13PM +1030, Qu Wenruo wrote:
> 
> [CAUSE]
> The failed command of fsx is COPY_RANGE:
> 
>  copy range: 0x6800 to 0xa200 at 0x3f200
>  do_copy_range:: Resource temporarily unavailable
>  LOG DUMP (8 total operations):
>  1(  1 mod 256): SKIPPED (no operation)
>  2(  2 mod 256): SKIPPED (no operation)
>  3(  3 mod 256): WRITE    0x14400 thru 0x211ff	(0xce00 bytes) HOLE
>  4(  4 mod 256): FALLOC   0x72bf4 thru 0x76221	(0x362d bytes) EXTENDING
>  5(  5 mod 256): SKIPPED (no operation)
>  6(  6 mod 256): INSERT 0x11000 thru 0x13fff	(0x3000 bytes)
>  7(  7 mod 256): TRUNCATE DOWN	from 0x79221 to 0xa800
>  8(  8 mod 256): COPY 0x6800 thru 0xa1ff	(0x3a00 bytes) to 0x3f200 thru 0x42bff
>  Log of operations saved to "/mnt/test/junk.fsxops"; replay with --replay-ops
>  Correct content saved for comparison
>  (maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")
> 
> Both ext4 and xfs only require direct IO to be aligned to the logical
> block size of the device, not the fs block size. So the 0x3a00 bytes
> read at 0x6800 is allowed, and should succeed.
> 
> But that range is a hole, and that commit makes iomap_dio_hole_iter()
> round the zeroed length down to the fs block size unconditionally.
> The first iteration zeroes 0x3a00 bytes but only advances 0x3000 bytes,
> then the next iteration zeroes the remaining 0xa00 bytes, which is
> rounded down to 0, so -EFAULT is returned.
> 
> As ext4 and xfs do not pass IOMAP_DIO_PARTIAL, the whole read fails
> with -EFAULT, which is then converted to -EAGAIN by copy_splice_read().
> Every retry of fsx hits the same -EAGAIN, failing the run.
> 
> That commit breaks all direct reads which range is not fs block aligned
> for ext4 and xfs.
> 
> [FIX]
> Do not revert the range unless the dio has IOMAP_DIO_FSBLOCK_ALIGNED flag.
> 
> iomap_dio_hole_iter() is only called for reads, and for now only btrfs
> reads can reach this path with the flag set. Btrfs has the proper
> fallback when dio returns -EFAULT.
> 
> Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap_dio_hole_iter()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/iomap/direct-io.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 

Ignore my previous question (I had a old version of xfstests).
I was able to reproduce the error on XFS, ext4 and this patch fixes it.

One small nit: should we update the IOMAP_DIO_FSBLOCK_ALIGNED flag
documentation to reflect this?

At the moment the document says "Ensure each bio is aligned to fs block
size". Should we expand it to say "Ensure each bio and any progress
reported for hole/unwritten extents is aligned to fs block size"?

But the changes look good to me, so:
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj
