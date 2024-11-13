Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA180382
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456869; cv=none; b=BpPFLTruRxpZ6KKib7XnT6gXkGapHx/AhdE+/2Zdvo3KnBgPTLqLynlgEyBY/Ys6hZ1VPUEvcBaYgGCliaHlnuTMBPTmFuPGF5aMtJ4C3sXB5lhqSOlvgo2ZtX+jrqVelDSZVtTcdWf2KuH/0s6oCoj/DVNBBF7USkGoAiY3s1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456869; c=relaxed/simple;
	bh=rJvxHfPVOmiYdHTuwuvaYnWonD0YlBdSUBIA1BAWvaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1L6cPiYrZxcVKEklIqqmpjtH2wYPBopUfeDtPqkP5CHBx6iPdl4ITEWejy3SgmMkZPSq+YjeDw8tyl1+Vs0cb58GFu/RlCRH/cz19pK8u4y6GOHIoBdeXElGYEC5SqBk2x09/ILx3Q8EEbP4+tf/I9JkgOLQUzrMfsVb3Lk1lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uzziUqhx; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uzziUqhx"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-72410cc7be9so5433919b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731456867; x=1732061667; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dMgP9ksCS/2lj0lE3qAOlc0c5aKz8/PzdAI7R0Rrr/I=;
        b=uzziUqhxf/p4Xjp9C4HePqEsqPvi/WA/M0QWHKYARnCVZEVwry8j1iZdDq5bzo8TIm
         I/IQpv8K5haIJ1Tvl2DJUxspGdED0ByU8y8NaZYXtgtgZd68FtYwQfodN+tNVtFtBxAA
         UWQo9+BZQHizPdtd68GjxvyhzGtW9anpeaE2p3v9wAo73DmMuZeoyaJv8SxT5gXzhTIM
         +00oHjBHs/3rE9Gwr9welOc7wQwZdjh7ve5u4/dseX3/2fmwLeEMg1vtCvvjVFLS4IUu
         ETzNjYqjxblYU6Sbwhdx0KS+coubUZcN2TT2wEhzypZvCjIyzzETu0cOSBSvdSQ9sTwM
         Yzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731456867; x=1732061667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMgP9ksCS/2lj0lE3qAOlc0c5aKz8/PzdAI7R0Rrr/I=;
        b=kn1kLhdU1Zz5p9QmbZG32PRzhbUcbrHm+1dGvmuSqhDsmWMP0EO8P62/zRGJP54eRt
         62PTAzGzAB9gAIZpVJHkwXVsHc8fqNaGtuwmqzzlM0nez3xUaSgQun5hpxGEgZBZTccf
         kxOUlOhaChUm051RLWgyv4oJy7cD7HYalTXF/CMqxjGrim1QtR6Medm93IXplELZqQ4M
         bAQG6hCp5HptdLDML6x3hLdm4qx96EY2GOVMjkbOx59teAtZrYOrDMZPDcvLNAYBfkz+
         krNOWu9nDX5Lh6s9W7RePb6YR1KaWC3oc7tujacHzQcDE/oxZrFiH1mf4VpuoH0zI8yH
         qoFQ==
X-Gm-Message-State: AOJu0YyEh9VdoeVsQSgTp3xg09A/BdeLadORNOdqp+KlWOqhZoFpQRMQ
	KPFQyZ+HAGlcFOdWNmNOqFfs1Yljz2zwUpkoMJbqyx+H4hLjALojbYFjJIcWSpLHK+fVM/b21/s
	T
X-Google-Smtp-Source: AGHT+IEHe7Iicx1FTaUfJoTk5XbxmmuSHCNt53ED5PLX7m0XtslV6IcbZ9r7uOBQ2K92Vb1Bom2a7A==
X-Received: by 2002:a05:6a00:1819:b0:71e:5d1d:1aa0 with SMTP id d2e1a72fcca58-72413282abcmr26224172b3a.6.1731456866984;
        Tue, 12 Nov 2024 16:14:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7240799bab1sm12188540b3a.107.2024.11.12.16.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 16:14:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tB11b-00Dr68-38;
	Wed, 13 Nov 2024 11:14:23 +1100
Date: Wed, 13 Nov 2024 11:14:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 2/3] xfs: delalloc and quota softlimit timers are
 incoherent
Message-ID: <ZzPvX824X9M9PZoM@dread.disaster.area>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-3-david@fromorbit.com>
 <20241112234835.GH9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112234835.GH9438@frogsfrogsfrogs>

On Tue, Nov 12, 2024 at 03:48:35PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2024 at 09:05:15AM +1100, Dave Chinner wrote:
> > From: Supriya Wickrematillake <sup@sgi.com>
> 
> Wow, there are still people working at SGI??

huh, that's a git-send-email screwup. It must have pulled that from
the quote of the initial quota commit:

> > This debug was introduced in:
> > 
> > commit 0d5ad8383061fbc0a9804fbb98218750000fe032
> > Author: Supriya Wickrematillake <sup@sgi.com>
> > Date:   Wed May 15 22:44:44 1996 +0000
> > 
> >     initial checkin
> >     quotactl syscall functions.

Here, and decided to ignore the actual "From: dchinner@redhat" tag
in the local commit message.

Great work, git!


> > The very first quota support commit back in 1996. This is zero-day
> > debug for Irix and, as it turns out, a zero-day bug in the debug
> > code because the delalloc code on Irix didn't update the softlimit
> > timers, either.
> > 
> > IOWs, this issue has been in the code for 28 years.
> > 
> > We obviously don't care if soft limit timers are a bit rubbery when
> > we have delalloc reservations in memory. Production systems running
> > quota reports have been exposed to this situation for 28 years and
> > nobody has noticed it, so the debug code is essentially worthless at
> > this point in time.
> > 
> > We also have the on-disk dquot verifiers checking that the soft
> > limit timer is running whenever the dquot is over the soft limit
> > before we write it to disk and after we read it from disk. These
> > aren't firing, so it is clear the issue is purely a temporary
> > in-memory incoherency that I never would have noticed had the test
> > not silently failed to unmount the filesystem.
> > 
> > Hence I'm simply going to trash this runtime debug because it isn't
> > useful in the slightest for catching quota bugs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Agreed!  I've hit this once in a blue moon and didn't think it was
> especially useful either.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
