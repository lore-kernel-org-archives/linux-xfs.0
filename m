Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14DE21E3C4
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029679; cv=none; b=QgwFg2sNU5xeOCLvVtHBubIowno3yOUmqZuQ4qpPSKkouXmmSDVlAxI+mB/On0yRfNFqmwQyOEeYD1P8R/LRe3ritI3GZUgTDAyT3cMHUNpfZ6x8VRkYSQ+dw2oRK7cR9oN9PUqAB3BnbzfVZY5Z1koF7iPp8ofWbxV+pT1UQds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029679; c=relaxed/simple;
	bh=/QkvVbMSdx7xzIvMs/w0our2sbah3SwimSIdTH/+GQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDva1fyWgJ20OmcWhNhyx4jKYcJXNNv+PRUoLUVPl5QKY2QPfoIA8eck8RwluXNCR1wtywJDE8yAKYJx8rXlPcLuNPmbw4uIRGoqq+bZHKpimFeDqdsrYRkAtDgKaEaeceeuIXPN1O7KF2B+tn4nQC+CLByTVR3HDRGKECLowyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WCl/FPCy; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WCl/FPCy"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cbcd71012so34076225ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 15:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729029677; x=1729634477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rh3BJ0bXUBMbK+4pBSJTp+cV+G1FHuqJqhtTlUnL/qE=;
        b=WCl/FPCy28suCKCoU3S7waS9ITRr2hT2AI3IsphpewQsZjENLtW9UqQKZCrvMNB/aC
         oZW9y0m6vU6hG8L42VAYSTtzd14fFhtMhtE7BiOgdcn9qhGvv/u9j6bztoVat1XjQDFC
         nSA2k4fThTUd+Uq7WWw+9n7FcvTYqhEQ9J5ZqikTmLhEFWXIwRe/Tz6e1LQMBpYdfveb
         /RgKFzJPOOXLacquzK5mNIJNVJZfIVkO8dEIBFPsv0VKM7Zfy/8h3LiK91ZvbCkMp4Te
         R0mCdg7FR57tqwsaD9X5rqZVYCI0egi1/pNBhEN1YtQQOY+v9uMXw4rc4aVYDjnXj9PQ
         PvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729029677; x=1729634477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rh3BJ0bXUBMbK+4pBSJTp+cV+G1FHuqJqhtTlUnL/qE=;
        b=oIrfBErcRXVU6YC3R/tLyyLXhsvSDG/U5qtlRbE0uhyffz+FjxXCYzSrGlIu93JvOj
         Wc3MrycNxWAx8R0AaT4nDS9kUrmzkYKLsH9GHJYd8eK1NYH+pqvB0HuG+LIxmb+tJlMC
         IpQkBLjd7xRERzN3PCKZcm8hKfefrKd33F0+YSzVLapnv3wzoIb4zWCG8uj9qyB8ADwE
         qEMKmTApzbBCSobur/s3gR8+uCGXmgGcOcgCWJh3b929oAajlUpbk5UCO8TnFTM95qlP
         A66ucCMuoig80C0dPCDgPRQDEme9hxUqpI2B7YyOIoGD+amBXir1KT752sb2yXuXKyVL
         WmXA==
X-Forwarded-Encrypted: i=1; AJvYcCXLsLlXXv9oaE6pRqLXRiz2F/OlYWDi8T6lOLm38jlEZUOnfE7YrIx2OdYFwehT2ADJ6QnRS89VZNY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd1diUULWD5HrDrVn4BaE2IaM2Y1ar+AJG1l4rkBV2FnmzxSCt
	o4Whq5EhGPJbzqKpzjYWNKIJCE1pE58+d7T6MV7NMALFV7PsH4csaOrCbz7Hb+lV6HR0eM96Hud
	M
X-Google-Smtp-Source: AGHT+IFL4/1RnuV/yF++KMKoAxY6T03Hc/ydvZ0UWhmxcAvUxAloSZFBJd8wzZqznWBy8XaoK1K2BA==
X-Received: by 2002:a17:902:d489:b0:20b:a25e:16c5 with SMTP id d9443c01a7336-20cbb2a0c4emr216153615ad.53.1729029677114;
        Tue, 15 Oct 2024 15:01:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1803661dsm16954975ad.133.2024.10.15.15.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 15:01:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0pbO-001JKa-10;
	Wed, 16 Oct 2024 09:01:14 +1100
