Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E61A2E64B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726662112; cv=none; b=GmkmKJnl2MOt0J/4viNjAUOf2qVnXUKN335dwLfxLsWIknDRlvO2+p0FsdcLLbZyOsqD/hNNDS8/8CclsINkBSUKjAEX/0CNz1T9AQ8Z72kNAZsywugFTEsPPfuGfJna4DsIuv6kTW4MeGebqlBY83LuMe0YtqrHrEAGVecWO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726662112; c=relaxed/simple;
	bh=PIH2MVmpa479jBpT5qS04GGWMKGVCk3tdH8HlcGhZpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXmBG1Q0QYQO1IiR5z2UMHcUxCBhfqO1hkUApiWly1iXY8ScFFsKg2yWZ9UvcekJN49wqcMiHVYEfJGlC4dWrn1hwMRd90URC9O1L4BIT6mrLvX/VX+OcMxkHbZHWxQSJ48xg2KPJozQFYfkpuKKSApEVQH0eDL25kBnCmsWv1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5ZiV9Eg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5ZiV9Eg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726662109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnYfNYNvKzMtBisGm5i7LLVAYcterxx3NjCo+s4EHuc=;
	b=C5ZiV9EgaW1CenOram2yGAw6UXTOpjNBQg21GiykmnrbIEXcXWLf7UxRgbwx5Q9eT0iLJv
	4RWW0eZBhfnGMiJoCIKq+zyvhyEPXhVN/g1hGS9mVehSRuWXEuRVz5MFj6CPHEJmxCwGjr
	wykzoA0e2vvDaOKoj+14Ct2u3IxhydY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-DZQp13IBM2i8HE6Q3vERpw-1; Wed,
 18 Sep 2024 08:21:47 -0400
X-MC-Unique: DZQp13IBM2i8HE6Q3vERpw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6E9C19773FC;
	Wed, 18 Sep 2024 12:21:37 +0000 (UTC)
Received: from bfoster (unknown [10.22.9.175])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00A65195608A;
	Wed, 18 Sep 2024 12:21:36 +0000 (UTC)
Date: Wed, 18 Sep 2024 08:22:43 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/1] xfs: don't free cowblocks from under dirty pagecache
 on unshare
Message-ID: <ZurGE3Cn0LNZMVOn@bfoster>
References: <20240903124713.23289-1-bfoster@redhat.com>
 <20240906114051.120743-1-bfoster@redhat.com>
 <20240917183142.GI182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917183142.GI182194@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Sep 17, 2024 at 11:31:42AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 06, 2024 at 07:40:51AM -0400, Brian Foster wrote:
> > fallocate unshare mode explicitly breaks extent sharing. When a
> > command completes, it checks the data fork for any remaining shared
> > extents to determine whether the reflink inode flag and COW fork
> > preallocation can be removed. This logic doesn't consider in-core
> > pagecache and I/O state, however, which means we can unsafely remove
> > COW fork blocks that are still needed under certain conditions.
> > 
> > For example, consider the following command sequence:
> > 
> > xfs_io -fc "pwrite 0 1k" -c "reflink <file> 0 256k 1k" \
> > 	-c "pwrite 0 32k" -c "funshare 0 1k" <file>
> > 
> > This allocates a data block at offset 0, shares it, and then
> > overwrites it with a larger buffered write. The overwrite triggers
> > COW fork preallocation, 32 blocks by default, which maps the entire
> > 32k write to delalloc in the COW fork. All but the shared block at
> > offset 0 remains hole mapped in the data fork. The unshare command
> > redirties and flushes the folio at offset 0, removing the only
> > shared extent from the inode. Since the inode no longer maps shared
> > extents, unshare purges the COW fork before the remaining 28k may
> > have written back.
> > 
> > This leaves dirty pagecache backed by holes, which writeback quietly
> > skips, thus leaving clean, non-zeroed pagecache over holes in the
> > file. To verify, fiemap shows holes in the first 32k of the file and
> > reads return different data across a remount:
> > 
> > $ xfs_io -c "fiemap -v" <file>
> > <file>:
> >  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
> >    ...
> >    1: [8..511]:        hole               504
> >    ...
> > $ xfs_io -c "pread -v 4k 8" <file>
> > 00001000:  cd cd cd cd cd cd cd cd  ........
> > $ umount <mnt>; mount <dev> <mnt>
> > $ xfs_io -c "pread -v 4k 8" <file>
> > 00001000:  00 00 00 00 00 00 00 00  ........
> > 
> > To avoid this problem, make unshare follow the same rules used for
> > background cowblock scanning and never purge the COW fork for inodes
> > with dirty pagecache or in-flight I/O.
> > 
> > Fixes: 46afb0628b ("xfs: only flush the unshared range in xfs_reflink_unshare")
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Question: Does xfs_repair report orphaned cow staging blocks after this?
> There's a longstanding bug that I've seen in the long soak xfs/286 VM
> where we slowly leak cow fork blocks (~80 per ~1 billion fsxops over 7
> days).
> 

