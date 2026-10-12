Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090F48B39D
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811127; cv=none; b=PE11s696ympU7N7T1oDQQBCLlZ3RVcvCjzwvrLG56I4v8/LGUIb+Pn/AVijY020lGWn3rLgYktFRR78ya6NllLQKHrFtQe/7NqhFHxW44qDDVTygELvIa583BG9O1DFXlfhFE7yKeifhvmnhHyvByd0EKBwKNwNAsdlRfV7twH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811127; c=relaxed/simple;
	bh=hdb80oqyR1bmE+sPEBDkzV/Ny2OCbqS+hUPsLM+20tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sp6OHa45jVpi7mRNeUD+DDxdPayFcmswP6e/+EcB/ihEgqNjf1MaMNmCdItStkw8NUNo3+v2vaWPiwSXjbPB6c69P1McykNq5+eb3tPHb3q24koClyTax3HxG9MxHCqeL18936o+kohLAwiz5kX//RO8VfqtOLR7+e5fT3wmuFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U+8+c+rJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U+8+c+rJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kI1X9MESvx8QdL3vkdJYnr18UfQUF5f2RCAJko7uNnc=; b=U+8+c+rJHfovANIM+nKfyHIJQn
	4cW+nGdmcjSoZSRIuxhNhs94e2yjMTPoTF3qk4tcuUzQo/zXZcTpZp5YLtxvc0dgAD5R6aNyp0Fsj
	ZaOJ6FXmG1y26V+ZJbYUEdSU1ELsFvXAP6N7SO51C7+WT6I6J+d0U0LP1cg5NfkGuWvfJCRz30APe
	BrqGu3yqOTSp9wI9yCNTAJCi3Zdt7XA3/4gLTaU2pMvy3zrs/9WDv9/yXPs0yGLrEJIftYfIMu/dj
	7tt3DL6BPKRKkHWLgWPuWboZvDdhKFCOzM+4XF5GlUTl3bsuVZsFVq4scFlShLb/fiGNy1SGFzf/G
	XzVD6XXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFvR-0000000AXwS-3HMJ;
	Mon, 12 Oct 2026 13:18:45 +0000
Date: Mon, 12 Oct 2026 06:18:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: drop unnecessary sa parameter from the
 xrep_ag init functions
Message-ID: <aszeNWI4gcAFyVAY@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065968.1058822.15486087597596647429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065968.1058822.15486087597596647429.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 11:00:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM went down a crazy path complaining about the horrible things that
> happen in these functions if sa != &sc->sa.  However, I observe that the
> sa argument is never not &sc->sa, so let's just drop the parameter.
> There's no bug here, but let's get rid of some stupid.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

