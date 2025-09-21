Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AE155C82;
	Sun, 21 Sep 2025 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758474988; cv=none; b=djPJhgn/Ve4usCzcdl7lYM0GpT62E9ObL1rMRJr4743sJOC/ejvlj+0sHuwqIx8SATbqnplhOE2sxR5DCMbH4fP6j7NEn0dyLZmYbINekkm3316sVw8mgp9Xrjffkylm0zHij1dLWEoeNuWZwW5Nr/P/jL7P0yA2AqaIdjQlusw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758474988; c=relaxed/simple;
	bh=UPXswAUSrZIxzSDUJryHz5yqoPHslofeNlXxxCUxl8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6gP363ytr9t0IrXbHFzbz3Sb4NeVp0NEa2PbNeij02XHqF1V7wbneKGjJmchozE3s+nsG0le/Kx8duMwwLoN2aF9lhVfk2hhthjsYdJduN+vYlpTRqccurNXHUtksS6UeCE8IWi+yfvo/KgIQ5fa/5fz62Oms1LAcxmcDl5CzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhL+rBVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhL+rBVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494BBC4CEE7;
	Sun, 21 Sep 2025 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758474987;
	bh=UPXswAUSrZIxzSDUJryHz5yqoPHslofeNlXxxCUxl8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhL+rBVIPWaz6ZayE5ZqlDam9e/8JD2px7feqUcX90E1l+iaCXOMdlIEMIHZZdLdt
	 mkCXktvqBAlUW+5YUcyUGBVxbWMFMjQ55FnM8wp6A3xs1MWplmTNsTy6A1ZmIXBkJh
	 rFH8aGSLvTqmf7Eld+DQLeY81jdDu5nDKw+YIu7E=
Date: Sun, 21 Sep 2025 19:16:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
Message-ID: <2025092158-marine-whoops-230b@gregkh>
References: <20250913030503.433914-1-amir73il@gmail.com>
 <20250915182056.GO8096@frogsfrogsfrogs>
 <CAOQ4uxg4eBMS-FQADVYLGVh66QfMO+tHDAv3TUSpKqXn==XdKw@mail.gmail.com>
 <20250915234032.GB8096@frogsfrogsfrogs>
 <CAOQ4uxh00vdYLs24aMTonCNJ0wnmudwysxaJQa95-iq7zziD4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh00vdYLs24aMTonCNJ0wnmudwysxaJQa95-iq7zziD4Q@mail.gmail.com>

