Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804751A267;
	Mon, 15 Sep 2025 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979634; cv=none; b=Rwg8lTFNlWq4pJIxaarPgw/R94obmIb6N9nni4S3kODo1PSPSmYQcYOzCCLOk5t3Wekt7ihfKK+VfSIvBdDk2qQlMEa+eBe9/6l1Vp+E43UYX9srxRYjwnFXWzYVg0nX87dxWupJ9o2U7rJIDIVMqOXcUJprXqrnP8el1ugrBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979634; c=relaxed/simple;
	bh=s9gaIDNQpFpJ/NdxlfswUF29RfCQahH7tUCg3I4JnyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JK8OTvfHLi7c9e3r5OWlaj4gn4YZJn9niOARIy2xo72V0t6yHcIiZjjozonipOYLgBnD1IlAG6tI8a4Sy0+5M6t8nOodV054o6ez/fbC3pyj5GXn76YFv9eMeiTzvU97k9ykXCBkLH5GV3YQ+Qv/aK7F5/XEpQ7LVOJGhTAVwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVgb0isJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVgb0isJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05807C4CEF1;
	Mon, 15 Sep 2025 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757979633;
	bh=s9gaIDNQpFpJ/NdxlfswUF29RfCQahH7tUCg3I4JnyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bVgb0isJGxvzR3J80oZ8JoYgxZZVUmvmpygyo52TIHQQEXn9rjJrIHVI2Vs+dQBz6
	 3tIq4ZUEyfmI8FQOdq57rbD26mbxXZfY1f15yRLpAiUxA3mGfRGMqDhuFPn3TBFm03
	 VayAmkie+yWjJQPlUy6wAkREF5mmz8/MBtZsAG9WH/o8K167Ev+Gt9lLbuWvipcujZ
	 bjpTZfapJqCRoTdxj1dFroHwEgAjLx2ZFSX1lV6CrZ2W9qSfLP+weoWb5nX9HafH1L
	 WrbBWSvCcj4KBNI+db8qbMXn6AliwzYV9ouDPI0RgV0G4skDiuglaW/XGBDTHM8C80
	 UmLqgcIUwMhMw==
Date: Mon, 15 Sep 2025 16:40:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
Message-ID: <20250915234032.GB8096@frogsfrogsfrogs>
References: <20250913030503.433914-1-amir73il@gmail.com>
 <20250915182056.GO8096@frogsfrogsfrogs>
 <CAOQ4uxg4eBMS-FQADVYLGVh66QfMO+tHDAv3TUSpKqXn==XdKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg4eBMS-FQADVYLGVh66QfMO+tHDAv3TUSpKqXn==XdKw@mail.gmail.com>

On Mon, Sep 15, 2025 at 10:20:40PM +0200, Amir Goldstein wrote:
> On Mon, Sep 15, 2025 at 8:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Sat, Sep 13, 2025 at 05:05:02AM +0200, Amir Goldstein wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > >
> > > [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
> > >
> > > With parent pointers enabled, a rename operation can update up to 5
> > > inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> > > their dquots to a be attached to the transaction chain, so we need
> > > to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> > > function xfs_dqlockn to lock an arbitrary number of dquots.
> > >
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > >
> > > [amir: backport to kernels prior to parent pointers to fix an old bug]
> > >
> > > A rename operation of a directory (i.e. mv A/C/ B/) may end up changing
> > > three different dquot accounts under the following conditions:
> > > 1. user (or group) quotas are enabled
> > > 2. A/ B/ and C/ have different owner uids (or gids)
> > > 3. A/ blocks shrinks after remove of entry C/
> > > 4. B/ blocks grows before adding of entry C/
> > > 5. A/ ino <= XFS_DIR2_MAX_SHORT_INUM
> > > 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> > > 7. C/ is converted from sf to block format, because its parent entry
> > >    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock)
> > >
> > > When all conditions are met (observed in the wild) we get this assertion:
> > >
> > > XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: 207
> > >
> > > The upstream commit fixed this bug as a side effect, so decided to apply
> > > it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable kernels.
> >
> > Heh.  Indeed, you only need MAXDQS==5 for filesystems that support
> > parent pointers, because only on those filesystems can you end up
> > needing to allocate a xattr block either to the new whiteout file or
> > free one from the file being unlinked.
> >
> > > The Fixes commit below is NOT the commit that introduced the bug, but
> > > for some reason, which is not explained in the commit message, it fixes
> > > the comment to state that highest number of dquots of one type is 3 and
> > > not 2 (which leads to the assertion), without actually fixing it.
> >
> > Agree.
> >
> > > The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> > > suggests that there may have been a confusion between "the number of
> > > dquote of one type" and "the number of dquot types" (which is also 3),
> > > so the comment change was only accidentally correct.
> >
> > I interpret the "OR" -> "and" change to reflect the V4 -> V5 transition
> > where you actually can have all three dquot types because group/project
> > quota are no longer mutually exclusive.
> >
> > The "...involved in a transaction is 3" part I think is separate, and
> > strange that XFS_QM_TRANS_MAXDQS wasn't updated.
> >
> > > Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dqlockedjoin")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Christoph,
> > >
> > > This is a cognitive challenge. can you say what you where thinking in
> > > 2013 when making the comment change in the Fixes commit?
> > > Is my speculation above correct?
> > >
> > > Catherine and Leah,
> > >
> > > I decided that cherry-pick this upstream commit as is with a commit
> > > message addendum was the best stable tree strategy.
> > > The commit applies cleanly to 5.15.y, so I assume it does for 6.6 and
> > > 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did not
> > > try to reproduce these complex assertion in a test.
> > >
> > > Could you take this candidate backport patch to a spin on your test
> > > branch?
> > >
> > > What do you all think about this?
> >
> > I only think you need MAXDQS==5 for 6.12 to handle parent pointers.
> >
> 
> Yes, of course. I just preferred to keep the 5 to avoid deviating from
> the upstream commit if there is no good reason to do so.

<shrug> What do Greg and Sasha think about this?  If they don't mind
this then I guess I don't either. ;)

> > The older kernels could have it set to 3 instead.  struct xfs_dqtrx on a
> > 6.17-rc6 kernel is 88 bytes.  Stuffing 9 of them into struct
> > xfs_dquot_acct instead of 15 means that the _acct struct is only 792
> > bytes instead of 1392, which means we can use the 1k slab instead of the
> > 2k slab.
> 
> Huh? there is only one xfs_dquot_acct per transaction.

Yes, but there can be a lot of transactions in flight.

> Does it really matter if it's 1k or 2k??
> 
> Am I missing something?

It seems silly to waste so much memory on a scenario that can't happen
just so we can say that we hammered in a less appropriate solution.

--D

> Thanks,
> Amir.
> 
