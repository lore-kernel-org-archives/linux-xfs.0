Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA56123CB
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721868116; cv=none; b=Cp/SZZdmEz+fQryvPwGEJ2epcAt2ZKOfzHoJR8WbH4w0MDOrBZIYrSCo+rI/r6jvFju11dMR1kZf3IfgrBHx7C9JdkDinHp/Z9dr3xww0eyFwDF1jnYPf6aKNQTyVE6BT50fRvfml4/lcvWem/E+R2HsZ7lRyMVa6gxTm97qoCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721868116; c=relaxed/simple;
	bh=l/MLz4UmM8iWFDSolJlEYEL8sYsw1/9b1R7ASYTacz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1I9K2KwnHSL3GZ4cKOdrlthuYp2bi/CskgaS2gCZ2NFf/36IC6jOWQxk5ik3Q07H1Ar+FEWkJfdldVTSPo4uMnIue+TZh3TuGeIQQGwRpzv6BdCz2JOHL0hgfw2Zkjy1drWVJAhsBKNBN1Eqbh2UDlaM/Ga7LBihvN+Uvhtk6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YO6H1YQD; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YO6H1YQD"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d24d0a8d4so293441b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 17:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721868114; x=1722472914; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxWq0hghtPcaizmy1WhfhpmcuaEESQMHCgoqEJcK1A0=;
        b=YO6H1YQDyi1LOiW68hSxQTkTZDgrtzekieIWv35XQAt5F6LECXuRoyCgyKlZl2b4Qu
         gJ6MPNKLVfGGmGDVmHln/vehRdXMBt+tKS+qDX8aaGgcZuTF3aTFtz/N2UDqNSm2FaBN
         h7BUivFebc4j/YyIMErpSZhvlch+m5B9eCg1pQdYxevOxq25CM2LI3aZN1RfDT17XQKV
         aF28nazYWurp+VnbWQbC1d0JTfTKWYh/j9y57VOT46vh2LZymKys7N5WRDG5KrP+AjTw
         LI+kkDHaH47AyApmPcJ786RVSo34QHcC3fE9C+Kq0DwblL2z028/XaeBa4f0Mj2KjdoS
         X8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721868114; x=1722472914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxWq0hghtPcaizmy1WhfhpmcuaEESQMHCgoqEJcK1A0=;
        b=lGjk7mOarRuoe6ofzvoxCHE25ss+Usa2Fq1r5v0KmH+0/UbRAl08kXQ9ll5iBeq9vX
         LjTBPTmnv2tk7b6HpZsBQw6WWkSNNWyAPUjNCH/8pJgd3G0oa3/6wWgfpGkbfx2niFUk
         hVlqL7VINTJix7E8/usxaWDJ8pyv0AeLtvh/THuYaz7brrph6HZOyLzRNPKSEsekqVXP
         4/WL3j9U3yMA5LkQ5XQ1ra0capYFISvqWms3JcmHotaNxY6frYkQQpc71pKguN3HojYr
         2cZ0GYWcZ7RA6vC8r+Ldg6CZnDmt+/5KqzJmyx05KBY/TBb2L3N/Xo3DOjy4SDw00wjC
         0IGg==
X-Gm-Message-State: AOJu0Yx5HzZZ7rZtJnfuSoRF5BuPI9zCsPfoblKZ2yVS41MLcWNdxHFU
	32L8uM2Gp9IT3wuC6nwKDnRZsGhqSl9wsqS0MHfHnsWVC0qQoeCU2dBU39j3jZQyHGyoJFI9joJ
	e
X-Google-Smtp-Source: AGHT+IFTZDGfpnILL8p+4VfRxxXzd9h/aEX81sFIC+sTm+Gj/wt3HEg7GlbqhwdPe5LHLx8Yj7VcAw==
X-Received: by 2002:a05:6a21:2d08:b0:1c2:96f1:a2ce with SMTP id adf61e73a8af0-1c47b1b56f0mr279534637.3.1721868113775;
        Wed, 24 Jul 2024 17:41:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7f85868sm1796445ad.238.2024.07.24.17.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 17:41:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWmYI-00AGl8-1W;
	Thu, 25 Jul 2024 10:41:50 +1000
Date: Thu, 25 Jul 2024 10:41:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZqGfTvAEzFbfe+Wa@dread.disaster.area>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724210833.GZ612460@frogsfrogsfrogs>

