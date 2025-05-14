Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC76226161;
	Wed, 14 May 2025 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227644; cv=none; b=fYMoqwlBLEy2Tr7dgPAp11k/bjk012QPrdwkd82t14MtKXKIX8EKuhCxAAaJAGih08Pus/M2X5ch3fvL5P7+EHWxh3Y6Xd4a6UZ+zRFECfDOvp37wIgsfpCKLgA3kAdKBvFSWtyv5qSa+NO7XCN0ChGWCJhXujfIPJrbz/O1GUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227644; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j41jBiDENuq9HE3x31tCbucHze4iAIxuqk1h6Ena8NQWWxeYR3fi693iK2OApd9yDJlNFRZwgo8raFvc9x4UdlTkJAzAzfdHqul2NF6/uvDqk7ZsIZL695vRWt/g3PF1y2nG7RHk7xRS5TiAbTHwuq42bomnJbtDJ5vq5W7M2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E2DD68BEB; Wed, 14 May 2025 15:00:38 +0200 (CEST)
Date: Wed, 14 May 2025 15:00:37 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: add inode to zone caching for data placement
Message-ID: <20250514130037.GB20738@lst.de>
References: <20250514104937.15380-1-hans.holmberg@wdc.com> <20250514104937.15380-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514104937.15380-3-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

