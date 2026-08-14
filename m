Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B185499F2B;
	Fri, 14 Aug 2026 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786731891; cv=none; b=anmLA2hj4OuVm14KagjlZjB/jAUYY7yIH+l9LSB3fM1p3EGko0bd0mnFJy6jBsjihUwcKM9hRx9o4TzGF9QV7iMhWsmWXSVGih2IcRLU0Mtz+K98SD2ccsGoUzWj+/ASVVtyBPkPy2abBaCTCc9LYh6vCPq1TdIdnaWkH0dQphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786731891; c=relaxed/simple;
	bh=3Xu+L9Kty7aK3QvAGkti7EEV6m/SzoZy3UUTi8caGrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHxQLbv78ivf+odhYtUzAwWJdglkMJjOHA4obR1STNKGVjErVsS156woSG1HUcQIMnokPc0e0BfcAIk/Z7BrnOv55GTzPjcdOW5NIvg1BXPCEKVc61mw4wAfX3Hc604H+1CrGcG2Pnl1rrRJx12HaA7BTHfv14C2fKLmub61mVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5d29nMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5d29nMM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E78F51F000E9;
	Fri, 14 Aug 2026 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786731890;
	bh=t1liPiXQyEl6o95GIL+d8GIdkHZGUn1hZ1oabuIg1O0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I5d29nMMP7JjkvAqo6eWnduKyZkSSVRIVzSGfEFIAl64flYehNisiwCyZ34uWGabV
	 38lotYf5Z2xtUpP6HeX9zLxpG9cU4J1JbFAYHU8WNT20VtFL6i0ykTl66srYvVeNat
	 fzh7zf56mCMjq1U8hX68pjPvBVyaEJlaP26PkeomB+AsI/nVPCC4Rc8pMFMgYWVIuc
	 NlGdHdR8LH+AOXGsHlBjG7nTrpJ4mk6kH0jbP2qa08ySKSC9SqUuEItZOtpNpibh82
	 yneJZzhTDPnzQDoTFP0+nbLPLgbrMN65JR2+eqRze9B/T3XT9t7Tw9u4Ewriatbt+y
	 Ggfq+LpCOtUsg==
Date: Fri, 14 Aug 2026 11:24:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <20260814182449.GI3556460@frogsfrogsfrogs>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com>
 <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
 <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
 <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
 <an7Dk2Tn1ibCRsv2@infradead.org>
 <an9BQdSqrmzYhB3l@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an9BQdSqrmzYhB3l@andromeda.toxiclabs.cc>

On Fri, Aug 14, 2026 at 06:25:41PM +0200, Carlos Maiolino wrote:
> On Fri, Aug 14, 2026 at 12:28:19AM -0700, Christoph Hellwig wrote:
> > On Thu, Aug 13, 2026 at 09:43:44PM +0530, Aditya Prakash Srivastava wrote:
> > > 
> > > Are there any remaining concerns or feedback that need
> > > to be addressed with this patch?
> > 
> > Still looks good to me, but I think it just go lost.  It's a bit close
> > for the 7.3 merge window now, but I'd suggest you resend it in a week
> > or two to get it onto the agenda for 7.4 early.
> 
> Yup, I was waiting for Darrick to follow-up then it fell on limbo.
> Please follow Christoph's advice, please rebase and re-send on top of
> the tree after 7.3 merge window.

I ignored the response because it's clearly AI slop, and obviously
wrong.

"In XFS, the canonical locking hierarchy is:

"sb_start_write (freeze lock) -> IOLOCK -> ILOCK ->
xfs_trans_alloc"

Nope.

"xfs_file_release() already holds XFS_IOLOCK_EXCL (acquired via
xfs_ilock_nowait())..."

Nope.  The snippet I suggested isn't fully formed, but this is obviously
wrong; go read xfs_file_release.

static inline void xfs_file_release_eofblocks(struct xfs_inode *ip)
{
	if (!xfs_can_free_eofblocks(ip))
		return;
	if (xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED))
		return;

	/* take freeze protection and i_rwsem */
	if (!sb_start_write_trylock(...))
		return;
	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
		goto out_sb_write;

	/*
	 * recheck if we want to trim eofblocks and someone else hasn't
	 * already done this
	 */
	if (!xfs_can_free_eofblocks(ip))
		goto out_iolock;
	if (xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
		goto out_iolock;

	xfs_free_eofblocks(ip);

out_iolock:
	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
out_sb_write:
	sb_end_write(...);
}

"xfs_trans_alloc() is the canonical, centralized place in XFS to
manage write-count blocking semantics."

Nope.  This isn't even talking about the same vfs lock here.

--D