On Wed, Jul 24, 2024 at 02:08:33PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 24, 2024 at 10:46:15AM +1000, Dave Chinner wrote:
> > On Tue, Jul 23, 2024 at 04:58:01PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 22, 2024 at 09:01:00AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > xfs-expand is an attempt to address the container/vm orchestration
> > > > image issue where really small XFS filesystems are grown to massive
> > > > sizes via xfs_growfs and end up with really insane, suboptimal
> > > > geometries.
....
> > > > +Moving the data within an AG could be optimised to be space usage aware, similar
> > > > +to what xfs_copy does to build sparse filesystem images. However, the space
> > > > +optimised filesystem images aren't going to have a lot of free space in them,
> > > > +and what there is may be quite fragmented. Hence doing free space aware copying
> > > > +of relatively full small AGs may be IOPS intensive. Given we are talking about
> > > > +AGs in the typical size range from 64-512MB, doing a sequential copy of the
> > > > +entire AG isn't going to take very long on any storage. If we have to do several
> > > > +hundred seeks in that range to skip free space, then copying the free space will
> > > > +cost less than the seeks and the partial RAID stripe writes that small IOs will
> > > > +cause.
> > > > +
> > > > +Hence the simplest, sequentially optimised data moving algorithm will be:
> > > > +
> > > > +.. code-block:: c
> > > > +
> > > > +	for (agno = sb_agcount - 1; agno > 0; agno--) {
> > > > +		src = agno * sb_agblocks;
> > > > +		dst = agno * new_agblocks;
> > > > +		copy_file_range(src, dst, sb_agblocks);
> > > > +	}
> > > > +
> > > > +This also leads to optimisation via server side or block device copy offload
> > > > +infrastructure. Instead of streaming the data through kernel buffers, the copy
> > > > +is handed to the server/hardware to moves the data internally as quickly as
> > > > +possible.
> > > > +
> > > > +For filesystem images held in files and, potentially, on sparse storage devices
> > > > +like dm-thinp, we don't even need to copy the data.  We can simply insert holes
> > > > +into the underlying mapping at the appropriate place.  For filesystem images,
> > > > +this is:
> > > > +
> > > > +.. code-block:: c
> > > > +
> > > > +	len = new_agblocks - sb_agblocks;
> > > > +	for (agno = 1; agno < sb_agcount; agno++) {
> > > > +		src = agno * sb_agblocks;
> > > > +		fallocate(FALLOC_FL_INSERT_RANGE, src, len)
> > > > +	}
> > > > +
> > > > +Then the filesystem image can be copied to the destination block device in an
> > > > +efficient manner (i.e. skipping holes in the image file).
> > > 
> > > Does dm-thinp support insert range?
> > 
> > No - that would be a future enhancement. I mention it simly because
> > these are things we would really want sparse block devices to
> > support natively.
> 
> <nod> Should the next revision should cc -fsdevel and -block, then?

No. This is purely an XFS feature at this point. If future needs
change and we require work outside of XFS to be done, then it can be
taken up with external teams to design and implement the optional
acceleration functions that we desire.

