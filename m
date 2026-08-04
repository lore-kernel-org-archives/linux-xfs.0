Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12153644C4;
	Tue,  4 Aug 2026 12:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847198; cv=none; b=usBtUaSBBbQcFPbu8RoyFcsP1y8gxvx18S8c8nHLHD9zCVRk9uju8fLma7tvK/J54pw6HCh7mFLWlM8v3cXTgvASwdBwdzkWRvaSZzZPd53az2RyJ8dvidmAzWwzItX7EGWOkB0uY770DAdwAkoMyzhG04c7okV7bC84YHqwbdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847198; c=relaxed/simple;
	bh=JreHsFiMci30cxxaPH6YXp8hx8SvvpzWJG5Ml4+B6C0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mhiJFYMAlQvas9unc+RPUJJ/47SkqyhyzO+lkA83HY0Pctcb/UhjMyFQz/owUBlfgNs2c3qp7/Rsco/zRVyk8pzLHqzoSExqFkah1KF5imC9/QLtzRlTRn8xL+cNnNOAkT8A0dDike3YvVeyCW99YyrvOhQ3DLvXX6peSWoqEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MjS+mdCL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MjS+mdCL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JreHsFiMci30cxxaPH6YXp8hx8SvvpzWJG5Ml4+B6C0=; b=MjS+mdCLtQB++bVl5DP7+zn4e5
	uO9a57cNaXZXSNMGaSbRRxvAuKpiAx2BeVhhQdBZ9vLP6FYdj8mLqMp25YL19jrTEpkYxKT1g7fdJ
	jgQwpbcMzVEViQ28svYNl0p5h5lXej/Q0Z4i9TgSmGBPu1JKJtAdSTZBqDQAN3am1mInShreltAMy
	op5zWrKl5TbZFuq1/lVuJXrj78oWh83mibZcI4I9r3bAK82OSkGPnhW2gVfj/KSYp8stRZlq34999
	o8UHsaP7q/anIOAq/5OcHEYngrbn5dEjOshkn0ElmDfjsib8hH+O6Yd4dhsN1WmyayoTca2STu1TV
	74qYtcng==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEQl-00000001pux-2GaM;
	Tue, 04 Aug 2026 12:39:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: fix fs-integrity for non-PI metadata v3
Date: Tue,  4 Aug 2026 05:39:22 -0700
Message-ID: <20260804123928.736596-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes incorrect calls into the PI generation helpers
when using fs-integrity on devics with non-PI metadata, which can
cause kernel crashes.

Changes since v2:
 - split the iomap patch into a separate series.

Changes since v1:
 - fix two more null pointer dereferences
