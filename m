Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466971;
	b=v93MOToT96cYv9iePrRPohuGchen2fLyINosX4k6Gka8H1+fNC3VYjx7U4EtBLyLGzM1
	 hGWuUsf5QBOhy8Xy40XmL2RHfsdiNekihVLwlAyPiZvE9aoB1qQuAtHYB3gs248Ra2X0a
	 YAPdQOHByqvSgq2Ko0Db4s/3zkpi+Efd7uzUrsj1gmp8VmiS7q5NFFeIVWpdvIfwPsAWL
	 Tf/h34hNnKaF+SAC10sBv4vrfRvcgqUZUHQKrNfos9Xqe3yDMnlXrDNjifNku5NXoNoDs
	 kXe0sHvy0byoI/tFKPahenIQ4TSw4AwK+Ms+TYyIkJfG3dbcgdZ7Qgwgd9e3Kjc3vjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466971;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Erw1O6wwL5fM4mtOlZyTOkojZUaVQzW8DQ7JMB6yxjM=;
	b=eySnsDXpfez6Ua5gGQ1o18WuU+2K5e8LyXKXiIGgVEa16WcUanLu5SI1EYRufrj4MFw2
	 zVTmM1zqVJfpk8slmBsR3Er2tvnAvjLlAkSSxyZ7DU0RkLhVA7jlKR+tAOBcSgRkKLACx
	 By5C+DcBR1yEeMGBlmFLBKthiXi9rHDaIq1X6Z7LtksBty+lEpS2GI6pDmOJ6k9T1H44q
	 wvc3LVKhS1Wg7/riPQ+jZKoUPnXJaZZgsgXmDFhIGgCVSWE7G/gRgcJPBMU0coDow8FkR
	 YmjVFCEuZ6D1L9MMLna3HgtjXmWIT4TlYztmmm1+k9HkZLcQBAXf2giNw7ZsT7Kfsvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TGiil+xt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF19606A326;
	Mon, 23 Nov 2026 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TGiil+xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247231F000CA;
	Mon, 23 Nov 2026 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795466971;
	bh=Erw1O6wwL5fM4mtOlZyTOkojZUaVQzW8DQ7JMB6yxjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TGiil+xtu1TYm6SODXtb2IoMmuuWvv2hflqNT7bS2cN6SvbaF26F5RXa/SNV4NOHl
	 ii+vFc+zFSnYutGVN1/B/jJ3nzVyFjhw5ehPWaFeXoVEuuQiiFNMz6e9ZcbEyUumot
	 IQesuMDJhGqfBrH79ErYmJjNoHmWd82K1JD5318uyU5kc+vHth0gJ0v6M0PxMkAx13
	 D3anaULdwig8RPtOpu7pf7AnoB/O1lQ9cgIEpUVqVxKFfEZg5J/by4IHxPf4/RGgiE
	 +wsPTygGWgcefZ/SLyIhrr3R+/d1thrO9BQOYl1hHahNvSQKlq4pSvp6afiG61RBoQ
	 lve0wy/Tb47Lg==
Date: Tue, 24 Nov 2026 07:49:21 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Qing Zhang <diasyzhangqing@gmail.com>, viro@zeniv.linux.org.uk,
	raven@themaw.net, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] namei: revalidate the symlink dentry before invoking
 get_link in RCU-walk
Message-ID: <awSm0WX5bb5p9hnW@dread>
References: <20261118083945.1449264-1-diasyzhang@tencent.com>
 <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
 <awB0RE6WN_v4YBbn@infradead.org>
 <awNlrO5A-kdDOYvO@dread>
 <d2w6jvflihqiyfbht3qv3mgjg3muuuvmhnss5j5dp4zh6axhn2@nsegavvnkpie>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2w6jvflihqiyfbht3qv3mgjg3muuuvmhnss5j5dp4zh6axhn2@nsegavvnkpie>

