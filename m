Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E030DECC;
	Thu, 23 Jul 2026 05:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783129; cv=none; b=bEk3LJcV0Y5lqFzyS5hX9Khutfr+inPd81ezhDQ4q970rH0iEAyLK9h+i/RovU/de2vDpKzseVSavYNiFoicxLNe75s4QQKlt/MgUoUlKq5RlfPgTljqrK3AkWjV5keANMGs66WqBrTPvI1mwFByL8VQwSmZKgwZJZPaiRQbrN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783129; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ms3+VlDxLFzhBYIOtozyas3wGlTviysg3tdaHrpoFcXRCHaaof6fxYEdG8GLWgD6Y8eOpaFx4/NEWd4A5Sj6QcjQ61wAm555RXM5n9o/I0t9656DZnf87FIqRJMi1iEtz8Mq7GIa2uVzircliNBy4zJ/ur7JCRfXzvG12NS9H3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2B59568D1F; Thu, 23 Jul 2026 07:05:25 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:05:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: don't walk off the end of a null
 sc->sa.agi_bp in AGI repair
Message-ID: <20260723050524.GB7121@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419553.830862.9786705599369420927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419553.830862.9786705599369420927.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

