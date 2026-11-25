Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616971;
	b=eBOIhIpA7Vy1FGm0MLIBk3OrrGZpTL/Y+/y/rPWBlj1MS5weBEI5JN7hYcO/ujIRl9Ei
	 D4TVmHGTrVmHGYImbxR0qDhWpgDQAYzohDo1Hnzzlm2FXJs+PosWM6e/0IhOJYDP39Ksf
	 czbu0guPF9bg9BN+DMMBUeo0ISHvrTIDcpQQUm+/QzAimaKRlRqazwJ2VoGmNqxe0YIz1
	 nLxoMWO1TssfbdR2lKw1XH0q5p6bOcROoXoGaFxqz6ZyJ3x3mWtoeGddpLg1gbn6++mzJ
	 Pw3c8x6SNMJTaq82mqsfmFXX/0S9S+SzWRvTpsswMVcBfaOBifaHEXtPBvaRy17nmiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616971;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=EwAn6n/xFkh/wsduSbhLjSW4qWf6LiYHQB0eOGq6tNSm5BvEenImkkI5t82sWUwKbWMR
	 oc3LVas89Gmg6mdkPGB2c9TEvDOxF7B/HWyjoGif8njF5WUMaqRbVggE6DK6db1TqFKOd
	 N+7OCrhZEhBjS6VfatMIoHlIvOr0CQi8lpLY58TpXBtML0z/i5//5Xjribe16VMm+JgkY
	 u2saL4XV8LkOveCmrKoaV9DawMC0UskCYVtccFCYJ/HYHblAIiT5kBFFzvH94zra0M+Bp
	 29UKclYJ+qNsYW/qh855oa5PWMCqiJ36xyQHXh9K6GOYuuFMm78mYC0LAXx+ZThEuFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45056606A326;
	Wed, 25 Nov 2026 14:29:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45056606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA36E68BEB; Wed, 25 Nov 2026 15:29:25 +0100 (CET)
Date: Wed, 25 Nov 2026 15:29:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, sandeen@sandeen.net,
	dgc@kernel.org, aalbersh@kernel.org, bfoster@redhat.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move _right_neighbor_result trace before
 erroring out
Message-ID: <20261125142925.GA15107@lst.de>
References: <20261125133204.113558-1-cem@kernel.org> <20261125133204.113558-2-cem@kernel.org>
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
In-Reply-To: <20261125133204.113558-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

