Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43F309EE6;
	Fri, 24 Jul 2026 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899590; cv=none; b=nWi6O1hPrj3Qsinwf7l0vQYDlpesIIv3eZvK0XLyecu4LzZCPtm9WDWeDPwmM1j1orQuzBzeUx7TImRstmzX0w1c6ebpjqEufvIpwC7k+pn0ttcWkUrrT8tBXH8PQlGWB7ETorkMg9EJCORI+xqxgb6M8/KaC8jFaMtz7j3VWwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899590; c=relaxed/simple;
	bh=8S38cdiJS5fAphNy6TtvofOQ8tJvME6l933lNlv4uYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnEj59rZFHqnX4JbVZb+qeAJbf+P2kBK3XGxbQHz3UTGbpRA5pkxh/kJx33PxqUvZvgXZ+U38/XAZ3/6BbQE6HKGPvWpe99lfPST2IbYYvPhnlTP2QG3TizSyxGxrTKeMLW9Qwmud4HOCQ91+705XywSEV6RKNAxsAwtu6OgvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 291C668D07; Fri, 24 Jul 2026 15:26:26 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:26:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: avoid UAF on sc->tempip in
 xrep_tempfile_create
Message-ID: <20260724132625.GF28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405504.3442778.13576241949059106185.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405504.3442778.13576241949059106185.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 11:22:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed a potential UAF if the tempfile creation code fails after
> it set sc->tempip.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

