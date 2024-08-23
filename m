Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80085381A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388132; cv=none; b=oXrrrf/7km+6AlQPUyc2KR+DcJkgP27AipchC8LRO2mTRyfmGO3fXOeVUEGxg4eem3951C6QR0CrhkPLHRkwmil25ObSG+EfjCa8h4ztbumPizo9hJSmR/reBGI+8ejoLyFIRpu/VvsyCam8QofUf11aSfvqfakiJDeMfLVcOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388132; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cxnnf8Yp/XPwG0cVnFlsykLt7iVMF1guyro/uMydiAVdAsRIKyQ6zawlSJ3vb5041trJrxGi1zIcuFYYSHeIo7ZWbUofe2lpQ4M9q3Or7/RevfRfUMU7LWdgvt4aLPk9NQ7kxqcCjwb+SD5CbzARmN0MX9rUPbzc7yMoMYfuBdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BdScS5gQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BdScS5gQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BdScS5gQ6jSAZ5bS+XfE7wxtGo
	U3uI9iP5rdnPG6CSj3hzjfG7wnuKgrtyM62MnzXaZVVRQ/w8G8sI02+KLTA6OdYNTPm3O2pNksr38
	ZP+joiL/8drMi8Jn35Rd0bGykgKPMxftO6BdG1Ej9AA3dv65Lnh4M6vRzOtcGmydiFtLeSK8UCxQh
	vyBsMjCjmr93ni3XM/mYbxTtViKtLzWKpxTyVs6QDPUkH3DBpy4fSgv4IGDRBRpu7fz87/k/3apUd
	feekr90oL/7fr4aoj0qywQiMQo+0OqMv6Hd4/1dAj7YCiX7cazqXB0WYELMnJ/sHVLx/2IDgCZGjE
	NVxi8ekA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM7m-0000000FDa7-2PBw;
	Fri, 23 Aug 2024 04:42:10 +0000
Date: Thu, 22 Aug 2024 21:42:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/26] xfs: don't count metadata directory files to quota
Message-ID: <ZsgTIkv2jsujJA6e@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

