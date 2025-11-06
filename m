Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B762F4A0E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762431380; cv=none; b=pQdicpvHrWG9eD817qr1zYDpkLVTqrFQAzK3kHsb7Z0CT+SpAIH+dkfZe22+Tp1AxzBVVRqh7Ul1QobM6cfm7p6fjTkVWjOTcrhmOKQg4kNR7iTW4J/gGu37x1sZkM17ECdD9vSHnI/jDaTvZ4YtOtpCZx3Mu8As+txvjUTrqJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762431380; c=relaxed/simple;
	bh=brGVhGKIYhLqdIyrnFZCxoQNahZHIsBOqZoXGfwcdJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAo44novChdIWwE5fsrwWXPR8IGxUSMF1OtemHU0lTRHjvwRd1nv3c9Hdi2K+18GDZJhCgERATx/Xy5GmEev7OsDi+9SG7QWeHO0+p+GSNZQxS/4T5ijPq/3DNgT6rxAbqOJaMn1l2RkMKQ+RMmPcb1iXdoAxKuRUDVowartQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILo/m9Fv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILo/m9Fv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762431376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RrrHE/3uXi/LoadAoxGRw68uoXIj/KtEj1rNsF5H2cM=;
	b=ILo/m9FvC37SZQWuGNJzMWgGHcqrbSW6Xxd6F8xtgEvuH4zo7a2E5vf4F4V6FeTzwF6XWq
	fMrNAgwoSRQp3oDgu96dEBj3Tj+fr6EqJxUn+vNEMqYYtfNOHG/kit4ftAtLg3B8psQxkJ
	zcR3CLAdfKzh6fFk24ACvSNZX75IhPM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-LiH1g7IqPmOkKzhZFAHaxA-1; Thu,
 06 Nov 2025 07:16:13 -0500
X-MC-Unique: LiH1g7IqPmOkKzhZFAHaxA-1
X-Mimecast-MFC-AGG-ID: LiH1g7IqPmOkKzhZFAHaxA_1762431373
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD9BC1956094;
	Thu,  6 Nov 2025 12:16:11 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.135])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 340293001E83;
	Thu,  6 Nov 2025 12:16:10 +0000 (UTC)
Date: Thu, 6 Nov 2025 07:20:39 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: fs-next-20251103 reclaim lockdep splat
Message-ID: <aQySlxEJAHY5vVaC@bfoster>
References: <aQux3yPwLFU42qof@casper.infradead.org>
 <aQu8B63pEAzGRAkj@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQu8B63pEAzGRAkj@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Nov 06, 2025 at 08:05:11AM +1100, Dave Chinner wrote:
> On Wed, Nov 05, 2025 at 08:21:51PM +0000, Matthew Wilcox wrote:
> > In trying to bisect the earlier reported transaction assertion failure,
> > I hit this:
> > 
> > generic/476       run fstests generic/476 at 2025-11-05 20:16:46
> > XFS (vdb): Mounting V5 Filesystem 7f483353-a0f6-4710-9adc-4b72f25598f8
> > XFS (vdb): Ending clean mount
> > XFS (vdc): Mounting V5 Filesystem 47fa2f49-e8e1-4622-a62c-53ea07b3d714
> > XFS (vdc): Ending clean mount
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 6.18.0-rc4-ktest-00382-ga1e94de7fbd5 #116 Tainted: G        W
> > ------------------------------------------------------
> > kswapd0/111 is trying to acquire lock:
> > ffff888102462418 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x14b/0x2b0
> > 
> > but task is already holding lock:
> > ffffffff82710f00 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x3e0/0x780
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (fs_reclaim){+.+.}-{0:0}:
> >        fs_reclaim_acquire+0x67/0xa0
> >        __kmalloc_cache_noprof+0x4d/0x500
> >        iomap_fill_dirty_folios+0x6b/0xe0
> >        xfs_buffered_write_iomap_begin+0xaee/0x1060
> >        iomap_iter+0x1a1/0x4a0
> >        iomap_zero_range+0xb0/0x420
> >        xfs_zero_range+0x54/0x70
> >        xfs_file_write_checks+0x21d/0x320
> >        xfs_file_dio_write_unaligned+0x140/0x2b0
> >        xfs_file_write_iter+0x22a/0x270
> >        vfs_write+0x23f/0x540
> >        ksys_write+0x6d/0x100
> >        __x64_sys_write+0x1d/0x30
> >        x64_sys_call+0x7d/0x1da0
> >        do_syscall_64+0x6a/0x2e0
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > -> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
> >        __lock_acquire+0x15be/0x27d0
> >        lock_acquire+0xb2/0x290
> >        down_write_nested+0x2a/0xb0
> >        xfs_ilock+0x14b/0x2b0
> >        xfs_icwalk_ag+0x517/0xaf0
> >        xfs_icwalk+0x46/0x80
> >        xfs_reclaim_inodes_nr+0x8c/0xb0
> >        xfs_fs_free_cached_objects+0x1d/0x30
> >        super_cache_scan+0x178/0x1d0
> >        do_shrink_slab+0x16d/0x6a0
> >        shrink_slab+0x4cf/0x8c0
> >        shrink_node+0x334/0x870
> >        balance_pgdat+0x35f/0x780
> 
> As I said on #xfs: false positive on the inode lock.
> 
> Reclaim is running in GFP_KERNEL context, so it's allowed to lock
> unreferenced inodes.
> 
> The inodes that the allocation context holds locked are referenced
> inodes, so it cannot self-deadlock on the inode locks it holds
> because reclaim does not access or lock referenced inodes.
> 
> That being said, looking at this patch:
> 
> https://lore.kernel.org/linux-xfs/20251003134642.604736-4-bfoster@redhat.com/
> 
> I think the allocation that iomap_fill_dirty_folios() should
> probably be using mapping_gfp_constraint(mapping, GFP_KERNEL) rather
> than a hard coded GFP_KERNEL allocation. This is deep in the
> buffered write path and the xfs ILOCK is held when
> iomap_fill_dirty_folios() and it does folio lookups in that
> context.
> 

There's an outstanding patch to nuke this allocation completely:

https://lore.kernel.org/linux-fsdevel/20251016190303.53881-2-bfoster@redhat.com/

This was also problematic for the ext4 on iomap WIP, so combined with
the cleanup to use an iomap flag this seemed more elegant overall.

The patch series it's part of still needs work, but this one is just a
standalone cleanup. If I can get some acks on it I'm happy to repost it
separately to take this issue off the table..

> Huh - that kinda feels like a lock order violation. ILOCK is not
> supposed to be held when we do page cache operations as the lock
> order defined by writback operations is folio lookup -> folio lock
> -> ILOCK.
> 
> So maybe this is a problem here, but not the one lockdep flagged...
> 

Yeah.. but filemap_get_folios_dirty() is somewhat advisory. It is
intended for use in this context, so only trylocks folios and those that
it cannot lock, it just assumes are dirty||writeback and includes them
in the batch for locking later (where later is defined as after the
iomap callback returns where iomap typically does folio lookup/lock for
buffered writes).

Brian

> Brian?
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

