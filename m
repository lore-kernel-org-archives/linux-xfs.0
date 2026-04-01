Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD3925FA29;
	Wed,  1 Apr 2026 06:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025125; cv=none; b=f1QoW/tcTibH9KD7tFeoWy6C1iCy2jsL03fGWdEDG/W9egvF3wLWzIMvwdWd6+j/Tpz5a2Z8o//4Tl62GU1nnwIXztvG3pMAGhjxns8V9hFMsD4AiuRuRP93bmWTgFMzqxfikw6LxYpoHU27hNZsdd/4g1cFNb/1VEL8w+JNt5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025125; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UThYTe/w563TEfl++joFkEKI1gZL3jEHScBlMyOPKBVRp6Vjbko0bjo8oK2KRcDe7GhNbyQnvrkiv04dj9nY6Ap06MmGZnvha/jX3zwMHZry4VRdLXRi9ZthzCbiemO9IZzgwUO2mPeJGd/olyWg56PsMFd4N8cPQqiFbRTRCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5644468AFE; Wed,  1 Apr 2026 08:32:02 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:32:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 22/22] xfs: enable ro-compat fs-verity flag
Message-ID: <20260401063201.GE24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org> <20260331212827.2631020-23-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-23-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

