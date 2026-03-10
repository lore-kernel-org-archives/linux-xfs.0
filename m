Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F191EEA54
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 09:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134686; cv=none; b=Pjg/Gsy1oq7NO0PUq6ZUNi2rrsiWNbe6xiAbUFRq+DvCTZVS01Imi+oj/e8Fl3SJf2fH72GmYihIyQjc7PsUgoS/bVc8PERicyzZLq0L4IC7xNebQNrwHUUankpC2vfMAXKlSfrW0dBS224t6a16WNwDv4b1Vrswcn6gCKfPfWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134686; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWD8uOJJYIjq73hJeaqux+Zn9egO0uTiI1G1HUsvSgcvUgigcAsrhaIiAPxwpHoNvoTnjjNuWs3Z3/zmtuYTWvnSX1CF19R8Nr47FbCTOe5G46rVjZtgmL6d2gug+8WyHYVPmZIHlHJ79208IlrL9i9sXxQOtQ4//MyCzcISEBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2ldIam8Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2ldIam8Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2ldIam8QlvD5acHkAZzMwjLAhX
	nwSyJDwPS1vQTM18Amom3MnJb91PAq0NlO3DFH7rWLsu+4jKx3DQUX1M3RFpEejOxz4uL7DtHiMdF
	e33HtOlUS4O2R8ZkU43apGbsyGVCHf9fPi6oP5j/EQIY/Yyrk66JkuqC4di1Qdv7p8Af5mB3qKPYN
	NaSUO4kaghGPdu/cIH6dKmeMs+oxotKpEC04yslHcwjjOpUTbufOEaNNnkCT6ItUL51ul8EzC9x0V
	n51w1an/tWLYqjf5gtq3/ck42oKb3lkHY5b83wggXVHyuSmlggU9p0dIa0X0bYOGTK4GsdJzuvvxc
	eHJjQbsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vztKV-0000000958o-2rCI;
	Tue, 10 Mar 2026 09:24:43 +0000
Date: Tue, 10 Mar 2026 02:24:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/28] libfrog: add wrappers for listmount and statmount
Message-ID: <aa_jWwvxD_8oWpOg@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401558.1183235.5702963681162220894.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401558.1183235.5702963681162220894.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