Date: Wed, 16 Oct 2024 09:01:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <Zw7mKivaebxnZa7C@dread.disaster.area>
References: <20241011182407.GC21853@frogsfrogsfrogs>
 <Zw4xYRG5LOHuBn4H@dread.disaster.area>
 <20241015165921.GA21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015165921.GA21853@frogsfrogsfrogs>

On Tue, Oct 15, 2024 at 09:59:21AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 15, 2024 at 08:09:53PM +1100, Dave Chinner wrote:
> > On Fri, Oct 11, 2024 at 11:24:07AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Check this with every kernel and userspace build, so we can drop the
> > > nonsense in xfs/122.  Roughly drafted with:
> > > 
> > > sed -e 's/^offsetof/\tXFS_CHECK_OFFSET/g' \
> > > 	-e 's/^sizeof/\tXFS_CHECK_STRUCT_SIZE/g' \
> > > 	-e 's/ = \([0-9]*\)/,\t\t\t\1);/g' \
> > > 	-e 's/xfs_sb_t/struct xfs_dsb/g' \
> > > 	-e 's/),/,/g' \
> > > 	-e 's/xfs_\([a-z0-9_]*\)_t,/struct xfs_\1,/g' \
> > > 	< tests/xfs/122.out | sort
> > > 
> > > and then manual fixups.
> > 
> > [snip on disk structures]
> > 
> > I don't think we can type check all these ioctl structures,
> > especially the old ones.
> > 
> > i.e. The old ioctl structures are not padded to 64 bit boundaries,
> > nor are they constructed without internal padding holes, and this is
> > why compat ioctls exist. Hence any ioctl structure that has a compat
> > definition in xfs_ioctl32.h can't be size checked like this....
> > 
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
> > > +	XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
> > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
> > 
> > e.g. xfs_fsop_geom_v1 is 108 bytes on 32 bit systems, not 112:
> > 
> > struct compat_xfs_fsop_geom_v1 {
> >         __u32                      blocksize;            /*     0     4 */
> >         __u32                      rtextsize;            /*     4     4 */
> >         __u32                      agblocks;             /*     8     4 */
> >         __u32                      agcount;              /*    12     4 */
> >         __u32                      logblocks;            /*    16     4 */
> >         __u32                      sectsize;             /*    20     4 */
> >         __u32                      inodesize;            /*    24     4 */
> >         __u32                      imaxpct;              /*    28     4 */
> >         __u64                      datablocks;           /*    32     8 */
> >         __u64                      rtblocks;             /*    40     8 */
> >         __u64                      rtextents;            /*    48     8 */
> >         __u64                      logstart;             /*    56     8 */
> >         /* --- cacheline 1 boundary (64 bytes) --- */
> >         unsigned char              uuid[16];             /*    64    16 */
> >         __u32                      sunit;                /*    80     4 */
> >         __u32                      swidth;               /*    84     4 */
> >         __s32                      version;              /*    88     4 */
> >         __u32                      flags;                /*    92     4 */
> >         __u32                      logsectsize;          /*    96     4 */
> >         __u32                      rtsectsize;           /*   100     4 */
> >         __u32                      dirblocksize;         /*   104     4 */
> > 
> >         /* size: 108, cachelines: 2, members: 20 */
> >         /* last cacheline: 44 bytes */
> > } __attribute__((__packed__));
> > 
> > I'm not sure we need to size check these structures - if they change
> > size, the ioctl number will change and that means all the userspace
> > test code built against the system /usr/include/xfs/xfs_fs.h file
> > that exercises the ioctls will stop working, right? i.e. breakage
> > should be pretty obvious...
> 
> It should, though I worry about the case where we accidentally change
> the size on some weird architecture, some distro ships a new release
> with everything built against the broken headers, and only later does
> someone notice that their old program now starts failing.
> 
> I guess the question is, do we hardcode the known sizes here, e.g.
> 
> 	XFS_CHECK_IOCTL_SIZE(struct xfs_fsop_geom_v1, 108, 112);
> 
> wherein we'd assert that sizeof() == 108 || sizeof() == 112?

This feels kinda fragile. We want the compiler to do the validation
work for both the normal and compat ioctl structures. Just
specifying two sizes doesn't actually do that.

i.e. this really needs to check that the structure size is the same
on all 64 bit platforms, the compat structure is the same on -all-
platforms (32 and 64 bit), and that the the structure size is the
same as the compat structure size on all 32 bit platforms....

> Or not care if things happen to the ioctls?  Part of aim of this posting
> was to trick the build bots into revealing which architectures break on
> the compat ioctl stuff... ;)

If that's your goal, then this needs to be validating the compat
structures are the correct size, too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
