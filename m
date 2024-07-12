Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D73391
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 00:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720744321; cv=none; b=NyAPpVC5dsKDCooJmG/8yg+muy0SSPBOiYbPnMBI8ze7UvTCrICUdTneqDdhx+61tSK6JxaNNdVtBB8a4lFp4gwthN719HnbhaRHJRaA3pG6cpqlEWrmpuJgJ3So6gjdnttV+0zUoVCAOU/BvgWBk2ZnZ8bzcCLYFyJ35+h0r4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720744321; c=relaxed/simple;
	bh=G360dXShm61Q+zIhO6OfScrfzCy32uUMRl52oDPBc1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIDFCMpDDl5eNWt/SSQF+VsWs7NaiyM33vlhUxYvtbqW7n0dVllwsgk1/lDRgQr/wMwVHj8g7fjvzQdGAAkz9mm5KM6YthzvhxJiz787UjWZEzbCG+EPJ3Zm7pzVQd/wG/H8zKWC5skPp/w5+jH05IojPddoP24yAYwwQ5wlWVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=XYJDLdcH; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="XYJDLdcH"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70af8128081so1228116b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 17:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720744320; x=1721349120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RvL8Fxd5PelloxdrPEBzs8+jyIld78kHS1+ndVEpKKg=;
        b=XYJDLdcH/IDVLy3Cl9yK5MscBqg7/60Vj66TJPcB7fl+n/j7WzmsmzLXAVCTsfwDD6
         e8KQ/vWLflB+zArmdnA30EEjPCjUEUyy0jZmK1XAY2tCI/LgXmcsir/tFKEo+o5HZa4H
         +C13Py7TqiVCtA34Gs4R6cjUMeccGRfMpFfqR65tgw02C5U+21M7K9NvO/gRN3T+8o26
         rhg/GeoG3evCVO9e6GRX55DcR8PYRshjXBanSTig5TZ/ziE+PPGKg7idrfjy+554fkC0
         k1cI5u5lBYuYKXtrI44u8xYlhvDuqZ3N1vKuT/ohoMSbjZE+XrL4Kk2NpD/CFp5D2463
         RFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720744320; x=1721349120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvL8Fxd5PelloxdrPEBzs8+jyIld78kHS1+ndVEpKKg=;
        b=UepDVQKZiuFAhGcv4DjrfuWAXT5lXJ1NWNC+b8Kqzg58WWrj9U4Ey58gyK5U+xuMOX
         qkuAZQdz16Ybos4esDyOU3YPI1jxVtR6dWduLt2V7yriS8Id40+Y94qdYdJehZjevLIX
         1tInKsKGpCPnEUJLPsE99V6KgdLyw+HTkDvp6kzCwtJ7kZyLMrwfEye8o18grOUXYqN0
         F40JNQatgqz1RmkmEgm6uPmFE611HYeNp2WJJozoEfsb8uRRtdPvC3fO7iUqTxVpvxE0
         NdAvsovpQ14QBIn79GAo/Tw+/p3pe0+xMtOjixrWx0T12FtlUlLdLX22n0SguhWNv/HM
         pHoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBDoIj4dGxY6jaJnLOl2FvT214PVBY8zd0IGSUnNkE0Ch5l8YwdseQNpHc/oX8Zs8EoxJYbRCHufMMeytGSQkbm8ZJ7j3frQJo
X-Gm-Message-State: AOJu0YwWNoxln+bn09Zk38vyV2uLC7QCtiSzanuqRNXD1kfJfxnw9kC/
	DZZZfJiJsMyHL6fvrf4lMdm8d+pADbUTSSZk/siRyrTnPMkl/v36OdUJseUF0EM=
X-Google-Smtp-Source: AGHT+IEt56nLnZqNbTRO03JS0rB9hyWQhUeruUDlMkxQEBu0ilPYQnCsiPHMhENrFqi7uISi1QorPg==
X-Received: by 2002:a05:6a00:1249:b0:70a:9672:c3a2 with SMTP id d2e1a72fcca58-70b43632384mr11263329b3a.24.1720744319565;
        Thu, 11 Jul 2024 17:31:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439c3213sm6270131b3a.194.2024.07.11.17.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 17:31:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sS4Cb-00Ccki-05;
	Fri, 12 Jul 2024 10:31:57 +1000
Date: Fri, 12 Jul 2024 10:31:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <ZpB5fS822UrP6JIs@dread.disaster.area>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
 <ZoIF7dEBkd4YPlSh@dread.disaster.area>
 <20240701233749.GF612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701233749.GF612460@frogsfrogsfrogs>

