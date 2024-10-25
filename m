Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA144430
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 00:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729817304; cv=none; b=YuTjCC/GOz9JyaAh9WllBxtWEUfjjTy3ey+S+FYKF0zntGp12NLUHmzvKSy9O6ZfA2bahWAWltiirX8IM+9cYMqEgXnfWGaL0OmPN+vCRyO4uXOuXzdv+90Btsrl4congrKBQmWBltS/xDdCVBCjq46GWvfNVlZsazVJ8g7Oaks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729817304; c=relaxed/simple;
	bh=VYgR+qJoh8D1ySUopoAOUiY4VLFg+wsAlPAb/zox9us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVaEA9PdNpp6BDDhqD1s7G9YMINXY2biojbtQefLEKSBdJIoXZDy8XS/aEqjZC9J5LcOM4Yf9WI96DFlWGlPOrdr80SjGYf5KQIwZHybcO9RoSSEvwe0wmjAhhTrS6bgr4faZSOdbBvFlfkfYhjfcCwsl+ehlUAkWHp7eNom3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xcEBVDhT; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xcEBVDhT"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-27b7a1480bdso712127fac.2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 17:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729817300; x=1730422100; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2SZebrm4sXQ71M/CEnUiJtPi/SjfvyVUqkbG4dZF+pk=;
        b=xcEBVDhTo4YlAHzOup4au/tRD09Z+C9CKfw94qDjX8A/Jeb707m+gaZAJ2KCsr/e/k
         uU9rh6KxdIwC8RWT9FV1u/f8nn5bMd9fOgGZFRPLrJ9hgRulgvt0ULthhlJi9gqx7JkD
         MJIwExZnBb+CZQ0Ol45zArPw+ATTCR+nqEzot5ToiGemNMo/hkfITOaQPM+QiTiaoEI0
         sOLSfzZG/pwcRE6Ogkm8+ZAk16xyzdnx+06Qq9E116QMNw07Ecd9Q7HIke3Y8t/M4jVl
         idNPL8V8IQDm4LOsR0J5Yb+X0A/MGrZ3oAGXxOx3+kKlgl9nFkdwRWCPCUNLlMJR43vv
         +7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729817300; x=1730422100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SZebrm4sXQ71M/CEnUiJtPi/SjfvyVUqkbG4dZF+pk=;
        b=qHw1U5W4e3wh8z+rGt4oewPMzNwCzLruS6bY8xov6JeWLU0fc60PZuihm863FH034d
         LenGj4drrFT3dcx69mp515BfwgAqKgW/2g47qATZdkPNPokOf8CG0J/qMq1m8zG56b2h
         ATpLJGlGAlVQd8iVZnpufVTEyT+zRphn5BjakYzB/iHCkD36emRG5aBYaxmts0IV2hBC
         ZfymNPPoyo5LQoX0cabNOZMPa73bwNPLRqPyOd9x6nCiW3i5mKDP+/IIeqBMArxFKxB5
         Sz+uaa6TJLcOeREHVJqihJgoCsiNsHWfzWJzW4WcEa7PKivRM6zNQV9H/LLJRMNOaSUu
         vuVA==
X-Gm-Message-State: AOJu0YzdQoIkUJeZhsFoO4x7EHppm5gy/Aq1eC8QQ0VhI6lRyP83vdgJ
	3a6LYfiOYZDWYZg+nX7j252Vy0qWylbe/Wb23ckhBud4ek4PzsLGcH6RSzDtjow=
X-Google-Smtp-Source: AGHT+IGTyN9VnDNNrJ42jsv8c3GiJeH/wJhgSZBQw2o3SKb39FR6WgLzFW7V3Fw91LmSoz0IyrONPA==
X-Received: by 2002:a05:6870:c69d:b0:25e:24b:e65b with SMTP id 586e51a60fabf-28ccb68e375mr8264624fac.42.1729817300569;
        Thu, 24 Oct 2024 17:48:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7edc866906dsm36811a12.10.2024.10.24.17.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 17:48:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t48Ux-005MhO-2x;
	Fri, 25 Oct 2024 11:48:15 +1100
