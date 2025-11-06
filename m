Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7126134D919
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446184; cv=none; b=Ernc+bjhdYEmRztbvWI+6mHOB6tMtDYz7rUG7Il2XUuc3abpwOzdLAoeALSMrUnkUljt8ImlJuANQl5Oz6AC76dR2Nw68aZbvjzuMwNDIitChrzBh5Ev9+yMu3QiQi6nBusp2PzWBJsV3KNP/OW1k3OEZq84Pvw6Omr0/tnsagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446184; c=relaxed/simple;
	bh=QMwx9Y+xF9cVbWXfyXeGBs4ta6W7qz9juYRb33R/OYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yu6Ds3qETW0a5OaIWAN5S+gpP4rfNEA4dyqw6ftyJft38DRUzx/w6CbCixyUWyZe7yI1aSw2CXyCzmGA1mkDRS9xxT3m7kHnrCkexibeJ1sQA6iFqgrccWJT7cOS5UGE03b9RMvc0Rg/7hS5r10vc3DiBoyevOWlrK6TyyfGS24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EIzFfYv0; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EIzFfYv0"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so1770375a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Nov 2025 08:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762446179; x=1763050979; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vNsPx84ow00us8mQGNUZ/5IigkZKqRCW8jzXpmXKZ2g=;
        b=EIzFfYv0qSKDrFeQ4pLXNv2fEpXq2CbjwVay8WR7wsoR3A+sGp+VI5XAdmHz5sKvsY
         g75Pv0nc5wKQ7GontmeUtNPk9+ff90eld3IV71RVkQu8MYYTgCrSU/i7T8V9EGqpTt3l
         WsSZzDJuE1v/My3Fp9Hlin4xJXdU8d4xholJo5gn2gb7HycmTsEdZaj2hSWP23K3ZYMr
         fiDvyi8xxtxQwsor1mMRCQhPtI7oaAd7ddZD1nIsmXvnpudkQL5Gx4/Zc8D6Lj54rnQx
         n11utpUQqQws1Sto3JPZcv9GIdCA/hICOzbkuRVfhkPHNrbPHmVD681pTy9EhPAzY9eE
         KKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446179; x=1763050979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNsPx84ow00us8mQGNUZ/5IigkZKqRCW8jzXpmXKZ2g=;
        b=sj7mwAfSwZbKM0IdOPpi76gc4ALzB86JH+WrBxH/f4h4piROfXLbS7NCCnHYDQsv8C
         9Ciaor0wbI5PP2LpRneiWPcnCR0Ji8OOuhZzGTwWumSTgfAVj7IiN3Ov5DFUlMZE6gom
         xUUTZNj8k52hlM3M+s5+xUV6+X1q1CRygFCDANOZmg2uGXZmfHzT3l6cI/j/aS8ZLnmV
         sytI6X9xinLtZ8r5faI5jMNpHjqOkvhaGf3ld8dRf4m5oIvFwpetyxVClOdmh+RhF19L
         qW3S9QCosN5NWl59C3Eg/oAJ6L8e5GCqheYxfQk/dHbLb1TEDT5WlUgPmwnEH9m+SG8v
         0pqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmz5DZHH+vjhzWwgGkxNrUzpH76FXAQSiKc928EIm15CkpVMfPlq1K+FEp80dXebh3qFP4462Moxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1BOok4WLnhvnAV+OtSxsgA0VstMLzlVXqz2hW8Rnj2fQ4bFqq
	L2N5muQBR60lCnf1rRWtLckd+AQ5HDtPTAorixZyeI5lsHjtKOFcODqnLc+WgdT+oh0=
X-Gm-Gg: ASbGncvf8v06UkRFUqgfEAKoFUUIMTen5DOt6pKqvy8rc6Pt1hju+W+laeuybjxDyTP
	pV+CDVGQZ7IU99+qLZrEH618+n0AvSjALcqOMg300hGHsjwyaZAtrIafN75H9D4RAbUkCfPZR/N
	x1cJ09URNSas6brob3FoBPV1CKf0aSXHLsuhMXriRfqYnyRE45yEmlFvhumSHF1yMrhS2FThkR+
	f8b71cI8HZ0nE+i7Irf0jk++bEsW9Ld9HorHxb5BwyhfiWineO36YeQKx9WqzBb6JeFRMavm6Se
	Nfrykq+s00zSouB5JFZ8CANn7SdImXjWhaqTA33r+F4WdmgNcvEPZ7Hgir5/QkZyVXQZ8RYyA+Z
	eOv08zSTgvlxA6g0btk47uLp/GFIkXGWYv+w0t1ZiBJ0UA52uVq9EqdhmzozAUrW5MWlgUCKGDQ
	6DHt8ntbumKUrSCA==
