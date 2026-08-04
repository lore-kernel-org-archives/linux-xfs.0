Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C230B51E;
	Tue,  4 Aug 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868904; cv=none; b=hVJtySLInLeo9OeESeeq0syehP+Z6DMAuY1z4oM29aVRV+8S7pTfVxHPeePcCPTSRg9MK9RitbDj5PbBpWT+O6uiRFSLehw5cR8XxHd/xx3nynirmazc6OaAYVRCpXxwgvnv1Bn8f56NeBJcpHxZaXbGzrCkC0LbUUvrNwLbvo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868904; c=relaxed/simple;
	bh=xN8nCKEmW4hjoDheOXQmWQUo50r7ocJOL/O5h4P8AZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQTh+Jbz0jPULLv6fIpAQFKfdhqUi+Uiu93Pp8CgQ44nD7VWW1JGWWQJXeIBiGuh7i5YYbY+RtrY0f5ffycTodxKs3aSSNb/ogKa3d9LFT17povIebvkbVvNkFawtRBzh2CIXZDT9Y+Rqp+DLsLDZ6PnNqoevgcSvq0OQXACIJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UT4E+76w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UT4E+76w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 097801F000E9;
	Tue,  4 Aug 2026 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868903;
	bh=CcOPUKX8rDjF51pacbtTPJ2HM4I2gq6LHJid1kJuZR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UT4E+76wWY4LMGLuPVfYiSncUgwrPKQyqvY4HEjN110kG9sbtCz1y6fsINocC8yZ6
	 uSpDtR1dzUvzudZRh4/WbBZ6pXTV/ARnJv/tJTOBx929SAcZVg0BmUkJpVa6ui4PZH
	 BOSeqaeKqZ6dUMz6bhro3b8FCNjeqtk0EAQF6RBFeUsOx9cg0f0zXRvJAncuqiimPE
	 VexeJAgioOsr16vHB61UODQSlFOjTrxSazu/BqHJoZBHwAOZoc3g+2VUmb27p9tQ3T
	 hXddwZjohyn3XwEqtHqgEQOGiR7c5XAYifj4tdgQjpg+p+8utlMgHIQU2vZwPS/OJl
	 zhVahJlhXxeRw==
Date: Tue, 4 Aug 2026 11:41:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	brauner@kernel.org, hch@infradead.org, joannelkoong@gmail.com,
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v4 2/5] iomap: support invalidating partial folios
Message-ID: <20260804184142.GA3560084@frogsfrogsfrogs>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
 <20260714082325.325163-3-yi.zhang@huaweicloud.com>
 <a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com>
 <anH-WKA1coW6wtfG@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anH-WKA1coW6wtfG@bfoster>

