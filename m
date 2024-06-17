Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CE3C136
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 05:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718600614; cv=none; b=rJxd2iYLmYv5PjfgLL6j8BY/oCRwYXdB3VMev6e2dBg/9KVpj0v3Bwr4aDHXAr+tts9t/u66DFQyDk4htAiGL6pqsuIlnLwkrq+nogYpssoNd7p26iOKp0xhBa5HYJz6YMvXBKbl1h5K1nlRVWAwACQYzrfpRxNOrrsJoSnoxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718600614; c=relaxed/simple;
	bh=u0aaJxLglBHxZKQBY2X8IcKtU4eSq97lb39f5eHlscw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCvjWRwns0EoS9o4WNyYiBU4u/jd2PfXchrLdDJHB3g82jqNGoKowP6OHPn9Kk94M591WY53Lrou3jWcLp7YVnADn6KdNl3gJwLYxgHJL39ujCP71BjciCyX9LP6sA+Bl0JGQUH5H+/ar7HB2B2Eli7PIk+i/G1KLPSGr6FGuMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=j7tvy+CN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="j7tvy+CN"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f6da06ba24so33914355ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jun 2024 22:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718600612; x=1719205412; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l6Zo1baX0zIsrpPBz/dshHC6llgIaoFdlb9I+C+EWa0=;
        b=j7tvy+CNXupIDZiTsok5C0O5zam1UhxuhMjN8OfAzADSK/cUFT08BdtvGZLfx2EdQM
         SQkkvVa0JgFZFYiXah/N2In9+eB3o89SqY4mCaMGTlgFQYrKTtIyip0ou0K0AJDRW97R
         uJqsJ8s18lNEXGIVJH8YqmdDQ0KyIrlal37zuR8bpBg2mCKilEkr3ETgMex8fkAwBX+J
         DwDl5RsrS5HxfitSxy8sSvPWXWq7c4saVqX6Lpw1ywBEvDGfRL3FGxR3JFrZdQo/D90h
         Zx9nor9hSdbDVZAR9RNgCJQgdG4sc2c4UuzbNeHngW8evqXOHRTS8gFa5Pd9HTXymX2Y
         lDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718600612; x=1719205412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6Zo1baX0zIsrpPBz/dshHC6llgIaoFdlb9I+C+EWa0=;
        b=Ks52ohD9bwFuUwHa2B1CGyYWkYDZuofP0zpqF6U2jaAwYGwNcxOpl/++Zhbugnr/A4
         PPeWiRm1eFlEE4RouqPdqYv0Qy+MTDfPgWOWA812+sVT1xnMqfqo0fdrCq/MVumByM9w
         uKpHt5gceg0J16OhiFiP5YAu/5ORt9f5k/ZYv/SRnKSui0b604Rriu2UQMUXl3TJDR50
         Jx6gHN6GnPpmjHqEvjv9wsiA6PkcSBQ3Ohj4rrRSuWKE+iQDu3mXLiHgWl9ooaTZ56fX
         Tbn8iAqEwPEDQDoW4wXEc2OcBbrPxkfaTa/E9mR/8ieypRXePJ1VE5kZ7Vtdn/qOeYPC
         ikLA==
X-Forwarded-Encrypted: i=1; AJvYcCXuYee4Nq715ER3fuAaCF43N3KDiCn1zHcFw8XUzUfDNge31RD6fKwEq5S/v+J7mBnpI7p1jM7QalEp0yqTe9BnY1DcwMsOGwmH
X-Gm-Message-State: AOJu0YxXfBBz58zdFnWC0NBUDyzYX/tiHRgQEj9P/aahxk+Su2MxhvF1
	h5xyM/3fILi5lLkVxHGLsl0h/7W3qrWW7KJbaBkp3LUzNAlibqPp6QD+FXMBrL4=
