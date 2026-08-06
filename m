Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449EA47A885
	for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2026 12:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018726; cv=none; b=gyGrghCosbb7PyAf+Ue+QOOCeYeXXeMeDy6LJheIxdGrQXUY/PRDvWcSMNB8rNleW5WU/6Kmdl9rZePG7FJTyUJfTVtsallIqYSkmO0wvw6ZREzNoRlh2IBIAKgNMqejvmnuTwc0kdmnxI09Hon65cKueIVEtER7sM9WqHJG7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018726; c=relaxed/simple;
	bh=M1MegnHzV73grper8Ny/IvBLmgNiJ5172cKqmQGZWwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGWCFMcZSWULPo7FSLNW3aMespMDoRXFtNRbGe4P++SK99Z1bEQLp2C8StoPrqXtcLXdf+dZJqXZfddc+BaVWVKkFivjn34NQ/Bbeq8i/h4AvI9XmQEfclHQ/lPcvwRwxxGMtAebBtg3TPkxJSHdXJnalDnsXUAfyYAkIfe1BhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dUW617Y2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUW617Y2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786018720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fzebfzj2r5MvZp6xkUR1tS7BFg5VZp9XY03lp902VFw=;
	b=dUW617Y2Cxk4n7jE5WVMDlBkF19P6oqJwnqeR6X3v3HM8+H07UTXXVCz5b1G0NC1wN+ce4
	HuNWmiAjtkOAiBa92wF4fLvauff7OE+v5yH/r0Ck/5lREHFYqyTfNCwHegYc1KMbVcY7S5
	0ph0tGuw8IKMzo/gyHfXcVwbdKvns6w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-uhnALEEQNHiKhJnMRBnydg-1; Thu,
 06 Aug 2026 08:18:36 -0400
X-MC-Unique: uhnALEEQNHiKhJnMRBnydg-1
X-Mimecast-MFC-AGG-ID: uhnALEEQNHiKhJnMRBnydg_1786018714
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E8AA1955E70;
	Thu,  6 Aug 2026 12:18:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.193])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9C21422;
	Thu,  6 Aug 2026 12:18:29 +0000 (UTC)
Date: Thu, 6 Aug 2026 08:18:27 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	brauner@kernel.org, hch@infradead.org, joannelkoong@gmail.com,
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v4 2/5] iomap: support invalidating partial folios
Message-ID: <anR7k9Nt8Qa0NduG@bfoster>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <20260714082325.325163-3-yi.zhang@huaweicloud.com>
 <a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com>
 <anH-WKA1coW6wtfG@bfoster>
 <20260804184142.GA3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804184142.GA3560084@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Tue, Aug 04, 2026 at 11:41:42AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 04, 2026 at 10:59:36AM -0400, Brian Foster wrote:
