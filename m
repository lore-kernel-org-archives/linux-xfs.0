Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F76FC3
	for <linux-xfs@vger.kernel.org>; Tue,  4 Jun 2024 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717473977; cv=none; b=QtvlxyF/QwuAlUy/A/Xj+NbG8acFHltzbEJuUASAPkqB23/N2zy0ILaB/YXOYQvwLTUmDRo6rX2OnAUBlgtaOy3WaervYBGo9jIijGf0mDzFmgCdVhIcZ54F2s6i+MH/GufKQ0LLHrJeTYVn4mWnyJZ7rJa+lL/tjSsohs3ha5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717473977; c=relaxed/simple;
	bh=pfudj6jCKxKaDGy5A+hUQj1x/6lDidDyiKfDpckXgkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tg3DlZEZBI/iJIYTdaf0pyJg7c3dYIr848XRiW8vO8CM63ax+c2DEYx3UCPwt1FiDEGapQ8tZU+BpwM0lb42NFH5U/RUxOpN3slQ+2vzO5oHzVEDjT/cfqNI1uuL2couqYeV5dDrDgxvf/d3th9iM0x+3tu4DVHxC5qfXew98zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=I2dq8K2b; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="I2dq8K2b"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-681bc7f50d0so3656234a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2024 21:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717473975; x=1718078775; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=As0GcRxqe50hiZeLME1pCj9vGTqSVihKGX+D8omSxv4=;
        b=I2dq8K2byVfIpGyLsDs3vy+NXiyYnqiw0Z9t8M6UdYAxxctbXq0SgXQOK/4AhG1L53
         Tm0P/WFerjwxf+b6UvSQGBujtCLkkjwOayH+8sPAbDXLYHRof1zYM/6TxQyIiVRsTdlE
         bQ7OwMwYLcSnbhQwmLZE2vk+KDOxf0t8uUA1Okg6iaEj2V9nJRqe4Oin3CHrCfVsTd2/
         7KCM3X/Bizy0etSgVHZ7SjFpuK6JUlCiKrm3AO0nlwmPY6YUAt6SJhsq2PUbDo7itJ20
         xOdA6POkq8emaFAr6IPoh6XMCgeNvKlDypys8KHbglKNnJfqCv9EIDzQCtqi4dQmVTJq
         vd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717473975; x=1718078775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=As0GcRxqe50hiZeLME1pCj9vGTqSVihKGX+D8omSxv4=;
        b=XsPZwKgBWwnX/YR1uJ8Ecm5TtN8ga1Z2Ab9/kodb4++n/HIsYPpd16qxX0Du5V/oRF
         YvzQBWW3lsXl5SKZC5zBvE61qh87G6vKBZpGyXJeJfgFBjoZTryl70vGkwNe6ixq64ym
         fO30+EFMYs4bOI6/rbYfElORcMY4zQo5PrtdFxGSddTn6tMlz2l5ZTM650gJx6Ye1Z8A
         5nrPzt1aix1z2JRm6HKJF16ubx8q5FLyz6ror9MKVeJ4rFWhGs7vRUshWtGMhK+IH7v0
         6MYGXBKccsYx/apbivsIt7r5e9DQ+RKcds8Bo5Y4c4wqcSfPn1fB5zxBdIApd0+//3f0
         /3Mw==
X-Forwarded-Encrypted: i=1; AJvYcCX1+NFtwAEXHeF2vMVAeMtAmA+oDx93F56fIvwQp9R4eOXCvVOnc90FxL4awqVbyK187mmREk0BnfwT9ka7hnhcDinP9k/HdPYA
X-Gm-Message-State: AOJu0YyoxbAurhmevG48q3EuNzIABBjfuvW5t0Te1hVQ3345exzQJJim
	j/vBM2mDtMqUqMFOyInqRrMo90KkkhRycWu1i/BD0vIpGwviKD+8Kr65i9X9ohuArZlxNBGyBPk
	m
