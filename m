Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200288;
	b=obg+5Gc5cHwuxAry61W3pZ3Aj4PpXSp5z78a3nlaVNWK4+/FIxczMvzJld/ydwGXcvfi
	 E29e5Mgb4k53QgBhWODb1VkofflaPFZuygrDIa+um4E2kfvfrdqAJ8vuwm/ZpffatiCmq
	 R4+c9AkERCbXCDQkhjATGsEAid0d7fXww2VZYafoo3pglWkWblh0K7kNaxNMmtdlEXKRv
	 S4ogQtv7ufaVOHJn7HmMroWGXzSowx/AVuRHLWC0SM/IJ4cGeZBLSUyX/ds1alk1VBJBw
	 TEiAm2TNU/MNnTdIkGKwsL7V4OVAAiRiEyI1sEmsv68UfY0+x8U5U/annR1ob4K7SXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200288;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=HO6jLGhAB1je1VSSvedduee7Qxur0Y1MkMgLZxXjBIJYJPSD9Lguq/DDwJHLeWAP6XGL
	 TnMOcHerOZqiCRi3erzmI95NDxvhvnnfqi4Ul/JlKTpE7g47uNuqSVGicTGRsnyeybwe2
	 1TTcV9kLYPYiOlr7H8punThfEELWRFiYzKHAW84vsrV24K8dSMAqqyFiwAPwTg644OE/A
	 LhtlCLX1KTX1V4E7TVidsRuLzkjspwIj5Jkc5jH6W34LX6KDC1rySF+scChdyCgSWeTca
	 RK22Zz45eK/PatU16WXfaKO7eY/WErkudmkZNzksZZhVfc475xX8y0XKPx6BIdU4Bhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592A606A320;
	Wed, 28 Oct 2026 15:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3592A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A326768AFE; Wed, 28 Oct 2026 16:11:24 +0100 (CET)
Date: Wed, 28 Oct 2026 16:11:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v3 1/8] iomap: export iomap_bio_read_folio_range_sync()
Message-ID: <20261028151124.GA16906@lst.de>
References: <20261016033349.3104509-1-chizhiling@163.com> <20261016033349.3104509-2-chizhiling@163.com>
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
In-Reply-To: <20261016033349.3104509-2-chizhiling@163.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

