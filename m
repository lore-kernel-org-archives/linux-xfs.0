Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC71917FA
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104926; cv=none; b=CW2UCK6wDZicVf6HiTLk+uO3Qmghtmax+ywR5RgcLkPZjWr8Rc9rGh2GTSSgVjyK2hPx4YBlxl/pC5L8Sp77jC4F2wzg1/gHwXVA8lHWy7eqy/mUrfj+VYg6A0DzyqCcRgZXsn/uEcqVVdp43H+dUNjG/tMsNZsFMa5usdZItbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104926; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dY4mStfrfH/yzeoiayJZC2MPgt2HBbpGToLAJgvXztSSQ4AWtvHQETR0mTRoEjraETRUNIghzrR4tXi6p/foJYKNObcf4/t9EFxwL7KE9GHcg/0YX0PZLq/dTpfEyz9/Xe6gUr5kIbOJWnnjc02wGQhK7/GsDyZqdIVrU52Jqyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uxnE4qCa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uxnE4qCa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uxnE4qCa4xWvoxQma2DAL4zAsI
	TGMqU6o0kJQRE9GmCqDE8gX3L5/DyW+Csc6JXyhsxcmCzwJRFfbtYe2qnO62CGhXBDPJDyHIgKWW9
	QZXliVDQzhTUf21QvMI5daVtXHH9pgFO7YZ1/OPC0o3Y52K2ZTEfaOCAY+VI4Re4HuWzIJn5ho3Qa
	Kjc3vjhZ30RnoZDUG9i7HlP7AvAMAxfAAXMhc/JTZIBlx93EwWZG46PmtuhMHxWNGnw5XhtkDxu9u
	FmpRatfd4sOX4j5u2UCXK5MY6T+/qnpGI2692foO+EF48p43/vADH+nZntqGu/1GfMIuopNdKygyN
	F1pzzoWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LK8-0000000A7qC-2kBO;
	Mon, 28 Oct 2024 08:42:04 +0000
Date: Mon, 28 Oct 2024 01:42:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_db: convert rtbitmap geometry
Message-ID: <Zx9OXFLc8fHqpSmU@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773834.3041229.7195564819100747860.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773834.3041229.7195564819100747860.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
