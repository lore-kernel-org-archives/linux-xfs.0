Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BD013BAD5
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 23:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721777903; cv=none; b=jB5RUHQ9x7pQ4ztLkcZKkVpwhXHIqTMvAqC2qGX+ymmH1s/ijcs/jGmWo5uDN9Kk1GjgGa1jAm6KDDIe5H13KSzR/ZrT/BAA5qgJ7HUBSViwA11/0Rnjcta/u9nJSiwpssqa5O5VJn0G5g7WEwyb4+EZjfIxUYs/ReQ4DpHeEkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721777903; c=relaxed/simple;
	bh=YZlqiXgB2/KpXOy/Xy7gba+mp9c/soUc7YYd2tZttKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ug8wixWopBuIl0Z+9kOMmXb74c74c/pOCePKk4Crm/zRpD0mILTpn6F0Iq0++mS3aGprhgz+QNGeLVg004t9sT+/cRyUjGP+IsCy1WB9KP5U/uqfEnd2snmUUAS15etGhTEVcw5b4iULDZJ+DacEeC23dJLYHMZuu5NO+OsE+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Xwc8Nwao; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Xwc8Nwao"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc6ee64512so3953635ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 16:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721777901; x=1722382701; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ke4GyxolaIMwY7FBQeuGRUN+roRlg42otU6rOoFkee0=;
        b=Xwc8NwaoE7yH/1CO0za3phVW9C50oRHGXs/G0RS2av49/KbCImBsc6ZN95ERY1ddKA
         fk8qhRwOvWkmDheejOQblzsFRrj4A7n5EP34CPoh0C6aGliilyKppGrDixqCcxhYxBya
         48uJ7YRjeDtHJvYFOannetAA5gWpggPqXMM4f74uxbCco9UWynFfbnNB73b3+8SPDP7w
         ECmZ8cZpYeBBds+oByzgmWj1K1cEGO+UTNh5nfnpwO6pKiYCeTGFY/nQbtE/AYtb5s+F
         EVFFIzMMeRmGmoDDpQ+fwF7u08DbL5+5TqOE88v9Ed2d1JhphY0KdIoGhk9gcyLo/YFL
         icZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721777901; x=1722382701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ke4GyxolaIMwY7FBQeuGRUN+roRlg42otU6rOoFkee0=;
        b=vFifgsbFWDrQGXxtYYrxid3Jy9KZ7vZ1gPRHBbo9LN1uoO/C2OOVttBOOvTQ8x8nCj
         nfOlQB6WoK/4K8twED2rZkpfjdmc8S2EN4kzKoRtPRoeD+3xIFOvjSi8jRiQPEkpgyCZ
         rSIwUf+PC5kY+ccrh6F8kbWLaMo3UrtdCHRZXZgP/FWDYbydVLTLuYEGKL28q30Ic8ci
         i8uEJsg07EVSuJ2r5yKE8c7YYdje7WcU86Oc4EvpVo7LaEB9weY6bRKTIPJbjJdkkcjF
         91I1uJLeLIkT9/vvrylf3CJLEkLaS1CxFzHMJbAqZJXy7MWST+LmLz0/w32dA5IsSWZG
         FnlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaux0H0I610NPQc/diLHykNaptpJivTmNfgK3MswOGu0NQn1aaJxvxwk2Wq2kRi+GfIVkggS2WvFOKA2m/pBq0jdDrLN9rTo5C
X-Gm-Message-State: AOJu0YwIWYWM43Iz0eQd48Aux4mo13rH3igcbk8bfHZ8mgesBdVIUAfv
	BWV/a+OBuTyzSzZjBi//gfPu0bma8bT5KPVfd+s0dS9MjJAUNFWtnajfcbhUQBWQ/LhHpEg4ZfE
	g
X-Google-Smtp-Source: AGHT+IHyILHL082CDZfLkAoHVX9H6GXLryDB+lHEgkbpls5+M0N8NGa2bQ3fWUJQo0rsFwrsUCcaig==
X-Received: by 2002:a17:902:ce8c:b0:1f9:c508:acd5 with SMTP id d9443c01a7336-1fd7457344fmr91518925ad.5.1721777901427;
        Tue, 23 Jul 2024 16:38:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f49a218sm81121255ad.298.2024.07.23.16.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 16:38:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWP5G-0092l1-1Y;
	Wed, 24 Jul 2024 09:38:18 +1000
