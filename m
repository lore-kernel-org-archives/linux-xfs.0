Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202680;
	b=Wn5h4nFRBE+MNi0WZrErOOz0QRs/f/yd9O3IOKyCpiP7yXzw7fGfeiO9z2noFKXm6JNX
	 5w81aKMArIsjVIecFJ6OdkDvhxT/5XiVg/4qmuA6Gg3C31YOtw/FlnkUN90BYaLNhXD6C
	 3jg8lg+q8OrseoydyJPcuLsO0UNko5eqq5qd0Gl/G8JicytN9jrhQmdtme598frSFBsVK
	 4CLIcYl4nrf08FOlVvCcB/sxA4yW4PtdI3+69H5oY5MU0DVo8vU1TJ7qa/0Tjq9mkhuGV
	 Ac/T8HuGE63gV0tc/JjxEsflyvBbPiKZk3aH/GrAoH4bOD4ri/KAVz3UkKVFIbje9kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202680;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=0r4D7xS6zmR2tFHmY39mRyC1HbwogK9DCr3EQFbVg3d4uK9yVJaf0mV96e8lnmlsrgwC
	 /jQolGb5SdvO1rBOhhPAZ0/CAXVXQ62vIz7ZqscRMegmZEgzWDJOABdBJqBhayx3p/TWy
	 Cz9EaIZEpw2vjv3MSqGj4e50FV79faxQAQrpa3oEYYp1AHw9ruItFWv35MNf2y0vRuhV0
	 IlB1JNEPpJMKlLbRXneR8nuI8lmfex530GoQlksc0Jk6ghPlziaHH+zXuWs73s3pwVOgJ
	 n15//A2Fsqg91slw9/l0/b7hxQOCFvzS8ZxbsIvIamVJuAdIa/2UtssqYu4dfpzMW3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QXSlF1dM;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BC5606A323
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92BC5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=QXSlF1dM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QXSlF1dM9p0wXk/brUanEi0L91
	ax3rI3OEYY11aszaKZQKHuYdQRaC5J18U2DWIRd3cDRJQEHeGZT2AJ+ZuotJs16PI+if+50k4X50F
	EpFcHJdgzR1+B2rq57V147nj5mSZGw9TCEfr6uNVtarhmk0sRVQjzcUxniu64lakx5T/z3+hT8lPb
	+tQQoZ4nK10sb1CKg1785eNZZszHQhsCOkh5lpGEfdexMBP/+L+SMIlDs7+keeN0dYRI2zpE6q6+Q
	+4kP6aFWkNnD7fsl/0eQS4XpWXWWmYJNnIWLO4Kk14Kb8v6NsV6BAooVMUOYW9owdPxgeGA+9B2l5
	cuSebzrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5vr-00000007Szw-0mzp;
	Wed, 28 Oct 2026 15:51:19 +0000
Date: Wed, 28 Oct 2026 08:51:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dgc@kernel.org
Subject: Re: [PATCH 7/8] xfs: remove redundant stat checks after
 xfs_refcount_delete()
Message-ID: <auIZ90n9AL9s9IUa@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-8-sandeen@redhat.com>
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
In-Reply-To: <20261016193422.1630907-8-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

