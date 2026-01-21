Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE536D516
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768978676; cv=none; b=qJ8yl85xTP81OPo30q/wS6EO7T7YVfJfXmNfxRJWxFybnRWCaQ0nRGS67/XsgzPryiuKRAwqOCWUAOsYdc9KeY0UJOKuRsP5kYJlscbg1JzYk1yclU210k3zKiwfWm9LOEbRWY+mMWQ27vkAOP3A2k8fRbmVowAAPkN+4RfzlYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768978676; c=relaxed/simple;
	bh=12m+pkJ9t4sASj/ZTlwHyhyQMxKHcgd8pnpUYZNNSMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jhr3K/L7hTpayZG8mR+e4UBTxKyOdfpzGpwjjSaOijqpFN8Rq2oDwT3PlFZDKIPkR+dTwAa4kQeoJXJ9Nf04MU/MF8tXH9cuZcM6fBIEoatSZ6CVqFjLLlhky3KRUtkzzM7LY/h2/DhLmEuiywzIVJCNEmvFaNK2cYdzFfs5sCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECEB9227AAA; Wed, 21 Jan 2026 07:57:47 +0100 (CET)
Date: Wed, 21 Jan 2026 07:57:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: promote metadata directories and large block
 support
Message-ID: <20260121065747.GB11349@lst.de>
References: <20260121064540.GA5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064540.GA5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 10:45:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> directories was merged in 6.13 (Jan 2025).  We've not received any
> serious complaints about the ondisk formats of these two features in the
> past year, so let's remove the experimental warnings.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

