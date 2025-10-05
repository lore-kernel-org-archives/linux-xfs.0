Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2E4136E37
	for <linux-xfs@vger.kernel.org>; Sun,  5 Oct 2025 22:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759702006; cv=none; b=ZAywimZtMJKyslipKbrKSTfSC4SakpTwOPuQyYuMhdMjQlFGLfB2jMsOMQXL1N/Wi4QFUqApP5hvZOHE2acRSLTMxvnfke17/TMY78Qu6gk9ZbI0/2dwsweXvfSPzYU/IBXNQj4GQjXOsZKmn7VKdW1sVQ4fbsdebK/orA3dRSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759702006; c=relaxed/simple;
	bh=ghK5/Akxyskde6VGn6Ahjhb7SpOkpwGVxVDkbDa5JHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cb9s1aRQHkyGL2DXGRPx9qTCg20gZB3Br127ozRm+t0AO4d2OjpyD6GKNBQWjxnq6VRCLmo20KM4RJdsyzoDrffx1vOGIr+d3FiVsri8Gvu0OuEbXX8mSogpQagHPdeCS9WyarW0d97Gf/y9p0A+g0fcqZ/xtFLAgmb1R7EU2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wZBCwzMP; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wZBCwzMP"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso3846721a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 05 Oct 2025 15:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1759702004; x=1760306804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EfB79PgOGfvIs0AN5btrRu7ltzbFZlxj1NUbJbf87SE=;
        b=wZBCwzMPOFZBmauIC3yw6qRd3Sykz5c41p4OyQrG7RW1fqeUVQVk4+mfyM1AevAKc1
         X3CNKtkrVkVwGxHS4GSCfu3viAmYXxbexjaDViFry9rBARBCcEv7pAqnB30zvTurTMSo
         ySylK2bcuJtlFWgHiUImDjfDfksXzOAzufpJHwfBsyZPBePY489kw9DUfFfOAUuC4Z2u
         nrSD3sltjbgbhrvL9Ru6C9W+9NuMNXwg27vo9iJ9iNMlyGyoxLOfHvcmS7YZ1vUz6vNg
         tVFSaRWyR3S4PzXDIKUy1sfNMftKsb077+bSXLRau2LyPrSCH/F4tw8ItMuGH4GDxKtZ
         MQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759702004; x=1760306804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfB79PgOGfvIs0AN5btrRu7ltzbFZlxj1NUbJbf87SE=;
        b=LWU1bcgR/9cZz29SU7ygDtl7zKa3qN3Q5+fJnZppPq7b1VUOuv37c+6Xp5NFM6Ziyo
         9tZKn3yf79HncrSlsP0kQD0IHZGCAvWupUasT4o9/A5ctR+hQBuhkaij5CIYv/J5mP9+
         DHLLzcUYRxlX38aOxbrMkjLXqEW9vr7iW70EDdEJQEvzt0wfwULjD9fZ33mI1UbHjzcs
         O01Sgw6YeChQNRIuHL4DkJ1uk1TemDcCUm7J0OpUDo6A8cay0U+xfcznUTmdJPLOGeYF
         kbtUvw7lU5d3uHOAc1WJ3IRPOguGp+36ZnPuHPrwvi6sHvZce5GzByIXGpJnci2ttWEE
         x4fg==
X-Forwarded-Encrypted: i=1; AJvYcCU7+DhC6cQ97YCWPI9St0aDl7E1tjNgT4AgDyQdHwHAnGJoHwkHi8R/opdjCp+2PSvB0HgCGWcCUpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR8XCgvj5oxZg/b+7Wi1n0ohht9r/WzhlarXPe0GZbtWNLAAQS
	g2YedqyRr6qJkDbgaK1MwusSFugEGnPtibs7LQLWWBeAIutuO6g5th2GtHi6SF4Py6k=
