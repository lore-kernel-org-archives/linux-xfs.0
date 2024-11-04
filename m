Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789C14E2F5
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730685168; cv=none; b=JE/N0ZeusqDDp42NECiqf9mOnJw3GAWPI/i7iTCRgrz2wtVGasORBPqzqb/j/JyB6LUYswcZDWmGb7SMBp8+mh0sOO05ApvMTw0IF/CdY3TXluw+QzEkP5/aR4t4/2DcZJh4+r9Xms7o1egOqX34KNQQWGzQ48HUSSoQa5C9LM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730685168; c=relaxed/simple;
	bh=4ER/EiUCkm4Hjda9LTk/1TdU9pkW80CjEHKAFrE8eD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVJW/G14FX+aFgwxrRJdUUqMFv/UTZdm0hZlC99pvjjspxcGtfnocx+1GcenLQNI2yji6QaAfnqINiUicrrlF2Yd42LobstBkeFYKrmgyltiXK8o/p7K3EbubfSYlBu9JZLJ8HWcS5JeE5FSQ+rx2yXs/RBCQzjtqBfi4iFgrlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=WK2nQ19i; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="WK2nQ19i"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7e9e38dd5f1so2904483a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2024 17:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730685165; x=1731289965; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D1gO7nE6k1d3RjOM7nVXHvrivHG7QQDb7RYI/vhsl1g=;
        b=WK2nQ19iurnnXZh/H138SBIHp3WiDagYGsLzW8Q2WSuM2PMUzKJj/GfR7k0AYmeKos
         hJn4GArnVZ4VEgxn7oZQy40khQpgPj7onWuH2Phl+7mmvdKuI37jBAHaDDPTsl5nb4Fz
         GdHbpXvzmCUvx3GQVcjZo3x5ojFrvAMzfz2Em6whCBa4W+CZ7v3EERd5opZz2RKoBb81
         EEqdAGGTVP1cqLjmU86d+PzgfVPvRq/9rGlVkHr9HWpW+8C1C42gfYNoimoMsqqagNqK
         iplPld4ChHpTcexP21UpEfo0BTYpe48qtj5N0rWNKy8fNMtiD/pGzmffBubX3nfkTSod
         NN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730685165; x=1731289965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1gO7nE6k1d3RjOM7nVXHvrivHG7QQDb7RYI/vhsl1g=;
        b=An3NMVjbekdZHgx1lU4nXHyG30G4VI9zvehAKPon7hBIuUEXSWXN9U3zx7pUlut0EO
         Zdf/O+bv4mF0kVEy7JojYO+bBtY9sCGsTgy6Mx0MkA9mG5PEVbCsEKKPCgHVP3MfnsgI
         qHXj61TN5eckbE/ULFXL5iBLvsnDi1oucrcm7hwFjFwfmq9NbaIWdkpgQBosJSdazTaF
         sZZ4yqlaRfN8qRMuY7T8b9XPy3aytHxLZSzGYNGAi+8ICCa9cj9/n3r7vmoiLAGcZ3b6
         OkCSmhIlbj9+l7eHLFdtWb8LWo6ZCFGbHLchamZW0ris8i3a7Wzqoxj+1a2vvFp71a9I
         aRfA==
X-Forwarded-Encrypted: i=1; AJvYcCX1mompEu6sY5mh6xgeG1G1tSn/4IY0ApWTq9bA+abhJPb74R9yki4PSqrmuRyqVjhIHXr2gDK5Se8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxezXPzpX+DQGAK6QXgfXzR+Wrjb0t2JHkW3ibpiyvcGPnOgsUZ
	RI4fxC9KGwEPqNLuU82a32W4HzpPfFGUO7QL/dAyGTCHdgkQo+bmynVvxXqaghPzc71rmN+DzQ6
	W
X-Google-Smtp-Source: AGHT+IHU0t6TXjLqTaEyMJ+80xaQseYHEZhGQPcykH54yPn7f5EMEawKPcrdWfzxP/RT/N77cHYxWA==
X-Received: by 2002:a05:6a20:d8b:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d9a84d168emr47042468637.35.1730685165442;
        Sun, 03 Nov 2024 17:52:45 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc318824sm6235825b3a.212.2024.11.03.17.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:52:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t7mGo-009qSI-0n;
	Mon, 04 Nov 2024 12:52:42 +1100
Date: Mon, 4 Nov 2024 12:52:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
	John Garry <john.g.garry@oracle.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/6] iomap: Lift blocksize restriction on atomic writes
