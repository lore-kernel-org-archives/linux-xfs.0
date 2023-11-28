Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80911845
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfxFpHg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9365C433C7;
	Tue, 28 Nov 2023 01:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701134966;
	bh=fYyHz8DcUG1RI0K41K4VkX567yIrEODphKDKmUGboeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfxFpHg6PRT6ZWBkS39csOnLyPteUta8I9DO53wxMGKhQnBfyNEDLzLp/TiVPgnP0
	 /lBVnDvr+iRPtwDzAcPQnCGSN0d1QQNYAaonwkdvAmaHR3dmv+JR2ofwwed6Xz09mE
	 apVzsXj7rh5hXAdyq18+Wt8gHmmY+/s+fUsJzzDH/ygOqI9H9jiyU19bQV4/tyOx3i
	 XE0WYFdI7kx8ITuL9zOAsrdk7ouRWgsNbynXQ5PfnpSuo5WarAlRy2Tategp3LXGk8
	 ND6Unw1/z5JSN59jvkXcZvZpHyLCtlyQ/GQlCtjyh6mSD2ey33M8KBWqn/W3V44mGV
	 GN7G8oM0OB6rQ==
Date: Mon, 27 Nov 2023 17:29:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: roll the scrub transaction after completing a
 repair
Message-ID: <20231128012926.GL2766956@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927027.2770967.2620740447463313551.stgit@frogsfrogsfrogs>
 <ZWGOsogKQX0AnLlE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGOsogKQX0AnLlE@infradead.org>

On Fri, Nov 24, 2023 at 10:05:38PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:50:17PM -0800, Darrick J. Wong wrote:
> > Going forward, repair functions should commit the transaction if they're
> > going to return success.  Usually the space reaping functions that run
> > after a successful atomic commit of the new metadata will take care of
> > that for us.
> 
> Generally looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> A random comment on a pre-existing function from reading the code, and
> a nitpick on the patch itself below:
> 
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -73,7 +73,7 @@ xrep_superblock(
> >  	/* Write this to disk. */
> >  	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> >  	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
> > -	return error;
> > +	return 0;
> 
> After looking through the code this is obviously fine, error must
> be 0 here because the last patch touching it is xchk_should_terminate,
> which only sets the error if it returns true.

<nod>

> But the calling conventions for xchk_should_terminate really make me
> scratch my head as they are so hard to reason about.  I did quick
> look over must caller and most of them get there with error always
> set to 0.  So just making xchk_should_terminate return the error
> would seem a lot better to me - any caller with a previous error
> would need a second error2, but that seems better than what we have
> there right now.

Agreed, the callsites would be a bit more obvious if they looked like:

	error = xchk_should_terminate(sc);
	if (error)
		break;

Though I'm working on some tweaks of that function, since it was pointed
out to me that cond_resched() and fatal_signal_pending() aren't entirely
free.  What I've been testing out the last three weeks is:

	unsigned long now = jiffies;

	if (time_after(sc->next_poke, now)) {
		sc->next_poke = now + (HZ / 10);

		cond_resched();

		if (fatal_signal_pending(current))
			return -EINTR;
	}
	return 0;

So far I haven't seen much improvement, but the callsite change is
something that I think I could promote to the end of online repair
part 2.

> >  /* Repair the AGF. v5 filesystems only. */
> > @@ -789,6 +789,9 @@ xrep_agfl(
> >  	/* Dump any AGFL overflow. */
> >  	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
> >  			XFS_AG_RESV_AGFL);
> > +	if (error)
> > +		goto err;
> > +
> >  err:
> 
> This seems rather pointless and doesn't change anything..

Oops, lemme get rid of that dead code...

--D

> 