On Tue, Aug 04, 2026 at 10:59:36AM -0400, Brian Foster wrote:
> On Mon, Aug 03, 2026 at 03:13:28PM +0800, Zhang Yi wrote:
> > On 7/14/2026 4:23 PM, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > Current iomap_invalidate_folio() can only invalidate an entire folio. If
> > > we truncate a partial folio on a filesystem where the block size is
> > > smaller than the folio size, it will leave behind dirty bits for the
> > > truncated or punched blocks. During the write-back process, it will
> > > attempt to map the invalid hole range. Fortunately, this has not caused
> > > any real problems so far because the ->writeback_range() function
> > > corrects the length.
> > > 
> > > However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> > > the support for invalidating partial folios. When ext4 partially zeroes
> > > out a dirty and unwritten folio, it does not perform a flush first like
> > > XFS. Therefore, if the dirty bits of the corresponding area cannot be
> > > cleared, the zeroed area after writeback remains in the written state
> > > rather than reverting to the unwritten state. Fix this by supporting
> > > invalidation of partial folios.
> > 
> > Hi all,
> > 
> > While working on the v5 of the ext4 iomap conversion series[1], I've
> > observed a rare data inconsistency issue in xfstests generic/127. After
> > debugging, I found that the root cause lies in the fact that the current
> > patch does not cover all scenarios when handling partial folio
> > invalidation during punch hole operations in cases where
> > block size < folio size. Specifically, the sub-folio dirty state is not
> > properly cleaned up in all cases. I think we need to discuss the fix,
> > and I'd like to hear your suggestions.
> > 
> > Root cause:
> > 
> > In both iomap buffered write and mmap write paths, if the write range
> > covers an entire folio (regardless of whether the folio size is larger
> > than block size), an ifs (iomap_folio_state) is not allocated
> > immediately. Instead, it is deferred until writeback time, where it gets
> > created in iomap_writeback_folio(). This creates a problem: when ext4
> > performs a punch or zero_range operation on a partial range within such
> > a dirty folio, there is no way to clear the dirty state for the
> > corresponding blocks.
> > 
> > This leads to two specific issues:
> > 
> > 1. After issuing FALLOC_FL_ZERO_RANGE on a range covering
> >    dirty+unwritten blocks within a large folio, the dirty state cannot
> >    be cleared. During subsequent writeback, zeroed data is still
> >    written back, and the final extent state for those blocks becomes
> >    written. As a result, the fix from this patch becomes ineffective in
> >    this case.
> > 
> 
> I suspect this may be (occasionally) the case even with an ifs. IIRC the
> folio batch stuff made a tradeoff for just zeroing any folio passed in
> from the fs that was determined to be dirty, regardless of whether
> underlying block aligned ranges may be unwritten and still clean.
> 
> I think this is relatively harmless so long as the underlying range
> returns zeroes from subsequent reads. The caveat may be if there are any
> cases where we have a really large folio and some small portion of it is
> dirtied and that causes some huge amount of unnecessary zeroing. I'm not
> sure if we've hit something like that in practice though..
> 
> > 2. The aforementioned rare data inconsistency in xfstests generic/127.
> >    When performing a partial folio punch hole on a dirty large folio,
> >    truncate_inode_pages_range() zeros the partial folio and then splits
> >    the folio. This causes an incorrect 'end' offset calculation in
> >    truncate_inode_pages_range(), which then results in all split folios
> >    being truncated via truncate_inode_folio(), turning partial valid
> >    data into zeroes.  For example:
> > 
> >    Suppose we have a large folio of 4 pages, and we punch a range
> >    starting from the beginning to the middle of the last page.
> >    truncate_inode_pages_range() will go through two rounds of splitting.
> >    Normally, if an ifs is present, the split path would hit
> >    folio_split() -> filemap_release_folio() -> iomap_release_folio(),
> >    which would intercept the operation and refuse splitting because the
> >    folio is dirty.
> > 
> >    However, without an ifs, filemap_release_folio() returns early via
> >    folio_needs_release(), causing the interception to fail. In the first
> >    round, the folio is split into 3 folios (1, 1, 2). In the second
> >    round, we expect to split into 4 folios (1, 1, 1, 1). If the second
> >    split succeeds, everything is fine, because
> >    truncate_inode_pages_range() calculates end = 3, and only the first 3
> >    folios are truncated. However, the second split is allowed to fail.
> >    If it does fail, truncate_inode_pages_range() still uses end = 3 and
> >    ends up truncating all 3 folios, resulting in data loss.
> > 
> 
> I was never really a huge fan of the ifs optimization thing, but I don't
> recall what the performance benefits really were.

IIRC at the time it was an optimization to avoid allocating an ifs for
the "uncommon" case of fsblock size < page size.  Then willy made it the
common case with large folios, so there's probably little point in
maintaining all this on/off complexity because large folios with no ifs
resulted in huge write amplification.

The only problem with always having an ifs is that splitting a large
folio with an ifs into smaller ones is (I think) currently not supported
because iomap doesn't know how to split the ifs and might not be able to
allocate the second one if memory is scarce.

--D

> That aside, doesn't this seem like more of a bug within the
> truncate_inode_pages_range() path? It's not clear to me if that's the
> only problem wrt iomap, but I'd think if the end offset split down in
> truncate_inode_partial_folio() fails, we should be able to return
> partial progress or something instead of a true/false for the whole
> thing. Would that allow this path to properly update the end index for
> the full truncate loop and at least prevent throwing away a folio with
> partial data like this?
> 
> Brian
> 
> > Now I remember I previously submitted two patches [2] that always
> > allocated an ifs in the iomap buffered write path and the mmap fault
> > path for the block size < folio size case. However, Christoph pointed
> > out that the iomap design intentionally defers ifs allocation to avoid
> > unnecessary overhead and improve performance, and suggested creating the
> > ifs in iomap_invalidate_folio() instead [3]. There is a hurdle, though:
> > iomap_invalidate_folio() is only called when the folio has private data
> > (in truncate_inode_partial_folio(), folio_needs_release() is called
> > first to check the private flag). So if we go with this approach, we
> > need to ensure that folio_invalidate() can be called even when the folio
> > does not have an ifs.
> > 
> > One relatively simple approach is to always set the AS_RELEASE_ALWAYS
> > flag on ext4 inodes that go through the iomap path. I don't think this
> > would introduce significant overhead, but it doesn't feel very generic.
> > 
> > Another approach is to modify truncate_inode_partial_folio(). Regarding
> > this, I don't want to introduce other magics to achieve this, so perhaps
> > modify truncate_inode_partial_folio() to check whether
> > i_blocks_per_folio > 1 before calling folio_invalidate(), and call it if
> > so.
> > 
> > So, what do people think? Any better idea?
> > 
> > Thanks,
> > Yi.
> > 
> > [1] https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v5-devel13/
> > [2] https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-4-yi.zhang@huaweicloud.com/
> >     https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-5-yi.zhang@huaweicloud.com/
> > [3] https://lore.kernel.org/linux-fsdevel/ZrxBfKi_DpThYo94@infradead.org/
> > 
> > 
> 
> 
