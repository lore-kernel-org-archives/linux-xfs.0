Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77FF292B4B;
	Fri, 24 Jul 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899434; cv=none; b=JLi29HmUE1rZw6KQwn+ZT+wFaXDfpoUf2xThp+8Jd4nXJot4nux9/MqAePNFyOnpYSsEUrs9RLUjzsm1LBinBmD794QO8VhGLrKlrqsGiZQpMUmb2uHAE4qbmlY2fKokIxpYrvnAUNDwFzCg6XO87SnvRFh4srBU7J7CCs0SEt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899434; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=De2fF0uQMmtUgWGc7wnDiZCC+CdgoG/62kHcgEOv08Qgmrf28TFcg3BJ3m9NZlEcF7EDU4uwPaPDXcKPRt32ZT/0qIPH86U26ZgsLFQJ6cXhSmWOqCIzi68vEpetz5oWi8n5px3fpfeZGwFTZseg7rFpzCyic9579zOmbzD82+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C0EE68D07; Fri, 24 Jul 2026 15:23:51 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:23:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't return EFSCORRUPTED when scrubbing
 corrupt parent pointers
Message-ID: <20260724132350.GC28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405441.3442778.15813909876284949564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405441.3442778.15813909876284949564.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

