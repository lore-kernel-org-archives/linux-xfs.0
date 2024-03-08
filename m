Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2CC3205
	for <linux-xfs@vger.kernel.org>; Fri,  8 Mar 2024 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709858838; cv=none; b=atEFRVAla9uNpZnQKPxVOEc3368t0t48WrNq1PDa54qv3qe/0+tpzszC+FeLuqy4yMaLy5RPmb7NmWIcGkUzret+PlrcNUN+pMp13HGMhPuv4gIcxhp6DbnLepE8eyrhWzAz2eNmolmExRLDHha/G/ygvJH57sJIF1iXnrcJuJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709858838; c=relaxed/simple;
	bh=NSfbEyik0E5fV9rKhv893xwhpcqfZnnnUpXzKbYMjLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZxvURXpi1tcc+vrho2MZabbL70SCzv0ek+KRSBH5Awsv8e7dc9V+b6kLzzqvL/dT3MjYWQCMNMz+o436x7GuD4ybcW5Oa/bvrqjPokN7/MNWKWr1q8Ch6cGOlPnwNriY8GcnbK87i5RM/TS+JAhu5SmVzaupOg/kQm81QNfaNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Vy6frY7N; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Vy6frY7N"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e64997a934so1261995b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Mar 2024 16:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709858836; x=1710463636; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aQ8GaPjt10k/rPvDTvZ+A248eFhAO1GEQb2ZATjjPu0=;
        b=Vy6frY7Nq/YpTyPpSS2hTNxpfCTnV/GRh3PQGKAgEXksSpgBp5aLYAY6FYzOBfE2P0
         C3qsQNTFj2HeMESxDtBeASGKU6X/BmW9NsH9BZEsfFqKLguyzZjiEyGSxBWQ4fdyxQds
         QyMDMH2Owd0z76Ep+wLQjZACnrelRfD1yfpV+CgXQmnJED56n+4YLyeEgcF1PsO/0uqc
         aXxvagWqu4W8OESMmeN12pqt7djIeVutSK6W1/3y+ptJ0dRrrN2R+cpN7bAYVWUE16ga
         SloicOCYJE7i67JxVolSeYPI1e+ZTiaUp7z8iqZoxg/l1BimnNXUXtcGlQppCWUzu8re
         o8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709858836; x=1710463636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQ8GaPjt10k/rPvDTvZ+A248eFhAO1GEQb2ZATjjPu0=;
        b=SVK/wJjZ6boc0WEst/Kn4qZsN3KzxGRJV4VO5o/nWBJ0eNQG68O4Pa7P+g/ClR8Kkx
         9Hmha6z2yZ9jmnfnupBjaFdBP8oOgz5a+tZstFAnDW//IG929HTAZUTWJsskgxQmlO1g
         z+PA7K0jOrXmmGFqFwRP0Upzgb5R0xPcq9J1a5Gn6b6wFQXBK3AsJDhcxmMpgplGLH4r
         my8krUZICMHXBXxKneiSNAp4GMkImeLq0DpSYjzSxE+BVbpkKrjDkJeDDoxbhnBV5Twa
         6dOIhNTphkeMX8i5YZo9RoFUPZqVCLbPBEB7Ip1eBrkd+CBSBwFWS1dQUUimqzWH1SzK
         G/aQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0NKaq9TJZk+t3Ek+4xIAx0V3E9GbWINuD9ITAXXCr91K1+q3NATw8DvdtAP6Az/5WMi1/2Fmu1ozA3eBXX3MbGZPH/Qk88n6P
X-Gm-Message-State: AOJu0YwTEltBgqlGpU2+2/ItkNFMUWO7F3+LGaGIdFQdAdG/msoFPKZL
	4mAEF9U7lZBGFqrGN1wPDOMMNYckUMUk8NxjY8cSCEue8pfOFmLHmvlUGrwu5XQ=
X-Google-Smtp-Source: AGHT+IFI6Q1sg1JNFnkP+MCq/MXc4ZsKz3moY3iMDmrYoQRU/jsVzrvfmYJYkWl+ScEYaNlfBMU4AQ==
X-Received: by 2002:a05:6a20:7fa9:b0:1a1:501e:814c with SMTP id d41-20020a056a207fa900b001a1501e814cmr10746429pzj.29.1709858836483;
        Thu, 07 Mar 2024 16:47:16 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902e9cc00b001db9fa23407sm15251920plk.195.2024.03.07.16.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 16:47:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1riOOG-00GUAB-2v;
	Fri, 08 Mar 2024 11:47:12 +1100
Date: Fri, 8 Mar 2024 11:47:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 10/24] iomap: integrate fs-verity verification into
 iomap's read path
Message-ID: <ZepgEGngCly8oqnM@dread.disaster.area>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-12-aalbersh@redhat.com>
 <20240304233927.GC17145@sol.localdomain>
 <ZepP3iAmvQhbbA2t@dread.disaster.area>
 <20240307234522.GJ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307234522.GJ1927156@frogsfrogsfrogs>

