Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AAE14A088
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726782606; cv=none; b=gjs9fZ5jZR7wTL9OIEtfYMIIwG6P5lE2fFBuFLmv3FDBzjm9QI7jv/sDejaiEaRUwpz1/SAWBtDlo2IY9/3w709YE2rQLBNn40PgQTzq09jQtvPmo7i7Vs3Yob7Y386cvhJ0w4XWolp4BeKh2WkdMvq/dEvhByMfcK7P5lH0SwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726782606; c=relaxed/simple;
	bh=DW0dVq2n3eznhoNhg3FnBdHAxOgHgQ2Ixdka2nib8Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjUIYSduPayTBnJdPEJfbAWenD4q/Qo0zPxl4rpi+kHa+advaCQKi3WatqpoJ3oIXITHBoVcB4mXHxK6h/leBhrFrXZKCDlookqZGI2zeBHdzw6EX4HVt7BqKsG16F9rJFegtBLLw8+y3PE9XQLYVexhVGI1xp2hVXmHgzdd7sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FmhFkfzX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FmhFkfzX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2055a3f80a4so9999615ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 14:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726782604; x=1727387404; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6x7ZdkvoVVjEQHpZUF/64NyMjRa52YcivfU8ppBgzY=;
        b=FmhFkfzXWLu+7+D5c4QwktfzUW1sMb46WNRxITCuNgvHqj4MccW63Zh9TyemiCY8vy
         staP3T/A1vZ58DG2nv9e/USUd0gFNWJ8pPmhBBn7hBW4FKUWX5aS3Svn0WNt1PVQBunW
         bQyhyxjFXpbBSoJNIKtBegpmGQpRnd0YZjfDHwCU2zBLu9E62IWDHa9JtEX2YzxJF7po
         Ng1Q/1Jf7HsBS+DaNTaGUWIkEBXXKlzzqN/hx8WwNgmnhiGmfHZnEiQ/8vmn1plM8Djh
         ZqgSZ9KQg/fLBihewxgwZFq883PEO4TM/+7Vhe8uI0gR7D6eMoJmw6DFQIF2rY02S1mt
         UPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726782604; x=1727387404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6x7ZdkvoVVjEQHpZUF/64NyMjRa52YcivfU8ppBgzY=;
        b=xE3ViNc7xjheu/wxiLNkTOdXak3c1XfjIIbgkTVO7CJNgj8scUXPMH97dX0wI/B40b
         gLsdHvL3hQOn259f/manwHjnNWR00xvZux8d04IdLTU609e4AeO9kFtqII0Z8WSeCAkI
         hsvXR9wqah4EYqRxActKoThDRgfdaF9Ys3UqTkPgN1HInN412smLGrh0n//MOB8haz8Z
         XEMQEqTo1O1rcMCZw3F/To8Qn1W6nMYbgrWS2/L/Ry9fZBpHzO5S6ADr/l8uQQ5xW0dj
         Ilk7dHTl3HBZsf9uJhcgfBlThFB/pS9Wm2sroYngLUGE+E+r3wWViivw2EXKncbaLVO4
         8Z6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXoLdJmxzpucw8HKn/oySCsX9Q8hn1aQs+r06zw6HvYDPNK8Z/X9EIKg7/5QdQg2OypcPBjT3P95Rk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXF+gayFNDsaMcsNChvz1Ke0XkIma4Qxep5S0/AFY8KS21YdTA
	KZL76Yil8VsSvQBE3uDrvU+YSGj3VaJQ/5CzC2pz5J8Rdoq5LBsIjdW7Ut41MQM=
X-Google-Smtp-Source: AGHT+IGn46XGCpwtH+QDECMERZKD+6txGMJw/v/awgG6z5OZlSMhAjgg1+8EOhxh8RjkLB2OSikZWQ==
X-Received: by 2002:a17:902:e541:b0:206:8db4:481b with SMTP id d9443c01a7336-208d9849480mr3319735ad.32.1726782603849;
        Thu, 19 Sep 2024 14:50:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946d15fesm84497045ad.162.2024.09.19.14.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 14:50:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1srP2G-007PJj-0g;
	Fri, 20 Sep 2024 07:50:00 +1000
Date: Fri, 20 Sep 2024 07:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create perag structures as soon as possible
 during log recovery
Message-ID: <ZuyciHNmweoltuA4@dread.disaster.area>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-4-hch@lst.de>
 <ZueJusTG7CJ4jcp5@dread.disaster.area>
 <20240918061105.GA31947@lst.de>
 <Zut51Ftv/46Oj386@dread.disaster.area>
 <20240919074631.GA23841@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919074631.GA23841@lst.de>

On Thu, Sep 19, 2024 at 09:46:31AM +0200, Christoph Hellwig wrote:
> On Thu, Sep 19, 2024 at 11:09:40AM +1000, Dave Chinner wrote:
> > Ideally, we should not be using the new AGs until *after* the growfs
> > transaction has hit stable storage (i.e. the journal has fully
> > commmitted the growfs transaction), not just committed to the CIL.
> 
> Yes.  A crude version of that - freeze/unfreeze before setting the
> AG live was my other initial idea, but Darrick wasn't exactly
> excited about that..

I'm not exactly excited by that idea, either...

> > The second step is preventing allocations that are running from
> > seeing the mp->m_sb.sb_agcount update until after the transaction is
> > stable.
> 
> Or just not seeing the pag as active by not setting the initial
> active reference until after the transaction is stable.  Given
> all the issues outlined by you about sb locking that might be the
> easier approach.

Yeah, that's a good idea for avoiding perag references from
iterations before the growfs is stable.

However, my concern is whether that is sufficient.  Whilst I didn't
mention it, changing sb_agcount and sb_dblocks before the grwofs is
stable affects things like size calculations for the old end runt
AG(*) because it is no longer considered a runt the moment we change
the in-memory size fields in the superblock. That will, at least,
affect ino/fsbno/agbno verification, as well as corruption checks
through the code.

An alternative is to delay the perag initialisation until after the
growfs is stable, because we don't want the old runt AG size to
visibly change until after the growfs is stable.

There may be more potential issues, but I haven't done a careful
code audit and that's kinda why I suggested simply delaying the
in-memory state update. Delaying the update removes the whole
in-memory transient state situation altogether...

-Dave.

(*) The precalculated AG length and inode min/max values we've added
to the perag (calculated at perag init time) should be used for
these calculations. That gets around this 'growfs changes sb values
dynamically' issue, but not all the places where we do these
verifications have a valid perag reference to pass these
functions. 

-- 
Dave Chinner
david@fromorbit.com
