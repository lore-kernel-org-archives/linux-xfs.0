Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D01D86DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769576576; cv=none; b=pF0J7vgIe2J+EvNdl8UiQ4OfvvMZU4Ba6psq4mX5a7BlOzB2tTZ/CYDM9HF/KiTHcqKeB+4/jPXBe3LfvPHHJTgAtPSclfGcPfK6lsZ3i8Ml0X8djohg02BFyJcQodCgcPEzbQhwMxecIXfpcTJBqhBHLZEe7lH1gLbqzOSfpL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769576576; c=relaxed/simple;
	bh=F0IlIWUsQJqhncscj5wV54hR92W/y2CZ2tltxDsoj/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bA2OQPXMvJSXZFmkw5WLkVLzLDV1NwK4SxFDowUP1UidYhWFiSqWsKlT9mCeCdXIY2Tq2KPV0D0a/+aRwaA5kRsRNhZhhapV21VaYzW1+mLb6IKe1kc0YWO9FZKGIO2AVeo9lmXquJfd7v8IylRziy9XV9uQsvIlq6Eeg/DVcxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYcFwveS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYcFwveS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAAEC4CEF1;
	Wed, 28 Jan 2026 05:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769576576;
	bh=F0IlIWUsQJqhncscj5wV54hR92W/y2CZ2tltxDsoj/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYcFwveS9p+nnQ1SmCCwq6zpI3xEB4iLvfUIbGZ+b0rcymQVwu1n06Sges+oPHnrf
	 1AQEYOMXBC0lr+l6TULkBOoDddcT/XWskQkDXiPKym31+GaIvPDOsDS8JvpVZ0VB9+
	 3pM5o/KADM21N3zDTGv1YEaUExZQE2TkJ8w8Qa6csPZx9wFQJrVjvWTHuFN20z6Gax
	 xPJnK6yvAX+sf0q2HaL0yKlMBd+m36Os0FzlbiH2XwoeE1gm4beASnLP89KXGenpEL
	 U4c1cjQGnBhcBtp84lbmDx8e4bfLh/1Ny4gYldwJJfwwbxE52wj8pSqLt3cVK5aUlC
	 l/AwIgTRX36Pw==
Date: Tue, 27 Jan 2026 21:02:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128050255.GL5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
 <20260128013525.GD5945@frogsfrogsfrogs>
 <20260128034459.GB30989@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128034459.GB30989@lst.de>

On Wed, Jan 28, 2026 at 04:44:59AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 27, 2026 at 05:35:25PM -0800, Darrick J. Wong wrote:
> > > +	xfs_warn_ratelimited(mp,
> > > +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> > > +		delay, file, line,
> > > +		mp->m_super->s_id);
> > 
> > Hrm.  This changes the logging ratelimiting from per-injection-site to
> > global for the whole kernel.
> 
> True.  But this has a total of three callsites and now matches what the
> more common XFS_TEST_ERROR does.  So if this was an issue, we'd have
> noticed it with XFS_TEST_ERROR.
> 
> Talking about dmesg - one thing that annoys me for both of them is
> that the messages is prefixed with the file system ID, but then
> also adds ', on filesystem \"%s\"' at the end, which is a bit silly.

<nod> I think it's silly too.  Want to send a patch for me to rvb?

--D
