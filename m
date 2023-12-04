Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEA22FC3C
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AP6cw23+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F40C433C7;
	Mon,  4 Dec 2023 20:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701723134;
	bh=a5TTpGwT+FdxpujXJdH/44X3S2Nkq4QqeWcEmEVViUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AP6cw23+Q2kwj6p6YmowTdqhULOHWH19bYdwzVrAkH5Oj9w2AyjVlHxqKQUhn0oeU
	 UM8FvgYn1ssyb0niAiCP14GbZzNVyqr8SOi3WO34MgnVV6RS2+9+3R+0efbqhmFZ5F
	 E3XkDNAuwWNiyaUS2j1K0PFPo2MSWAkLxiziQsXQfvVVGf5xc4SHlsVENslNVIVADU
	 /vNohybihP8Iy67GMz08uTn10kzLR2LGcC7IWYIBBwozCUSQeK2+4uF0mFphLkYahg
	 2BtCPcPRhdT4KOVrOzHUxmHlvy6eoEG1TXxR1MoYGkLNbW9JrCy0+MRc4y5/B888OL
	 l67JDBRpQGieg==
Date: Mon, 4 Dec 2023 12:52:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <20231204205214.GI361584@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
 <20231130221015.GR361584@frogsfrogsfrogs>
 <ZW1aFIC1OxfApK5z@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW1aFIC1OxfApK5z@infradead.org>

On Sun, Dec 03, 2023 at 08:48:20PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 30, 2023 at 02:10:15PM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 29, 2023 at 09:33:41PM -0800, Christoph Hellwig wrote:
> > > > @@ -328,7 +328,6 @@ xchk_quota(
> > > >  		if (error)
> > > >  			break;
> > > >  	}
> > > > -	xchk_ilock(sc, XFS_ILOCK_EXCL);
> > > >  	if (error == -ECANCELED)
> > > >  		error = 0;
> > > >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
> > > 
> > > What is the replacement for this lock?  The call in xrep_quota_item?
> > 
> > The replacement is the conditional re-lock at the start of xrep_quota.
> 
> Hmm.  but not all scrub calls do even end up in the repair callbacks,
> do they?  Ok, I guess the xchk_iunlock call in xchk_teardown would have
> just released it a bit later and we skip the cycle.  Would have been
> a lot easier to understand if this was in a well-explained
> self-contained patch..

How about I not remove the xchk_ilock call, then?  Repair is already
smart enough to take the lock if it doesn't have it, so it's not
strictly necessary for correct operation.

> > Not sure what you meant about "we used just lock the exclusive lock
> > directly without tracking it" -- both files call xchk_{ilock,iunlock}.
> > The telemetry data I've collected shows that quota file checking is
> > sorta slow, so perhaps it would be justified to create a special
> > no-alloc dqget function where the caller is allowed to pre-acquire the
> > ILOCK.
> 
> My confusions was more about checking/using sc->ilock_flags in the
> callers, while it is maintained by the locking helpers.  Probably not
> *THAT* unusual, but I might have simply been too tired to understand it.

Ah, got it.  I'll ponder a no-alloc dqget in the meantime.

--D
