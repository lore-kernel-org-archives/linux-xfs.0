Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AED182D2
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808725; cv=none; b=RF1dyXoxJh+2HjtOZO+kNuOz0PIRNOa+NipdcIiMqbjQOWFZL9+89YRzU/+dGV2wgCJi6QxnNZAcSCUkwlDVWpY10CYwDCm+01/fYzDM9MEsTF8h6DIctvX1b3fVM0NYDlrJ6Zy0YiFBYkpuy33Vbrqz3TqK2TRySc3R9kcALZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808725; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PB+nWuKLVgIYI+E2w1yyC0RNnFw71xp1BFOTfqR3yXrvmqjWrloydgSQkQ3ogn73KoguB8D8yUNWiPrSqWOIvlkV6G+5fvUHX1JpJeqSMIVbNwUojFewIKUjRRAm9Cw2GDVmIawdjIarDNs8ofluE8m/1KAA9Or3AxgkcwX1vXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n6CCXKQK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n6CCXKQK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n6CCXKQK2xymYx8tmNIFOqgK3S
	TM+kWgjs8s6EKKEQoBSajFAReaN9/lXfghnk3NcFlgjtzQs25oPvzBGqKWyT27xy4mTQLBqOLmYer
	49FpFmJpHwKCz3uz/T2//awgHvIGXAukzRK98wdxCTGbvqrjgBUoieVdSSrV8hCpJyo+kPzB3XuS5
	8D2SKDoQRvapsiDmxzFAeBHMQ5a0VlXYraTtrr9xpjkUn6jb3ILBHAyDGB9cSbGCymPyl4YhAHYEv
	kofqdcUimM6UsZq+QxJDYvwv5zSLMl6qLncB44bvGosFNN9Ag2rnamz1y2TT8I7hwmvVkX/0k3MzX
	F/a827mA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsqq-0000000AHvF-0BF6;
	Tue, 10 Dec 2024 05:32:04 +0000
Date: Mon, 9 Dec 2024 21:32:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/50] libfrog: scrub the realtime group superblock
Message-ID: <Z1fSVHRMfkO0myx5@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752022.126362.18323811506203138310.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752022.126362.18323811506203138310.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

