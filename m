Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43533A9C3;
	Wed, 25 Mar 2026 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774468481; cv=none; b=cW5SGUueubq9KhHQsNYxtfMoEuar5thHto2UAJV0IwzkyaTOMl8CDKwm9mu/+sUeL3a5T1sg7+Kzk0xE3CqY+ISlz74ok6smGxSHHPVh+xl1Kk7ZUk6MiU9mxStBdueP0doxypE7eMyCG13HLE7FagGh262FoobluFUuzeK46Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774468481; c=relaxed/simple;
	bh=SRolz9YRkdZPXElTrZ+9nprlzBGVBK0pqNX6YCRgn9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQ/cMKVIk8W8sPWYZME5U4Gq1zkfjUqS8f/dmvZ4E0Oly2OLw7u5sDQRqxMDCrYg3Mu3oTlL42tkuGaRy7w/8UWzl8lEMAgCj8cXPPb0e8ET00+I1jy/ZbIUzR2g8/SE29QRniRCnwiv7YDSoOPmhDwgZhzmQnT6K8sbUfhkWwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NQqLQZHr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NQqLQZHr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IFchlTIOZMfi9wJHQbujTSnEB7GeSbipD+i3VdUS68A=; b=NQqLQZHr3QDq+7W+lb/RJzepJM
	7m+WjNfHq2E5KZgeHlvEWdCPyhaMgeMkREIcAjaGHTIDUtebvp/mZIDJcbBTaBhWBTEFTeCuJB4I4
	KP0DCG+gDd5MWACEtrA8I0GS0ohlKP8PpSMphdBt54Mre+oSXPGtfQ+pGOoE9yQBf5vo5eYn8Q7OR
	qu8dB6d8+khYP/Dx75Ay4LJVWLr2+DrgGTzW8YAea/jN25i7zKst0b2zt9aDztEsv9Rvj7qqbrbH2
	fnoOIsVOdw0+0fvhhxDMdHmgc9Fz8wwcKAZFKvh8AMOZyn6ZFJub/AcwRgGW1MtSUDohCA9SXI6OU
	urgqcbkg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5UJG-0000000GT4U-0a8s;
	Wed, 25 Mar 2026 19:54:34 +0000
Date: Wed, 25 Mar 2026 19:54:33 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acQ9ebzkF1u_ifuG@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>

On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch;
> +	struct bio_list list;
> +
> +again:
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	list = batch->list;
> +	bio_list_init(&batch->list);
> +	local_unlock_irq(&bio_complete_batch.lock);
> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}
> +
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	if (!bio_list_empty(&batch->list)) {
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (!need_resched())
> +			goto again;
> +
> +		schedule_work_on(smp_processor_id(), &batch->work);
> +		return;
> +	}

I don't know how often we see this actually trigger, but wouldn't this
be slightly more efficient?

+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+again:
+	bio_list_init(&batch->list);
+	local_unlock_irq(&bio_complete_batch.lock);
+
+	while (!bio_list_empty(&list)) {
+		struct bio *bio = bio_list_pop(&list);
+		bio->bi_end_io(bio);
+	}
+
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+	if (!bio_list_empty(&list)) {
+		if (!need_resched())
+			goto again;
+
+		local_unlock_irq(&bio_complete_batch.lock);
+		schedule_work_on(smp_processor_id(), &batch->work);
+		return;
+	}


Overall I like this.  I think this is a better approach than the earlier
patches, and I'm looking forward to the simplifications that it's going
to enable.
