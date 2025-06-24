Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5F25393A
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773601; cv=none; b=KTg6zt2KTB9skgktgPntS40gzXN+iFv8mgqZAlcBIeasBdhduF110zDqxRQmfsRwkmR5aIJqb8wq4WL3KYNRIqSTAgESzLBJn6g6MBP1MuZKW/gZvxN6MjZdsijZwpxo0bZhoVbGor0S98wXFEESkgkw82f2vn2nmoiS2jmOiYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773601; c=relaxed/simple;
	bh=BcNezf93mTicC4SBXcntKeKdCdfrPQ3XMIEHRC9/7D4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1hjTbefR6XxLA7E+rKyYiWphocMhJ2c9cL2KZyqkTSltXYj2DkMEd9y8LT+ZGGtTILmKOfbunIUBpZW39FIbfs7WiZuR7SE252wOG8fN7JXi30oXKj2ZqCviRvkSeuMm0Ot/NqkotgJ+YTttfgTNtiCaf2x1O6GFTAJ+h3FB6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44212227A87; Tue, 24 Jun 2025 15:59:54 +0200 (CEST)
Date: Tue, 24 Jun 2025 15:59:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com,
	djwong@kernel.org
Subject: Re: [PATCH 2/2] xfs: kill xlog_in_core_2_t typedef
Message-ID: <20250624135953.GB24420@lst.de>
References: <20250620070813.919516-1-cem@kernel.org> <20250620070813.919516-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620070813.919516-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I'm all for killing this typedef, but the name of both the union and the
typedef is just horrible as it describes an on-disk log record.

Maybe replace the union name with something like xlog_rec or xlog_record
first, update the comment above the definiton and only then kill the
typedef?

