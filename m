Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D23B37A820
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790654357; cv=none; b=fC+8d8hswB5l9+szd8JXYNvWJqPGmCU/vnT0LHnd2KbxekiEtz2AQQsnkvoYY56SZfn1kdO6f3ExvHW7XGa/LIvbgqQikYwOSajtnPvz8ARrHy1RCGkTH68P2Nkn98UmDnGNelqIsjBjJU2KYAIgm4ZrNADz2Z8km/HsI2kQp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790654357; c=relaxed/simple;
	bh=BSgMiyw+6SF30Fm88xgVxn4h12Oke/sjcA14nyCXgsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0/3aTSoMwsmGFnuTwXlDWKwvOlFgM9SgwDQu4d9NtE29rw4wfG+ks2FA/j7/mP+HV5AH2CHHQgTx90rhOkWEbaNGxsWMeZdre4KQe8Kmyw5FgGEyO9hhbNlDEJrP1vvkEwoSi0MaexHSwd5fmHnhFHaLRpKQ3/7sKlcK7RodIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4i22azG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4i22azG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F22831F000FF;
	Tue, 29 Sep 2026 03:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790654356;
	bh=UaEgFe64tL+nzhXX03iC827iA3ssrB0wmc0nOx+h8O0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N4i22azG6hrXyOZnSsrxVn/VaNn7qCXMd5d0aGoJ/ugDbHyxvpCqI9b/sWhbRIpP0
	 YMJXtZdDYTVVAPuXq/lNsi6F+HGL2ZND4mCbkv9oPYA4HHhbzJvRQBFybfGxJ8KBaV
	 +kYjyW9IBNv2O4XxiyqAhLIvQypMN22F/LbiSLqRtyKCinLqkTrx+7XL22U4fw5xez
	 O2H4Xw3f4zYd4WP7JcGCz4WxkI3zYLMrAvFDAl5JdKtfuLtGde0f72Q638FF3gAk9K
	 kn7OA5v6KlOZb4g8WarCXA7DQZqBIE9tiNT3Br+Dgcc25JcRBNQUKiEgWKmKg/BLxE
	 y5GgDeiiU+afA==
Date: Mon, 28 Sep 2026 20:59:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: be extra careful about replacement directory
 construction
Message-ID: <20260929035915.GQ2705364@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
 <179057612618.479634.3835896628058983547.stgit@frogsfrogsfrogs>
 <aroKgvEG5maAmXg3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aroKgvEG5maAmXg3@infradead.org>

On Sun, Sep 27, 2026 at 11:34:42PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 27, 2026 at 11:16:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the directory repair code, we have some debug calls that check that
> > we never add a duplicate name to (or remove the wrong entry from) the
> > new directory structure.  LOLLM thinks that we should actually be
> > careful about that all users, not just the developer's system, so let's
> > do that.  We already had ASSERTs in the bailout cases to make problems
> > more obvious to the developers.
> 
> Does it also explain why?  The code does look obviously ok, but a
> rationale why we do extra lookups would be kinda useful..

LOLLM's explanation is that if the lookup is a useful checking point for
the developers then it ought to be enabled for everyone.  I thought
that was a little silly, so I have a better justification:

Directory reconstruction has to be done completely correctly.  Hopefully
doing so is vanishingly rare, so it's not a performance hot spot.
Therefore, we should actually double-check our work on the new directory
since we can always discard it and report that the repair failed.

(I should put that in the commit message...)

--D