> > On Mon, Aug 03, 2026 at 03:13:28PM +0800, Zhang Yi wrote:
> > > On 7/14/2026 4:23 PM, Zhang Yi wrote:
> > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > 
> > > > Current iomap_invalidate_folio() can only invalidate an entire folio. If
> > > > we truncate a partial folio on a filesystem where the block size is
> > > > smaller than the folio size, it will leave behind dirty bits for the
> > > > truncated or punched blocks. During the write-back process, it will
> > > > attempt to map the invalid hole range. Fortunately, this has not caused
> > > > any real problems so far because the ->writeback_range() function
> > > > corrects the length.
> > > > 
> > > > However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> > > > the support for invalidating partial folios. When ext4 partially zeroes
> > > > out a dirty and unwritten folio, it does not perform a flush first like
> > > > XFS. Therefore, if the dirty bits of the corresponding area cannot be
> > > > cleared, the zeroed area after writeback remains in the written state
> > > > rather than reverting to the unwritten state. Fix this by supporting
> > > > invalidation of partial folios.
> > > 
> > > Hi all,
> > > 
> > > While working on the v5 of the ext4 iomap conversion series[1], I've
> > > observed a rare data inconsistency issue in xfstests generic/127. After
> > > debugging, I found that the root cause lies in the fact that the current
> > > patch does not cover all scenarios when handling partial folio
> > > invalidation during punch hole operations in cases where
> > > block size < folio size. Specifically, the sub-folio dirty state is not
> > > properly cleaned up in all cases. I think we need to discuss the fix,
> > > and I'd like to hear your suggestions.
> > > 
> > > Root cause:
> > > 
> > > In both iomap buffered write and mmap write paths, if the write range
> > > covers an entire folio (regardless of whether the folio size is larger
> > > than block size), an ifs (iomap_folio_state) is not allocated
> > > immediately. Instead, it is deferred until writeback time, where it gets
> > > created in iomap_writeback_folio(). This creates a problem: when ext4
> > > performs a punch or zero_range operation on a partial range within such
> > > a dirty folio, there is no way to clear the dirty state for the
> > > corresponding blocks.
> > > 
> > > This leads to two specific issues:
> > > 
> > > 1. After issuing FALLOC_FL_ZERO_RANGE on a range covering
> > >    dirty+unwritten blocks within a large folio, the dirty state cannot
> > >    be cleared. During subsequent writeback, zeroed data is still
> > >    written back, and the final extent state for those blocks becomes
> > >    written. As a result, the fix from this patch becomes ineffective in
> > >    this case.
> > > 
> > 
> > I suspect this may be (occasionally) the case even with an ifs. IIRC the
> > folio batch stuff made a tradeoff for just zeroing any folio passed in
> > from the fs that was determined to be dirty, regardless of whether
> > underlying block aligned ranges may be unwritten and still clean.
> > 
> > I think this is relatively harmless so long as the underlying range
> > returns zeroes from subsequent reads. The caveat may be if there are any
> > cases where we have a really large folio and some small portion of it is
> > dirtied and that causes some huge amount of unnecessary zeroing. I'm not
> > sure if we've hit something like that in practice though..
> > 
> > > 2. The aforementioned rare data inconsistency in xfstests generic/127.
> > >    When performing a partial folio punch hole on a dirty large folio,
> > >    truncate_inode_pages_range() zeros the partial folio and then splits
> > >    the folio. This causes an incorrect 'end' offset calculation in
> > >    truncate_inode_pages_range(), which then results in all split folios
> > >    being truncated via truncate_inode_folio(), turning partial valid
> > >    data into zeroes.  For example:
> > > 
> > >    Suppose we have a large folio of 4 pages, and we punch a range
> > >    starting from the beginning to the middle of the last page.
> > >    truncate_inode_pages_range() will go through two rounds of splitting.
> > >    Normally, if an ifs is present, the split path would hit
> > >    folio_split() -> filemap_release_folio() -> iomap_release_folio(),
> > >    which would intercept the operation and refuse splitting because the
> > >    folio is dirty.
> > > 
> > >    However, without an ifs, filemap_release_folio() returns early via
> > >    folio_needs_release(), causing the interception to fail. In the first
> > >    round, the folio is split into 3 folios (1, 1, 2). In the second
> > >    round, we expect to split into 4 folios (1, 1, 1, 1). If the second
> > >    split succeeds, everything is fine, because
> > >    truncate_inode_pages_range() calculates end = 3, and only the first 3
> > >    folios are truncated. However, the second split is allowed to fail.
> > >    If it does fail, truncate_inode_pages_range() still uses end = 3 and
> > >    ends up truncating all 3 folios, resulting in data loss.
> > > 
> > 
> > I was never really a huge fan of the ifs optimization thing, but I don't
> > recall what the performance benefits really were.
> 
> IIRC at the time it was an optimization to avoid allocating an ifs for
> the "uncommon" case of fsblock size < page size.  Then willy made it the
> common case with large folios, so there's probably little point in
> maintaining all this on/off complexity because large folios with no ifs
> resulted in huge write amplification.
> 
> The only problem with always having an ifs is that splitting a large
> folio with an ifs into smaller ones is (I think) currently not supported
> because iomap doesn't know how to split the ifs and might not be able to
> allocate the second one if memory is scarce.
> 

I see.. Zhang Yi touches on this in the other reply as well.

I wonder how critical this behavior really is to the large folio case,
particularly if the base case is block size == page size and we wouldn't
need the ifs at all. I'd think if we're under memory pressure then at
some point writeback will trigger anyways and allow a release and split
to proceed..?

Brian

> --D
> 
> > That aside, doesn't this seem like more of a bug within the
> > truncate_inode_pages_range() path? It's not clear to me if that's the
> > only problem wrt iomap, but I'd think if the end offset split down in
> > truncate_inode_partial_folio() fails, we should be able to return
> > partial progress or something instead of a true/false for the whole
> > thing. Would that allow this path to properly update the end index for
> > the full truncate loop and at least prevent throwing away a folio with
> > partial data like this?
> > 
> > Brian
> > 
> > > Now I remember I previously submitted two patches [2] that always
> > > allocated an ifs in the iomap buffered write path and the mmap fault
> > > path for the block size < folio size case. However, Christoph pointed
> > > out that the iomap design intentionally defers ifs allocation to avoid
> > > unnecessary overhead and improve performance, and suggested creating the
> > > ifs in iomap_invalidate_folio() instead [3]. There is a hurdle, though:
> > > iomap_invalidate_folio() is only called when the folio has private data
> > > (in truncate_inode_partial_folio(), folio_needs_release() is called
> > > first to check the private flag). So if we go with this approach, we
> > > need to ensure that folio_invalidate() can be called even when the folio
> > > does not have an ifs.
> > > 
> > > One relatively simple approach is to always set the AS_RELEASE_ALWAYS
> > > flag on ext4 inodes that go through the iomap path. I don't think this
> > > would introduce significant overhead, but it doesn't feel very generic.
> > > 
> > > Another approach is to modify truncate_inode_partial_folio(). Regarding
> > > this, I don't want to introduce other magics to achieve this, so perhaps
> > > modify truncate_inode_partial_folio() to check whether
> > > i_blocks_per_folio > 1 before calling folio_invalidate(), and call it if
> > > so.
> > > 
> > > So, what do people think? Any better idea?
> > > 
> > > Thanks,
> > > Yi.
> > > 
> > > [1] https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v5-devel13/
> > > [2] https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-4-yi.zhang@huaweicloud.com/
> > >     https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-5-yi.zhang@huaweicloud.com/
> > > [3] https://lore.kernel.org/linux-fsdevel/ZrxBfKi_DpThYo94@infradead.org/
> > > 
> > > 
> > 
> > 
> 

