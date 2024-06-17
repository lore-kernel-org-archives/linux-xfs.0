Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9534288BD
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718668487; cv=none; b=h2ByrdgAoo60mP2p6am5sXzl7JHw8BHH5ENk+n7X9Ix8D/hjQ4EgjE1hRy5PULHDYjQ1bGeqVz9Ht/gu+1ingYWcRmG4N5WvleWFqBakaRJMUYJXw1D4hUa8Rx0LxVXBgtvcYZUIjvjcnliypuZ+EazQI/McK/t9MJLAN1PycOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718668487; c=relaxed/simple;
	bh=iretq1DlZekDvuoyVZO98rxEMQeJMnjYtrzh9wbiak0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q20LMZ3NSfdSJTb1nLgRKiJGgmUf7jnLgKJN/bVs2R97ibU4sbhjtLsSD7eVjm3laDYFDjtz9By6z9gpDY5zyWR1jTy1vFOGG3gxY+BU4AcIADkjoLH3Qwcyd7M3s96EXd6suxqtsZrmu7swutfQj/vthB/KImfsfqP+Hn13PKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pkbmxDwe; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pkbmxDwe"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3748ebe7e53so22226195ab.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 16:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718668485; x=1719273285; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Hn7Uw1Pm65VhzySE2qfIsVBg9n7H6rZMeI5/fbUyBk=;
        b=pkbmxDwe6bvXWlXtvLmXd8CtsXWmJGp8C7RdmdSjy1vIqlNW7daq/5K1s8x1IENcGM
         uqCMjKrq/EEk8U32vAi9ltpLr68VF6NxyyRTLwVN+PDTJefr0r221B1MSD6BzXHKfD2t
         85SCY67r8og1kTq344dfuTexGZuih9FLnH+EA9BcyeLuSryYcJLnuouUFCZg7aqDZitu
         Y5HuEz731PIJqrixdU157hdNCDpQs25lx+Ep8AsxVqwOk5MqHr9S86vK7aNJbgxAmo7l
         N1W/FnoQqRv2iJJUFr5DXgSBLSeRIxEpbsd3cxJKPT5aRUQej7hSY2cvmGlvN67Kpj0u
         jE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718668485; x=1719273285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Hn7Uw1Pm65VhzySE2qfIsVBg9n7H6rZMeI5/fbUyBk=;
        b=huqFN7CvWjizH91Kdn61lw7g//fI95SBvE/NOuv4JycRcLmEWL6//OuvXMCp148ojs
         04fRILrhXW3TeKcq/XgMxrTzvHEk0L0bnbLztEOBzaHYa5NKIqZVlUfQ7bHObLWnYQMR
         nm30DiowapQ/RU1TjEhspKH4DAkB/adxFFnt3ekFISF4veEHaRbCPNmAokKzfKswlBXX
         Bf/r69M9kF/BgrbcVqOpV6X/EDtAVoYyTQjUIImmxfzDn2fJS8/oABv1ueLzO/Kwc6Da
         NYz2ueHHFg58Bxaa2BfmcNPMmxeam6VL2KhwjWdXpy73b19CFF82aCF91bbn2mc8N0KN
         msYg==
X-Forwarded-Encrypted: i=1; AJvYcCXdjgOb32blRYJauZKfzRO1k+1gI84AgWlO9FKSJgQia4c4wIQcNq7vkp/QAYTr/99beBm7SfVmI6QLF77mZP+0fcHJNqdIQgGT
X-Gm-Message-State: AOJu0YyzYrvDOWRisEKjBTcsq7ZJxxMFeo8Jc7INHMKLoum6jKedaX3h
	RIIaoDFtoGZT5/Pt1Y0341OTS9B4h03/8zKOEklEVdtIjMjl+5qkSzcogDodFmc=
X-Google-Smtp-Source: AGHT+IEWjrUuc9kHPZwYN9kZ1hLtNVkKYEjKvkBrtj/wQnQ8J4hmedDMBn9Fhq7VmrM8vAdM0Cg8Sw==
X-Received: by 2002:a05:6e02:1a86:b0:375:a202:2535 with SMTP id e9e14a558f8ab-375e1094965mr119882725ab.30.1718668484518;
        Mon, 17 Jun 2024 16:54:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fee3c9f7b9sm7130690a12.86.2024.06.17.16.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 16:54:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sJMBN-0027So-1Z;
	Tue, 18 Jun 2024 09:54:41 +1000
Date: Tue, 18 Jun 2024 09:54:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] bringing back the AGFL reserve
Message-ID: <ZnDMwennkO+zGfzq@dread.disaster.area>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <ZmuSsYn/ma9ejCoP@dread.disaster.area>
 <20240617222527.GA2044@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617222527.GA2044@templeofstupid.com>

