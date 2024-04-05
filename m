Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244181EB2B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 06:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712297235; cv=none; b=ZDLj8mHwW4fT0EPX63py8VB8hCY6jY54NeH6JZZ84Hj61eFZyyvofyQbalrhJTPRVJxC3FWsbasIhz1B4vw0Qq+4PSsGTeEwOHVquRJ0ua2dAljQhUjmaNNUpW/9wba1jCWwnQ6sgAJxmwPrK1Nn7rmEQOsNuyVcWPnhiDeXrr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712297235; c=relaxed/simple;
	bh=SaKs7O2mDjwZbAMnxbJXjJ6l+098FK2CrjvebOpUcUE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p+U01R/VQDUl+/HkByk8zszxwwWATQAB1/I/3IF+HEYterxyF1fKYOa77XpVR23WwXDAgTMyTyTLK9zu9uGFtQtYGH3wXCJwhlnpWKABpCEo5IS+3HjaYOpZbhuIxXutjFH9vznbgTorKkdbP99ypow1oVTaP/58XNs7eGTXXFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4RtOojs0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4RtOojs0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=2qhX1HyZRE07bfKv6GbR7MZdaLfQALxsvL4MrYIcRRY=; b=4RtOojs0yTlRoNwLELzLbfh4wT
	BUuwF2iU//5+vLubPlYj/kFhamZNSO/jOkTWMZBuS821r9La+VDPVum1MNzkNNxr5vEh5F1AX9CRf
	HwtMg49vfZD9VAtlWpdFJbUGFrsHBrMDBi47goYTa+p/1N0qcdCjzKwZahbsu8FUqJTJz0iWeaDzE
	/OzKiwNeHMZ7iAa/K7Ya21Ac0bmTIQbv4JqI9IvenXVRrQCjyM42vay8HK6yHS2Wwy0qrqGIZ2TW7
	fn39MKpOKHL/FLecYBCigG0a6gTNbOaXlG6mODyUzfUu79WFbUx+AIyzJU4bousgmwcppoRjYyqt7
	FJqwgfYg==;
Received: from [2001:4bb8:199:60a5:d0:35b2:c2d9:a57a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rscjI-00000005OMf-0bYF;
	Fri, 05 Apr 2024 06:07:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: spring cleaning for xfs_extent_busy_clear
Date: Fri,  5 Apr 2024 08:07:07 +0200
Message-Id: <20240405060710.227096-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is a little cleanup for xfs_extent_busy_clear, primarily motivated
by getting rid of the sparse log annoation warning. 

Diffstat:
 xfs_extent_busy.c |   80 ++++++++++++++++++++++++------------------------------
 xfs_trace.h       |    1 
 2 files changed, 36 insertions(+), 45 deletions(-)
