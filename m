Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D933346A4
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 05:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760678863; cv=none; b=bLOvbXA0BAx6ht9mWfQiRdOJAY32myo7GRNnLsP9nYYP5w5CzDjwmHidMU8F2SP+D0c02vgKS4k9wwrUlIWhNCbvlJHOcGHa5Pfby+pMf/Fa2BLe00Itn3AcVvnvkDwy4myp8n+ErNOrlP/oyJUYBuXyDl5JrHEPN+oRryRSHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760678863; c=relaxed/simple;
	bh=BJXzuthfBrl4LjhmmOtfWM8hoygbm+VoWNyhPQMlz7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LXjh3PtUkrwyPmotx98Rv0+bkLLpYubVOfysohAa0wT58y6rLSOi7wHVguZAkhpj5IKNO2oPHY8UDUh5yO8WEteCs6gkQHBRycJPTkmSnjKC3rZA2aUZS/ibIjuBgq4UokiKX1cby0ke05oSADi8SwYCR50vo91rPQ01B4LRSc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0FDE227A87; Fri, 17 Oct 2025 07:27:36 +0200 (CEST)
Date: Fri, 17 Oct 2025 07:27:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: cache open zone in inode->i_private
Message-ID: <20251017052736.GA31727@lst.de>
References: <20251017035212.651929-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017035212.651929-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Disregard this version, it was missing the fold of the comment
update.  I though I had stopped git-send-email before it went out,
but that seems to have failed.

