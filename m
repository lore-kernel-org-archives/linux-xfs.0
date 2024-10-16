Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C01813AF2
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729048222; cv=none; b=BhUPAoKzkmlBrzYi/qOYo5dEwGFaQ6OAhoGbEEUiHRuJLvXrZi6lJkJVouNZhQ/5IqlwOBuz2kMh4qK/7VgyGk5ZIVLD7pt6p/9fKCWVMgBIP6xYlhgA1IPBlSSmdiGqi3NA3KCKSM1GyU+6TSCXQkTmHnZStHFlnZda3h6R8kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729048222; c=relaxed/simple;
	bh=YFIiiJi8oUZJfT07MyC/hcKtxaJy2Lc2AM/BV+002kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksaf2NfGo6fhhC7FgeWoWZhS7FLebgsjefM72vOdoASFGPV8wTO9Lip8pc2kHmOrigbNbwMg5lzfNmmAixotlsm3doIcg/epo2Ui3sHjA4XjH1SthO2LC+Y1VkzW0XRNjaQ3SjqdRIleo+eqx7vFLLUp4Ak2gs9SQfI29wbfk5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SBrD0IXD; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SBrD0IXD"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20c7edf2872so3528995ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 20:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729048218; x=1729653018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpd408SmoilD2VhWqiLaKma+XAHj9KpsTJocWovM/NY=;
        b=SBrD0IXDr1qfHucau+DyP7ZINspJUkgWPeKPeumkZPuB5xLt8JFuXqP8rwa4Wtd/+7
         5RmhbuaQnDaHwJ7WXgFndTwYCWVp934TMMN4eaGnpD50SwhEXozRZnINjT0bvEjPoygr
         ihQThvfYvqKknGt8NOLYuTVfpyv1NnqySk86WU3phnQXGI7D5wDpdG8+MNWj5gWQgW0C
         zin71uJpS6RTVcMuqbiaZgSflSrex4X5aWaSHeL+mZyCMu36vFQLENy7Cs02Zch9m+qj
         nO129dkETZiEcJ80knEghfDgJXXqt6yJYFqcHMhbHlGRxm4FqGeLWbLCSikjjbBFQX10
         7V7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729048218; x=1729653018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpd408SmoilD2VhWqiLaKma+XAHj9KpsTJocWovM/NY=;
        b=AZ8P/COYXrOXtFYJ1StAYob57l2DCE1UNan9GnH3H8F6fi29qMYAW6obdRtxZ3uMz0
         /mmzhedJ6Ac18osQyRCt8voSW+CwXTrn8j6S+xMQWHW2tjGhlJ+QYt3Ssny7mwb0Vb6q
         DzJ3V4NVvMZUCe8p5iNcBzAtoIJZooouxeP/zO8yWbh0zqm+mEJWp9CBY7XpCPnmz8AM
         tKFSYOpybwesSyLNQsBEgBMO1W0qeemSyMc9xwHf+lpYrSINptRDq9sb+HJEHfdoeJZm
         hGbZO7EM/IIuBuovdSazItDsoZkop8Z53ZfAjpfyOuD7XZ770H1lfyEhw2jahOK63HA1
         kJPQ==
X-Gm-Message-State: AOJu0Yz7+QBSURmzUQsAezG0eNXYA85CLFh/nixP+9Q4fklMWxy3+QO8
	yC+g6LYiAejOGUzNyd9kKxCJPo9TtnNW1NPLKEkahAyWXk3g4HBIPA1UI5oEFeY=
X-Google-Smtp-Source: AGHT+IFvLr6kou5rSHMJEhfTdiKHgky+hjeKL5gGW7Sf9DAVo3LPuVayVANk3hxga9eRhQbecmTanA==
X-Received: by 2002:a17:903:284:b0:20b:51c2:d792 with SMTP id d9443c01a7336-20ca017819cmr261523925ad.2.1729048218082;
        Tue, 15 Oct 2024 20:10:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1805b088sm19422245ad.251.2024.10.15.20.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 20:10:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0uQQ-001P8p-1y;
	Wed, 16 Oct 2024 14:10:14 +1100
Date: Wed, 16 Oct 2024 14:10:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/28] xfs: iget for metadata inodes
Message-ID: <Zw8ulrPaeXw8bUnd@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642100.4176876.17733066608512712993.stgit@frogsfrogsfrogs>
 <Zw4R2zxI6XwOHrIC@dread.disaster.area>
 <20241015190404.GH21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015190404.GH21853@frogsfrogsfrogs>