Date: Wed, 24 Jul 2024 09:38:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2 07/13] xfs: Introduce FORCEALIGN inode flag
Message-ID: <ZqA+6o/fRufaeQHG@dread.disaster.area>
References: <20240705162450.3481169-1-john.g.garry@oracle.com>
 <20240705162450.3481169-8-john.g.garry@oracle.com>
 <20240711025958.GJ612460@frogsfrogsfrogs>
 <ZpBouoiUpMgZtqMk@dread.disaster.area>
 <0c502dd9-7108-4d5f-9337-16b3c0952c04@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c502dd9-7108-4d5f-9337-16b3c0952c04@oracle.com>

On Thu, Jul 18, 2024 at 09:53:14AM +0100, John Garry wrote:
> On 12/07/2024 00:20, Dave Chinner wrote:
> > > > /* Reflink'ed disallowed */
> > > > +	if (flags2 & XFS_DIFLAG2_REFLINK)
> > > > +		return __this_address;
> > > Hmm.  If we don't support reflink + forcealign ATM, then shouldn't the
> > > superblock verifier or xfs_fs_fill_super fail the mount so that old
> > > kernels won't abruptly emit EFSCORRUPTED errors if a future kernel adds
> > > support for forcealign'd cow and starts writing out files with both
> > > iflags set?
> > I don't think we should error out the mount because reflink and
> > forcealign are enabled - that's going to be the common configuration
> > for every user of forcealign, right? I also don't think we should
> > throw a corruption error if both flags are set, either.
> > 
> > We're making an initial*implementation choice*  not to implement the
> > two features on the same inode at the same time. We are not making a
> > an on-disk format design decision that says "these two on-disk flags
> > are incompatible".
> > 
> > IOWs, if both are set on a current kernel, it's not corruption but a
> > more recent kernel that supports both flags has modified this inode.
> > Put simply, we have detected a ro-compat situation for this specific
> > inode.
> > 
> > Looking at it as a ro-compat situation rather then corruption,
> > what I would suggest we do is this:
> > 
> > 1. Warn at mount that reflink+force align inodes will be treated
> > as ro-compat inodes. i.e. read-only.
> > 
> > 2. prevent forcealign from being set if the shared extent flag is
> > set on the inode.
> > 
> > 3. prevent shared extents from being created if the force align flag
> > is set (i.e. ->remap_file_range() and anything else that relies on
> > shared extents will fail on forcealign inodes).
> > 
> > 4. if we read an inode with both set, we emit a warning and force
> > the inode to be read only so we don't screw up the force alignment
> > of the file (i.e. that inode operates in ro-compat mode.)
> > 
> > #1 is the mount time warning of potential ro-compat behaviour.
> > 
> > #2 and #3 prevent both from getting set on existing kernels.
> > 
> > #4 is the ro-compat behaviour that would occur from taking a
> > filesystem that ran on a newer kernel that supports force-align+COW.
> > This avoids corruption shutdowns and modifications that would screw
> > up the alignment of the shared and COW'd extents.
> > 
> 
> This seems fine for dealing with forcealign and reflink.
> 
> So what about forcealign and RT?
> 
> We want to support this config in future, but the current implementation
> will not support it.

What's the problem with supporting it right from the start? We
already support forcealign for RT, just it's a global config 
under the "big rt alloc" moniker rather than a per-inode flag.

Like all on-disk format change based features,
forcealign should add the EXPERIMENTAL flag to the filesystem for a
couple of releases after merge, so there will be plenty of time to
test both data and rt dev functionality before removing the
EXPERIMENTAL flag from it.

So why not just enable the per-inode flag with RT right from the
start given that this functionality is supposed to work and be
globally supported by the rtdev right now? It seems like a whole lot
less work to just enable it for RT now than it is to disable it...

> In this v2 series, I just disallow a mount for forcealign and RT, similar to
> reflink and RT together.
> 
> Furthermore, I am also saying here that still forcealign and RT bits set is
> a valid inode on-disk format and we just have to enforce a sb_rextsize to
> extsize relationship:
> 
> xfs_inode_validate_forcealign(
> 	struct xfs_mount	*mp,
> 	uint32_t		extsize,
> 	uint32_t		cowextsize,
> 	uint16_t		mode,
> 	uint16_t		flags,
> 	uint64_t		flags2)
> {
> 	bool			rt =  flags & XFS_DIFLAG_REALTIME;
> ...
> 
> 
> 	/* extsize must be a multiple of sb_rextsize for RT */
> 	if (rt && mp->m_sb.sb_rextsize && extsize % mp->m_sb.sb_rextsize)
> 		return __this_address;
> 
> 	return NULL;
> }

I suspect the logic needs tweaking, but why not just do this right
from the start?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