X-Gm-Gg: ASbGncub0FIsCimRvPRvZmzp5MsKI6cVNENKlbgxXmLr69uMeGweCZ7yt8+UwsOtrnk
	bAdQ1vL3yhqAW/+9/Vccak5Vl471RVnq82AxKtcYeNfgBMuZ49GGsISjsZCq6Pi4kETCZdPelrd
	VZO8vhOi176zJMs8M5F/S0+XnP8IAGfyiwwIjX0Ww1UrYd9CA3GI8fERC7X7lalpTigy6gBUMBn
	WSYohy/o0DNbtkgI63q1Cm7IX28EMXRPZ1EKwy2DADkNqpkevrTQx7kDzhfZWYt16iWdzdn7ew6
	lv7Z4TMUaZMcAEe/sJmm1Ah27+wuxJYl+I/fBy4uYvG2h4ExTwvLIAIoMQHY3HnXmamm2zjnnCr
	ex3RI+MwpRE4wig6BkAHyeV4SMELHw6HrIrYpbjl9GByrf0onO7CusTH919vor1qWxli+GOQpIx
	i6G6PuSKGwzCvDcPi9HE8HN0Y4Wo1SJ9VE
X-Google-Smtp-Source: AGHT+IENWyTXPDADMQ43Q+qUkEcxH8/Cfr1KV4BDn/buPYFW/8tWf4Jvv5Qv2AAxqHLtTLmLsOKCaA==
X-Received: by 2002:a17:903:3c48:b0:269:805c:9447 with SMTP id d9443c01a7336-28e9a5bd2c0mr110553955ad.4.1759702004172;
        Sun, 05 Oct 2025 15:06:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1269b8sm111302175ad.50.2025.10.05.15.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 15:06:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v5WsK-0000000B0Wz-40rk;
	Mon, 06 Oct 2025 09:06:40 +1100
Date: Mon, 6 Oct 2025 09:06:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Emelyanov <xemul@scylladb.com>, linux-fsdevel@vger.kernel.org,
	"Raphael S . Carvalho" <raphaelsc@scylladb.com>,
	linux-api@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: Propagate FMODE_NOCMTIME flag to user-facing
 O_NOCMTIME
Message-ID: <aOLr8M6s1W2qC5-Q@dread.disaster.area>
References: <20251003093213.52624-1-xemul@scylladb.com>
 <aOCiCkFUOBWV_1yY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOCiCkFUOBWV_1yY@infradead.org>

On Fri, Oct 03, 2025 at 09:26:50PM -0700, Christoph Hellwig wrote:
> On Fri, Oct 03, 2025 at 12:32:13PM +0300, Pavel Emelyanov wrote:
> > The FMODE_NOCMTIME flag tells that ctime and mtime stamps are not
> > updated on IO. The flag was introduced long ago by 4d4be482a4 ([XFS]
> > add a FMODE flag to make XFS invisible I/O less hacky. Back then it
> > was suggested that this flag is propagated to a O_NOCMTIME one.
> 
> skipping c/mtime is dangerous.  The XFS handle code allows it to
> support HSM where data is migrated out to tape, and requires
> CAP_SYS_ADMIN.  Allowing it for any file owner would expand the scope
> for too much as now everyone could skip timestamp updates.
> 
> > It can be used by workloads that want to write a file but don't care
> > much about the preciese timestamp on it and can update it later with
> > utimens() call.

If you don't care about accurate c/mtime, then mount the filesystem
with '-o lazytime' to degrade c/mtime updates to "eventual
consistency" behaviour for IO operations. If inode metadata is
otherwise modified (e.g. block allocation during IO) or the
application then calls utimens(), it will update the recorded
in-memory timestamps in a persistent manner immediately.

> The workload might not care, the rest of the system does.  ctime can't
> bet set to arbitrary values, so it is important for backups and as
> an audit trail.

But we can (and do) delay the persistence of IO-based timestamp
updates with the lazytime option.

> > There's another reason for having this patch. When performing AIO write,
> > the file_modified_flags() function checks whether or not to update inode
> > times. In case update is needed and iocb carries the RWF_NOWAIT flag,
> > the check return EINTR error that quickly propagates into cb completion
> > without doing any IO. This restriction effectively prevents doing AIO
> > writes with nowait flag, as file modifications really imply time update.
> 
> Well, we'll need to look into that, including maybe non-blockin
> timestamp updates.

Lazytime updates can generally be done in a non-blocking manner
right now (someone raised that in the context of io-uring on #xfs
about a month ago), but the NOWAIT behaviour for timestamp updates
is done at a higher level in the VFS and does not take into account
filesystem specific non-blocking lazytime updates at all.  If we
push the NOWAIT checking behaviour down to the filesystem, we can do
this.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
