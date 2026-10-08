Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE42F9D85;
	Thu,  8 Oct 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475190; cv=none; b=PCm27x5yUk+B4l3cQZGQL8U7SJL/ls0O9kLtDHLJDRE5EAUKCcZswzNi59J1RWiGoM2Hcm+lynrUHpBw4LkemAOVMBsORxsPEdo3XXxap6viQrjbp1r2zKihUq3k0qVXKJlfGDfC809HPxrINVb9Eyezf8DLISjlFBUEiC/SFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475190; c=relaxed/simple;
	bh=ZR7xVNixuLjSCasNg1sl8hOHzkGBr6ZKTRnjSR9TVr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ev8uU3FFVg4MW1QkKKmdn/MEqJ6JDDj0a2uR1YiF1IQjBqgboynZtR4FLr58nIRFEDEbpU2ooVQ++2qKprhOGtphMUpXcR+c/U/oaNkq9fuEh5yOxRs2kD5Djfy0e0B9uikd14zPELsQG0el+RJHnHO9AlXLtbMB5AskReJrDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZzdEh9MM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzdEh9MM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A17D1F000FF;
	Thu,  8 Oct 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791475189;
	bh=O0xYpJnVhvHxm420qm8tLOxQ9F+RLA5LESJkZ4Qm2qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZzdEh9MMdIQYgCneE76a6wjzUhnN8dC+n7CbmHgfU8B0/4vNw9ELVUblzmlDqeIsS
	 MP//vGUDHZEAumM07wc/SvLibMU4nLePzFF2dSMUmRgIdqTIPX7elcl7+T6VpJ5zEO
	 eUaEmr3KR1BZP4jAKpRM1B5TBoDnYLOLanscML2Gq5ejJO87nErTaF4ilxVMCRffgz
	 DygMbyFw2/czff6wOUaVrPkTipZuZ+cH9SkDnUncEDch+imzOCpGqzQGvQy8xfgflT
	 MafLbFcTXtW6W1YSqIT8BDzdIXMRTdg/2X4t9eGsDSkhodmSnbM917AEiexxzcgo/C
	 iat5BKidyHokg==
Date: Thu, 8 Oct 2026 08:59:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: fix correction of unwritten extents in quota
 file data fork
Message-ID: <20261008155949.GR2705364@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521385.2728617.15371099582568233395.stgit@frogsfrogsfrogs>
 <aseFxRJQwFyvJM2v@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseFxRJQwFyvJM2v@infradead.org>

On Thu, Oct 08, 2026 at 05:00:05AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 10:56:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed a couple of problems with the code that fixes unwritten
> > mappings in the quota file's data fork: first, we should zero the ondisk
> > contents as part of converting them to "unwritten" just in case we crash
> > shortly after the conversion.  Second, and more importantly, it noticed
> > that we fail to resynchronize the iext tree cursor after modifying the
> > iext tree.  If the tree shape changes, we could be in a world of hurt.
> > Third, we should force a quotacheck if we reset an ondisk dquot.  Fix
> > all issues.
> 
> I don't think the existing code here that mixes raw cursor based
> iext access and xfs_bmapi_write is safe, and that is probably also
> the root cause of the sashiko complaints.  So we'll probably need
> to drop out of the loop, finish and restart from the new offset.

Oh, yeah.  I hadn't realized that the merging could involve the *next*
extent, in which case we skip right past to the next one.  Instead, I'll
redo the loop like this:

	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
	xfs_iext_first(ifp, &icur);

	while (xfs_iext_get_extent(ifp, &icur, &irec)) {
		...

and then the end of the loop becomes:

			error = xfs_bmapi_write(...);

			/*
			 * Set cursor to the next block past the extent we just
			 * converted because bmapi write could have merged
			 * records.
			 */
			if (!xfs_iext_lookup_extent(sc->ip, ifp,
					irec.br_startoff + irec.br_blockcount,
					&icur, &irec))
				break;
			continue;
		}

		xfs_iext_next(ifp, &icur);
	}

Also I'm pretty sure the xrep_force_quotacheck should go with the same
transaction that captures the xfs_bmapi_write.

--D