On Mon, Jun 17, 2024 at 03:25:27PM -0700, Krister Johansen wrote:
> On Fri, Jun 14, 2024 at 10:45:37AM +1000, Dave Chinner wrote:
> > On Thu, Jun 13, 2024 at 01:27:09PM -0700, Krister Johansen wrote:
> > > I managed to work out a reproducer for the problem.  Debugging that, the
> > > steps Gao outlined turned out to be essentially what was necessary to
> > > get the problem to happen repeatably.
> > > 
> > > 1. Allocate almost all of the space in an AG
> > > 2. Free and reallocate that space to fragement it so the freespace
> > > b-trees are just about to split.
> > > 3. Allocate blocks in a file such that the next extent allocated for
> > > that file will cause its bmbt to get converted from an inline extent to
> > > a b-tree.
> > > 4. Free space such that the free-space btrees have a contiguous extent
> > > with a busy portion on either end
> > > 5. Allocate the portion in the middle, splitting the extent and
> > > triggering a b-tree split.
> > 
> > Do you have a script that sets up this precondition reliably?
> > It sounds like it can be done from a known filesystem config. If you
> > do have a script, can you share it? Or maybe even better, turn it
> > into an fstest?
> 
> I do have a script that reproduces the problem.  At the moment it is in
> a pretty embarrasing state.  I'm happy to clean it up a bit and share
> it, or try to turn it into a fstest, or both.  The script currently
> creates small loop devices to generate a filesystem layout that's a
> little easier to work with.  Is it considered acceptable to have a
> fstest create a filesystem with a particular geometry?

Absolutely.

We do that quite a bit in fstests - if you just need one filesystem
for this, then _scratch_mkfs_sized() can be used to make a
filesystem of a specific size, or you can use _scratch_mkfs and pass
the options you want directly to it. An example of this is xfs/227.

Otherwise you can create loop devices and use _mkfs_dev() to create
the filesystems you need on them. An example of this is xfs/074.

> (And would you
> consider taking a patch to let mkfs.xfs --unsupported take both size and
> agsize arguments so the overall filesystem size and the per-ag size
> could be set by a test?)

We can already do that, but it's been placed behind a strong
environmental guard to restrict such configurations to the fstests
environment:

# TEST_DIR=foo TEST_DEV=foo QA_CHECK_FS=foo mkfs.xfs -dagcount=2,size=32m,file,name=foo

will bypass the "300MB minimum size" checks and allow you to make a
filesystem image with 2x16MB AGs (i.e. a 32MB filesystem) ready to
have a loop device created over it. If this is run inside a fstest,
then you don't need the env variables because they are already set.

> > > On older kernels this is all it takes.  After the AG-aware allocator
> > > changes I also need to start the allocation in the highest numbered AG
> > > available while inducing lock contention in the lower numbered AGs.
> > 
> > Ah, so you have to perform a DOS on the lower AGFs so that the
> > attempts made by the xfs_alloc_vextent_start_ag() to trylock the
> > lower AGFs once it finds it cannot allocate in the highest AG
> > anymore also fail.
> > 
> > That was one of the changes made in the perag aware allocator
> > rework; it added full-range AG iteration when XFS_ALLOC_FLAG_TRYLOCK
> > is set because we can't deadlock on reverse order AGF locking when
> > using trylocks.
> > 
> > However, if the trylock iteration fails, it then sets the restart AG
> > to the minimum AG be can wait for without deadlocking, removes the
> > trylock and restarts the iteration. Hence you've had to create AGF
> > lock contention to force the allocator back to being restricted by
> > the AGF locking orders.
> 
> The other thing that I really appreciated here is that the patchset
> cleaned up a bunch of the different allocation functions and made
> everything easier to read and follow.  Thanks for that as well.
> 
> > Is this new behaviour sufficient to mitigate the problem being seen
> > with this database workload? Has it been tested with kernels that
> > have those changes, and if so did it have any impact on the
> > frequency of the issue occurring?
> 
> I don't have a good answer for this yet.  The team is planning to start
> migrating later in the year and this will probably run through to next
> year.  I'll have that information eventually and will share it when I
> do, but don't know yet. 

OK, that's fine. We still need to fix the issue, I just wanted to
get an idea of the urgency of the situation.

> Aside from the script, other synethtic
> load-tests have not been successful in reproducing the problemr.  That
> may be the result of the databases that are spun up for load testing not
> having filesystems that as full and fragmented as the production ones.

Yeah, that's typical when triaging these sorts of issues. We've had
issues like this in the past with scyallaDB w.r.t.  extent size hint
based allocation occasionally failing at ~70% filesystem capacity.
Situations like this require a very particular free space pattern to
trigger, and it tends to be rare that they are hit in either test or
production systems. Having a synthetic reproducer for such an issue
is like finding gold. :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
