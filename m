Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585142ECE91
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 05:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760788; cv=none; b=Fn6bXqmYq3a1qzkF6WN/ULgRVn3VZ63lL4WMx8BCqFxB8DA2cMtW9Yic2rWFPOZrY6cgLf1wZhHfg/zPmB8k1ITWPqagnkX/DGouYWBTNV+DyaDd9LRXc9PCHMHUUaVUmk9SbLH4aWbEu+pjLgxMrU0G/lrk7OQgcoWwCi1MjAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760788; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgVWT8qz7whs7TyKu5/lZtNgtW13YMUzOYfUpn+OZto/nG8SFr+J/otcLwnYzTW8lueCiEoHst7/fYPK2Ln3Q//1e995AA7zW9ugFg4eAXU83cHSx0XqSZh4sVqKyhxlUKHRvC3Bb4fSx+4rfp2ZIVaVjciFbMcWut3M690yG5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F28C868D05; Mon,  7 Sep 2026 07:59:43 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:59:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: remove redundant function declaration
Message-ID: <20260907055943.GD31753@lst.de>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs> <178850312582.1198660.18019501735306969631.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312582.1198660.18019501735306969631.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