X-Google-Smtp-Source: AGHT+IE08HmORqHbz2m0uvai3cj8NgPnbGUJ7c/vK84uqQfLOz86XCiAJbCrlgBPuPPnAW3Py/FEIA==
X-Received: by 2002:a17:907:9409:b0:b40:b54d:e687 with SMTP id a640c23a62f3a-b726561117amr730715966b.47.1762446178676;
        Thu, 06 Nov 2025 08:22:58 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72893cc74bsm244483466b.33.2025.11.06.08.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:22:58 -0800 (PST)
Date: Thu, 6 Nov 2025 17:22:55 +0100
From: Petr Mladek <pmladek@suse.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	syzbot <syzbot+3686758660f980b402dc@syzkaller.appspotmail.com>,
	"amurray@thegoodpenguin.co.uk" <amurray@thegoodpenguin.co.uk>,
	brauner@kernel.org, chao@kernel.org, djwong@kernel.org,
	jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [iomap?] kernel BUG in folio_end_read (2)
Message-ID: <aQzLX_y8PvBMiZ9f@pathway.suse.cz>
References: <CAJnrk1bF8sLU6tG2MGkt_KR4BoTd_k01CMVZJ9js2-eyh80tbw@mail.gmail.com>
 <69096836.a70a0220.88fb8.0006.GAE@google.com>
 <CAJnrk1Yo4dRVSaPCaAGkHc+in03KaTXJ+KxckhLoSrRxbEdDBg@mail.gmail.com>
 <aQpFLJM96uRpO4S-@pathway.suse.cz>
 <87ldkk34yj.fsf@jogness.linutronix.de>
 <aQuABK25fdBVTGZc@pathway.suse.cz>
 <87bjlgqmk5.fsf@jogness.linutronix.de>
 <87tsz7iea2.fsf@jogness.linutronix.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tsz7iea2.fsf@jogness.linutronix.de>

On Thu 2025-11-06 12:42:21, John Ogness wrote:
> On 2025-11-05, John Ogness <john.ogness@linutronix.de> wrote:
> >> Another question is whether this is the only problem caused the patch.
> >
> > This comparison is quite special. It caught my attention while combing
> > through the code.
> 
> The reason that this comparison is special is because it is the only one
> that does not take wrapping into account. I did it that way originally
> because it is AND with a wrap check. But this is an ugly special
> case. It should use the same wrap check as the other 3 cases in
> nbcon.c. If it had, the bug would not have happened.

I think that there are actually some differences between the
comparsions, see below.

> I always considered these wrap checks to be non-obvious and
> error-prone. So what if we create a nice helper function to simplify and
> unify the wrap checks? Something like this:

But I agree that some wrappers with a good description
would be helpful.

> diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
> index 839f504db6d30..8499ee642c31d 100644
> --- a/kernel/printk/printk_ringbuffer.c
> +++ b/kernel/printk/printk_ringbuffer.c
> @@ -390,6 +390,17 @@ static unsigned int to_blk_size(unsigned int size)
>  	return size;
>  }
>  
> +/*
> + * Check if @lpos1 is before @lpos2. This takes ringbuffer wrapping
> + * into account. If @lpos1 is more than a full wrap before @lpos2,
> + * it is considered to be after @lpos2.

The 2nd sentence is a brain teaser ;-)

> + */
> +static bool lpos1_before_lpos2(struct prb_data_ring *data_ring,
> +			       unsigned long lpos1, unsigned long lpos2)
> +{
> +	return lpos2 - lpos1 - 1 < DATA_SIZE(data_ring);
> +}

It would be nice to describe the semantic a more clean way. Sigh,
it is not easy. I tried several variants and ended up with:

   + using "lt" instead of "before" because "lower than" is
     a well known mathematical therm.

   + adding "_safe" suffix to make it clear that it is not
     a simple mathematical comparsion. It takes the wrap
     into account.

Something like:

/*
 * Returns true when @lpos1 is lower than @lpos2 and both values
 * are comparable.
 *
 * It is safe when the compared values are read a lock less way.
 * One of them must be already overwritten when the difference
 * is bigger then the data ring buffer size.
 */
static bool lpos1_lt_lpos2_safe(struct prb_data_ring *data_ring,
				unsined long lpos1, unsigned long lpos2)
{
	return lpos2 - lpos1 - 1 < DATA_SIZE(data_ring);
}