X-Google-Smtp-Source: AGHT+IHGYUgVmdSZPueJC9/98f5vF3lsnWzglHqDw7+l+2GLJHDAMms9fmZv6hiFkkfDR5KvOQEjmQ==
X-Received: by 2002:a17:902:c94d:b0:1f7:1688:9e36 with SMTP id d9443c01a7336-1f86290073cmr101581635ad.48.1718600611672;
        Sun, 16 Jun 2024 22:03:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee830csm72399275ad.162.2024.06.16.22.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jun 2024 22:03:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sJ4We-001Ck4-0w;
	Mon, 17 Jun 2024 15:03:28 +1000
Date: Mon, 17 Jun 2024 15:03:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
Message-ID: <Zm/DoN5npLCd+Y/n@dread.disaster.area>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs>
 <ZmqLyfdH5KGzSYDY@dread.disaster.area>
 <20240613082855.GA22403@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613082855.GA22403@lst.de>

On Thu, Jun 13, 2024 at 10:28:55AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 13, 2024 at 04:03:53PM +1000, Dave Chinner wrote:
> > I disagree, there was a very good reason for this behaviour:
> > preventing append-only log files from getting excessively fragmented
> > because speculative prealloc would get removed on close().
> 
> Where is that very clear intent documented?  Not in the original
> commit message (which is very sparse) and no where in any documentation
> I can find.

We've lost all the internal SGI bug databases, so there's little to
know evidence I can point at. But at the time, it was a well known
problem amongst Irix XFS engineers that append-only log files would
regularly get horribly fragmented.

There'd been several escalations over that behaviour over the years
w.r.t. large remote servers (think of facilities that "don't trust
the logs on client machines because they might be compromised"). In
general, the fixes for these applications tended to require the
loggin server application to use F_RESVSP to do the append-only log
file initialisation.  That got XFS_DIFLAG_PREALLOC set on the files,
so then anything allocated by appending writes beyond EOF was left
alone. That small change was largely sufficient to mitigate worst
case log file fragmentation on Irix-XFS.

So when adding a flag on disk for Linux-XFS to say "this is an
append only file" it made lots of sense to make it behave like
XFS_DIFLAG_PREALLOC had already been set on the inode without
requring the application to do anything to set that up.

I'll note that the patches sent to the list by Ethan Benson to
originally implement XFS_DIFLAG_APPEND (and others) is not exactly
what was committed in this commit:

https://marc.info/?l=linux-xfs&m=106360278223548&w=2

The last version posted on the list was this:

https://marc.info/?l=linux-xfs&m=106109662212214&w=2

but the version committed had lots of things renamed, sysctls for
sync and nodump inheritance and other bits and pieces including
the EOF freeing changes to skip if DIFLAG_APPEND was set.

It is clear that there was internal SGI discussion, modification and
review of the original proposed patch set, and none of that internal
discussion is on open mailing lists. We might have the historical
XFS code and Linux mailing list archives, but that doesn't always
tell us what institutional knowledge was behind subtle changes to
publicly proposed patches like this....

> > i.e. applications that slowly log messages to append only files
> > with the pattern open(O_APPEND); write(a single line to the log);
> > close(); caused worst case file fragmentation because the close()
> > always removed the speculative prealloc beyond EOF.
> 
> That case should be covered by the XFS_IDIRTY_RELEASE, at least
> except for O_SYNC workloads. 

Ah, so I fixed the problem independently 7 or 8 years later to fix
Linux NFS server performance issues. Ok, that makes removing the
flag less bad, but I still don't see the harm in keeping it there
given that behaviour has existed for the past 20 years....

> > The fix for this pessimisitic XFS behaviour is for the application
> > to use chattr +A (like they would for ext3/4) hence triggering the
> > existence of XFS_DIFLAG_APPEND and that avoided the removal
> > speculative delalloc removed when the file is closed. hence the
> > fragmentation problems went away.
> 
> For ext4 the EXT4_APPEND_FL flag does not cause any difference
> in allocation behavior.

Sure, but ext4 doesn't have speculative preallocation beyond EOF to
prevent fragmentation, either.

> For the historic ext2 driver it apparently
> did just, with an XXX comment marking this as a bug, but for ext3 it
> also never did looking back quite a bit in history.

Ditto - when the filesystem isn't allocating anything beyond EOF,
there's little point in trying to removing blocks beyond EOF that
can't exist on final close()...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