Date: Fri, 25 Oct 2024 11:48:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
Message-ID: <Zxrqz9xMV5PKQ5+f@dread.disaster.area>
References: <20241024025142.4082218-1-david@fromorbit.com>
 <ZxpJp48vi4NpFVqJ@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxpJp48vi4NpFVqJ@bfoster>

On Thu, Oct 24, 2024 at 09:20:39AM -0400, Brian Foster wrote:
> On Thu, Oct 24, 2024 at 01:51:02PM +1100, Dave Chinner wrote:
> > We have had a large number of recent reports about cloud filesystems
> > with "corrupt" inode records recently. They are all the same, and
> > feature a filesystem that has been grown from a small size to a
> > larger size (to 30G or 50G). In all cases, they have a very small
> > runt AG at the end of the filesystem.  In the case of the 30GB
> > filesystems, this is 1031 blocks long.
> > 
> > These filesystems start issuing corruption warnings when trying to
> > allocate an in a sparse cluster at block 1024 of the runt AG. At
> > this point, there shouldn't be a sparse inode cluster because there
> > isn't space to fit an entire inode chunk (8 blocks) at block 1024.
> > i.e. it is only 7 blocks from the end of the AG.
> > 
> > Hence the first bug is that we allowed allocation of a sparse inode
> > cluster in this location when it should not have occurred. The first
> > patch in the series addresses this.
> > 
> > However, there is actually nothing corrupt in the on-disk sparse
> > inode record or inode cluster at agbno 1024. It is a 32 inode
> > cluster, which means it is 4 blocks in length, so sits entirely
> > within the AG and every inode in the record is addressable and
> > accessible. The only thing we can't do is make the sparse inode
> > record whole - the inode allocation code cannot allocate another 4
> > blocks that span beyond the end of the AG. Hence this inode record
> > and cluster remain sparse until all the inodes in it are freed and
> > the cluster removed from disk.
> > 
> > The second bug is that we don't consider inodes beyond inode cluster
> > alignment at the end of an AG as being valid. When sparse inode
> > alignment is in use, we set the in-memory inode cluster alignment to
> > match the inode chunk alignment, and so the maximum valid inode
> > number is inode chunk aligned, not inode cluster aligned. Hence when
> > we have an inode cluster at the end of the AG - so the max inode
> > number is cluster aligned - we reject that entire cluster as being
> > invalid. 
> > 
> > As stated above, there is nothing corrupt about the sparse inode
> > cluster at the end of the AG, it just doesn't match an arbitrary
> > alignment validation restriction for inodes at the end of the AG.
> > Given we have production filesystems out there with sparse inode
> > clusters allocated with cluster alignment at the end of the AG, we
> > need to consider these inodes as valid and not error out with a
> > corruption report.  The second patch addresses this.
> > 
> > The third issue I found is that we never validate the
> > sb->sb_spino_align valid when we mount the filesystem. It could have
> > any value and we just blindly use it when calculating inode
> > allocation geometry. The third patch adds sb->sb_spino_align range
> > validation to the superblock verifier.
> > 
> > There is one question that needs to be resolved in this patchset: if
> > we take patch 2 to allow sparse inodes at the end of the AG, why
> > would we need the change in patch 1? Indeed, at this point I have to
> > ask why we even need the min/max agbno guidelines to the inode chunk
> > allocation as we end up allowing any aligned location in the AG to
> > be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> > unnecessary and now we can remove a bunch of code (min/max_agbno
> > constraints) from the allocator paths...
> > 
> > I'd prefer that we take the latter path: ignore the first patch.
> > This results in more flexible behaviour, allows existing filesystems
> > with this issue to work without needing xfs_repair to fix them, and
> > we get to remove complexity from the code.
> > 
> > Thoughts?
> > 
> 
> This all sounds reasonable on its own if the corruption is essentially
> artifical and there is a path for code simplification, etc. That said, I
> think there's a potential counter argument for skipping patch 1 though.
> A couple things come to mind:
> 
> 1. When this corrupted inode chunk allocation does occur, is it possible
> to actually allocate an inode out of it, or does the error checking
> logic prevent that?