>  /*
>   * Sanity checker for reserve size. The ringbuffer code assumes that a data
>   * block does not exceed the maximum possible size that could fit within the
> @@ -577,7 +588,7 @@ static bool data_make_reusable(struct printk_ringbuffer *rb,
>  	unsigned long id;
>  
>  	/* Loop until @lpos_begin has advanced to or beyond @lpos_end. */
> -	while ((lpos_end - lpos_begin) - 1 < DATA_SIZE(data_ring)) {
> +	while (lpos1_before_lpos2(data_ring, lpos_begin, lpos_end)) {

lpos1_lt_lpos2_safe() fits here.

>  		blk = to_block(data_ring, lpos_begin);
>  		/*
> @@ -668,7 +679,7 @@ static bool data_push_tail(struct printk_ringbuffer *rb, unsigned long lpos)
>  	 * sees the new tail lpos, any descriptor states that transitioned to
>  	 * the reusable state must already be visible.
>  	 */
> -	while ((lpos - tail_lpos) - 1 < DATA_SIZE(data_ring)) {
> +	while (lpos1_before_lpos2(data_ring, tail_lpos, lpos)) {
>  		/*
>  		 * Make all descriptors reusable that are associated with
>  		 * data blocks before @lpos.

Same here.

> @@ -1149,7 +1160,7 @@ static char *data_realloc(struct printk_ringbuffer *rb, unsigned int size,
>  	next_lpos = get_next_lpos(data_ring, blk_lpos->begin, size);
>  
>  	/* If the data block does not increase, there is nothing to do. */
> -	if (head_lpos - next_lpos < DATA_SIZE(data_ring)) {
> +	if (!lpos1_before_lpos2(data_ring, head_lpos, next_lpos)) {

I think that the original code was correct. And using the "-1" is
wrong here.

Both data_make_reusable() and data_push_tail() had to use "-1"
because it was the "lower than" semantic. But in this case,
we do not need to do anything even when "head_lpos == next_lpos"

By other words, both data_make_reusable() and data_push_tail()
needed to make a free space when the position was "lower than".
There was enough space when the values were "equal".

It means that "equal" should be OK in data_realloc(). By other
words, data_realloc() should use "le" aka "less or equal"
semantic.

The helper function might be:

/*
 * Returns true when @lpos1 is lower or equal than @lpos2 and both
 * values are comparable.
 *
 * It is safe when the compared values are read a lock less way.
 * One of them must be already overwritten when the difference
 * is bigger then the data ring buffer size.
 */
static bool lpos1_le_lpos2_safe(struct prb_data_ring *data_ring,
				unsined long lpos1, unsigned long lpos2)
{
	return lpos2 - lpos1 < DATA_SIZE(data_ring);
}


>  		if (wrapped)
>  			blk = to_block(data_ring, 0);
>  		else
> @@ -1262,7 +1273,7 @@ static const char *get_data(struct prb_data_ring *data_ring,
>  
>  	/* Regular data block: @begin less than @next and in same wrap. */
>  	if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next) &&
> -	    blk_lpos->begin < blk_lpos->next) {
> +	    lpos1_before_lpos2(data_ring, blk_lpos->begin, blk_lpos->next)) {

Hmm, I think that it is more complicated here.

The "lower than" semantic is weird here. One would expect that "equal"
values, aka "zero size" is perfectly fine.

It does not hurt because the "zero size" case is already handled
earlier. But still, the "lower than" semantic does not fit here.

IMHO, the main motivation for this fix is to make sure that
blk_lpos->begin and blk_lpos->next will produce a valid
*data_size.

From this POV, even lpos1_le_lpos2_safe() does not fit here
because the data_size must be lower than half of the size
of the ring buffer.

> 		db = to_block(data_ring, blk_lpos->begin);
>  		*data_size = blk_lpos->next - blk_lpos->begin;

I think that we should do the following:

diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index 839f504db6d3..78e02711872e 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -1260,9 +1260,8 @@ static const char *get_data(struct prb_data_ring *data_ring,
 		return NULL;
 	}
 
-	/* Regular data block: @begin less than @next and in same wrap. */
-	if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next) &&
-	    blk_lpos->begin < blk_lpos->next) {
+	/* Regular data block: @begin and @next in same wrap. */
+	if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next)) {
 		db = to_block(data_ring, blk_lpos->begin);
 		*data_size = blk_lpos->next - blk_lpos->begin;
 
@@ -1279,6 +1278,10 @@ static const char *get_data(struct prb_data_ring *data_ring,
 		return NULL;
 	}
 
+	/* Double check that the data_size is reasonable. */
+	if (WARN_ON_ONCE(!data_check_size(data_ring, *data_size)))
+		return NULL;
+
 	/* A valid data block will always be aligned to the ID size. */
 	if (WARN_ON_ONCE(blk_lpos->begin != ALIGN(blk_lpos->begin, sizeof(db->id))) ||
 	    WARN_ON_ONCE(blk_lpos->next != ALIGN(blk_lpos->next, sizeof(db->id)))) {

1. Just distinguish regular vs. wrapped. vs. invalid block.

2. Add sanity check for the "data_size". It might catch some wrong values
   in both code paths for "regular" and "wrapped" blocks. So, win win.

How does that sound?

Best Regards,
Petr
