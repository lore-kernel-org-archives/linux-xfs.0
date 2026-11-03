Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717737;
	b=UWWObyEaLD4/g+HSsoGdK6vg/EHmXNJmPKBwoJOS3iiyoJ6HP6c/hBdigkWUlEH/a3Gl
	 ruzLs4/f0UZlEP+j4xDpu7XT2JvmZnz+zPOIcSwE4ADtpd06OTaNolKV+9HAiU3SkZWG9
	 5pG3b2g1q5HVWuCuodYOljpfOAyYOwKEUTL4zCoQKmqWV3G3IZsqU0uip4sXqYC4jExkG
	 iKI0zjmSyow1HpYehbwnyotsSzRmsuYaFzzmCVoAO6W6fGF2CldhzGZJ26909KVDIBVwN
	 +TxUfjhcwvmDxxhVHGg+tiQwyEWjwQOARxQGFOKb6ADtruqGdW5jfBAmjagVSMGCBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717737;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=wJ9+7D8CTNSKpD+vxXFaqOrO1OYM/BJjvq62hqWSFEW/T/AoO7fheS7riiijwE85nFCI
	 VBr3p6LwPHXJEB16JWEyIpLBngQyJMFOOwY11gaH062ZYW6yNGIzJ+DK/XYAwzGByaDsf
	 CQpFQJwXcwfYlgwruSyKHd11M8L8z6ssQlewXRxrDJ3UCmhaIRAYt+uAdxjhnmOUHNJRJ
	 Xx+gV6UhZw2Y3McQ7eiooc6GZKgEO040sIXqKDCjd/qResPrvPtStfQGSBS3unHbNq67L
	 9i0SHCImBmViI70YyuT6PjMGaZ0K/3DFh92O3PNuir/spg88i1/x/8EHAjYMFTrmBiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Xqu4WS+Z;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40F606EE91;
	Tue,  3 Nov 2026 14:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD40F606EE91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Xqu4WS+Z
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Xqu4WS+ZS302cuVSRLQTj/6UWx
	UDtR81CXNJgX4c31KUuSOLvfqPegt21VUdWzBfwerUD982yTFgOKVqs9qn+Gpbh5s+doop/Jp0mM6
	7JKx0wnx0SxKpJxYiW2STgDwdnR9MWebugGY7Nswlx2gglawwGNt3lEFi2OKTmD8Bh+bUeXOVZMkt
	UYb0gEhkhQkHxFGcEB5fnYqTqWdenzF2kB0FvWUEXT0tWAI+dcoBQoJLxH23iru9H1IEq/KqlWUfn
	Rdfm5/ev21vOieVkfPLcSQh1toLVzEhhWZgAP1QQuBJ72BV4JnA33iBbMZthMPYSK7n3021vnVuvJ
	Dcd1yR/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFv1-00000002oZ0-3rJf;
	Tue, 03 Nov 2026 14:55:23 +0000
Date: Tue, 3 Nov 2026 06:55:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Viktor Malik <vmalik@redhat.com>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	Bill O'Donnell <billodo@sgi.com>,
	David Chinner <david@fromorbit.com>,
	Lachlan McIlroy <lachlan@sgi.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix temporary cursor leak in btree shift corruption
 paths
Message-ID: <aun1260OJPfdw0V7@infradead.org>
References: <20261102150146.19777-1-jianyungao89@gmail.com>
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
In-Reply-To: <20261102150146.19777-1-jianyungao89@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

