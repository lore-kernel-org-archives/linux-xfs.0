Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064F135280
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898418; cv=none; b=b9pm87Ok4BNzIQNlL/ahycIWUE0qIlxWo/IggJ5bW4Fsn0m8VQthWutTq7YEYguMRnQuwXgVmH4p0Nwx14Nfbbmk29g+RPbSKR3F8rJVKib+kcU4Rjir4xQzQS3jONBQTgRufmrnsqPUPTE53R9Spop4ssQRJ4oWL7+FlDR0PsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898418; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAOQJCiljQZcug7wrUgixZiEu3ID9cjqXV1fMk/ffuxTxX0cxeoRxZBnTScK7TvVWLo9SUbKEL64+XqFylUhXukWcH2Q89qj4/4h1RqES5KczrUE1TeMb8RuLsGkzEQvaYALbcZw8sUb3o0rdSwWbiajbQHiLXL2UQoS2w671JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CCBF68B05; Tue,  2 Jul 2024 07:33:34 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:33:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/7] xfs_scrub: don't close stdout when closing the
 progress bar
Message-ID: <20240702053333.GK22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118640.2007921.1141459290194402070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118640.2007921.1141459290194402070.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

