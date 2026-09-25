Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C091922FD
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315224; cv=none; b=gcDQqQus3b2D9ERH9t5ugEAxLpOWdLOPOoDZLXdvBw/tJfPoJi75TAMgoJZIjPrWbn7jEpgcJmHykeZUzB03qZ+xMezkYb0aLyI8Rd5x2Rrpjopea3QNXQ08ajp9T80wu64Av3DIAcHkiZDhuT0AtgxJXUOk92X65SL0RT2+xhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315224; c=relaxed/simple;
	bh=HXNz0WgcUBiwsq91IBg0mvoVL96FFwvvhlVylLrMgFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLUNsKqk1GL9YNx6nDT0vqqdlqeekPRbXbujdtQ1/iHDid54gpiBX+9u22lom2pcTcmr5anOE1P4RQ302X1nwKiwtwPfKD81jboIs/gCRVQiKyBFrXjoW46+rWem/IQsbVmKjlRQLIQLb5M061NUciyWZVsHUprLSBoWpxwax0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B3EC968BFE; Fri, 25 Sep 2026 07:46:58 +0200 (CEST)
Date: Fri, 25 Sep 2026 07:46:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: split xfs_end_ioend_write
Message-ID: <20260925054658.GA3109@lst.de>
References: <20260924095740.2732474-1-hch@lst.de> <20260924095740.2732474-8-hch@lst.de> <20260924202637.GW2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924202637.GW2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, it turns out this actually needs some changes only queued up
in the block tree right now.  So I'll resend with the bits that
actually apply against xfs/for-next after waiting for a few more
reviews.

