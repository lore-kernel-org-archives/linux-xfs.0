Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32EF1D61B7
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 21:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736977287; cv=none; b=n0pxijYHLXbgG8RRkYHXjtV6K8oKvdtV6YR7gyWOHbp+IdqlnOuMtSg1SF8EGnEU0T6b1iCtSoc69C+IrhuPyW+kCAuGySiO+hvgCEfpLy1+ZV6W6s+BomnAjZWQVnC8H2DIy+FiPmy3GvVDuWw8RWntePx6uI6SgTZzxzmb3gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736977287; c=relaxed/simple;
	bh=UnypkakFh9Sy4d5cl/pyyfhYnwQ3OSP4C3p6B5y8KRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5NWD+uwQ0IpYDTLxjp0WADF4ewSR+mDLgNJegtB7wJR59XU+pHNw3NniTyYADmtT8diprNo06LkysQokDDSlFIEVvjDVbS0UGJtVTFIv2s150T6CvuFzXb/cTUQYg5FIzTbn8FC7/4gDoNjl9T2CCg71LC75RZ2QQ0+LTmEB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wUSTFnKp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wUSTFnKp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2167141dfa1so4767405ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 13:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736977285; x=1737582085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+7RqsypsFMbQh8it8gHq1oAn4Wjjku2FuWrarD2dysU=;
        b=wUSTFnKpwFW1j3+RLuTMqK/nurhxzk7BOy2etItpFScXGmCwXG4H4C/KvDhFm6imIX
         JJ+8ejav1ExoROFcbWQUKbGe01fgT4aoNzdUyDKEzQn3+373UWPUyox4UO2rVFiKVBIO
         iue0daOCuXOdkh/HQapxUgmywoiwOLrtXyXqLj0cD+zi9TJS/htcZDkoB6JDxULh3f/9
         36hE7FoT2ZocyPJl3QIFwQpmu8dbXF57wQFnLqv5uWS9S+BbT0doMCGUs8QAu6EhjtWE
         wFOxj2pmfPiRU14tTsphqk5nytfN2rEJpeyi++T9vDj39Xn9n4JGMmvjODM3CEOG6GV7
         6z2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736977285; x=1737582085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7RqsypsFMbQh8it8gHq1oAn4Wjjku2FuWrarD2dysU=;
        b=Hnjs8v9mldUzbI1i1g0bX98fHMQPk7gNEDl6rzjgqgPIyj+INcB8FnuEO+1pPMd7Uu
         sKoH8jV8ApwESu7u8OG3vEF4ip3m2+Mp0CQAyR4L18rFqeMRRe2sM2WW8cB3SQiUW4V7
         uL2cuXkFb08Vu+KVav4UCjF/Cte1XPxXu2EBhLKIGz4EqtyDaEZSsx69q39NrSoLTiGB
         4AB/V9GbYvHyCvvm7j4MTtvFtrAk/4QCjzLtwfPEL2q22Ji5Wk9ySkLcss+2VKTVxsY8
         gjjKjhi9JElWWzcRosDq3Df1QiNyCQIeLop/bOhdB3gQ6h+d8kjX+dLEx4cU8KfFghRD
         RgkA==
X-Forwarded-Encrypted: i=1; AJvYcCVIE+NR+pNRzw3hk+o0B1HUAgMNlOuaPIUGBm9X3EQUYSKGqyKx+dNcvqjhgHIqQGa9096ybHQrQOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Xp05vnLQGnePXdd+pXMB9sPLJriw7VqTp8ptNN2tUZd7aMp7
	v64YuacErFvpJoMl9Op40LXGipfw3ELe8q9IT646Zmn7JKGbm/zpAtoPzqwYPDs=
X-Gm-Gg: ASbGncueMIdafvkakVqS1nDvl3wmh4QGmIg3CadlTNplEL71fZmpnpyWRPxKpxC6Y3S
	uzDtBVjAzTrTUBB2nbIsBrPhB2xTA60FAg0wmjfqm39IX7YfWL9gpITsFFHyXYv8MhAsndHv8mG
	+PHTQkUei1gq78vSnYr1SqZsITxa1TgJWMXETgpXaN9VU8lUonvx0uFWNblyT+vUNYcm3970IaA
	1Hh74PA+UYrV1K3szFH9i1IriJQ2DfNccyfFXCN8WGSCeRAU5RNbJMUIfQpeQURVKbIZ4zr16hS
	Mn51gf+1qjsOefGNETwrBA==
