Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDE23932FA;
	Fri, 25 Sep 2026 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314938; cv=none; b=H82NWdmG6bEsmM3NZm2fcYoYBzUWx5CsHR5NrHT0g1Qd8+wDftWZz8kABWHsvLfaK0eJcUJgPJ5kcc8wRcjT1Y4fkJIRZIaKKU+ojm+SWtr6CtkDe/B09Vs+qdNbLna7bcGiZHpayYCH7WbRDpxqw1Lgw30yTlkH93zXLaSxaLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314938; c=relaxed/simple;
	bh=et55z3GiQzGcdPnn182mAWJzs1+Bmj8hKYVQqGwfBtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbdojOSzFzPTrsyXaGDRbsr8S6nHnHtu0NYne6l1BhlE1MTsBzrpbMH8PMiqAlsWNkikiwwljxd4SMwCHxS5/NlEu1ZFljzIjrBJqztTe1C9YbJ0n/7QkNMDhse6+DnpTX5CFUm0sbh3gKiS2vvdEparrruxoFTJSBD7pCyo/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kuXdjcN0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kuXdjcN0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R27JejZcGN5zjIHwsNvdEBH9XqUvVW9iZusgldQD86A=; b=kuXdjcN0cT/yL/wrtIKRYrA24O
	Y43VNVw0jpZOzkRpGC/ZDjjMt+FqwB2FAHatLXdzfnd4Hf3msyZsvfbxFEFPQBR0JPW60w9DUQabj
	mon8D+3xtUaS5rSw6ngCqv2h8vz98uQ5xnY/Q9JuqD7zkPL2hzZ+drYYTclt66sAIQaF2f5/UrpIg
	DMvxHdlEicgi14+N8ZWXXzlRUCWCMuq7+aU9FWqENdCVTMRJ5L9dVhM3O/bLL05C/BFMXbRSkSZ0n
	aYb6myd9Q7VXnKBnSDjzpimxIccb1onh5MTzLKpBfajRcn13VirEblHLO4h4fPMHa+T09L3yeQy2J
	QNJmqazw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yhK-0000000Ci5R-3I92;
	Fri, 25 Sep 2026 05:42:14 +0000
Date: Thu, 24 Sep 2026 22:42:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: jump out of xchk_bmap_check_rmap if fatal
 signals
Message-ID: <arYJtupWwHFfYezo@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932261.3344850.16757175231565950517.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932261.3344850.16757175231565950517.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:13:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that we never check for fatal signals inside the loop
> that checks file fork mappings against the rmapbt.  This can lead to
> lengthy delays in responding to a ^C, so add some bailout checks.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

