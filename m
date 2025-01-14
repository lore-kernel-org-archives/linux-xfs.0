Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43BD1C01
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 00:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813383; cv=none; b=JmTPcJ49VVwxm5F+ecblsQpjR+YO3XxWQ0Wwez/mozfDv0jiBMCBiVXIt0yKTR+YwrgkiyUFyJbkuuVc+ngtRhelDoCf4qty2BCM2fpn42558tzAQ5wW4NQGA/Xl/Esa3rVapUgFrnxabqUhfD/C5vGkRMbreUQQIbDYraOsYWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813383; c=relaxed/simple;
	bh=8duD0um65ze9pFKz6UfYQ4qf0fncx1lLOtE13qzU/lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scDJBWHfmZWptqHyrdTUxSfMUMYY8jpMyF7pjdWAXXgAWnzF2SqYbzlxcQOt3RcEqTntBkPAaytFq612dkcDIgkyMNvcxcY4S7ROvBq6Eduo1a6YT2P3ZthgJAELERHB6ox2dEkATBDaTpGCHmiTUM14s592Xo3Y8MVV2/Lf3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HF4n37Dd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HF4n37Dd"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21670dce0a7so104512795ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 16:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736813380; x=1737418180; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4PvNuu1s4hJpBZBc9EGTOF3JLqWN/EA3PJibkNXz5FU=;
        b=HF4n37DdO5Y1xk2urQr4sEEy208Ii+y7VuYTIMZsX21bQKrC13A4bkgHhapo3SGcU+
         6QntuQQFSUjty5oUClOVw2NotBWbnQoG+topOMvA+m2kfKu7A9Ibq6Rcz8moYP3IFNsi
         qvm1T127le+i+L1ftnsvk/1Ne+l9V5FNHX5fhZ8Eo+5DeiXPH1+c/PhkgQGXQIXn158n
         FiTnJOxMemEyXYJ5NOACRorKMiX3pMzd2A29NqtbmYdwuN6SRsF49IudsbrpDLK5xy6X
         E+iKFmCbEEEmt6rC2vz4eB5uDCGcKXrB8tSOya522/CXkIrXIJcePy3ALYOE33q59xPH
         5D3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736813380; x=1737418180;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PvNuu1s4hJpBZBc9EGTOF3JLqWN/EA3PJibkNXz5FU=;
        b=DjZacv4mwHLX6o/uv4O4rH49HPT2AvLNi8I3WLpi+ADPT30txn9nRwHVmc7MQHOU2e
         V7xrf1rP9PHqn340s5Ip8mdp/cikWrmrSPQ22zA84lxu/9zyedafOKpm/ZWKp6vCJ4Rx
         mstqg+oK/OOmAWNDtig8JVVarHgrWtvjuo75O87Uggha2gp3F325Er5DygigRFd3k/Z8
         OaeOYucJ0ghVAh/Mm0wjGR1XwIi2W2nFIbI3ps9piATkRMD5PE7zqhUu7KgETZJRv+Ot
         zAy3d7GVhc29pivchf/9OZxB6jOXhUiqP3THY1rpn5khgZ0mH+hLYkyKq3tMWFwA5EvT
         FLag==
X-Forwarded-Encrypted: i=1; AJvYcCX1HQzSLsMPLTlC0KHZ334CwZ498WLNEIKYHZdKYPBS2yrLjjN5ftCUK4Xp/YMu5ud3llp4EzzpwO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1XepngD4uBDDFtNN5ZDvTT7YAAl2leyXu1Ac0j7an3lc0hOM6
	L1WZpJXfjknlYiMXwyf4omTTfq8I4j89IAfMdp496NBK+A9R37TsR11KKh9oSSA=
X-Gm-Gg: ASbGncsTGzk/0Sj/hL1A+a6N48oUkZaeWUzC1X5xBpJCQhSYYt3eICtpLd/XV3uWQa5
	Yv+wx1eUySUUV5S4z8fh7GO38eQv8pYjzqTYSsg9iZz6zbMpj+HoULd5ieZxJgB0YS9VmAwaQ2Z
	mmw+c+mctyHBlqgeZzFyASzHkVrkbVXaWH8xDgjpBU57lVaLDqN40Y7To1PAmubFKvtVfsozKWb
	tASRcH4Gnjqu5uhPS4P9Y258G3+QuaxJhlGGXyr/gHnScn5SkzWpnLpYgSJGRv0fqzPsi/3Dl9D
	0DG/0Mk/abvzr/k+79YpAQ==
