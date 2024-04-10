Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D11C8E0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727955; cv=none; b=cFrL/1TCc2s5sJe2M98p3mfksjHEcHfJA+KLyg//0uFwfBLv+VpWbou2nk7TXmJc3qiWUkYIiE+yP75g2g59UYOpFPLyfhOVnsxPfCx4JZrpOGIGzAh4Z2WeMuoRyit0kN4lvRBoqZsp8qGDW4uvq2c+tJgtQoczqhtKITBq3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727955; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rDNS+BX4XfrKbie5Odc803/yiHmeYlQKBnbQlnN9sKKA+1c5EZBsHpOPH/9G3MR7AjNKQKEkxTpglRnSzixwl3UdTMcPHYSMCKUuPtJVMOBO8XmhNdpdoZLHXO1FGTqVzCWsHam9dQi/JWY4Qug1vfLhQ607PKDcFJxNhZ9h9e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rrWcLG6s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rrWcLG6s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rrWcLG6slKeZdDU9Tz1wvEhKnr
	AVNy/Chzercu5s/8z8tSpYS9Kf25koD/DI3OCkk1bEChCocMrhZ33Uhh2RNoPBg1icFMr5PHN+Jl5
	TRigBWSGljZ5cTr4wojgrIH2Pl4u1zVGiMcmmb/AvYN5hYEP/JfouRgHVf2v7LZdRewIPkQsrL3cf
	Ul2jNrB1JlXQJP34/e+D+7EPmMwSUqdARRMK7Ct0onsI6XQ3sL6jtUV5HjCNN/5b74E5wdg/IN2yP
	zea1EPG2R08jEebSdBHbJIwfMPVnMBT00j/2yDbp3z2CczG7/MdBReryTbFSH+X4qv3JrjnFpCOQh
	ZVD2veoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQmO-00000005FEC-0NfX;
	Wed, 10 Apr 2024 05:45:52 +0000
Date: Tue, 9 Apr 2024 22:45:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/32] xfs: remove parent pointers in unlink
Message-ID: <ZhYnkD4jUsW6uRVy@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969891.3631889.16415446774447161383.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969891.3631889.16415446774447161383.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

