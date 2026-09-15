Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F9404BE9;
	Tue, 15 Sep 2026 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453945; cv=none; b=WBes5tDL9qkQpf/3fjVCBXY3ymroD6Y/ULqn4kZrnIgbLgPwxjGeeoDwFKoQ8s1Iyp7Nikp6ZAxPiI/EMb0zDQ43EjtpH199KSp/xpZxgcNJD+fc4QuSv5ySDBHM9LYRuVaVJ4pl/sVHwaPz61eJVqFYILpd3cdw0PjcxnJ8DJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453945; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0N1eGSyXVFp8LKANDJizEG+XRAgbqOIUSoEC/DQu+4Xow6QiLaiCieVQwBdullc/+xH037l/toLz9znkTyLGCa5g2HO+yUPtWGf5WMZkVn/X5O+eet8Q1U1WS5pWUVZgkM6kCYhzD1iFie5gmKdB7R8ln5JAbo+wwod8JdwmZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FqPVMkNi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FqPVMkNi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FqPVMkNidJNLfTfmNoYZSG2WVv
	K64k8QbJP+75vXkeWczK2GX9v5qTTXxORB6dDCrn5mhpoO0ggIQnEvQosezV0731HVBwHeuuM9Gr8
	9WZ8WNzQTrp2NYjUWV0vFbmxZ6ePXPkfU7v1v2eiEZPeZMx8Boh6HrAoiRUR9MLFRbmmQPTTk+6VC
	A0K/zE9nMjHaErMAYygqgPOOgzOI7lh+WkQyZkqku7n9Q3l3qtnnsgmZ1tjer4UbcZxJ8XTO2RNNl
	hK5O5kAf9tWalBWAW+njjzXVXahDsVKIC29R9a44ptF/DkdXZnGK0qGZ61fDCAiXkeZwawmzn1E3I
	XHYF1UgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6MiN-00000005Li8-1hdg;
	Tue, 15 Sep 2026 06:32:23 +0000
Date: Mon, 14 Sep 2026 23:32:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: drop dquot flush lock when we can't find a
 buffer to flush
Message-ID: <aqjmdwtGTm-zX1ea@infradead.org>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048690.3061055.7567460343709434849.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178945048690.3061055.7567460343709434849.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
