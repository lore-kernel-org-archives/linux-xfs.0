Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865021;
	b=CFRHhl4QfgDlj+jj+sFHKSLhVYvphUx6Og3IoDmXGGtD+sHAWoZ93c84m0QK4FNeso89
	 ZMqkYqa9i0x9ljvXnFaMMF3xyelh0uJgs6jLyV0IvavVPf3L8qo/xjO3PgCbdhUIsx5kA
	 yfcDOvxtU25TNgCZFLKg/XfOFVt080kQ9M2eHa4ydexZtqsO00Ranwatml4STLyJaqIfV
	 xd8CWvPyjyS+FUgPEy/J+Lr8XL8RS4GM8rLhH1bzZBGJal5oIEhO7q4f8oG/52HHCPkiz
	 Rk8OgrGUMCUeNpsg3/ENz05QUCxkP35lTrmqkBY0n/o7/1PMzz3GyvPhF7j36p66eeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865021;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=KAn1h7vSbiYx6j5uk8g/NV4ULBdE9K4jbne4FCHmwUuXm4GI72gallTzbQ9ssb2khbbE
	 Jz2wIPhIF2kpSceDCYy8J6ds+CLJg7buEZKx24l2MSNYFXVC+WdrvtIf8KH+ZS3ztBhNT
	 swcoFNJqsHEpPWzXq79hGQSI7sCdKwhIX2reAARioG3gmwwVXwNyj0tJwssvXrS+tJUbr
	 cUi7vP9M2zmhpoYv5PSU3jf6/OEyOyW0V/1HLxD26tVYzlBT8tIhZOi6XcICgLELQD+Oi
	 xWiKS2Pm6As0cDngCHuY2jsXdwZMYh8ok9XBPVtQl1m3dbkn2rHZU1mHlXSd1/7LAwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vKIPrzOL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9A606A334;
	Thu,  5 Nov 2026 07:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E9A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vKIPrzOL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vKIPrzOLn0fWTq6JNDVWD0PlFN
	Uzq/Lhz48jPFfixgbT2Y+wrxmCXN3vfs/hJqpulOdvu49sYxvltfFlc1mE+5vsnE8PM2i2qcoVyCS
	uGKz2/IEQTg2L/VO/wkZjPBo0bgl9pzbn9dh3zBGXpwxqkOYh18ajRiUtufj+xBt+Igz0sHbVbpjO
	WN0O0mXvrJEvOtxYFvF3BQ+HNIX4qc6vOOjteQpFATUe7mXi67dwAob011X8Sd1VkTSD1eyvcmPio
	cWULvYIzrSWfS2QphPKiGJ9z0UfGyukIpIjbaKPL/glyYxDe00Y02+tbXKwY9/oXOQrRzHF0s2SM5
	JPTEnVsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOsEc-000000083Oi-011B;
	Thu, 05 Nov 2026 07:50:10 +0000
Date: Wed, 4 Nov 2026 23:50:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/6] fstests: consolidate _require_fs_sysfs and
 _require_fs_sysfs_dev_attr
Message-ID: <auw1MZqTQG1Xdzqc@infradead.org>
References: <20261104184736.1564283-1-zlang@kernel.org>
 <20261104184736.1564283-3-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104184736.1564283-3-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

