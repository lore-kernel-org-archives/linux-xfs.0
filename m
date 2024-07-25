Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50563AE
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 01:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721871766; cv=none; b=dz9kvkK9FJYVpF4SRTGm41fV0XBhxo0+b3o5pSqBzzt8hMlu0ErDDPFK470YLy0Cft5W6v4wZwVlUZqMVlRb1fjzdw5lZtt23xo6zQsJFTN7FQm4Nz+dEfdQ3YycYKKaZLPueWnnwYq0Y9xmYROw1VuQv0YN35EtCqIP8X4CIWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721871766; c=relaxed/simple;
	bh=/VPnrh+PKy+dUK8UKPozntAjybmgbj+ga/6vRUmIuPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1Lv/YU1mYCDWMIxc7TilkoNKSmSmCHXTV+dzLBslS5pg6v9skYUj9V3rPN/i+zSGOaxEhtjPeXB5yWmXsP7wgfSeBYZpi7Y/nIaygCr5NgL5werLGsRm5eLniXMdPH6Tgxe+eFKZ9dqETjWYE3Sa495H9KuarKwjL2jzi9qupw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0wisCA5w; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0wisCA5w"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d153fec2fso340240b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 18:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721871764; x=1722476564; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6YfVuPX2mFRiH/1DVbVZG8sQT3wA8dUonqj/CURwIs=;
        b=0wisCA5w+QdoM37/zrCGC/19es3dyf/NFwfEXLbyP6Q5b/AC2Sk017YOueNQU7LqHi
         cItiywJ2am92noJ543vZOYMrfgswTA1Cf7xSOzYGV9nwhZP1zLzVMV9bmzS68qPa9al5
         4L9KFrG09W5FoceBaNSBL0M4MB+XUIr21fhH4MfQSc2wLWLgKsMhri2Y25zHBt4ioNEx
         YkeN8UuO5CF7fCuVqcYjU2kmy9bvXS5MqeIJwO7TtHLlQ/Njj2AOapmKL2tD62KB4PrV
         qaNcyB8eXJFKK9lEURWRXdBQnMXNQ0JWKCLfAddK3joduI5am5hGZ2IFKUhgomEtwy/q
         NXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721871764; x=1722476564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6YfVuPX2mFRiH/1DVbVZG8sQT3wA8dUonqj/CURwIs=;
        b=ltnn2OkQnOG+fkC4C2cXwRWimoJvBET38aXsNHg+cZGDWKcze1PppFqo0GXt1djgsz
         kiwiqeK3ms7s3jR6KsBIo9pEf1oS/mbBJQnKybJE8gGnOzaUY0rRgfuI4pM4O3RJV5CL
         IVBT7XLRkuPn/k13oPVfUd3ugi+aL8dtjdcNMlD31weDXmMF9zeGNDcLTULOSuMaUBye
         cuVZ+8OuFolu3HCtteCq6RJ/SYTIAWWLM78JuY9i+N0GM9hACB7LNj4pp78GTN2A19dK
         T26PM8cFLYJQcXGNRK0j9mEgIYoXhqvpQ28q44AAZXNpMYNF8vGQUd4qNzykmVUdw+NY
         SL8A==
X-Forwarded-Encrypted: i=1; AJvYcCXZu+n0nSKWTk4oAL7MRXZjXGxXTsMKM8W7iM3qnlraGoCrguo/rfoD15SMVuSlOJpFwshBiVusX+xMSSW6v94Jw5tGxtnb3/NQ
X-Gm-Message-State: AOJu0YxHjngWdtv6MPIkt21GFxZ3Q7Ztc0LkbMrv9blxJCM9M9kIZGS+
	OYR6p0jeCMLvLE26HO5U6T2X7ycpQ4SX4Q7Zs2vXFxXVKDkZHrMQXm2a5qIp5dQ=
X-Google-Smtp-Source: AGHT+IG/15FcHufsA3ss2b+NN1SQT4CTZIW6I4jqqEAOOtRv24q6LgnnVxMsbBCevGgoIAz/F0/mMw==
X-Received: by 2002:a05:6a20:9183:b0:1c0:f5c1:8083 with SMTP id adf61e73a8af0-1c47b3f7735mr472090637.41.1721871764215;
        Wed, 24 Jul 2024 18:42:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb65158bfsm2397983a91.0.2024.07.24.18.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 18:42:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sWnVB-00AJog-2B;
	Thu, 25 Jul 2024 11:42:41 +1000
