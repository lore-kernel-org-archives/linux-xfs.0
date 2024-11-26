Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE58ABA3F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645253; cv=none; b=NmKu/bvOZSP/SM+gBV0xgLV3yBg7pt9kcpEUe+5LvDwPQ643mrRLxPaCHm23+DhaDDSYdQ4/b/WU+dOhYmZF1yboEDMYNfA1YEVETy0FneYdX1/1wrzzE92gkb1a5VA/UymlBMh9yGhFyYbFzKQ9qfXezEemKIHlgqt3xMVLztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645253; c=relaxed/simple;
	bh=O6gKNJ4ei2pFFZsC/7B3TC82ctHZL95qn/cL2J1t12o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YN/+0++K1+RSeF/YGJz6oZxsRxs4yRp8RklQq3cjG1gR4JEAleG3gJlPIVZFQcSO6pzM69E8cgoqfzeZVToQbS1VXZhlmUZOvAC3CWGYex9Cc1BgeATxSgTtkenM0iYJloBnGFCepDiTqdsC+YEirUhzG0ArQhf1vOEXtNpa7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUC4WIBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUC4WIBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE8BC4CECF;
	Tue, 26 Nov 2024 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732645253;
	bh=O6gKNJ4ei2pFFZsC/7B3TC82ctHZL95qn/cL2J1t12o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IUC4WIBrgOhX79kOyJe2mITHlcJ2PriQUEdqT+hUcYK7jraLJTxWntGmyHi28QAZ+
	 vb4qaL11sK2xCh1luElbtwgTzJA2Ae/mHncfrB8+7MXIsWhS38nAQY/J0TDBQYz+tA
	 GaIbaFrOJQdSfY/Lo9KTdGXQjPuSonE/C1htEMeR59/AA5nssaaZD6ruHWpq7Imsgf
	 LrryeRpxCPFQAsqCmXsuiAgmFeVgOZ92HdrLP0mL1U0aPajQg1i7oqwA0eZUBtIS0x
	 PQ627D4BWQkX2V+YRTm+g2v6CQggi/e985y7WuXP2y5Ly4c/ZR9uj+5DU0O2fhKywZ
	 Qzyy9b2j6ZcWA==
Date: Tue, 26 Nov 2024 10:20:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
Message-ID: <20241126182052.GK9438@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
 <Z0VYar-LmcdXptXh@infradead.org>
 <Z0VYew8ATCmf-jBA@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0VYew8ATCmf-jBA@infradead.org>

On Mon, Nov 25, 2024 at 09:11:23PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 09:11:06PM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 25, 2024 at 05:28:37PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
> > > __xfs_trans_commit again on the same transaction.  In other words,
> > > there's function recursion that has caused minor amounts of confusion in
> > > the past.  There's no reason to keep this around, since there's only one
> > > place where we actually want the xfs_defer_finish_noroll, and that is in
> > > the top level xfs_trans_commit call.
> > 
> > Hmm, I don't think the current version is a recursion, because the
> > is keyed off the regrant argument.  That being said the new version is
> > a lot cleaner, but maybe adjust the commit log and drop the fixes tag?

How about:

"xfs: avoid nested calls to __xfs_trans_commit

"Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which
calls __xfs_trans_commit again on the same transaction.  In other words,
there's a nested function call (albeit with slightly different
arguments) that has caused minor amounts of confusion in the past.
There's no reason to keep this around, since there's only one place
where we actually want the xfs_defer_finish_noroll, and that is in the
top level xfs_trans_commit call.

"This also reduces stack usage a little bit."

> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
