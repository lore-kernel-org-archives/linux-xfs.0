Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202527;
	b=3ZUzknj2B5byS1OWHJ6EjSL8K5dEipt9zL2lCdVV/SnABPe65Ex0852xhBtrIC9XitXJ
	 JziwUwpSmDNmSVsS0pt6sf48TfGDouSghoHUKKDjZZuQbDhPnf9Wf3TkTsxNmzj1XL9Hn
	 GATOPQ+gwD9GtDItFIPkICacoM761ue/XcKKqNJCBFLO+L7kznJocfpc4SiQ+rt1Drm0L
	 m2EVnTC5KZX52Gbde4jxKaE1RjoUuX5aY/x6pPd8J+MW0jzdfntaTJYNRydACcIg9R2Zm
	 jyKvEEWuDAPZXc+UdYdZXymOVmCG1OGEQbBncCbCt2nmFl+xs/SfCOTQi2yyxkejrGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202527;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=U53xUhyX7xbuNCNht6O0Sq15XE3fLNVOd4TLSi47Wwdi3UoV0kfETwa1Hqdif0sV0TLR
	 2TFV3cfVhC5FcI3APmb6t8Q2hLr3O4ZHL+BnIyJMUlIyBnAEkBA4CUfZKAK+LWgX+Lz9o
	 +b98rIHJLKVMa1varYNaOyiiim83Td7yXU9ycFypxTiKIjr1z9UmyKjHHu982aQzYRc/f
	 ++pxihFJ40UN16aZbE/vkx6zBejDMcL0jtLfgxn51D70RiBkCiSzKObY06WLncuGEWgd8
	 +crHsHUFOf/Q0FW+AVnn+VRqcG6BFFKeuSm9e7sB2fB6gS0iYAuqJiZ/GLqGUeXLv2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=J3Qx3YIb;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D6606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:48:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 204D6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=J3Qx3YIb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=J3Qx3YIb7yQe6VlgYfH8/thfsC
	kKaPsfXXgpAInjSdGBLm2udV0OjnMBFNnKkk7PLhYNaGWCH3vuX8I05sPlXzacwLxTdcNJRAhr/pO
	J0Ts/K22yl7mNoIfTB1zCV1KHDqpzJmQCSY3hD25sqe1hIDCf3YVwFJYUX81UNXaDyyLfDx4ak/ns
	DqaXDiMKAyQ+ezgdV693XUGw8nmZ2yB2k18O44ChSF8rKeitsbWEzJSItOHl5kFKIYHQVwJxN5ten
	txT0PqaGEyPsdrw7TWe+0sSpnj3EUR//Mf68uzXJdLwsuu4Hqkv5Sgr6mOwsnwmTmNjqpfsZtjpYK
	AmCCCXKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5tO-00000007Sbk-2tk7;
	Wed, 28 Oct 2026 15:48:46 +0000
Date: Wed, 28 Oct 2026 08:48:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dgc@kernel.org
Subject: Re: [PATCH 2/8] xfs: remove redundant stat checks after
 xfs_refcount_insert()
Message-ID: <auIZXm5j37PFKOU4@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-3-sandeen@redhat.com>
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
In-Reply-To: <20261016193422.1630907-3-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