> > > In the worst case (copy_file_range,
> > > block device doesn't support xcopy) this results in a pagecache copy of
> > > nearly all of the filesystem, doesn't it?
> > 
> > Yes, it would.
> 
> Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> we allowed people to create single-AG filesystems with large(ish)
> sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> size and copy your 2GB of data into the filesystem.  At deploy time,
> growfs will expand AG 0 to 100G and add new AGs after that, same as it
> does now.

We can already do this with existing tools.

All it requires is using xfs_db to rewrite the sb/ag geometry and
adding new freespace records. Now you have a 100GB AG instead of 2GB
and you can mount it and run growfs to add all the extra AGs you
need.

Maybe it wasn't obvious from my descriptions of the sparse address
space diagrams, but single AG filesystems have no restrictions of AG
size growth because there are no high bits set in any of the sparse
64 bit address spaces (i.e. fsbno or inode numbers). Hence we can
expand the AG size without worrying about overwriting the address
space used by higher AGs.

IOWs, the need for reserving sparse address space bits just doesn't
exist for single AG filesystems.  The point of this proposal is to
document a generic algorithm that avoids the problem of the higher
AG address space limiting how large lower AGs can be made. That's
the problem that prevents substantial resizing of AGs, and that's
what this design document addresses.

> > > Also, perhaps xfs_expand is a good opportunity to stamp a new uuid into
> > > the superblock and set the metauuid bit?
> > 
> > Isn't provisioning software is generally already doing this via
> > xfs_admin? We don't do this with growfs, and I'd prefer not to
> > overload an expansion tool with random other administrative
> > functions that only some use cases/environments might need. 
> 
> Yeah, though it'd be awfully convenient to do it while we've already got
> the filesystem "mounted" in one userspace program.

"it'd be awfully convenient" isn't a technical argument. It's an
entirely subjective observation and assumes an awful lot about the
implementation design that hasn't been started yet.

Indeed, from an implementation perspective I'm considering that
xfs_expand might even implemented as a simple shell script that
wraps xfs_db and xfs_io. I strongly suspect that we don't need to
write any custom C code for it at all. It's really that simple.

Hence talking about anything to do with optimising the whole expand
process to take on other administration tasks before we've even
started on a detailed implementation design is highly premature.  I
want to make sure the high level design and algorithms are
sufficient for all the use cases people can come up with, not define
exactly how we are going to implement the functionality.

> > > > +Limitations
> > > > +===========
> > > > +
> > > > +This document describes an offline mechanism for expanding the filesystem
> > > > +geometery. It doesn't add new AGs, just expands they existing AGs. If the
> > > > +filesystem needs to be made larger than maximally sized AGs can address, then
> > > > +a subsequent online xfs_growfs operation is still required.
> > > > +
> > > > +For container/vm orchestration software, this isn't a huge issue as they
> > > > +generally grow the image from within the initramfs context on first boot. That
> > > > +is currently a "mount; xfs_growfs" operation pair; adding expansion to this
> > > > +would simply require adding expansion before the mount. i.e. first boot becomes
> > > > +a "xfs_expand; mount; xfs_growfs" operation. Depending on the eventual size of
> > > > +the target filesystem, the xfs-growfs operation may be a no-op.
> > > 
> > > I don't know about your cloud, but ours seems to optimize vm deploy
> > > times very heavily.  Right now their firstboot payload calls xfs_admin
> > > to change the fs uuid, mounts the fs, and then growfs's it into the
> > > container.
> > > 
> > > Adding another pre-mount firstboot program (and one that potentially
> > > might do a lot of IO) isn't going to be popular with them.
> > 
> > There's nothing that requires xfs_expand to be done at first boot.
> > First boot is just part of the deployment scripts and it may make
> > sense to do the expansion as early as possible in the deployment
> > process.
> 
> Yeah, but how often do you need to do a 10000x expansion on anything
> other than a freshly cloned image?  Is that common in your cloudworld?
> OCI usage patterns seem to be exploding the image on firstboot and
> incremental growfs after that.

I've seen it happen many times outside of container/VMs - this was a
even a significant problem 20+ years ago when AGs were limited to
4GB. That specific historic case was fixed by moving to 1TB max AG
size, but there was no way to convert an existing filesystem. This
is the "cloud case" in a nutshell, so it's clearly not a new
problem.

Even ignoring the historic situation, we still see people have these
problems with growing filesystems. It's especially prevalent with
demand driven thin provisioned storage. Project starts small with
only the space they need (e.g. for initial documentation), then as
it ramps up and starts to generate TBs of data, the storage gets
expanded from it's initial "few GBs" size. Same problem, different
environment.

> I think the difference between you and I here is that I see this
> xfs_expand proposal as entirely a firstboot assistance program, whereas
> you're looking at this more as a general operation that can happen at
> any time.

Yes. As I've done for the past 15+ years, I'm thinking about the
best solution for the wider XFS and storage community first and
commercial imperatives second. I've seen people use XFS features and
storage APIs for things I've never considered when designing them.
I'm constantly surprised by how people use the functionality we
provide in innovative, unexpected ways because they are generic
enough to provide building blocks that people can use to implement
new ideas.

Filesystem expansion is, IMO, one of those "generically useful"
tools and algorithms.

Perhaps it's not an obvious jump, but I'm also thinking about how we
might be able to do the opposite of AG expansion to shrink the
filesystem online. Not sure it is possible yet, but having the
ability to dynamically resize AGs opens up many new possibilities.
That's way outside the scope of this discussion, but I mention it
simply to point out that the core of this generic expansion idea -
decoupling the AG physical size from the internal sparse 64 bit
addressing layout - has many potential future uses...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
