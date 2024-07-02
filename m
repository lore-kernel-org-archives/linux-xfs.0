Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECAF2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898079; cv=none; b=H4oX/k9k0ML4mDBbi0IZU/c78uGQISd1p8L6BBaAi4HFIBJ1krtDlH/J88IDnJym2wYddYxJdY9p+jQgf9HaKyIjOgyQjg24gUIZztd3pgPHb9ECvbox90phngWUU3nBgSGj2PwTt1dZdM7inPUl5JBg3k8PZf5iCJOHWjPqaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898079; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsIUPQSQFCR4A0ZP2++OgBuJ+tGavquh8G8Fsmxkpg8exSSeTxIZECNCGrnKp9XHgcOwspvK++i6EkYy7oNxOlSXqdv0wCF539otZL2ohK8QCovm52kBV9VB01TemT/2PNya7ZVh3pm0aAUycv+S+sf06n2krkZFP20o6ol1Kqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4355368B05; Tue,  2 Jul 2024 07:27:55 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:27:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/8] xfs_scrub: fix the work estimation for phase 8
Message-ID: <20240702052755.GD22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118191.2007602.10091096037746377494.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118191.2007602.10091096037746377494.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