Message-ID: <Zygo6nqOJMoJxYrm@dread.disaster.area>
References: <87v7xgmpwo.fsf@gmail.com>
 <7e322989-c6e0-424a-94bd-3ad6ce5ffee9@oracle.com>
 <87ttd0mnuo.fsf@gmail.com>
 <7aea00d4-3914-414d-a18f-586a303868c1@oracle.com>
 <87r084mkat.fsf@gmail.com>
 <509180f3-4cc1-4cc2-9d43-5a1e728fb718@oracle.com>
 <87plnomfsy.fsf@gmail.com>
 <20241025182858.GM2386201@frogsfrogsfrogs>
 <87jzdvmqfz.fsf@gmail.com>
 <20241031213640.GB21832@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031213640.GB21832@frogsfrogsfrogs>

On Thu, Oct 31, 2024 at 02:36:40PM -0700, Darrick J. Wong wrote:
> On Sat, Oct 26, 2024 at 10:05:44AM +0530, Ritesh Harjani wrote:
> > > This gets me to the third and much less general solution -- only allow
> > > untorn writes if we know that the ioend only ever has to run a single
> > > transaction.  That's why untorn writes are limited to a single fsblock
> > > for now -- it's a simple solution so that we can get our downstream
> > > customers to kick the tires and start on the next iteration instead of
> > > spending years on waterfalling.
> > >
> > > Did you notice that in all of these cases, the capabilities of the
> > > filesystem's ioend processing determines the restrictions on the number
> > > and type of mappings that ->iomap_begin can give to iomap?
> > >
> > > Now that we have a second system trying to hook up to the iomap support,
> > > it's clear to me that the restrictions on mappings are specific to each
> > > filesystem.  Therefore, the iomap directio code should not impose
> > > restrictions on the mappings it receives unless they would prevent the
> > > creation of the single aligned bio.
> > >
> > > Instead, xfs_direct_write_iomap_begin and ext4_iomap_begin should return
> > > EINVAL or something if they look at the file mappings and discover that
> > > they cannot perform the ioend without risking torn mapping updates.  In
> > > the long run, ->iomap_begin is where this iomap->len <= iter->len check
> > > really belongs, but hold that thought.
> > >
> > > For the multi fsblock case, the ->iomap_begin functions would have to
> > > check that only one metadata update would be necessary in the ioend.
> > > That's where things get murky, since ext4/xfs drop their mapping locks
> > > between calls to ->iomap_begin.  So you'd have to check all the mappings
> > > for unsupported mixed state every time.  Yuck.
> > >
> > 
> > Thanks Darrick for taking time summarizing what all has been done
> > and your thoughts here.
> > 
> > > It might be less gross to retain the restriction that iomap accepts only
> > > one mapping for the entire file range, like Ritesh has here.
> > 
> > less gross :) sure. 
> > 
> > I would like to think of this as, being less restrictive (compared to
> > only allowing a single fsblock) by adding a constraint on the atomic
> > write I/O request i.e.  
> > 
> > "Atomic write I/O request to a region in a file is only allowed if that
> > region has no partially allocated extents. Otherwise, the file system
> > can fail the I/O operation by returning -EINVAL."
> > 
> > Essentially by adding this constraint to the I/O request, we are
> > helping the user to prevent atomic writes from accidentally getting
> > torned and also allowing multi-fsblock writes. So I still think that
> > might be the right thing to do here or at least a better start. FS can
> > later work on adding such support where we don't even need above
> > such constraint on a given atomic write I/O request.
> 
> On today's ext4 call, Ted and Ritesh and I realized that there's a bit
> more to it than this -- it's not possible to support untorn writes to a
> mix of written/(cow,unwritten) mappings even if they all point to the
> same physical space.  If the system fails after the storage device
> commits the write but before any of the ioend processing is scheduled, a
> subsequent read of the previously written blocks will produce the new
> data, but reads to the other areas will produce the old contents (or
> zeroes, or whatever).  That's a torn write.

I'm *really* surprised that people are only realising that IO
completion processing for atomic writes *must be atomic*.

This was the foundational constraint that the forced alignment
proposal for XFS was intended to address. i.e. to prevent fs
operations from violating atomic write IO constraints (e.g. punching
sub-atomic write size holes in the file) so that the physical IO can
be done without tearing and the IO completion processing that
exposes the new data can be done atomically.

> Therefore, iomap ought to stick to requiring that ->iomap_begin returns
> a single iomap to cover the entire file range for the untorn write.  For
> an unwritten extent, the post-recovery read will see either zeroes or
> the new contents; for a single-mapping COW it'll see old or new contents
> but not both.

I'm pretty sure we enforced that in the XFS mapping implemention for
atomic writes using forced alignment. i.e.  we have to return a
correctly aligned, contiguous mapping to iomap or we have to return
-EINVAL to indicate atomic write mapping failed.

Yes, we can check this in iomap, but it's really the filesystem that
has to implement and enforce it...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
