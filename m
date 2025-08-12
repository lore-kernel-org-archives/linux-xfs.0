Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207E91531F9
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984756; cv=none; b=fjPZPZ81lbRMfy7DUW6fd3DbbgTS2FZfp17WhjAu15Cn0Bmzf+qTHL2U800vsy1JghGjGDmphrJ2fIFUd0nnn04b7rLpSolD8pXHoDqZkWoKFpAJoX7qFLWbpfoFD5yHCstUOsNfTykxKYAn6DEU5I3/VaNDK1PsgVuy1fBUPGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984756; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tR49BjMRhHt6hoqZ+cjCbytOsSN2h9gRVfCkdlvUdXpdqItxV3xpY79vZLTdGQwcV1ApcvHxRqK493XNOoBfTUVsFpPOgFZN65vIYodanQB6Y5Wfy1zO+dyIqFxBS5RPdjkOLM1Ep+u3t3q9qWt6FoFMIHAQGmj2hd9fNBDxfFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9057B68AA6; Tue, 12 Aug 2025 09:45:51 +0200 (CEST)
Date: Tue, 12 Aug 2025 09:45:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is
 enabled
Message-ID: <20250812074551.GA19614@lst.de>
References: <20250812025519.141486-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812025519.141486-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