X-Google-Smtp-Source: AGHT+IEvt/QSzPvBFP9LW10rKqfU1MECiiEk439wKCt8PtL4dDNqLVCAIUWEcIpSQo5mV/erM1QotQ==
X-Received: by 2002:a17:90a:c384:b0:2bd:ef6b:c336 with SMTP id 98e67ed59e1d1-2c25309e19amr2182451a91.11.1717473975385;
        Mon, 03 Jun 2024 21:06:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f632409ab0sm73608555ad.259.2024.06.03.21.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 21:06:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sELR6-003c9Z-0J;
	Tue, 04 Jun 2024 14:06:12 +1000
Date: Tue, 4 Jun 2024 14:06:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Message-ID: <Zl6StNJmfnCInAdS@dread.disaster.area>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
 <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
 <A9F20047-4AD8-419F-9386-26C4ED281E29@oracle.com>
 <Zl0CKi9d34ci0fEh@dread.disaster.area>
 <39E20DD5-EDB2-4239-B6EE-237B228845F5@oracle.com>
 <20240603184327.GC52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603184327.GC52987@frogsfrogsfrogs>

On Mon, Jun 03, 2024 at 11:43:27AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 03, 2024 at 05:23:40PM +0000, Wengang Wang wrote:
> > > What about the sb_icount and sb_ifree counters? They are also percpu
> > > counters, and they can return transient negative numbers, too,
> > > right? If they end up in the log, the same as this transient
> > > negative sb_fdblocks count, won't that also cause exactly the same
> > > issue?
> > > 
> > 
> > Yes, sb_icount and sb_ifree are also percpu counters. They have been addressed by
> > commit 59f6ab40fd8735c9a1a15401610a31cc06a0bbd6, right?
> 
> icount and ifree don't go through xfs_mod_freecounter, which means that
> they never do the "subtract and see if we went negative" dance that
> fdblocks/frextents does.  percpu_counter_sum_positive isn't necessary.

I'm pretty sure that what xfs_mod_freecounter() does has no bearing
on whether percpu_counter_sum() can return a negative number.
percpu_counter_sum() is intentionally designed to be racy w.r.t.
sub-batch percpu counter updates.

That is, percpu_counter_sum() takes the fbc->lock while summing only
to bound the maximum sum error to +/-(nr_cpus * batch size). It does
not serialise against sub-batch percpu count modifications - add/sub
only serialise against a sum when they go over the batch size and
need folding. Hence the sum will serialise against folding
operations, thereby bounding the maximum error across the sum to
+/-batch size on every CPU.

For example, if we have a counter with a batch of 128, 4 CPUs,
fbc->count = 0 and the current percpu count values are:

CPU 	value
 0	32
 1	0
 2	-32
 3	0


We have a sum of zero when everything is static and unchanging.

However, when we look at the dynamic nature of the sum, we can have
percpu counters change during the summing iteration. For example,
say between the sum starting and finishing on CPU 3, we have a
racing subtraction on CPU 0 of 64, and and add of 64 on CPU 1.
Neither trigger batch overruns so don't serialise against a sum in
progress.

If the running sum samples CPU 0 after it updates, and CPU 1 before
it updates, the sum will see:

fbc->count = 0

CPU 	value
 0	-32
 1	0
 2	-32
 3	0

and the sum will be -64. If we then rerun the sum and it doesn't
race with any updates, it will see:

fbc->count = 0

CPU 	value
 0	-32
 1	64
 2	-32
 3	0

and the sum will be zero.

The above example could actually happen with ifree/icount.
Modifications to ifree and icount in
xfs_trans_unreserve_and_mod_sb() aren't serialised against each
other (i.e. multiple alloc/free transactions can be committing and
updating the ifree/icount counters concurrently) and they can also
be running concurrently with the superblock update summing in
xfs_log_sb(). Hence the inherent raciness in percpu_counter_sum() vs
percpu_counter_add() is not mitigated in any way, and so ifree and
icount could have a transient sum that is less than zero....

So AFAICT, then need the _sum_positive() treatment as well.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