X-Google-Smtp-Source: AGHT+IEF9DsGk/eqKSv91kWaf6atrZs2CIMnQO1CTfN7kM9Vq3qR1ckQCkXdRiuQgz0CIbhZuVJZJw==
X-Received: by 2002:a17:902:cecf:b0:216:5cc8:44e7 with SMTP id d9443c01a7336-21bf0d31063mr66954335ad.25.1736977285271;
        Wed, 15 Jan 2025 13:41:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219aefsm86190185ad.107.2025.01.15.13.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 13:41:24 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tYB8b-00000006Kqt-449P;
	Thu, 16 Jan 2025 08:41:21 +1100
Date: Thu, 16 Jan 2025 08:41:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4grgXw2iw0lgKqD@dread.disaster.area>
References: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4dNyZi8YyP3Uc_C@infradead.org>

On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> > Sorry if this is out of left field as I haven't followed the discussion
> > closely, but I presumed one of the reasons Darrick and Christoph raised
> > the idea of using the folio batch thing I'm playing around with on zero
> > range for buffered writes would be to acquire and lock all targeted
> > folios up front. If so, would that help with what you're trying to
> > achieve here? (If not, nothing to see here, move along.. ;).
> 
> I mostly thought about acquiring, as locking doesn't really have much
> batching effects.  That being said, no that you got the idea in my mind
> here's my early morning brainfart on it:
> 
> Let's ignore DIRECT I/O for the first step.  In that case lookup /
> allocation and locking all folios for write before copying data will
> remove the need for i_rwsem in the read and write path.  In a way that
> sounds perfect, and given that btrfs already does that (although in a
> very convoluted way) we know it's possible.

Yes, this seems like a sane, general approach to allowing concurrent
buffered writes (and reads).

> But direct I/O throws a big monkey wrench here as already mentioned by
> others.  Now one interesting thing some file systems have done is
> to serialize buffered against direct I/O, either by waiting for one
> to finish, or by simply forcing buffered I/O when direct I/O would
> conflict. 

Right. We really don't want to downgrade to buffered IO if we can
help it, though.

> It's easy to detect outstanding direct I/O using i_dio_count
> so buffered I/O could wait for that, and downgrading to buffered I/O
> (potentially using the new uncached mode from Jens) if there are any
> pages on the mapping after the invalidation also sounds pretty doable.

It's much harder to sanely serialise DIO against buffered writes
this way, because i_dio_count only forms a submission barrier in
conjunction with the i_rwsem being held exclusively. e.g. ongoing
DIO would result in the buffered write being indefinitely delayed.

I think the model and method that bcachefs uses is probably the best
way to move forward - the "two-state exclusive shared" lock which it
uses to do buffered vs direct exclusion is a simple, easy way to
handle this problem. The same-state shared locking fast path is a
single atomic cmpxchg operation, so it has neglible extra overhead
compared to using a rwsem in the shared DIO fast path.

The lock also has non-owner semantics, so DIO can take it during
submission and then drop it during IO completion. This solves the
problem we currently use the i_rwsem and
inode_dio_{start,end/wait}() to solve (i.e. create a DIO submission
barrier and waiting for all existing DIO to drain).

IOWs, a two-state shared lock provides the mechanism to allow DIO
to be done without holding the i_rwsem at all, as well as being able
to elide two atomic operations per DIO to track in-flight DIOs.

We'd get this whilst maintaining buffered/DIO coherency without
adding any new overhead to the DIO path, and allow concurrent
buffered reads and writes that have their atomicity defined by the
batched folio locking strategy that Brian is working on...

This only leaves DIO coherency issues with mmap() based IO as an
issue, but that's a problem for a different day...

> I don't really have time to turn this hand waving into, but maybe we 
> should think if it's worthwhile or if I'm missing something important.

If people are OK with XFS moving to exclusive buffered or DIO
submission model, then I can find some time to work on the
converting the IO path locking to use a two-state shared lock in
preparation for the batched folio stuff that will allow concurrent
buffered writes...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