On Mon, Jul 01, 2024 at 04:37:49PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 01, 2024 at 11:27:09AM +1000, Dave Chinner wrote:
> > On Tue, Jun 18, 2024 at 06:06:22PM -0700, Darrick J. Wong wrote:
> > > On Tue, Jun 18, 2024 at 04:21:12PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > xfs_init_new_inode ignores the init_xattrs parameter for filesystems
> > > > that have ATTR2 enabled but not ATTR.  As a result, the first file to be
> > > > created by the kernel will not have an attr fork created to store acls.
> > > > Storing that first acl will add ATTR to the superblock flags, so chances
> > > > are nobody has noticed this previously.
> > > > 
> > > > However, this is disastrous on a filesystem with parent pointers because
> > > > it requires that a new linkable file /must/ have a pre-existing attr
> > > > fork.
> > 
> > How are we creating a parent pointer filesystem that doesn't have
> > XFS_SB_VERSION_ATTRBIT set in it? I thought that mkfs.xfs was going
> > to always set this....
> 
> <shrug> The first three versions didn't set ATTRBIT; somewhere between
> v4 and v5 Allison changed mkfs to set ATTRBIT; and as of v13 it still
> does.
> 
> That said, there aren't actually any parent pointers on an empty
> filesystem because the root dir is empty and the rt/quota inode are
> children of the superblock.  So, technically speaking, it's not
> *required* for mkfs to set it, at least not until we start adding
> metadir inodes.
> 
> At no point during the development of parent pointers has xfs_repair
> ever validated that ATTRBIT is set if PARENT is enabled -- it only
> checks that ATTRBIT is set if any attr forks are found.

Right, that's the oversight we need to correct. mkfs.xfs is already
setting it, so adding checks to the suerpblock verifier, repair, etc
isn't going to break anything.

> > > > The preproduction version of mkfs.xfs have always set this, but
> > > > as xfs_sb.c doesn't validate that pptrs filesystems have ATTR set, we
> > > > must catch this case.
> > 
> > Which is sounds like it is supposed to - how is parent pointers
> > getting enabled such that XFS_SB_VERSION_ATTRBIT is not actually
> > set?
> 
> Someone who fuzzes the filesystem could turn off ATTRBIT on an empty fs.
> That's a valid configuration since there are also no parent pointers.

No, it's not. The parent pointer feature bit it set, mkfs.xfs always
sets the ATTRBIT in that case, so the superblock feature bit checker
needs to error out if (PARENT | ATTRBIT) == PARENT.

This is basic on-disk format verification stuff, Darrick, and you
know this as well as I do.

> Or at least I'm assuming it is since xfs_repair has never complained
> about ATTRBIT being set on a filesystem with no attr forks, and nobody's
> suggested adding that enforcement in the 6 years the parent pointer
> series has been out for review.

Which is a classic demonstration of an oversight. We're not
omniscent, and hindsight is wonderful for making things we missed
obvious.

Also, xfs_repair failing to catch something doesn't mean the
behaviour is correct or good. It just means we failed to consider
that specific failure mode and so haven't added the code to catch
it. Fixing this sort of oversight is exactly why we have
EXPERIMENTAL tags....

> Getting back to the story, if someone mounts that empty filesystem and
> tries to create a directory structure, the fs blows up.  This patch
> fixes that situation without adding more ways that mount can fail.

But that's the issue: we should not be working around feature bit
bugs in core XFS code. PARENT is dependent on ATTRBIT being set, and
the whole point of our feature bit checks is to catch on-disk format
bugs like this at mount time. Ignoring the bad feature flag
combination and workign around them in core code is the antithesis
of the XFS on-disk format verification architecture.

The fact is that mount *should fail* if PARENT is set and ATTRBIT is
not. xfs_repair should flag this as an error and fix it. mkfs.xfs
has set both PARENT and ATTRBIT for a long long time, and so we
should be enforcing that config everywhere. We should not be working
around an invalid feature bit combination anywhere in the XFS code,
ever.

> > > > Note that the sb verifier /does/ require ATTR2 for V5 filesystems, so we
> > > > can fix both problems by amending xfs_init_new_inode to set up the attr
> > > > fork for either ATTR or ATTR2.
> > 
> > True, but it still seems to me like we should be fixing mkfs.xfs and
> > the superblock verifier to do the right thing given this is all
> > still experimental and we're allowed to fix on-disk format bugs
> > like this.
> > 
> > Can we add that to the superblock verifier so that the parent
> > pointer filesystems will not mount if mkfs is not setting the 
> > XFS_SB_VERSION_ATTRBIT correctly when the parent pointer feature is
> > enabled?
> > 
> > Worst case is that early testers will need to use xfs_db to set the
> > XFS_SB_VERSION_ATTRBIT and then the filesystem will mount again...
> 
> Patches welcome.

It's taken me a long time to calm down after reading these two
words.

One of the reasons we have an EXPERIMENTAL period for new features
is to provide scope for correcting on-disk format screwups like this
properly. This means we don't need to carry hacks around stupid
thinko's and straight out bugs in the on-disk format and initial
implementation forever.

We also work under the guidelines that it is largely the
responsibility of the engineer who asked for the new functionality
to be merged to do most of the heavy lifting to fix such issues
during the EXPERIMENTAL period.

Suggesting that someone else should do the work to tidy up the loose
on-disk format ends in the kernel and userspace in preference to a
one line hack that works around the problem goes against all the
agreements we've had for bringing experimental code up to production
quality. This isn't how to engineer high quality, robust long lived
code...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
