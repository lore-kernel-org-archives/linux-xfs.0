Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728B5199E87
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718666905; cv=none; b=pBXtUKFCOagpWMYs1hlpLfoHJG2ygqhMjvDmABX05/aCvE5pdcVY2SdXqIUMIqyok+JI9n3Obzo3qjYJ90sKH7xJow9rY+dOiEexEi0oRAvjY7gjRTBXOTz5KcPRmKR/ERZPTiWLPgddHqydp4Rz+T+oU7Oj7Yj2Xvt8QegmiTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718666905; c=relaxed/simple;
	bh=VO3y6sGKqj0ntUGZI5OAQl92r9uQBZrMMCBu+LXu+x4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dX3pePpPBuEb94/HI4s0NXk89AszNEDt1jYuRnhKWLAmILfNa7hiZaxtkleAKzwnLQRwY8YY9zLyvIlokj+uQbmgt6Ikk0mopo6DEQ+4N44X+rFgYmTH1DeSCNLOZDpZrAHDnHAVDTFYJlxL/peOiud98dP2wdX1SLoc4yOnF18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MuTiZTp6; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MuTiZTp6"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f44b594deeso45594625ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 16:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718666904; x=1719271704; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXC4uD49vw07uIuiQdsFqqowBM54LdRDc7FVAblEGxQ=;
        b=MuTiZTp6lb0XtUqV7oRmxE1a2EP2FjI2ZZRQ15fuOs76h20SjPV5fNz6F4Ynugl7ko
         4STCWerwNmmHKqR3zXCiwfAC3Vo0IRhRg5Ct8uZvMlfubjRVdFxgvn83FitmciKbjDNW
         VVMKzWd84JOKZAgzcXXjU1qgBOhXqQElegnlBAHGI5FD+6wZ/g2EbVaz1U8Yi50cjdVV
         0xUCWyOTv4oh6qkX50J1F/xH6urIHHU/LDVYCLefah+fVWon/Kxn0t40NvG5of2jW0fn
         wtXZpYJdXfBadBIMiOoOSsMyuGclrwGtiNntG4hoO8LQTTTi5fPYjG7gU6rYKm7/q5Oh
         C3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718666904; x=1719271704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXC4uD49vw07uIuiQdsFqqowBM54LdRDc7FVAblEGxQ=;
        b=ELqJKXIJAJbrz4oDfq5QDNhHs7IBAsIVZfwI2j83HjMyT7ib7ZJQa5vS8Pg+4BAZ7/
         ptTuFZeGrIKqaHR0T4bziWPZfbp7KNqJitgMUB37+vE8kkJkn3O2tpr+jKX/B2gJB5BN
         l25/CUVz//lmzNSSMa8PWKsLmjwZvkY5edXMJ/zoHxx0vrSCLqwXjy0L0r7brukWQo91
         M3P8Bp/PhLzoSAf8eJUzYPqK5qSvmAn/pOu8fUiM6KL9X4oG9pJDWFsF7MLt3vKf+LEA
         zInFk6+/8J/LFbVgZFGo3k+a8ALrm+JO6VUOvMOV3ZCK7ozOKT/2FnYQrYuZOa1PQGkc
         7Hfg==
X-Forwarded-Encrypted: i=1; AJvYcCVyaKOxoEc/poQ6+egZom76CJdyjH2/he1A20gYo1LBWEpJHbMtXble3Y8/osR98uPFzUOVn1oQsI2r4MRwlqKxYRTaoXv5StBA
X-Gm-Message-State: AOJu0YwPhntWplebm5539N+TL17OqoRwpQKni11SRRHIq/MbbiRzHN/c
	jWW/07nPpMSxK74kdlgjHdHTYuM+lJEFAhJr1H5W0XonqGkbiL/miGwRFaOF1OI=
X-Google-Smtp-Source: AGHT+IGn73LJfl79d/dz+Ai4ZcS/7+Cgx4CpWMuf/4xsCO1VzCLRdOvOy/f2KLKyA6kM/5+q7iMqXA==
X-Received: by 2002:a17:902:ed11:b0:1f4:5ad1:b65e with SMTP id d9443c01a7336-1f8627cd514mr69647575ad.34.1718666903516;
        Mon, 17 Jun 2024 16:28:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e5613esm84637365ad.15.2024.06.17.16.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 16:28:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sJLls-0026Ia-2I;
	Tue, 18 Jun 2024 09:28:20 +1000
Date: Tue, 18 Jun 2024 09:28:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
Message-ID: <ZnDGlHwBxi2pBNv8@dread.disaster.area>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs>
 <ZmqLyfdH5KGzSYDY@dread.disaster.area>
 <20240613082855.GA22403@lst.de>
 <Zm/DoN5npLCd+Y/n@dread.disaster.area>
 <20240617064603.GA18484@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617064603.GA18484@lst.de>

On Mon, Jun 17, 2024 at 08:46:03AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 03:03:28PM +1000, Dave Chinner wrote:
> > > That case should be covered by the XFS_IDIRTY_RELEASE, at least
> > > except for O_SYNC workloads. 
> > 
> > Ah, so I fixed the problem independently 7 or 8 years later to fix
> > Linux NFS server performance issues. Ok, that makes removing the
> > flag less bad, but I still don't see the harm in keeping it there
> > given that behaviour has existed for the past 20 years....
> 
> I'm really kinda worried about these unaccounted preallocations lingering
> around basically forever.

How are they "unaccounted"? They are accounted to the inode, they
are visible in statx and so du reports them.

Maybe you meant "unreclaimable"?

But that's not true, either, because a truncate to the same size or
a hole punch from EOF to -1 will remove the post-EOF blocks. But
that's what the blockgc ioctls are supposed to be doing for these
files, so....

> Note that in current mainline there actually
> is a path removing them more or less accidentally when there are
> delalloc blocks in a can_free_eofblocks path with force == true,
> but that's going away with the next patch.

... fix the blockgc walk to ignore DIFLAG_APPEND when doing it's
passes. The files are not marked with DIFLAG_PREALLOC, so blockgc
should trim them, just like it does with all other files that have
had post-eof prealloc that is currently unused.

In short: Don't remove the optimisation that prevents worst case
fragmentation in known workloads. Instead, fix the garbage
collection to do the right thing when space is low and we are
optimising for allocation success rather than optimal file layout.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
