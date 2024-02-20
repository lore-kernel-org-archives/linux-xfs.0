Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21771E49F
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708405484; cv=none; b=qYxg+oapin7Dmwtb7wOEahKNSCw1opiR3lj4+dod8gEn9y5ZnXTOkFLsBV1rKB5R6nKcVGvIDlHnmLL/E9zRxnDRtAHMHF0AxUQTqaVnATsSCQBm3MsLLeYxcF5J26BPKboEXXWOkTPGgpt9KuTfwCbh08lXTi/MiukppR6D60M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708405484; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aT4U0eTG7nmD6w555LyHRTMoKYfsM10k1kNk1RAvWayHJR2OiUvqYuStqSclj2ZXwJI1B9TXK/7mLqzu1uk+CL/ZghKmOUKV1QX50kEFgKPKgzOVTUo8LpNmE4F/S+9SbOyLBVC2Kyxw0d0CYCkq1zmGEe7dm4kGqEqGpZqIoF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=egi1fwwI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egi1fwwI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=egi1fwwIlp14I2qa7Qx0lxTw9D
	AB+xf+Ap3oWxWsV+wtl0HAREEA7q1EcRPFnCmZEsCobKCqtBypv6sIMHb1oi3cGr4mM5gBAHkDDdn
	Cr0RPwkEoJp7KAyHPEiI6m2X8LE0KPO+dwZZFXQSG3Sy0sM7g7tD2wIrR160IySlBUrVav9soazgL
	vIfgGNHI6awYXtrr7Ved2VqLxjss6bFw0zai4ClEXk77dAYCGRbtU+tvNVBy5WgjcqEjUOETNW/xu
	9CEdHbAUJw7bl3IRkOFN2lZaETe3qq4FOs3rgsFRWgPVpXajGw9hcUN8m332IBruiTS8xLZucRcbt
	7JPOVPLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcIJ8-0000000DARX-1i0E;
	Tue, 20 Feb 2024 05:04:42 +0000
Date: Mon, 19 Feb 2024 21:04:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: use kvfree in xfs_ioc_getfsmap()
Message-ID: <ZdQy6jna17dfjQGs@infradead.org>
References: <20240220002442.4112220-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220002442.4112220-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
