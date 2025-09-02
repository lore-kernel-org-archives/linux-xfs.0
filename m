Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B89C32F747
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794382; cv=none; b=Fz3P3hJRVUamPDoQKatT9UrvTLkxBKH6fhuvqqg8b1zRZT6jcytoXpPumKiSvUemXhMDnRtL/fgcHbLkn2rIkwvZBpbgSGIayyEk2LFpxKVL1Y85jbPAprjfXgKT5Mm/1hTeZaUXO/q8lBfHS+mfB4RyzfU0m/HeqkVDte44lXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794382; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5WyQ/i4SVj6aKZwFGbDJNYon/cA5/orHXcj2zPAKkAGAQD+QuPyYZdLeU9F9iT7MrRl8I9Ls424RbPqpd15JTALWuN26CuEf/6XhZ/pQ2x2XPerVNKspIiTlgPG9hm0gwaJ+rBRqXGuWpUbgxzKgf49n53a+7mPI2yzSWrOrhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C1F568AA6; Tue,  2 Sep 2025 08:26:16 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:26:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: compute per-AG extent reap limits dynamically
Message-ID: <20250902062616.GD12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126522.761138.15571172483898795822.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126522.761138.15571172483898795822.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

