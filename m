Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491757;
	b=myW7DCbB71QT4vc9xr/FMb3pkFQkF+gt50OQtrWDpvRWLj8D3wt8EsJLwQlIMpmDQY2Y
	 /ZS7XScxZXfTQ4Fogvdt/su8KY5wPdmozqG+ZPwQ180TL96Ka70xsc7QAijUsa2bpL8ts
	 VCsmX461Sj+4zQSfX29ANtquVRh6yA5M+uT88Xb755BjIu9OgaROLfT65zh4fwaXYsyXx
	 l9I6Ht6Rq7OQVpER8pSX/L0JJdNmfu4STDuf/1sStW7Y66kMrTOrZzzRsZn2FaeQXysIP
	 I6jO2p2/FQtgPh8k/u/NhRVcUQgh3Vzri1kSXQ2vONKz2BOc1WrPM6bf4IAoRgzFPog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491757;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=kfPOOutypg6/gvOyWcf+er38LL+G2+SfSBhwT/jg0YqYFi1YHSdHb11FuQhNdVioqcCq
	 h6Kow5pFoWNeHEJQYyc/6brDiTYipWAMtASWxq3sgpa4oacNuJSJNQMwgdDQehcqQBuDo
	 m2HVhdNZbdGlAuiASB/i1fZSPsRtcBzYXSOUO1kNQyp/ppysNlPZX2d7iL6EctfNK87GL
	 o0gfHoa0qKsQVZ58AKv5HG8nUulARG4Ls7u0968oW5SHVUNbN7Cnz5LjfOxSd1wjoYY+c
	 TmMKwTfNbZqCLIWqM75NOeMputGNfKJ08YEWxF4W2NYTfDSOr6v66Tn1meyHWMRVjHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8E9606A31C;
	Thu, 12 Nov 2026 13:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C8E9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F20668D09; Thu, 12 Nov 2026 14:55:53 +0100 (CET)
Date: Thu, 12 Nov 2026 14:55:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/438: retry failed metadata writes again
Message-ID: <20261112135552.GA24290@lst.de>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com> <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
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
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

