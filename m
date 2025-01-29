Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2B17E473
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2025 00:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738112399; cv=none; b=FudqQNVAi322rIErXs80vrcCES8tOghGa3gwgCpf1XJrwrUpDbQymXxpWLilgy31ZXcd4Jws0zkG/KrwvizJTdkElC3/G666bHZ73jiBEWdLvQx8uLk5FoX68GBvNPvsbfWpFs0FJoElQ5HMFlmMM9n/jkIdtpauRXp0/LSckKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738112399; c=relaxed/simple;
	bh=WqVTtsXX7bPMeMdCybZgI8wYK3qsNrpNuBgQgREfkJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwiAlpLdKV46B968CF4DK+Jy0HR1p3IfB0hC5Ivb++cw9hq91m3LMkvaUWGcxfVIPHdmXzkDaVKq25xgt6FZ1vuDerVcTDPbv0+pnVV2w8gnPBrxUcdGK67u0QNYXJv/+mYy8eSecEiMS89II7kJ5jwT4z7tvqQiPFOeXyepDiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j3/OlMDO; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j3/OlMDO"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2efded08c79so8843841a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 16:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738112397; x=1738717197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=elwhvKi666iQFEb/LwJj0lI81yVVHHbgLDJ2x+b/F4w=;
        b=j3/OlMDOv7PQPjIFCaMQeiNQvcMKWzps0AOdybAbQftPAk8YGyHO71uqLImlTzLyo2
         Bh+Iu+V0mstXm/BgO2gzLE2PVCfjEqYA0u9H2NziA/7P3tdpTf61S2tHp0Hfn7TP7N9p
         gpHyRyc/S84QIbfQ3bSxJeo7870wr597ZLFtbPNQVKogto8WpVudeXwmx7Z8ntbzMrUG
         5uNckDfiawr6AGtW3qxtls11l1cvjTvMjy33hHsjwmX3YAK98tz9/rBv+MR8gVBgPe8I
         bIqQBWgibY2ahHxKI8BPO7rsKEdID/eADPKg/A+++2eNuY9Zd8Y3IF5dzCKr2y2WHaS5
         k9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738112397; x=1738717197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elwhvKi666iQFEb/LwJj0lI81yVVHHbgLDJ2x+b/F4w=;
        b=j9K4UwU8UYkutTE/OPDyUXbY2RdX5S9+wmZLqkhHz72n7/wU61pWA91aMru8VjFu/H
         xafKxTJOfO0VlzQraC0Udlye2KbrsBMKWZ/xPhZtE3yyud8i9h+yy7FaU+Ar+D8xsQ9D
         dceOvUnaAtRaAbWpHEVBDrH507ELVM7Dzbq4jJMpgAQbd7i/c3Si+v8A/fW/JuHjADf7
         Z72XRtS6Qsh7t6098F6GYPyiUhaRwEWrKNtRei/naDuGJPPgeaon1X/SslVe8fc1aA8b
         tlOSf9tl2l5klcLJbMC2YtnELzZ8vHFuL6e4EjMmF8u09rSw9u6mUlp2T98lhBRQ+y1m
         /JxA==
X-Forwarded-Encrypted: i=1; AJvYcCUv5jRWobPC7LcRicLSAWu/dEQWO4nZC5zV2Gbd/gUsJg+fs/OwfJ7tNWbDI4LtLtBObvgxpRdrvK4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyge6sANPKLRMsIf08nUJh/Iabl8q/8JqyWBNlvhQ54C2aqEQdL
	vTNk1NCN4cIFIHn3bPXRT1HANcIPD/U9+4RimJ7pV1rU9YG++TQ5vx7N+XHrGZQ=
X-Gm-Gg: ASbGnctNGX1+l9ooRC54A1yMIvkTb+uE0TnyRXQRuJrfwOUZs4KkDvrlpqMX8E0NEuw
	KhhYQ/oGvtEv3sCbpldAb6RbsY1svqKnFUfS5zPiTQ2w5JjEoAG/UvwIsx/jjuOOFYESRqnYgMP
	Xbfniv7NXQ5rZFE7t8y1vCawrkjNECiNuXGC0mNFMrgZF+6LYstxKdNYMsbLOwUU4V5AWkf1e6F
	l0RLYGFHjnetsVQDQEBBEH+5/nPRSFMyh4P+jRmsazwtKLcNVIRHJAOwGuWCncoz92G42XClYLM
	jO5ZC24LqtcESTtFt7o8J8DSXn/p+DXMWm5ML28jbtJ6XzuRUMtjGtBdveNjbUOUHYk=
X-Google-Smtp-Source: AGHT+IGiueVtR3L81+IT9PByKRYjSPvZvEl4bE48jUqsFpSQQjSQYfTP1OMLvMIzMiHkpNimWngMpQ==
X-Received: by 2002:a05:6a00:3927:b0:729:c7b:9385 with SMTP id d2e1a72fcca58-72fd0be5439mr1777197b3a.6.1738112396790;
        Tue, 28 Jan 2025 16:59:56 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b3f86sm10285657b3a.67.2025.01.28.16.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 16:59:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcwQr-0000000Bnoj-1TQ9;
	Wed, 29 Jan 2025 11:59:53 +1100
Date: Wed, 29 Jan 2025 11:59:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chi Zhiling <chizhiling@163.com>, Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5l9ieD8zkCQYHFV@dread.disaster.area>
References: <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
 <Z5fxTdXq3PtwEY7G@dread.disaster.area>
 <Z5hn_cRb_cLzHX4Z@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5hn_cRb_cLzHX4Z@infradead.org>

On Mon, Jan 27, 2025 at 09:15:41PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 28, 2025 at 07:49:17AM +1100, Dave Chinner wrote:
> > > As for why an exclusive lock is needed for append writes, it's because
> > > we don't want the EOF to be modified during the append write.
> > 
> > We don't care if the EOF moves during the append write at the
> > filesystem level. We set kiocb->ki_pos = i_size_read() from
> > generic_write_checks() under shared locking, and if we then race
> > with another extending append write there are two cases:
> > 
> > 	1. the other task has already extended i_size; or
> > 	2. we have two IOs at the same offset (i.e. at i_size).
> > 
> > In either case, we don't need exclusive locking for the IO because
> > the worst thing that happens is that two IOs hit the same file
> > offset. IOWs, it has always been left up to the application
> > serialise RWF_APPEND writes on XFS, not the filesystem.
> 
> I disagree.  O_APPEND (RWF_APPEND is just the Linux-specific
> per-I/O version of that) is extensively used for things like
> multi-thread loggers where you have multiple threads doing O_APPEND
> writes to a single log file, and they expect to not lose data
> that way.

Sure, but we don't think we need full file offset-scope IO exclusion
to solve that problem.  We can still safely do concurrent writes
within EOF to occur whilst another buffered append write is doing
file extension work.

IOWs, where we really need to get to is a model that allows
concurrent buffered IO at all times, except for the case where IO
operations that change the inode size need to serialise against
other similar operations (e.g. other EOF extending IOs, truncate,
etc).

Hence I think we can largely ignore O_APPEND for the
purposes of prototyping shared buffered IO and getting rid of the
IOLOCK from the XFS IO path. I may end up re-using the i_rwsem as
a "EOF modification" serialisation mechanism for O_APPEND and
extending writes in general, but I don't think we need a general
write IO exclusion mechanism for this...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
