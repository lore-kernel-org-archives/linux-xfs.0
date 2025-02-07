Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0B3231CB9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901444; cv=none; b=Pgt/Pu+t0YMmmeNr6xLRFRDvtHu+oo58gZEh/dOFx/K6prIuqhQ71qa6bzPzE2EnCkSRpG/MENhJxmEzrnD1/IvkTRnM/H1Lw0m1Kh/RnqTqZfvV2pbhO3+GNxu8T3aXDH3rFJcY2jYdNCHZLcjDllNzGkLhl6H6239IJfuFBbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901444; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1ZYGwWUHLa/baZqJAgK+JMgPK/T3YutM1TBXsuWe0TLtXWXdwQqAXmqP7dmoPWm8AnxYhu7BGQ2MZrZwh/RM5D7BkSroqyEhI7fIEO2lfIkOynA/sT5Rmm59cEAypVvMN3HfHwn2w+2mvmaOKPMqpHbiGE2fsd2yRe7KCcLC9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A4CD68D0D; Fri,  7 Feb 2025 05:10:38 +0100 (CET)
Date: Fri, 7 Feb 2025 05:10:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] libxfs: unmap xmbuf pages to avoid disaster
Message-ID: <20250207041037.GA5349@lst.de>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs> <173888086075.2738568.9520704150703509751.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086075.2738568.9520704150703509751.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