On Mon, Nov 23, 2026 at 09:50:21AM +0100, Jan Kara wrote:
> On Mon 23-11-26 08:59:08, Dave Chinner wrote:
> > On Fri, Nov 20, 2026 at 08:24:36AM -0800, Christoph Hellwig wrote:
> > > On Fri, Nov 20, 2026 at 02:59:42PM +0100, Christian Brauner wrote:
> > > > This only makes the window smaller.
> > > > 
> > > > XFS can still reinitialize the inode right after this check and while
> > > > get() is running. Then ->get_link() operates on an inode that is being
> > > > reset underneath it. And the !get check only catches the case where the
> > > > that re-init already finished before we loaded ->get_link.
> > > > 
> > > > RCU pathwalk relies on inode memory not being reused before a grace
> > > > period has passed. XFS itself frees inodes via call_rcu() but the
> > > > recycle path hands the same struct inode out again without waiting for
> > > > existing RCU walkers.
> > > > 
> > > > So that should be fixed in XFS, either by not recycling an inode in
> > > > place while RCU walkers can still see it or by keeping i_op and the link
> > > > state valid across a recycle.
> > > 
> > > Not recycling the inode really isn't an option, as that means there
> > > would cause duplicate inodes in the xfs inode cache.  Keeping i_op and
> > > state in place sounds a bit more feasibly, but could be iffy as well.
> > > 
> > > The best thing would be to find a way to keep the inode alive at the VFS
> > > level when XFS marks it reclaimable.  That would be a huge an invasive
> > > change, but it would solve this and many other problems as well.
> > 
> > I don't think that's feasible without a massive rework of the VFS
> > inode life cycle management and/or the way XFS tracks inode metadata
> > dirtiness for writeback purposes.
> > 
> > Background:
> > 
> > The xfs_iget_recycle() code exists because dirty XFS_IRECLAIMABLE
> > inodes are tied into the journal machinery and need writeback before
> > they can be reclaimed. This is all invisible to the VFS, and it is
> > done via lockless lookups and atomic state checks without the need
> > for reference counts within XFS itself.
> > 
> > The issue is that reclaiming such an inode generally requires a log
> > force to stabilise it in the journal before it can be written back,
> > and the act of writing it back requires access to the inode state.
> > Hence the journal requires the XFS inode to live in XFS_IRECLAIMABLE
> > state until metadata writeback is complete, regardless of any other
> > inode state changes.
> > 
> > xfs_ireclaim() can expedite the writeback portion of reclaim (by
> > running an inode flush) but it does not expedite the required
> > journal flush if the inode is still dirty in memory. On lookup
> > of an XFS_IRECLAIMABLE inode in RCU mode, we cannot directly reclaim
> > a dirty XFS_IRECLAIMABLE inode because it requires blocking on both
> > a log force and metadata writeback. That's why the inode is sitting
> > in the XFS_IRECLAIMABLE limbo in the first place...
> > 
> > That's where the xfs_iget_recycle() code stepped in - it
> > reinitialises the VFS portion of the inode without affecting the
> > internal journal state of the inode. This allows new modifications to
> > be added to the inode and the attached log item without any
> > discontinuities in journal state.
> > 
> > The reason it does a full initialisation of the VFS inode is that
> > the inode can change identity whilst in XFS_IRECLAIMABLE. i.e. it
> > could be unlinked and then reallocated as a different inode (same
> > number, different generation), and so the type can change (e.g. REG
> > -> DIR) and hence a full VFS init is required to recycle it.
> > 
> > And the reason that we've always done this recycle is for
> > performance reasons - the inode allocation algorithms can prefer to
> > allocate recently freed inodes (for locality reasons), and hence
> > recently unlinked inodes in the IRECLAIMABLE state can be
> > reallocated and need recycling because the final unlink state hasn't
> > reached stable media before they are recycled.
> > 
> > Doing things like forcing logs, instant reclaim, RCU
> > synchronisation, etc have all had significant performance impacts
> > due to the additional latency these operations add to common
> > workload patterns. Hence the rarity of this recycle issue hasn't
> > outweighed the cost of the "simple" fixes to everyday operation.
> 
> I'd just mention one possible solution which you didn't mention below (I
> don't know how complex it would get for XFS but we effectively do this in
> ext4) - make the VFS part of the inode and the journalled portion of the
> inode separate entities in memory (independently allocated & freed).

Yes, that's another avenue - we already have the abstraction of hte
log items being tracked and used by the journal, and the inode
simply contains a pointer to the log item for.

*however*

> Then
> you can free the VFS portion of the inode while still keeping the
> journalled portion allocated.

The separation is between the XFS/VFS inode structure and the xfs
log item structure. The problem is that the XFS/VFS inode is a
single comingled structure (i.e. struct xfs_inode { ... struct inode
vfs_inode; } and xfs_iget_recycle() is reinitialising just the VFS
portion of the structure.

The reality is that the XFS inode is still needed by journal
writeback to format the current state of the inode into the backing
buffer at writeback time, because the delta written to the journal
is not tracked by the log item itself past the journal commit.

We used to have separate XFS and VFS inode structures - a couple of
decades ago. That went away a long time ago, and I don't think we
really want to go back in that direction because we'd have to undo
all the inode field deduplication we've done in the last 15 years...

> If the inode location on disk gets
> reallocated, you allocate fresh VFS part and recycle the journalled part.
> In ext4 we have this natural separation between the buffer carrying the
> inode structure on disk which is part of the journalling process and the
> inode itself so this separation is easy there. For XFS I presume this is
> complex or you wouldn't bother with all the separate inode lifetime logic
> but I just wanted to toss this idea out.

XFS uses individual structure-based inode logging, not buffer based
logging. Hence writeback of the inode log item still needs to format
the inode structure into the backing buffer. Hence the inode
structure must be available at writeback time, and because we do
transactions on inodes after evict (e.g. unlinked inode freeing),
the inode structure -must- persistent beyond the VFS inode life
cycle.

When describing the above solutions, I did consider "can we keep the
log item and reallocate the struct xfs_inode and point it back at
the log item?" to do somethign similar to what you suggest. We could
potentially do that, but the changes we need to do first to enable
it are .... quite extensive.

Unfortunately, the log items are not reference counted by the
journal when being tracked for writeback, and the inode is not
reference counted by the log item's back pointer to the inode
itself. Hence disconnecting and reparenting the inode log item
whilst it is still active in the journal machinery is ... excitingly
complex.

(FYI - log item writeback reference counting and dynamic inode log
item design docs:

https://lore.kernel.org/all/aqI6v-_dc2DDSbgB@dread/

tl;dr: very complex!)

Then there's the fact that the inode cluster buffer tracks dirty
inode log items, too. Hence there's situations where buffer IO
completion can reach through the attached inode log item to the XFS
inode to change state, and it does this without holding a direct
reference to the inode, too. The state that allows this to be done
safely is held in the XFS inode itself (the flush 'lock' and
XFS_IFLUSHING) and processing is dependent on inode state (e.g.
XFS_ISTALE), and hence any 'replacement' of the xfs inode cannot be
done whilst the inode itself is under writeback....

So, yeah, I did consider the 'leave the log item in the journal,
recreate just the XFS/VFS inode' path, but handling the changeover
in a sane manner seems far more complex than the 'flush, reclaim,
reallocate' approach.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
