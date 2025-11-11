Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B933AA195
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762869774; cv=none; b=se7JGgypm8qPsnpjxaYvJpaeWic04E1T4Klc5Np9Ei31QLWkM8cDhtvzCO3sTrgP15a7140uHa4zsIZ6eEwnH3SniAZBc1Yn2jLHVfYM/+Wf1Bpu9WfR1xOyM07XUcMlQMSuiBEAnEraw1u4Q+pCOl4Ln48SpTW0E/HR56owl64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762869774; c=relaxed/simple;
	bh=gU8piPZjTHFDHdqUCbuwlUUccTzTooCZwUEsrts1GM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzaUY/5KYsH1m7iQ89WTmUo+lkyCWxr3AFM3WA9ZXf0Pubr5z9oTEf5jApgIpSucB05g+b+nY/54Vn1ifUILR3kg7t9yKDA2ENFxTFpB+kphCEjltcvQ9YWin0E0Qp7RYqYMl19ThieYoP2TU882DIdvY+X5p25h5PY/+vbuedc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QaqXuFQt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QaqXuFQt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762869771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fwMs2HSqhbZAdwuzANZii4wadi5w54+e2uSw8pvjaGE=;
	b=QaqXuFQtUe/WyfexsiQMldTq5JSDfdVrvYHg6A4YD68UDrWmZ9O0eU23IXaIoGDZAFuHY4
	+b28qa6O8qcjH57c9e6YhNR5QiNvp6OaaHnBhijnTYdsvbqSoIP7IGL7Bk+Zu5fZ1oRtes
	lwLevNZB7P55AZJUJLmebizS//DmYvU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-KUK4moJfMgCUbjSZI3OGTQ-1; Tue,
 11 Nov 2025 09:02:46 -0500
X-MC-Unique: KUK4moJfMgCUbjSZI3OGTQ-1
X-Mimecast-MFC-AGG-ID: KUK4moJfMgCUbjSZI3OGTQ_1762869765
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F6301800561;
	Tue, 11 Nov 2025 14:02:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62B71195608E;
	Tue, 11 Nov 2025 14:02:44 +0000 (UTC)
Date: Tue, 11 Nov 2025 09:07:16 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: fs-next-20251103 reclaim lockdep splat
Message-ID: <aRNDFNenNDq3icjw@bfoster>
References: <aQux3yPwLFU42qof@casper.infradead.org>
 <aQu8B63pEAzGRAkj@dread.disaster.area>
 <aQySlxEJAHY5vVaC@bfoster>
 <aRJg-LcA8RGeqOgQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRJg-LcA8RGeqOgQ@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Nov 11, 2025 at 09:02:32AM +1100, Dave Chinner wrote:
> On Thu, Nov 06, 2025 at 07:20:39AM -0500, Brian Foster wrote:
> > On Thu, Nov 06, 2025 at 08:05:11AM +1100, Dave Chinner wrote:
> > > On Wed, Nov 05, 2025 at 08:21:51PM +0000, Matthew Wilcox wrote:
> > > > In trying to bisect the earlier reported transaction assertion failure,
> > > > I hit this:
> > > > 
> > > > generic/476       run fstests generic/476 at 2025-11-05 20:16:46
> ....
> > > As I said on #xfs: false positive on the inode lock.
> > > 
> > > Reclaim is running in GFP_KERNEL context, so it's allowed to lock
> > > unreferenced inodes.
> > > 
> > > The inodes that the allocation context holds locked are referenced
> > > inodes, so it cannot self-deadlock on the inode locks it holds
> > > because reclaim does not access or lock referenced inodes.
> > > 
> > > That being said, looking at this patch:
> > > 
> > > https://lore.kernel.org/linux-xfs/20251003134642.604736-4-bfoster@redhat.com/
> > > 
> > > I think the allocation that iomap_fill_dirty_folios() should
> > > probably be using mapping_gfp_constraint(mapping, GFP_KERNEL) rather
> > > than a hard coded GFP_KERNEL allocation. This is deep in the
> > > buffered write path and the xfs ILOCK is held when
> > > iomap_fill_dirty_folios() and it does folio lookups in that
> > > context.
> > > 
> > 
> > There's an outstanding patch to nuke this allocation completely:
> > 
> > https://lore.kernel.org/linux-fsdevel/20251016190303.53881-2-bfoster@redhat.com/
> > 
> > This was also problematic for the ext4 on iomap WIP, so combined with
> > the cleanup to use an iomap flag this seemed more elegant overall.
> 
> Ok, that looks like a good way to get rid of the allocation, so
> you can add
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> 
> to it.
> 

Thanks. I'll repost that one standalone since the rest of that series
still needs some work.

> > The patch series it's part of still needs work, but this one is just a
> > standalone cleanup. If I can get some acks on it I'm happy to repost it
> > separately to take this issue off the table..
> > 
> > > Huh - that kinda feels like a lock order violation. ILOCK is not
> > > supposed to be held when we do page cache operations as the lock
> > > order defined by writback operations is folio lookup -> folio lock
> > > -> ILOCK.
> > > 
> > > So maybe this is a problem here, but not the one lockdep flagged...
> > 
> > Yeah.. but filemap_get_folios_dirty() is somewhat advisory. It is
> > intended for use in this context, so only trylocks folios and those that
> > it cannot lock, it just assumes are dirty||writeback and includes them
> > in the batch for locking later (where later is defined as after the
> > iomap callback returns where iomap typically does folio lookup/lock for
> > buffered writes).
> 
> I guess I don't understand why this needs to be done under the
> ilock. I've read the patches, and it doesn't explain to me why we
> need to look up the pages under the ILOCK? The only constraint I see
> is trimming the extent map to match the end of a full fbatch array,
> but that doesn't seem like it can't be done by iomap itself.
> 
> Why do we need to do this dirty-folio batch lookup under the
> ILOCK instead of as a loop in iomap_zero_range() that grabs a fbatch
> for the unwritten mapping before calling iomap_zero_iter()
> repeatedly until we either hit the end of the mapping or there are
> no more dirty folios over the mapping?
> 

It doesn't need to be under ilock, just either under ilock or before
iomap_begin to rule out problematic inconsistency (i.e. seeing a clean
folio && unwritten mapping and racing with writeback). This was
discussed at multiple points during review of the original batch series.

The longer term prospects for this are to potentially use it for
multiple different operations, and therefore lift it into core iomap
(not necessarily just zero range). The reason it's done this way to
start was mainly just to manage scope and complexity. The use case is
bounded, so it was easiest to work this in where it is and defer
complexity associated with broader use to later.

That might sound pedantic, but when you consider things like dependent
changes like incremental iter advancement, the impedence mismatch
between some of these changes and the ext4-on-iomap WIP, and the little
issues that fall out of that, this is all much easier to develop,
support and improve with as little unnecessary complexity as possible. I
think when some of the kinks the rest of that series is trying to
address are worked out, that might be a reasonable point to consider
such a lift.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

