Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15B417542
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855311; cv=none; b=COAk7pr5ItVqqKJJrEtICMPmrRFf/QfbfG6PWZAz5SiUVDdlIaushhpA2R7b1aYxYr+ZxR7ZL2VlD3ouAYAcAA0Zrpqf74Im7ofsPW9fkmwe6XQpc0PaTCYEAMK8KQa+ek9YyUdSUonCBQT7PXCPckLK7FqJHzqp71vthhxLUyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855311; c=relaxed/simple;
	bh=CAF8McW5PRm2XAhwXxl+zjMbuvfSrUWbeS5bkVkRL4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5baQiSbkNC736+JmkGLSq2yeRA3i+DtGOG7cejsXXjwJZCmPQawhnho8W9IIDhTEzN9yjMj/Mz1iigGYvAajXAsj5dBuvSTgXQjCqMpUNB7i+QG/upf8GBS/K2Wiukz2A9UuOfFuxlb/RuywF7t7Dd3Bf8k2IbAvUgeX6smy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mBAENd91; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mBAENd91"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CAF8McW5PRm2XAhwXxl+zjMbuvfSrUWbeS5bkVkRL4c=; b=mBAENd91vbfby+eyCqeKY/KlFF
	jh2k7l0Q/EN1bdUauJSQwl7RAlp9Fw7/yF+K1tzJxmdrWJatIdd6yPBD8majdSvlRiwWtYwLEO3yN
	5hXxRuPAnIAXNEbKbvNgNS6/YrGDdSvdV1Zf8MdNtUmntyOtcQuxs6tqDZgRTzXZVpsaOnISZiIFT
	VvtmEyemPq6/NelrNKRGED6AQ2iF8Vjsdmltz018a4PDabBLvViwa9xws9TJjZEq0c5QJ+g/JW0Kz
	WfYPaANWAPskhXoRs2/ywC0yUFYZqcsTiyPTQsQtZxw4MiLFAWu84ce6Qv5rPMseErnN5lkTBn5Z5
	xKmfKQzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn2M-0000000APyT-0Ty2;
	Fri, 02 Feb 2024 06:28:30 +0000
Date: Thu, 1 Feb 2024 22:28:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: create agblock bitmap helper to count the
 number of set regions
Message-ID: <ZbyLjuIzetQUNU6e@infradead.org>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
 <170681337456.1608576.11464579397615876665.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681337456.1608576.11464579397615876665.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

(still no fan of the explicit callouts, but otherwise:)

Reviewed-by: Christoph Hellwig <hch@lst.de>
