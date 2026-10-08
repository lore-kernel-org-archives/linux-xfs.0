Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6231743E4A2;
	Thu,  8 Oct 2026 11:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460626; cv=none; b=gcR45DL0huv+A+0AKYL1YzDwdyB0kYAwa0tTPOHJWQJp3ntrfW8neMT5+jE4aD2wZsnvWsT3ze0ijmBUNTNBlXL50qifAGzD9lYR3FlJYIzxIagjdlFYK1MFmkgJWcI11jqw9WwPP1hYyaqeFUTdhrw8t0CQLijYRrkeeRL3tFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460626; c=relaxed/simple;
	bh=409xGD14WpmLen0G1Ag1sGkgtARQTjuhpfTP3PFT1xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYZxmP7aNcCUVTDqXEEsjH0+r4MIujn5Ok9xPieI/eCIquqU3RIya6kpsH6KSMG/bvlSxoCs7+tmANOZI7RSxujovnpJnJxVjA0AlzwMBqxhihVNQO4FE4fxVT6HJofhRQd4O3Yn+Z5i/zYMizSKZiHOtz8IVb0+vJugMh6E8+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3GRE3+ot; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3GRE3+ot"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xe61ubYAjgILkR9cJRWb5xOWRnTNRhpdGwPAZGVt88I=; b=3GRE3+otOTZg5J61zJlvf0DbD2
	sZ0C1Ok1avKhsAQDh2k7iwNlVmYfo5rJ8WuJaZsvNl5xV5SrcyiqO3liXuyksRLg+EdaQojKY4Uef
	Z9c/vlIxOFXCcMRXtsW5FPYEg62xOaIUjdT4axdJASkQmvPC2dqpXa9seMzVgP7ZaKdMTnb3dUonk
	H7HvflbqI2EO5kN8RkrHtR2P/AjbxqAa67EQRH/zYOn5XnTSTtMn6Q125cMfbqARcs3hvhWox0ih0
	PulCYvSBnMGvPp+x1q2A6lRxpx+G3cVk8dO1zMnCqM/g+mJYYxuY6mVY0DSec6OuCPcFQI/jeJtQp
	6SAlvnxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmkB-00000004Ivx-0JdU;
	Thu, 08 Oct 2026 11:57:03 +0000
Date: Thu, 8 Oct 2026 04:57:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reattach dquots after changing inode ids
Message-ID: <aseFDykX3OaCKSC1@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521342.2728617.2833089550706486434.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521342.2728617.2833089550706486434.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:55:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_inode_ids can change the user, group, or project
> id of any given file.  When this happens, we need to detach any existing
> incore dquot and attach the correct ones.

Sashiko complains about changing the dquot while attached to the
inode and I think it is right, or rather the issue goes even deeper.
We should not have the dquot attached while changing these identifier
as otherwise things will get really nasty.  I'm not really sure how
to do better here, though.