On Tue, Sep 16, 2025 at 08:37:54AM +0200, Amir Goldstein wrote:
> On Tue, Sep 16, 2025 at 1:40 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Sep 15, 2025 at 10:20:40PM +0200, Amir Goldstein wrote:
> > > On Mon, Sep 15, 2025 at 8:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Sat, Sep 13, 2025 at 05:05:02AM +0200, Amir Goldstein wrote:
> > > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > > >
> > > > > [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
> > > > >
> > > > > With parent pointers enabled, a rename operation can update up to 5
> > > > > inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> > > > > their dquots to a be attached to the transaction chain, so we need
> > > > > to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> > > > > function xfs_dqlockn to lock an arbitrary number of dquots.
> > > > >
> > > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > >
> > > > > [amir: backport to kernels prior to parent pointers to fix an old bug]
> > > > >
> > > > > A rename operation of a directory (i.e. mv A/C/ B/) may end up changing
> > > > > three different dquot accounts under the following conditions:
> > > > > 1. user (or group) quotas are enabled
> > > > > 2. A/ B/ and C/ have different owner uids (or gids)
> > > > > 3. A/ blocks shrinks after remove of entry C/
> > > > > 4. B/ blocks grows before adding of entry C/
> > > > > 5. A/ ino <= XFS_DIR2_MAX_SHORT_INUM
> > > > > 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> > > > > 7. C/ is converted from sf to block format, because its parent entry
> > > > >    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock)
> > > > >
> > > > > When all conditions are met (observed in the wild) we get this assertion:
> > > > >
> > > > > XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: 207
> > > > >
> > > > > The upstream commit fixed this bug as a side effect, so decided to apply
> > > > > it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable kernels.
> > > >
> > > > Heh.  Indeed, you only need MAXDQS==5 for filesystems that support
> > > > parent pointers, because only on those filesystems can you end up
> > > > needing to allocate a xattr block either to the new whiteout file or
> > > > free one from the file being unlinked.
> > > >
> > > > > The Fixes commit below is NOT the commit that introduced the bug, but
> > > > > for some reason, which is not explained in the commit message, it fixes
> > > > > the comment to state that highest number of dquots of one type is 3 and
> > > > > not 2 (which leads to the assertion), without actually fixing it.
> > > >
> > > > Agree.
> > > >
> > > > > The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> > > > > suggests that there may have been a confusion between "the number of
> > > > > dquote of one type" and "the number of dquot types" (which is also 3),
> > > > > so the comment change was only accidentally correct.
> > > >
> > > > I interpret the "OR" -> "and" change to reflect the V4 -> V5 transition
> > > > where you actually can have all three dquot types because group/project
> > > > quota are no longer mutually exclusive.
> > > >
> > > > The "...involved in a transaction is 3" part I think is separate, and
> > > > strange that XFS_QM_TRANS_MAXDQS wasn't updated.
> > > >
> > > > > Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dqlockedjoin")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >
> > > > > Christoph,
> > > > >
> > > > > This is a cognitive challenge. can you say what you where thinking in
> > > > > 2013 when making the comment change in the Fixes commit?
> > > > > Is my speculation above correct?
> > > > >
> > > > > Catherine and Leah,
> > > > >
> > > > > I decided that cherry-pick this upstream commit as is with a commit
> > > > > message addendum was the best stable tree strategy.
> > > > > The commit applies cleanly to 5.15.y, so I assume it does for 6.6 and
> > > > > 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did not
> > > > > try to reproduce these complex assertion in a test.
> > > > >
> > > > > Could you take this candidate backport patch to a spin on your test
> > > > > branch?
> > > > >
> > > > > What do you all think about this?
> > > >
> > > > I only think you need MAXDQS==5 for 6.12 to handle parent pointers.
> > > >
> > >
> > > Yes, of course. I just preferred to keep the 5 to avoid deviating from
> > > the upstream commit if there is no good reason to do so.
> >
> > <shrug> What do Greg and Sasha think about this?  If they don't mind
> > this then I guess I don't either. ;)
> >
> 
> Ok let's see.
> 
> Greg,
> 
> In kernels < 6.10 the size of the 'dqs' array per transaction was too small
> (XFS_QM_TRANS_MAXDQS is 2 instead of 3) which can, as explained
> in my commit, cause an assertion and crash the kernel.
> 
> This bug exists for a long time, it may have low probability for the entire
> "world", but under specific conditions (e.g. a specific workload that is fully
> controlled by unpriv user) it happens for us every other week on kernel 5.15.y
> and with more effort, an upriv user can trigger it much more frequently.
> 
> In kernel 6.10, XFS_QM_TRANS_MAXDQS was increased to 5 to
> cover a use case for a new feature (parent pointer).
> That means that upstream no longer has the bug.
> 
> I opted for applying this upstream commit to fix the stable kernel bug
> although raising the max to 5 is an overkill.
> 
> This has a slight impact on memory footprint, but I think it is negligible
> and in any case, same exact memory footprint as upstream code.
> 
> What do you prefer? Applying the commit as is with increase to 5
> or apply a customized commit for kernels < 6.10 which raises the
> max to 3 without mentioning the upstream commit?
> 
> If you agree with my choice, please advise regarding my choice of
> formatting of the commit message - original commit message followed
> by stable specific bug fix commit message which explains the above.

Original message followed by stable specific bugfix seems to make sense
to me, thanks!

greg k-h
