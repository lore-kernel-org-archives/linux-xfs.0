Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F189040EB9B;
	Thu, 30 Jul 2026 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410707; cv=none; b=E62PHrz9gKharHkU7DE+IMedeUO8mlHfhd/rK56SIOs/pwbQEoS6iGkR+3VHhCo/lXix5qS0wmG9p0lmC1qo79CJ+WBrUDd/4UYMzDWxkO1LpKIoeFUNj9k2ZvvIel7W3V67RqNd4HR+cjhMP2zaRuZcFE4j0FUfXfokvomdv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410707; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5qC/kYD+tQhVafnbMmS7sDhuxnly5GQObfP60Dp77nUVOL02GpmZ533w0vnsAuSwuZWN6xlWi11FBbOahGWw12qqscKn24R1XVQ2AYxJdEe85znU/qY/7GA60bv7uMrA6OZBZm5lycQ+SgdJE/tCcH/JLwrX3caFbl/drH334M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6FC6868C4E; Thu, 30 Jul 2026 13:24:58 +0200 (CEST)
Date: Thu, 30 Jul 2026 13:24:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, hch@lst.de, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260730112458.GB24565@lst.de>
References: <20260730093002.1034320-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730093002.1034320-1-yun.zhou@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

