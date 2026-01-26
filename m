Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CDC293B75;
	Mon, 26 Jan 2026 20:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769459457; cv=none; b=glrHSR52whHQP0yZNJAixg4uhGo3fq5JgXpjGM/taze2FtP0Lt/IM6xOR1CO+x+oQo5LW4vrydbb2OIcIy+Gpym+whPO1A92F+8wjT4QcRo75PxNSSrOfULYUzIKbddXoOeqUeIJnwB2WwYLiSAI9glAS1j0LhTWyjNnVYol3to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769459457; c=relaxed/simple;
	bh=wcRS12150jQDMEIw41aY5AmWZmd5Z7+BTq28L69cujc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qow/q0jdssfLFa3T1k7hyfnQsLocDT1x+bxZgm61++eCMBS7vSWRjeofuSeNIJ335rZfbicVX6ymIKv5Ost5mLgIn1GC0XoGVlPdv9H2o6Fp0FqdVlfye+ZOckwHGlj8jsdvcEyRONrxtJKOEZkTAs7UE7B76HdMOB0J0pH3Y6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGY88YJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGY88YJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF7BC116C6;
	Mon, 26 Jan 2026 20:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769459457;
	bh=wcRS12150jQDMEIw41aY5AmWZmd5Z7+BTq28L69cujc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vGY88YJsobn0/JQgNGlUIQOfFu5byl/b2ZdzMy1QxxkzyUnUHdgDYLMo2YpCXP33B
	 TvAkDlcDwmTEi3NoRdYG/rAd6UnoFtygLlevYZNgPrxUWpTl+ZNmMosHxacOQ6d00Q
	 mN4fDkKHX/T43yS0Df9hw4/aElYY2S5X1QN4wVPmRhxNvZ395CFB8Ikz4DCbBM7ETh
	 jrA6kD6Lqaxnnf+AGDomvAHKpgnKaOPo9LUDYbnPFiOkKDNpB55VrTsNtHireLfGCV
	 o2Qyj3+a4pKYElvCWead1n2qLc9hRvJHWRfF/nQtf8HpqxDkc7vqUk8DUqYB0Y5KYp
	 KBvyo5sSH2VqA==
Date: Mon, 26 Jan 2026 13:30:54 -0700
From: Keith Busch <kbusch@kernel.org>
To: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
Message-ID: <aXfO_ghd0yoKK8dm@kbusch-mbp>
References: <20260114130651.3439765-4-hch@lst.de>
 <20260125000314.561545-1-clm@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125000314.561545-1-clm@meta.com>

On Sat, Jan 24, 2026 at 04:03:04PM -0800, Chris Mason wrote:
> On Wed, 14 Jan 2026 14:06:43 +0100 Christoph Hellwig <hch@lst.de> wrote:
> > @@ -590,7 +578,12 @@ xfs_zone_gc_ensure_target(
> >  xfs_zone_gc_scratch_available(
> >  	struct xfs_zone_gc_data	*data)
> >  {
> > -	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
> > +	if (!data->scratch_tail)
> > +		return data->scratch_size - data->scratch_head;
> > +
> > +	if (!data->scratch_head)
> > +		return data->scratch_tail;
> > +	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
> >  }
> 
> Can this function correctly distinguish between an empty and full ring
> buffer?
> 
> When scratch_head wraps back to 0 and scratch_tail is also 0 (because no
> I/O has completed yet), the first condition returns scratch_size (2MB),
> indicating the buffer is empty.  But if the buffer just filled completely
> and head wrapped to 0, the buffer is actually full, and the available
> space should be 0.
> 
> Consider this sequence in xfs_zone_gc_handle_work():
>   - Initial: head=0, tail=0, available=2MB (correct, empty)
>   - After 1MB chunk: head=1MB, tail=0, available=1MB (correct)
>   - After another 1MB chunk: head=0 (wrapped), tail=0, available=2MB (wrong)
> 
> The buffer is full but the function reports it as empty.  The while loop
> in xfs_zone_gc_handle_work() calling xfs_zone_gc_start_chunk() would then
> continue adding more data, overwriting the buffer contents from the first
> chunk before its I/O completes.

I think you're right that ring wrap can't distinguish full vs. empty here.
 
> A common solution is to track a separate count, or to sacrifice one slot
> so head == tail always means empty, and head == tail-1 means full.

The buffer size is a power of two, so I suggest just let scratch_head
and scratch_tail only increment without modulo, and rely on the unsigned
int wrapping. We can get the actual offset by masking the head with the
scratch size.

---
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index ba4f8e011e36c..7d2bd0dc8b322 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -578,12 +578,7 @@ static unsigned int
 xfs_zone_gc_scratch_available(
 	struct xfs_zone_gc_data	*data)
 {
-	if (!data->scratch_tail)
-		return data->scratch_size - data->scratch_head;
-
-	if (!data->scratch_head)
-		return data->scratch_tail;
-	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
+	return data->scratch_size - (data->scratch_head - data->scratch_tail);
 }
 
 static bool
@@ -663,7 +658,7 @@ xfs_zone_gc_add_data(
 {
 	struct xfs_zone_gc_data	*data = chunk->data;
 	unsigned int		len = chunk->len;
-	unsigned int		off = data->scratch_head;
+	unsigned int		off = data->scratch_head & (data->scratch_size - 1);
 
 	do {
 		unsigned int	this_off = off % XFS_GC_BUF_SIZE;
@@ -729,7 +724,7 @@ xfs_zone_gc_start_chunk(
 	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
 	bio->bi_end_io = xfs_zone_gc_end_io;
 	xfs_zone_gc_add_data(chunk);
-	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
+	data->scratch_head = data->scratch_head + len;
 
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_add_tail(&chunk->entry, &data->reading);
@@ -860,8 +855,7 @@ xfs_zone_gc_finish_chunk(
 		return;
 	}
 
-	data->scratch_tail =
-		(data->scratch_tail + chunk->len) % data->scratch_size;
+	data->scratch_tail = data->scratch_tail + chunk->len;
 
 	/*
 	 * Cycle through the iolock and wait for direct I/O and layouts to

--
