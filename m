Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C13B500952
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767980488; cv=none; b=VtRNqD+eBzUpgwH1NrBeZFuoY1hndcMwPjhVbc1n7L5X7/+6qzjnaiT/OkdH/jRjs4+UKV6flnvhwyz/RhuuKS/gvbLkZd4oVHLtRdOpgWU1G3JaRghhN4QEH2Rql5iwyI7tXc4CGYWuAbjJajFWoF++jLis3Cf0mLcLN6syByU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767980488; c=relaxed/simple;
	bh=JBSSXSFJfQemMtKrnvKvTDsNGhMxSS1yLNqrZsNZ/20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8k9q60/jZHoBOXp7U3oZXR7A2KxUXb5/DOTXqiTCkBjtGE6AUkgZZu1+MgfuURVNpZP3XFTwW2AiP3Xjc7Rq5kCl3aocybRy95XmXmhbtatVc5NMj32y3rqpisAqczEJrjQJFEvoFO3ImiHr4fP3CcPaX8U9VP5ey2C3ITVFZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spnIWFOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spnIWFOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0BEC4CEF1;
	Fri,  9 Jan 2026 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767980487;
	bh=JBSSXSFJfQemMtKrnvKvTDsNGhMxSS1yLNqrZsNZ/20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spnIWFOHZK+rGB/14crS1DmdBeGB5QAZCajxNLrcDBS4cST+/btvgY5abJiTb50nL
	 K4bqPqcCZ603HGcgEMLb6NLEAK4Sg9+7BmihPDZ5QkP5/7tXymyMBDmXPPw3dovB2B
	 JaVgK+NXXOvasCy508sTJuMfEtKtptexhCO9QV1TC2h04p+ftL+qmrbtL6tRmuU6qv
	 peqYCNl9LHnlkQE9eSeFIBSmztJwEGIH6i3gf7sRBch5USvuH7FoUWISqHqSMnc7XM
	 BJkQ0DEsFPmdgxBJAMkAS6KI0XPPvzFca33wkV4OpuMt/Z8AdGBOGKiMmaXV7k4H6a
	 t8E0a96gmIHRQ==
Date: Fri, 9 Jan 2026 09:41:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <20260109174127.GF15583@frogsfrogsfrogs>
References: <20260109151741.2376835-1-hch@lst.de>
 <20260109162911.GR15551@frogsfrogsfrogs>
 <20260109163706.GA16131@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109163706.GA16131@lst.de>

On Fri, Jan 09, 2026 at 05:37:06PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2026 at 08:29:11AM -0800, Darrick J. Wong wrote:
> > Blerrgh, xfs_attr3_leaf_lookup_int encoding results with error numbers
> > makes my brain hurt every time I look at the xattr code...
> 
> Same.  I've been really tempted to pass a separate bool multiple times.
> Maybe we should finally go for it?  That would also remove most (but
> all of the issues) due to the block layer -ENODATA leak.

I support that.

--D