X-Google-Smtp-Source: AGHT+IGfvAiS1KOlFTwtHp4rp3pE2JZ6vaJJKwQSOdSNt7t6H/H9wirlwG5RaLC2orygEQDjmeBgIg==
X-Received: by 2002:a17:902:ecc5:b0:215:bf1b:a894 with SMTP id d9443c01a7336-21a83f76704mr350424525ad.24.1736813380177;
        Mon, 13 Jan 2025 16:09:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10f019sm58773475ad.26.2025.01.13.16.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 16:09:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXUUy-00000005XqM-3wHD;
	Tue, 14 Jan 2025 11:09:36 +1100
Date: Tue, 14 Jan 2025 11:09:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@163.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4WrQJN1cbL-lZl-@dread.disaster.area>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
 <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>

On Fri, Jan 10, 2025 at 06:07:48PM +0100, Amir Goldstein wrote:
> On Fri, Jan 10, 2025 at 12:28 AM Dave Chinner <david@fromorbit.com> wrote:
> > That said, I just had a left-field idea for a quasi-range lock
> > that may allow random writes to run concurrently and atomically
> > with reads.
> >
> > Essentially, we add an unsigned long to the inode, and use it as a
> > lock bitmap. That gives up to 64 "lock segments" for the buffered
> > write. We may also need a "segment size" variable....
> >
> > The existing i_rwsem gets taken shared unless it is an extending
> > write.
> >
> > For a non-extending write, we then do an offset->segment translation
> > and lock that bit in the bit mask. If it's already locked, we wait
> > on the lock bit. i.e. shared IOLOCK, exclusive write bit lock.
> >
> > The segments are evenly sized - say a minimum of 64kB each, but when
> > EOF is extended or truncated (which is done with the i_rwsem held
> > exclusive) the segment size is rescaled. As nothing can hold bit
> > locks while the i_rwsem is held exclusive, this will not race with
> > anything.
> >
> > If we are doing an extending write, we take the i_rwsem shared
> > first, then check if the extension will rescale the locks. If lock
> > rescaling is needed, we have to take the i_rwsem exclusive to do the
> > EOF extension. Otherwise, the bit lock that covers EOF will
> > serialise file extensions so it can be done under a shared i_rwsem
> > safely.
> >
> > This will allow buffered writes to remain atomic w.r.t. each other,
> > and potentially allow buffered reads to wait on writes to the same
> > segment and so potentially provide buffered read vs buffered write
> > atomicity as well.
> >
> > If we need more concurrency than an unsigned long worth of bits for
> > buffered writes, then maybe we can enlarge the bitmap further.
> >
> > I suspect this can be extended to direct IO in a similar way to
> > buffered reads, and that then opens up the possibility of truncate
> > and fallocate() being able to use the bitmap for range exclusion,
> > too.
> >
> > The overhead is likely minimal - setting and clearing bits in a
> > bitmap, as opposed to tracking ranges in a tree structure....
> >
> > Thoughts?
> 
> I think that's a very neat idea, but it will not address the reference
> benchmark.
> The reference benchmark I started the original report with which is similar
> to my understanding to the benchmark that Chi is running simulates the
> workload of a database writing with buffered IO.
> 
> That means a very large file and small IO size ~64K.
> Leaving the probability of intersecting writes in the same segment quite high.

Likely - I recognised this granularity problem, though:

| If we need more concurrency than an unsigned long worth of bits for
| buffered writes, then maybe we can enlarge the bitmap further.

We could also hash offsets into the bitmap so that offset-local IO
hit different locks - the bit lock doesn't necessarily need to be
range based. i.e. this is a "finer grained" lock that will typically
increase concurrency. If we keep striving for perfect (i.e. scalable
range locks) we're not going to improve the situation any time
soon...

> Can we do this opportunistically based on available large folios?
> If IO size is within an existing folio, use the folio lock and IOLOCK_SHARED
> if it is not, use IOLOCK_EXCL?

The biggest problem with this is that direct IO will -not- do
folio-by folio locking, and so folio based locking does not work for
direct IO exclusion. Currently we get coherency against buffered
writes by writing back or invalidation dirty folios before doing
the DIO read/write. Because we hold the IOLOCK shared, a buffered
write will not redirty the page cache until the DIO write has been
submitted (and completed for non-async DIO).

Hence moving to shared i_rwsem, folio-based range locking for
buffered writes will lose all serialisation against DIO operations.
We will lose what coherency we currently have between buffered write
ops and DIO, and I don't think that's an acceptible trade-off.

i.e. The problem with using the mapping tree for DIO coherency is,
once again, locking overhead. If we have to insert exceptional
entries to lock the range in the mapping tree because there is no
folio present (for DIO to serialise against new buffered IOs), then
we are simply back to the same exclusive tree update scalability
problem that tree based range lock algorithms have....

That's why I suggested a bitmap lock external to both buffered and
direct IO...

> for a benchmark that does all buffered IO 64K aligned, wouldn't large folios
> naturally align to IO size and above?

Maybe, but I don't think folio/mapping tree based locking is a
workable solution. Hence the external bitmap idea...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
