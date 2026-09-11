Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F82408031;
	Fri, 11 Sep 2026 07:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110892; cv=none; b=r7mcUyKP61ICVIiUTNzU/i4ED1bVE7OsDmqCeqkeSQV2hk4FRvhl1osmo+5OGsdayWySqC6thd3Hk9rluZwksOdLsnq1dxlu0kaEW9V5g9EA1t2o25eQJIvub7kvgxER+PXshIs4a5AUtow3OpLH9CFxjXHtSs2qB34Y/iIDdMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110892; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMQqppALakUuRx5Qw8beZlUWm78NaHJFy45WHvLpTROGeLOwuB4ESbTmwlX9a19Ly4u4PB1yzSF1QEJooYZEWvbgeMzp5W7qP4bEBTM4+2gUpvLfxCH14ixquqP/tSefpwpx3SelD62sw+2vUs+J6CIX/A0CpKy7JyDMsJICiQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E9F8468C7B; Fri, 11 Sep 2026 09:14:38 +0200 (CEST)
Date: Fri, 11 Sep 2026 09:14:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't call xfs_exchange_range_finish for a
 dry run
Message-ID: <20260911071438.GB16914@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162063.174887.8246767904188448425.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162063.174887.8246767904188448425.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

