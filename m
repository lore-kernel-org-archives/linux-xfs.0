Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199854;
	b=JdtjwVEwazr1m5cgkRoxWAiVFdGgb1JN3BadEEBOb8GpHAiFsTxg5hDT1U+1kziZVXG9
	 Rl6D+gXMv8HZqdQSXklpRAlcMir2yqO5dB3sJbLtcB/plWC4+RcvPObLjqZtctvV8Lw0x
	 dQpNow3UdShxNLOPFfByiRHbCQ1e5k0glY14WZtJiVsFFfjPhZweylP9z/6U5l1Jy4yrh
	 I8sZNcXsW0NOPc4jayrs5hk7TJDPidFFLAN3KfSZkk/0iwmlCGy9JZ9ybhqGlOa+om30y
	 BUSvzj3b9XFVwuDhCrC6LD5mRE/q85vJ/NikfPEWTUTIHVP0qds1jAE7sKinw4nOq9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199854;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=rDk1ma6X7sUVVjrCW8yDbg+SwWUKyFNz3hyRYESPv4UmJsNOq6MdeUsc64Iu7n6gYUqi
	 GeysPPskTyhQO6WNp4fGsZuT2hSpJfnMhUC+GoMJy5jlKcCy0GTTUO0VdXgjnXZvQiGKJ
	 s7BpsOQvV0fZS7yAXGSk+viqhTwDa7srYEzvpT5XTL+9JYQGEzuof3Yud62QKiuyZAUhF
	 xnemLyRLaPha8dQIU8Jq3W8R6IE9bumnOprFCfghRRnKQLthaA54qK2qtIrJny2HWFCRp
	 VoRbKBc2Nf9HGAEM17O3L4Aju4GRPn+I/nY0A7A9oDRbuKwQBG1trYpoxhQMCT1XQNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C11606A326;
	Wed, 28 Oct 2026 15:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16C11606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFF4368AFE; Wed, 28 Oct 2026 16:04:10 +0100 (CET)
Date: Wed, 28 Oct 2026 16:04:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't skip free extents of the longest length
 in a whole-AG FITRIM
Message-ID: <20261028150410.GB16152@lst.de>
References: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com> <20261026-xfs-fitrim-skip-v1-2-cddd8414f99c@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-xfs-fitrim-skip-v1-2-cddd8414f99c@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