On Tue, Oct 15, 2024 at 12:04:04PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 15, 2024 at 05:55:23PM +1100, Dave Chinner wrote:
> > On Thu, Oct 10, 2024 at 05:49:40PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Create a xfs_metafile_iget function for metadata inodes to ensure that
> > > when we try to iget a metadata file, the inobt thinks a metadata inode
> > > is in use and that the metadata type matches what we are expecting.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > .....
> > 
> > > +/*
> > > + * Get a metadata inode.  The metafile @type must match the inode exactly.
> > > + * Caller must supply a transaction (even if empty) to avoid livelocking if the
> > > + * inobt has a cycle.
> > 
> > Is this something we have to be concerned with for normal operation?
> 
> I think we should be more concerned about this everywhere.  Remember
> that guy who fuzzed a btree so that the lower levels pointed "down" to
> an upper level btree block?

Yes, but that's kinda my point: it requires malicious tampering to
create these loops. Once someone can tamper with the data held on
the device, it's game over. It's far easier to trojan and setuid a
file that the user will run (or be tricked into running) and get
break into the system that way than it is to exploit a flaw in
filesystem metadata. There's every chance that the metadata exploit
will be detected and prevented, but no filesystem code can check
user data for trojans or modified-but-valid inode ownership and
permissions. 

In all my time working on XFS, I've never seen an unintentionally
corrupted filesystem with an cycle in btree metadata. I guess it
could happen if an XFS bug slipped through testing, but that seems
like a very unlikely occurence. 

Hence, based on my experience, btree cycles are mainly an academic
concern, not an actual security or reliability issue that we really
need to be concerned about.

> Detection and recovery from that is what
> running with xfs_trans_alloc_empty() buys us.  It's not a general cycle
> detector as you point out below...

It's not a detection strategy at all - it's a workaround.

When we traverse the btree, we know all the higher level btree
blocks we have locked already - they are held in the cursor.
However, we don't check that the btree ptr we are about to follow is
already locked at a higher level in the cursor before we try to read
the buffer from disk.

Hence the workaround to rely on the transaction allowing nested
access to locked buffers so that we can skip the second buffer
lookup, then decode the btree block again and notice that the level
in the btree block header is wrong.

If we descend to a non-ancestor higher layer btree block, then there
is no deadlock potential, we get the locked buffer, decode it and
then we find it is from the wrong level and abort.

IOWs, we *should* be checking the full btree path cursor for
recursion before we follow *any* btree pointer rather than relying
on the transaction structure to prevent deadlock before we can
detect we descended to the wrong layer.


> > We don't care about needing to detect inobt cycles this when doing
> > lookups from the VFS during normal operation, so why is this an
> > issue we have to be explicitly concerned about during metadir
> > traversals?
> > 
> > Additionally, I can see how a corrupt btree ptr loop could cause a
> > *deadlock* without a transaction context (i.e. end up waiting on a
> > lock we already hold) but I don't see what livelock the transaction
> > context prevents. It appears to me that it would only turn the
> > deadlock into a livelock because the second buffer lookup will find
> > the locked buffer already linked to the transaction and simply take
> > another reference to it.  Hence it will just run around the loop of
> > buffers taking references forever (i.e. a livelock) instead of
> > deadlocking.
> 
> ...because we don't detect loops within a particular level of a btree.
> In theory this is possible if you are willing to enhance (for example)
> a XFS_BB_RIGHTSIB move by comparing the rightmost record in the old
> block against the leftmost record in the new block, but right now the
> codebase (except for scrub) doesn't do that.

So add that detection to the btree increment and decrement
operations. We also need to perform the same pointer following checks as
for descending - the sibling pointer traversal could ascend or descend the
the tree to a locked buffer in the path cursor. Descent needs to be
checked, because we could be walking siblings at an interior level
(e.g. inserting new pointers back up the path)

Fundamentally, cycle detection on search traversal does not require
transaction contexts to perform or unwind. The btree search code
tracks all the btree blocks the traversal has locked at any time.
hence we can detect direct recursion without any risk of deadlocks
by walking the path cursor. We can also unwind correctly if we find
a cycle simply by releasing the path cursor.

All the more complex cases with dangling locked btree buffers occur
when modifications are in progress. In these cases we always have a
transaction context, so tracking all the non-path locked buffers
for buffer lock based recursion deadlock protection happens
naturally for these cases.

> Maybe someone'll do that some day; it would close a pretty big hole in
> runtime problem detection.

I'd much prefer that we either:

1) fix the runtime detection for cycles properly because that avoids
the need to transaction contexts for pure lookups completely; or

2) stop adding complexity and overhead for random one-off operations
because it's only a partial workaround and doesn't provide us any
real protection against malicious cycle-inducing attacks.

> > Another question: why are we only concerned cycles in the inobt? If
> > we've got a cycle in any other btree the metadir code might interact
> > with (e.g. directories, free space, etc), we're going to have the
> > same problems with deadlocks and/or livelocks on tree traversal. 
> 
> We /do/ hold empty transactions when calling xfs_metadir_load so that we
> can error out on wrong-level types of dabtree cycles instead of hanging
> the kernel.

The dabtree code has a full path cursor and so can unwind correctly
when level cycles are detected on lookup. So, again, we should be
fixing this by using the path cursor to detect direct path
cycles that would deadlocki along with level+sibling order checks to
find other non-path based cycles.

> > > -	sbp = &mp->m_sb;
> > > -	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
> > 
> > .... and it's clear that we currently treat the superblock inodes as
> > trusted inode numbers. We don't validate that they are allocated
> > when we look them up, we trust that they have been correctly
> > allocated and properly referenced on disk.
> > 
> > It's not clear to me why there's an undocumented change of
> > trust for internal, trusted access only on-disk metadata being made
> > here...
> 
> I feel it prudent to check for inconsistencies between the inobt state
> and the inode records themselves, because bad space metadata can cause
> disproportionately more problems in a filesystem than a regular file's
> metadata.

Yet we still implicitly trust the contents of AGFs, AGI, the free
space btrees, etc despite the fact the same arguments can be made
about them....

Regardless of this inconsistency, let's follow this "we need more
validation because the metadata is more important" argument through
to it's logical conclusion.

Essentially, the argument is that we can't trust the metadir
directory contents because there might be some new inconsistency
in the allocated inode btree that might have marked the metadir
inode as free. i.e. we are trying to protect against either XFS
implementation bugs, storage media failure or a malicious corruption.

Let's address the XFS implementation bug aspect, which is
essentially the same as having a CRC error in an inobt block:
detecting an inobt corruption at runtime will result in filesystem
shutdown regardless of whether metadir is in use or not.

Mounting the filesystem again will either succeed or fail
depending on whether the inobt corruption is tripped over during the
mount. Currently that only depends on unlinked inode recovery,
metadir would add another inobt traversal path before we perform
unlinked inode recovery.

Either way, the traversals may not encounter the corruption that
shut the filesystem down, so the mount can still succeed (or fail)
regardless of whether metadir exists or whether it does a inobt
lookup for it's internal inodes.

Repair, however, is still necessary to resolve the corruption.

IOWs, doing an inobt check via an untrusted lookup doesn't actually
change anything material w.r.t. inobt corruption. We're entirely
unlikely to detect an otherwise unknown inobt corruption with this
check at mount time. If we already have an inobt corruption then the
untrusted lookup isn't guaranteed to encounter it and prevent
metadir instantiation or mount.

It's kinda insane to say we don't trust the inode number from a
verified directory structure, but we will absolutely trust
in a known corrupted inobt to validate that inode number!

i.e. if we are going to perform untrusted inode lookups under the
guise of "this metadata is very important to verify", then we need
to first verify that the -entire- inobt and its inobt records we are
verifying the inode number against is are not corrupt first.

i.e. if we don't trust our own inode numbers, then we've got to
scrub a good chunk of the filesystem metadata before we can use the
inobt as a source of trust to validate those inode numbers.

As for the malicious tampering case, we can't trust any metadata in
the filesystem to be consistent.

IOWs, if we can't trust that the metadir inode pointers and the
inode btree is consistent because someone might have laid a
cycle-based deadlock trap in the inobt, then we can't trust that the
block mapping btree in a metadir inode is consistent for the same
reasons. Not only that, it could point to any attacker controlled
block in the filesystem and not to the metadata it is supposed to
contain, right?

So now we have to validate the BMBT is consistent before we use the
metadata the metadir points to.  To do that, we have to check that
the free space and rmap btree records are consistent with what the
BMBT says, and then we have to check that the refcount btree is
consistent with what both the BMBT and RMAPBT say about that block.

So if these all check out, we're good, right?

Well, no, we aren't. The attacker could have tampered with all of
these btrees, making the runtime checks look consistent when in fact
they hide the fact that the metadir contains attacker controlled
data.

Of course, we haven't validated any of the non-metadir metadata in
the filesystem, but the attacker has control of that, too. They
could have manipulated that metadata to cross-link metadir contents
with user files and directories. This could give userspace direct
control of metadir file contents.

And that leads us to the point of needing a full filesystem metadata
scrub at mount time to validate that the metadir structure has not
been tampered with in any way nor does any of the external metadata
have illegal references into the metadir structure.

-----

Regardless of the source of metadir/inobt corruption, if we are
going to consider this "more important metadata", then we need to
ensure that our verification model reflects that.

There's a fundamental principle involved here.  The moment we say
"we cannot trust this bit of our own metadata", then we have to
acknowledge that we cannot trust *any* of our own metadata that we
store in the same context.

The metadir inodes, directory blocks and inobt blocks we are talking
about here can be -physically located- in nearby blocks in the
storage device. The LBAs might even be close enough together that
they get placed in the same erase block in flash storage. Hence we
cannot make any assertions that there are differences in trust,
reliability, recoverability or robustness between the different
types of metadata we store in the filesystem.

Hence we have a simple choice: either we trust our internal metadata
to be consistent with other internal metadata, or we don't trust
anything.

The XFS verification architecture is firmly planted in the "we trust
internal metadata to be consistent" corner. This, at the most basic
level, means all filesystem metadata is as trustworthy as any other
filesystem metadata until proven otherwise....

Hence from a architectural point of view, arbitrary implementation
declarations that "we don't trust this metadata but we will trust
that metadata" make little sense.

> Unlike regular files that can be unloaded and reloaded at will, we
> only do this once, so the overhead of the inobt walk is amortized
> over the entire mount-lifetime of the filesystem because we don't
> irele metadata inodes.

I suspect the need for dynamic metadir file behaviour won't be that
far away.  At minimum, we're going to have to be able to dynamically
unlink and free rtg inodes if we want to shrink RT volumes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
