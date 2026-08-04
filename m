Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C967446D08C;
	Tue,  4 Aug 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785852529; cv=none; b=pi5rmK06rdia4Y4KNxFm8060UlDrHKCV/yrWsBq8GbowP3KT0SbAoi7MbkzIwUJqo5ornG8e66PvTGORY0b8Hp56C2gDBHwMZhxL5dn2Hj6/JY2Gqf5al7XNu+jPMJxjF5tomXn2Ezb5wpArD/FOCqd7f0RcxMkhXKqBSaHQn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785852529; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzbIBWEm2G7hXl/JyomGWziTY0YpAW7jHFX4kMngtWXyECo8KxQHANyfRn43cLsqSoHQTRegh1nAD1eE7mtLtjdZ3TS6zrrjZWNdFc3CTu1ZjdS/nUuVtGhHnphV5vKp5txLQNRi5Vape1hBP4UMQQ3MGVizxW9lmNVnRFgMqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B806F6732A; Tue,  4 Aug 2026 16:08:42 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:08:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH v4 1/5] xfs: fix capability check in xfs
Message-ID: <20260804140842.GA9121@lst.de>
References: <20260804094602.84766-1-cem@kernel.org> <20260804094602.84766-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