On Thu, Mar 07, 2024 at 03:45:22PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 08, 2024 at 10:38:06AM +1100, Dave Chinner wrote:
> > On Mon, Mar 04, 2024 at 03:39:27PM -0800, Eric Biggers wrote:
> > > On Mon, Mar 04, 2024 at 08:10:33PM +0100, Andrey Albershteyn wrote:
> > > > +#ifdef CONFIG_FS_VERITY
> > > > +struct iomap_fsverity_bio {
> > > > +	struct work_struct	work;
> > > > +	struct bio		bio;
> > > > +};
> > > 
> > > Maybe leave a comment above that mentions that bio must be the last field.
> > > 
> > > > @@ -471,6 +529,7 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
> > > >   * iomap_readahead - Attempt to read pages from a file.
> > > >   * @rac: Describes the pages to be read.
> > > >   * @ops: The operations vector for the filesystem.
> > > > + * @wq: Workqueue for post-I/O processing (only need for fsverity)
> > > 
> > > This should not be here.
> > > 
> > > > +#define IOMAP_POOL_SIZE		(4 * (PAGE_SIZE / SECTOR_SIZE))
> > > > +
> > > >  static int __init iomap_init(void)
> > > >  {
> > > > -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> > > > -			   offsetof(struct iomap_ioend, io_inline_bio),
> > > > -			   BIOSET_NEED_BVECS);
> > > > +	int error;
> > > > +
> > > > +	error = bioset_init(&iomap_ioend_bioset, IOMAP_POOL_SIZE,
> > > > +			    offsetof(struct iomap_ioend, io_inline_bio),
> > > > +			    BIOSET_NEED_BVECS);
> > > > +#ifdef CONFIG_FS_VERITY
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	error = bioset_init(&iomap_fsverity_bioset, IOMAP_POOL_SIZE,
> > > > +			    offsetof(struct iomap_fsverity_bio, bio),
> > > > +			    BIOSET_NEED_BVECS);
> > > > +	if (error)
> > > > +		bioset_exit(&iomap_ioend_bioset);
> > > > +#endif
> > > > +	return error;
> > > >  }
> > > >  fs_initcall(iomap_init);
> > > 
> > > This makes all kernels with CONFIG_FS_VERITY enabled start preallocating memory
> > > for these bios, regardless of whether they end up being used or not.  When
> > > PAGE_SIZE==4096 it comes out to about 134 KiB of memory total (32 bios at just
> > > over 4 KiB per bio, most of which is used for the BIO_MAX_VECS bvecs), and it
> > > scales up with PAGE_SIZE such that with PAGE_SIZE==65536 it's about 2144 KiB.
> > 
> > Honestly: I don't think we care about this.
> > 
> > Indeed, if a system is configured with iomap and does not use XFS,
> > GFS2 or zonefs, it's not going to be using the iomap_ioend_bioset at
> > all, either. So by you definition that's just wasted memory, too, on
> > systems that don't use any of these three filesystems. But we
> > aren't going to make that one conditional, because the complexity
> > and overhead of checks that never trigger after the first IO doesn't
> > actually provide any return for the cost of ongoing maintenance.
> 
> I've occasionally wondered if I shouldn't try harder to make iomap a
> module so that nobody pays the cost of having it until they load an fs
> driver that uses it.

Not sure it is worth that effort. e.g. the block device code is
already using iomap (when bufferheads are turned off) so the future
reality is going to be that iomap will always be required when
CONFIG_BLOCK=y.

> > > How about allocating the pool when it's known it's actually going to be used,
> > > similar to what fs/crypto/ does for fscrypt_bounce_page_pool?  For example,
> > > there could be a flag in struct fsverity_operations that says whether filesystem
> > > wants the iomap fsverity bioset, and when fs/verity/ sets up the fsverity_info
> > > for any file for the first time since boot, it could call into fs/iomap/ to
> > > initialize the iomap fsverity bioset if needed.
> > > 
> > > BTW, errors from builtin initcalls such as iomap_init() get ignored.  So the
> > > error handling logic above does not really work as may have been intended.
> > 
> > That's not an iomap problem - lots of fs_initcall() functions return
> > errors because they failed things like memory allocation. If this is
> > actually problem, then fix the core init infrastructure to handle
> > errors properly, eh?
> 
> Soooo ... the kernel crashes if iomap cannot allocate its bioset?
>
> I guess that's handling it, FSVO handle. :P

Yup, the kernel will crash if any fs_initcall() fails to allocate
the memory it needs and that subsystem is then used. So the
workaround for that is that a bunch of these initcalls simply use
panic() calls for error handling. :(

> (Is that why I can't boot with mem=60M anymore?)

Something else is probably panic()ing on ENOMEM... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