The error checking during finobt lookup prevents inode allocation.
i.e. it fails after finobt lookup via the path:

xfs_dialloc_ag_finobt_newino()
  xfs_inobt_get_rec()
    xfs_inobt_check_irec()
      if (!xfs_verify_agino(pag, irec->ir_startino))
         return __this_address;

Before any modifications are made. hence the transaction is clean
when cancelled, and the error is propagated cleanly back out to
userspace.

> 2. Would we recommend a user upgrade to a new kernel with a corruption
> present that causes inode allocation failure?

I'm not making any sort of recommendations on how downstream distros
handle system recovery from this issue.  System recovery once the
problem has manifested is a separate problem - what we are concerned
about here is modifying the kernel code to:

a) prevent the issue from happening again; and
b) ensure that existing filesytsems with this latent issue on disk
   don't throw corruption errors in future.

How we get that kernel onto downstream distro systems is largely a
distro support issue. Downstream distros can:

- run the gaunlet and upgrade in place, relying on the the
  transactional upgrade behaviour of the package manager to handle
  rollbacks when file create failures during installation; or
- grow the cloud block device and filesystem to put the inode
  cluster wholly within the bounds of the AG and so pass the
  alignment checks without any kernel modifications, then do the
  kernel upgrade; or
- live patch the running kernel to allow the sparse inode cluster to
  be considered valid (as per the second patch in this series)
  so it won't ever fail whilst installing the kernel upgrade; or
- do some xfs_db magic to remove the finobt record that is
  problematic and leak the sparse inode cluster so we never try to
  allocate inode from it, then do the kernel upgrade and run
  xfs_repair; or
- do some xfs_db magic to remove the finobt record and shrink the
  filesystem down a few blocks to inode chunk align it.
- something else...

IOWs, there are lots of ways that the downstream distros can
mitigate the problem sufficiently to install an updated kernel that
won't have the problem ever again.

> My .02: under no circumstances would I run a distro/package upgrade on a
> filesystem in that state before running repair, nor would I recommend
> that to anyone else.

Keep in mind that disallowing distro/package managers to run in this
situation also rules out shipping a new xfsprogs package to address
the issue. i.e. if the distro won't allow kernel package upgrades,
then they won't allow xfsprogs package upgrades, either.

There aren't any filesystem level problems with allowing operation
to continue on the filesystem with a sparse inode chunk like this in
the runt AG. Yes, file create will fail with an error every so
often, but there aren't any issues beyond that. The "corruption"
can't propagate, it wont' shut down the filesystem, and errors are
returned to userspace when it is hit. There is no danger to
other filesystem metadata or user data from this issue.

Hence I don't see any issues with simply installing new packages and
rebooting to make the problem go away...

> The caveat to this is that even after a repair,
> there's no guarantee an upgrade wouldn't go and realloc the same bad
> chunk and end up right back in the same state, and thus fail just the
> same.

Sure, but this can be said about every single sparse inode enabled
filesystem that has an unaligned end of the runt AG whether the
problem has manifested or not. There are going to *lots* of
filesystems out there with this potential problem just waiting to be
tripped over.

i.e. the scope of this latent issue has the potential to affect a
very large number of filesystems.  Hence saying that we can't
upgrade -anything- on <some large subset> of sparse inode enable
filesystems because they *might* fail with this problem doesn't make
a whole lot of sense to me....

> For example, I assume allocating the last handful of blocks out of the
> runt AG would prevent the problem. Of course that technically creates
> another corruption by leaking blocks, but as long repair knows to keep
> it in place so long as the fs geometry is susceptible, perhaps that
> would work..?

I think that would become an implicit change of on-disk format.
scrub would need to know about it, as would online repair. growfs
will need to handle the case explicitly (is the trailing runt space
on this filesystem leaked or not?), and so on. I don't see this as a
viable solution.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
