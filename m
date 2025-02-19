Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BB28C0B;
	Wed, 19 Feb 2025 07:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949625; cv=none; b=cClozJ3eNSXDIMLZs2yTxOCDwtjXxntvISB5fbMDmj4b3Q1Db6sWbehLr/5YcvQbFqqbujCsqCaDwhTu/UG5JZKEh0cQ4PXH4yz8k62lR+brLzF53h4Wxcf/k+EH+Nkz7Rcd2S+CMgK/kiniwJRv/MejEeDYx28dhtwwRJATxq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949625; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYcStyEwFAZh5TP9NfWJG9HYZEglftl8nHeqJpOJbmXVjkvheZSMS7Ev0iovFfQIuYULffzwQqUKwBrRwD9omjmjrElqweLbl/zsTjRCt9XMZbyeEz8LEkpPEe+KGNtr5fhkxyBWgHlieOJ/qZIEmM/9993Z4ue/wf/SFKIxOPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AJo6fH50; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AJo6fH50"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AJo6fH50UPtlrg1tEcVPBehfAP
	IyiieX6wpioJyqbvJn1EfMWrHHJv4RWRyLb2IN6chyRvW5UXEVADGMt3gMqM59RK0dQb+v6iiBl6J
	wm0MIEYy1kz0ucv+zZfOVpKs+jG/Kp8Prjz24qlzg/jejcjMzkv53okkVhu1xMfr2mBZNmFJWaLUC
	E+V/pgBWxNHFlLgS7BJJ4wn0kyJk+0J5Oe75fZJfAhrNxuxpaJ+Y5fBtRQ+ydBhfKwa1EEo4KBRnW
	WldeY6QZjWEBWh5tTxqwNRN08GCThSsqPiieyhnxpUGzBFlfTVSgqiUR1nJFHd+yyXH/v2TbILFAE
	2fNUIHHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeNb-0000000BD2q-2zj0;
	Wed, 19 Feb 2025 07:20:23 +0000
Date: Tue, 18 Feb 2025 23:20:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix quota detection in fuzz tests
Message-ID: <Z7WGN4gJm7Yhnspn@infradead.org>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
 <173992589897.4080063.9479673215974446416.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589897.4080063.9479673215974446416.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

