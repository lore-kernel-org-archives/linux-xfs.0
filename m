Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203120;
	b=udPRHeEhB9kNwKqxaECN3Pv7bOlEnr5qW2WNheT86beHNGTyrJ1/kwWFT9AXDnXTFOy4
	 DhIvGJz5I/3HjN6G6SjXJ7mByStUUcEU2bV9wN/EByLRmrw/IL1AfTj8aFyTuG8Feu1Yp
	 K0u6RmJPZRQiu77XxGVrIHoTUSM5FnWGRmr0nNCxFWbZYTe8dzcP5Ek+9yysq3aGKuut3
	 vN+Q+QmRJG3Aue+sRwHC7Wg+KFA/i/Uqin7yZ94ZUUUTCS9ZZEonuL8vXgObU4FpV/t4h
	 hHvlq3PEKWox0KzauKdN7yq58VWS7c6MONnpQMlaNijM2GT9KShuOGzPjn5Sv9BK2/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203120;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Wxa3Mtrl13fLM/Tqmy85yhq1vmpiVCQNdDH38gCdnQpgqofnN2xwwkhiI+X5/uiHTsPc
	 ly3cAQMIPA5PlpMkvjHNYhbLxZzZN/ubtQetzy5Wkhp1BfmqXZFRCkaFXpiM9mO1l81fR
	 +QN5d91nllZQVEZjrIqpuwOw4BIynFRAiLMuA8DYF9xq8x1eAdp4ibNSkL1t0VGkKn6AQ
	 J5U3d4F1IZt6gRyBR064BYO9jzL6HlOmZz2B/bvbTDBdkww082Qos2boUGB40tvMnkXad
	 zCkXiiRR28J9UR0zJcy3uHNGoy3hkDatOWUXabYup/DUYgZkBmKrMlZwSHCtZJKWFoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lrdrXwrL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE40606A320;
	Wed, 28 Oct 2026 15:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EE40606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=lrdrXwrL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lrdrXwrLoFOTWcSsCPFeo1oKQb
	kStEXqax7ntAkpDUO2MZ06XjFQAmG6Ne+8YRD6FF434elHtMES0K6W4bzOra4Ek2gMGhf92Dj6nx7
	1nWOvfkbG/UOhCXIzEXKwPqSgQ2GTlWHkdsXP4KpH3eZpAsxyp6nhrb7Uo/VSLt67vKeZAUMwAn8s
	QtFS+32ZC96ymukxzwaD7lA4sP2obnxvrS3TFfVb14VcA1Hkf4oLwi44z4dqUmh3fybQw1GEIdgRy
	JuLQv9KxqKfMeUlOpdKUxcLbphoI6exl+rIUGgNIr+/6xC1EZb/5/ALBTCQywZ5QC22XKJzBBRzgJ
	QnCJYLTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM62x-00000007Tep-2Vlq;
	Wed, 28 Oct 2026 15:58:39 +0000
Date: Wed, 28 Oct 2026 08:58:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/6] fstests: replace btrfs specific helpers with
 common sysfs helpers
Message-ID: <auIbr44GkKwofZs3@infradead.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
 <20261023203114.1655019-7-zlang@kernel.org>
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
In-Reply-To: <20261023203114.1655019-7-zlang@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

