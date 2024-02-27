Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B663D541
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057362; cv=none; b=KV/7wbwbE3x+IJPTkpnAo3o5U1/iOwz6GwaQKY0gWCizwNeVGhp7JBLQ8EjtmgOgLWWjCTmK6h2OeC2ppxadZoK/0/bhbkCfnduuneXcuXByQBrYZaHPhl5gSBuvxGMnOrFS6kCXSNd+YxQ774p88lI7dNuQe62l+q9YNpO1Yjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057362; c=relaxed/simple;
	bh=MpQllQTs4xqLd8JKX7vudoDLwtl6wL2XilZLoDU52V4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MrgPmSh7YL8P8eAsw0ZjB1l1TgHDcJR1ECGXeCBLrhUPRpZNRHIXZWacPVcLg4S0V22TSZmLfOEx6CwJd8Ko7BmtxXbTtRiti6XiNOGxXRNZbnyFnTuVIyfjFNdXLUbhAWNU2CiaT7bVttSqrt6fCv7CmPO0M0Uq+78nV0aOP4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oSdtpH5w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oSdtpH5w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MpQllQTs4xqLd8JKX7vudoDLwtl6wL2XilZLoDU52V4=; b=oSdtpH5w32LRzvRXPNKHexfAcj
	VjkvRBfedvVXgFevYc8u9zF4vJKo4hx+sMx0NE+AyCSR6kwKMdz72Jd+/H92rOAvU5hyTaXEkOfGi
	7qMzn/y2aikVbwOtv2ufKD5J2H3IcjWastSVoAhh9/oPs9YaeV5P0ElaY/YmCPrgP1tIq1fTPBS4q
	odoucWxti+Yu0OFGXOtzIugQG44UhCrhGD0oVB+iOxI+Oq947nt7bzcDLajJl5/QOOXOqA4IwgH5s
	kgflD2HSMCg+dhnU/13o4Dw+glQEAnZs0TDgV9de4ELG6Tu5KheqfI1MPTX4Vl01c5zY1quVXQfX/
	+j5X9X2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1tJ-00000006MgP-0419;
	Tue, 27 Feb 2024 18:09:21 +0000
Date: Tue, 27 Feb 2024 10:09:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
Message-ID: <Zd4lUAcj2zSX74R7@infradead.org>
References: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
 <170900010779.937966.9414612497822598030.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900010779.937966.9414612497822598030.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although the CAP_SYS_ADMIN override is a bit odd if we explicitly
asked to not do automagic feature upgrades)
