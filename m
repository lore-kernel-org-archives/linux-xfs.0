Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA2A13CFA1
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721946788; cv=none; b=LkPuKT2DYbyNp8rJZ3nYAnYoy7tEmbCPHoXVtlqbakG3OyY1mFM0UDwzWqUMxRrIOrIrrZfa3ZoyakB2qyALuTu5k6mHGegWoMzG6PUWdOSHB0FY8rKz9hVj/6YNuxoVOGNIcv1+xzIxzb4OfKotmNhw99tXShkqOVz2m82fkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721946788; c=relaxed/simple;
	bh=9g8HuG45jRPn1Tamv2H44Z/hlhdoyM5hCrj4DHh3TLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmm5Jr4ZnXGzg2qYdOyUYq10iiYH8NB6Iivk16/ZoWmppL6FTePnxCl87/5OiP06plYOQCzlmfsiZ1Z637L5dLruXj9wuD5z4Nw5bK6x0xXoD86s/x8kWrQJT1I0WlaEuAfGroC50xVpCW7t/3s0ScOe43iefM6HvNSeJpiZjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=JA2nfcWB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="JA2nfcWB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc49c0aaffso491425ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 15:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721946786; x=1722551586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JS8UfH1adpczx+zJgIZ8RPiMLrRw3pwIj/ebZhnjp+o=;
        b=JA2nfcWBDGKWzo3Bk8QCbSvkhGEbLyx8gmdYBi/JHVoAsQdLn3oIGvaLovWsqRmpaD
         noNXRHrmJsAg49QpkFkGr7nOoyNeHd8GahJZ6708kMPHbGhAoI9Rp5UX7xNhsbOCeTrv
         jC7TyjxQTZviVJHkj1OHdPEicTzzbg70arbVRGn15+GdObI7n8wE9CnZrG5VQQyFhHFX
         cn/CleKjQte4NCi1OUc5XiUd9OjmAWyLloXy/lFExfI6bwT73Tz27YBwM0tFxNuyf/JS
         KoQduyGjPP0H4d/WH/qCondD3vGNZw+s723jsB9Ckfcr6XMHljRayPs2vrO+89Ce721I
         aCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721946786; x=1722551586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JS8UfH1adpczx+zJgIZ8RPiMLrRw3pwIj/ebZhnjp+o=;
        b=VERAMyxL/rfgST2+Q4fjwqgfzarxebEhb7lQIAVvKBIl8a7tz94asIBvfUZB4gl9Vs
         qtJeVcsL83eLSjzpOdKI3FX0zLAt17DdoGpUY2Xo/oJzdSM6dnMWIu3JTpGm52EbIF/P
         6tykGVhyA4FoPtPCgCo6IUhspCteukbE0WPZiBLAyQhon4/+KgwVUEp7RI79/GAmpALN
         M8xvMYK3lA0KFaCgOUgG7Q8LpgMGzFGMQaotYJoEcfzU31Go2NbRyTGTDR8MKzuBajIj
         P7EXQujofDhmNDe5wt7raudsJK9XRSlHnwz4TntKAOufUaPi8sMtcGcgIBSZ6ctLkCeR
         Z18w==
X-Forwarded-Encrypted: i=1; AJvYcCXxr6j4ojTtl1RsKSTR1V+QmXSy/wS0K6cYdaN/VUr9yRWt/OatOFmvmEfsyAgFk2l64QxoGi9EP97+zJlRGcohiC0Fp/WzFH55
X-Gm-Message-State: AOJu0YwW3gUFjIRB98Y189R67drc3WqlAKOLskgt7RlMsZPQWdAuNKUm
	GQu9Zv2QVzS1+6/VvCVhzR55RtxtNISC+hfHo0WwOPMrOWLs0V2ZdJ4672F/c8U=
X-Google-Smtp-Source: AGHT+IGZMMmGhHrC9JQHhA92l8hhN+dD07oiDh8ommJkmn10l25BIkMyVrFCO4da5Z0U+zWg8oxMMg==
X-Received: by 2002:a17:903:2309:b0:1fd:8bad:6437 with SMTP id d9443c01a7336-1fed92d1863mr43454935ad.49.1721946785743;
        Thu, 25 Jul 2024 15:33:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7c8c826sm19248925ad.58.2024.07.25.15.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 15:33:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sX71C-00BL9O-0s;
	Fri, 26 Jul 2024 08:33:02 +1000
Date: Fri, 26 Jul 2024 08:33:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [RFC] xfs: opting in or out of online repair
Message-ID: <ZqLSni/5VREgrCkA@dread.disaster.area>
References: <20240724213852.GA612460@frogsfrogsfrogs>
 <ZqGy5qcZAbHtY61r@dread.disaster.area>
 <20240725141413.GA27725@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725141413.GA27725@lst.de>

On Thu, Jul 25, 2024 at 04:14:13PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 25, 2024 at 12:05:26PM +1000, Dave Chinner wrote:
> > Maybe I'm missing something important - this doesn't feel like
> > on-disk format stuff. Why would having online repair enabled make
> > the fileystem unmountable on older kernels?
> 
> Yes, that's the downside of the feature flag.
> 
> > Hmmm. Could this be implemented with an xattr on the root inode
> > that says "self healing allowed"?
> 
> The annoying thing about stuff in the public file system namespace
> is that chowning the root of a file system to a random user isn't
> that uncommon, an that would give that user more privileges than
> intended.  So it could not hust be a normal xattr but would have
> to be a privileged one,


I'm not sure I understand what the problem is. We have a generic
xattr namespace for this sort of userspace sysadmin info already.

$ man 7 xattr
....
Trusted extended attributes
       Trusted extended attributes are visible and accessible only
       to processes that have the CAP_SYS_ADMIN capability.
       Attributes in this class are used to implement mechanisms
       in user space (i.e., outside the kernel) which keep
       information in extended attributes to which ordinary
       processes should not have access.

> and with my VFS hat on I'd really like
> to avoid creating all these toally overloaded random non-user
> namespace xattrs that are a complete mess.

There's no need to create a new xattr namespace at all here.
Userspace could manipulate a trusted.xfs.self_healing xattr to do
exactly what we need. It's automatically protected by
CAP_SYS_ADMIN in the init namespace, hence it provides all the
requirements that have been presented so far...

> One option would be an xattr on the metadir root (once we merge
> that, hopefully for 6.12).  That would still require a new ioctl
> or whatever interface to change (or carve out an exception to
> the attr by handle interface), but it would not require kernel
> and tools to fully understand it.

That seems awfully complex. It requires a new on-disk
filesystem format and a new user API to support storing this
userspace only information. I think this is more work than Darrick's
original compat flag idea.

This is information that is only relevant to a specific userspace
utility, and it can maintain that information itself without needing
to modify the on-disk format. Indeed, the information doesn't need
to be in the filesystem at all - it could just as easily be stored
in a config file in /etc/xfs/ that the xfs-self-healing start
scripts parse, yes? The config is still privileged information
requiring root to modify it, so it's no different to a trusted xattr
except for where the config information is stored.

Userspace package config information doesn't belong in the on-disk
format. It belongs in userspace configuration files (i.e. as file
data) or in trusted named xattrs (file metadata).

-Dave.
-- 
Dave Chinner
david@fromorbit.com