I've not seen that, at least in the test case I have. I think what's
happening here is more that we clean up the COW fork correctly from an
accounting standpoint, but we do so prematurely because the pagecache is
dirty in ranges that are still only backed by COW fork blocks.

> Anyhow this looks correct on its own so
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 

Thanks!

Brian

> --D
> 
> > ---
> > 
> > Here's another COW issue I came across via some unshare testing. A quick
> > hack to enable unshare in fsx uncovered it. I'll follow up with a proper
> > patch for that.
> > 
> > I'm sending this as a 2/1 here just to reflect patch order in my local
> > tree. Also note that I haven't explicitly tested the fixes commit, but a
> > quick test to switch back to the old full flush behavior on latest
> > master also makes the problem go away, so I suspect that's where the
> > regression was introduced.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_icache.c  |  8 +-------
> >  fs/xfs/xfs_reflink.c |  3 +++
> >  fs/xfs/xfs_reflink.h | 19 +++++++++++++++++++
> >  3 files changed, 23 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 900a6277d931..a1b34e6ccfe2 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1278,13 +1278,7 @@ xfs_prep_free_cowblocks(
> >  	 */
> >  	if (!sync && inode_is_open_for_write(VFS_I(ip)))
> >  		return false;
> > -	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> > -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> > -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> > -	    atomic_read(&VFS_I(ip)->i_dio_count))
> > -		return false;
> > -
> > -	return true;
> > +	return xfs_can_free_cowblocks(ip);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 6fde6ec8092f..5bf6682e701b 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1595,6 +1595,9 @@ xfs_reflink_clear_inode_flag(
> >  
> >  	ASSERT(xfs_is_reflink_inode(ip));
> >  
> > +	if (!xfs_can_free_cowblocks(ip))
> > +		return 0;
> > +
> >  	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
> >  	if (error || needs_flag)
> >  		return error;
> > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > index fb55e4ce49fa..4a58e4533671 100644
> > --- a/fs/xfs/xfs_reflink.h
> > +++ b/fs/xfs/xfs_reflink.h
> > @@ -6,6 +6,25 @@
> >  #ifndef __XFS_REFLINK_H
> >  #define __XFS_REFLINK_H 1
> >  
> > +/*
> > + * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
> > + * to do so when an inode has dirty cache or I/O in-flight, even if no shared
> > + * extents exist in the data fork, because outstanding I/O may target blocks
> > + * that were speculatively allocated to the COW fork.
> > + */
> > +static inline bool
> > +xfs_can_free_cowblocks(struct xfs_inode *ip)
> > +{
> > +	struct inode *inode = VFS_I(ip);
> > +
> > +	if ((inode->i_state & I_DIRTY_PAGES) ||
> > +	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
> > +	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> > +	    atomic_read(&inode->i_dio_count))
> > +		return false;
> > +	return true;
> > +}
> > +
> >  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
> >  		struct xfs_bmbt_irec *irec, bool *shared);
> >  int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> > -- 
> > 2.45.0
> > 
> > 
> 

