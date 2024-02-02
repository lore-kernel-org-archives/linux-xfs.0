Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1897617546
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855050; cv=none; b=b2Y4ZxBb90nUMH2166NVv41+/3GTdbTec5M4zRdU6qXczs1Tx3TQz2t7i0ct9okhMebUEk3GtgJLTnCvgzNhfSO992LTXPjMxIJeRGW9n+tBK5Q2SxuaEitD7vh6eU982fUNSekeAuvbrTKNEiT0zGi6c3WX9iaH1Rv4e1PUyOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855050; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qo5kjPaYoAljBt/iKhLORtCCEAUg2fUQNjra0SI7CDbN1TulfydMQc5mTZUZje+lcmUYwDQjYlVNzh8xPdBgHkweHnfJtjKZd49gYTHGEQnauoYdjzsL99kEMPeCy3gCg2Gpzfu775+93CAf8p5ssKsYrjhvKXep7BFAtffgu0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nYUsPOgr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nYUsPOgr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nYUsPOgrIr57P2B4Y6IyA79QAd
	8FWuZ80atlI13NkkbfBVZf/kcmqO1K6LVTL+R1iYnseML+NzLC3XhCDAfxtgvOUyMoeqTW0zwp+my
	25R1WJumnwiG0SBoVmNbhH8XGFj499HBFzUbT7YryQvyV5rTZIsYagMR7ERk04h4pJXykw6F4S1Dm
	o9U9RPelVJxBe+fpu7BNEooIcf8NX5cVnC/cyRbCfJlFyVxbIA7SsEptww88Tuf9SWzf0kc3s77iO
	BuKIRo471yVIKzIR4f6ZF1yYnT3Fh7WPhMNKJz62CWFtp9TuNf5zvyiqs20ONa6cIs9hSJwHaUHoM
	hCXOercA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmy8-0000000APOH-2pRO;
	Fri, 02 Feb 2024 06:24:08 +0000
Date: Thu, 1 Feb 2024 22:24:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/23] xfs: store the btree pointer length in struct
 xfs_btree_ops
Message-ID: <ZbyKiLr13lC9-cD7@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334265.1604831.15668208190067622847.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334265.1604831.15668208190067622847.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