Date: Thu, 25 Jul 2024 11:42:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <ZqGtkbc+QpE5YyyR@dread.disaster.area>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <345207bd-343a-417c-80b9-71e3c8d4ff28@sandeen.net>
 <20240724221233.GB612460@frogsfrogsfrogs>
 <5ccb5a51-75c0-41eb-92ff-a2ce5674ac0f@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ccb5a51-75c0-41eb-92ff-a2ce5674ac0f@sandeen.net>

On Wed, Jul 24, 2024 at 05:38:46PM -0500, Eric Sandeen wrote:
> On 7/24/24 5:12 PM, Darrick J. Wong wrote:
> > On Wed, Jul 24, 2024 at 05:06:58PM -0500, Eric Sandeen wrote:
> >> On 7/21/24 6:01 PM, Dave Chinner wrote:
> >>> +The solution should already be obvious: we can exploit the sparseness of FSBNO
> >>> +addressing to allow AGs to grow to 1TB (maximum size) simply by configuring
> >>> +sb_agblklog appropriately at mkfs.xfs time. Hence if we have 16MB AGs (minimum
> >>> +size) and sb_agblklog = 30 (1TB max AG size), we can expand the AG size up
> >>> +to their maximum size before we start appending new AGs.
> >>
> >> there's a check in xfs_validate_sb_common() that tests whether sg_agblklog is
> >> really the next power of two from sb_agblklog:
> >>
> >> sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1
> >>
> >> so I think the proposed idea would require a feature flag, right?
> >>
> >> That might make it a little trickier as a drop-in replacement for cloud
> >> providers because these new expandable filesystem images would only work on
> >> kernels that understand the (trivial) new feature, unless I'm missing
> >> something.

Yes, I think that's the case.

I don't see this as a showstopper - golden images that VMs get
cloned from tend to be specific to the distro release they contain,
so as long as both the orchestration nodes and the distro kernel
within the image support the feature bit it will just work, yes?

This essentially makes it an image build time decision to support
the expand feature.  i.e. if the fs in the image has the feature bit
set, deployment can use expand, otherwise skip it and go straight to
grow.

> > agblklog and agblocks would both be set correctly if you did mkfs.xfs -d
> > agsize=1T on a small image; afaict it's only mkfs that cares that
> > dblocks >= agblocks.

I don't think we can change sb_agblocks like this 

Fundamentally, sb_agblocks is the physical length of AGs, not the
theoretical maximum size. Setting it to the maximum possible size
fails in all sorts of ways for multiple AG filesystems
(__xfs_ag_block_count() is the simplest example to point out), and
even on single AG filesystems it will be problematic.

sb->sb_agblklog is not a physical size - it is decoupled from the
physical size of the AG so it can be used to calculate the address
space locations of inodes and FSBNOs. Hence we can change
sb_agblklog without changing sb_agblocks and other physical lengths
because it doesn't change anything to do with the physical layout of
the filesystem.

> Yes, in a single AG image like you've suggested.

I'm not so sure about that.

We're not so lucky with code that validate against the AG header
lengths or just use sb_agblocks blindly.

e.g. for single AG fs's to work, they need to use
__xfs_ag_block_count() everywhere to get the size of the AG and have
it return sb_dblocks instead.  We have code that assumes that
sb_agblocks is the highest AGBNO possible in an AG and doesn't take
into account that the size of the runt AG (e.g.
xfs_alloc_ag_max_usable() is one of these).

I've always understood there to be an implicit requirement for
sb_agblocks and agf->agf_length/agi->agi_length to be the same and
define the actual maximum valid block number in the AG.

I don't think we can change that, and I don't think we should try to
change this even for single AG filesystems. We don't even support
single AG filesystems. And I don't think we should try to change
such a fundamental physical layout definition for what would be a
filesystem format that only physically exists temporarily in a cloud
deployment context.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
