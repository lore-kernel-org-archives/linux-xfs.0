Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198469;
	b=avvN1loPPOHkubrnZ8WarCVSwW0cWTOflRCnMtDlpqD6ODLjlGu4oTJMkUe2UYDSbTLX
	 yZ+Kp8hQyqGpTGjMKyyQt+lyovyleoWrYQAN86b5qSmnkmCWN5BaorqjartxqOJLRvarF
	 9CzeXbbgLd+s5YhsdPLg1c0EopHQGkklCCZJiWVmTELbeXNwM4TLeN40gX/LnioQHd2sb
	 ZEDqP73encqGdSDFv4IJSTNdjbvMyNcRR5khv3lB/r1gO2QtOCg5uyQjVA0azFoVb7uNu
	 TZcBeMudrIwx8w/fNeyonBXKGWkhg9D56+LLytk/CTXG0FPZlkLEa+wJLkS835KJNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198469;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=JFrIQvqxEeMaMIgX/6LUgfTbf97tmXhE1IfIl3f6ZAI=;
	b=vAh+v3HOOFLWDQVRyfPOmtCaPn1Zbiyl9lAtFm1YNLimsnXFDn90BQMEX0vk2pAzq0xO
	 ElH6WTwPEBInPdYFlGOKDLivmUGqp1MWc/UAyKBZHwEWJwLUdieDwlzFYMJaqK+4NL6dW
	 qhLVWKGV9Id9XW6bU7vUFCow02x5Sp6va30n+COKEF3jKy7wYZvEVRxbZp8IvqUHEhFsi
	 2jg08bw3Ld8SVjc92q4NUWtulopYt2RfAKJIPTDWVEy+g/2P00SS3m/DHZSP0HOELq6lo
	 KyWmLzPmcXUIeKzVqlVwAvvMNCFIkKxOoXGzIEkUj926MYIDOQ0av0XzYCv2NpzbrLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A77606CD23;
	Fri, 20 Nov 2026 18:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A77606CD23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A456D6732A; Fri, 20 Nov 2026 19:14:24 +0100 (CET)
Date: Fri, 20 Nov 2026 19:14:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: number the cache flushes submitted to each
 buftarg
Message-ID: <20261120181424.GA1954@lst.de>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com> <20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
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
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Can you try to merge the two patches?  Having the logic split over two
patches is really confusing.

> +	struct xfs_buftarg	*btp)
>  {
>  	struct bio		*bio;
> +	s64			seq = xfs_buftarg_flush_start(btp);

Nit: we usually keep variables that are initialized at declaration time
above those that are not. 

