Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF81B946
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 01:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712109567; cv=none; b=cNIg2/S/WrGOO0jwF9sH+86mkj3d1hqMRqmBAZHDZAFHgrddkLjhTPnhQSwz4mPHzsobhDgnBTXar2svqDqHYhlLO+R/Cy6Te1n/+H9mC6jI5eKCXTG8x4qQYF+VOW8QvziUFLHbGaygOjeqwIqgZxzaMHS2Ct7++dbpvaouyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712109567; c=relaxed/simple;
	bh=QIwoSNVbGhF4tVY6dhV0Hdf7RkIWChRHPzMOnXsGvyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBKmZUSu0SpHwhDrhB4ukdnjnQgWsjNfQALaTFJb6/NvJL/q7eKywhqQzxi7EgbDvEM4H0hjLtwrWfGyN3vFMH14NLDYFrW9N/65185Bg1qU53U3t1mGfk5792kM0H8VFRySWoI2jfJnLWaQnGu+4S3Bov/bYdXmbbbZ6dB8udY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rpjs7nyy; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rpjs7nyy"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6eaf1a3e917so3086260b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 18:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712109565; x=1712714365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NYvnBCprFZzYoPCfFCY9FHGMDGDnnbenpZrTFCrtHqg=;
        b=rpjs7nyyzAAMQeWPg+BIk9yk5PJuPWeYYoY1Uos8w6nfhEGE90DxqhXsnYPcYqQLAV
         gdQCZEqdmgwAbNyXNuxgdGHH2a4dbaecGQ4U/7NvzWBYZ2c2WWDy898PvSMbtGRyJSPd
         Hq9OJFC7q/D3Awx4AMUmOOliQhqfJoIJpe0+MsLSinlM4amxTcqFoEU69Zu3osUCeEnl
         jkgyOcQza2pOuweaWEG9Cog2XBsoZXAKonzdHZklaIIWJaeTI+IqBhI0xX2r1cxe/w4w
         sFJiIgmf4rRMGxGtKVikl1VCAQJl/lQZPo6++42llug2bvHBDX50r4OnkqGNyNtmQtFo
         rzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712109565; x=1712714365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYvnBCprFZzYoPCfFCY9FHGMDGDnnbenpZrTFCrtHqg=;
        b=l09KEcfLgl5aq9xkL9maH0ToMCrqmpUhkjsSeytWZM1+7gQYG0H0HJCNDoE0L9I3RU
         shu7o0AiN5j2caAUzhju47hMsqS28rkhBxrWNsYM/D5DZY5jqAMapFrjqkGMYDLBjDW1
         Gqi3F0RS62CNS9Tw3QVKTpUezFpV7VLkJJ4iGZB6f9jnSEd6MUO6WCm38YG+kbH415Kw
         INtczKVfPmL4XIlStsycSnEVpwtnaMEZp5M+3PSQSp3vnBBRlCvB4hGP95ZxNn8wPokj
         JwO8JajnxtnQt2RqmxZP0W7rABVNUEYLnkccIxS5PNK9CEpA4IzW1v8VJTC0Tesmw7V0
         ZXBg==
X-Forwarded-Encrypted: i=1; AJvYcCWU+TyZp05ASzO7nquoOubI3PX4CHg5R96CUZ8HJJjjZMiyM1pnxoGYm7+VNXw+hwFcLI46FL2CNyJxeGMSYNTb3+nlMzae8Ee1
X-Gm-Message-State: AOJu0YwsnZrVI/N73w5DweZyFgD18oeEnZ5Bx1i0eBUuNPh2kogbyiUM
	DjglLS/2DlvuYSlYsVPFW6qvaEkXhe/Cvg3yvADW2aKpayrAU/ezUBRBG3uHk+I=
X-Google-Smtp-Source: AGHT+IH7IcdRuRfN1eedYkwr5P3Wm/AdI3Un/KrVubjcpsHE0mA4uhQCOt/SLnjlUQhlQrSkkwksHg==
X-Received: by 2002:a05:6a20:8f27:b0:1a3:30a8:2ad6 with SMTP id b39-20020a056a208f2700b001a330a82ad6mr12794751pzk.10.1712109565140;
        Tue, 02 Apr 2024 18:59:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902d2ce00b001e0942da6c7sm11830061plc.284.2024.04.02.18.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 18:59:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrpuM-0020Ui-0p;
	Wed, 03 Apr 2024 12:59:22 +1100
Date: Wed, 3 Apr 2024 12:59:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Colin Walters <walters@verbum.org>, Eric Biggers <ebiggers@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	fsverity@lists.linux.dev, Alexander Larsson <alexl@redhat.com>
Subject: Re: [PATCH 28/29] xfs: allow verity files to be opened even if the
 fsverity metadata is damaged
Message-ID: <Zgy3+ljJME0pky3d@dread.disaster.area>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175869022.1988170.16501260874882118498.stgit@frogsfrogsfrogs>
 <2afcf2b2-992d-4678-bf68-d70dce0a2289@app.fastmail.com>
 <20240402225216.GW6414@frogsfrogsfrogs>
 <992e84c7-66f5-42d2-a042-9a850891b705@app.fastmail.com>
 <20240403013903.GG6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403013903.GG6390@frogsfrogsfrogs>

On Tue, Apr 02, 2024 at 06:39:03PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 02, 2024 at 08:10:15PM -0400, Colin Walters wrote:
> > >> I hesitate to say it but maybe there should be some ioctl for online
> > >> repair use cases only, or perhaps a new O_NOVERITY special flag to
> > >> openat2()?
> > >
> > > "openat2 but without meddling from the VFS"?  Tempting... ;)
> > 
> > Or really any lower level even filesystem-specific API for the online
> > fsck case.  Adding a blanket new special case for all CAP_SYS_ADMIN
> > processes covers a lot of things that don't need that.
> 
> I suppose there could be an O_NOVALIDATION to turn off data checksum
> validation on btrfs/bcachefs too.  But then you'd want to careful
> controls on who gets to use it.  Maybe not liblzma_la-crc64-fast.o.

Just use XFS_IOC_OPEN_BY_HANDLE same as xfs_fsr and xfsdump do. The
handle can be build in userspace from the inode bulkstat
information, and for typical inode contents verification purposes we
don't actually need path-based open access to the inodes. That would
then mean we can simple add our own open flag to return a fd that
can do data operations that short-circuit verification...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
