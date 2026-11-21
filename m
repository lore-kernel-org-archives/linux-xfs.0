Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220137;
	b=qpNhTfFWva12Hu1nFhDnkguM14OGSzxGCYUFn/LCmg0Or0Clu7+F+ZwRd8c5R7lLHnse
	 5xtjimU4wCYuskAJW78//1OSekBz+z4RxlOdfmixty65WEtL6RjbtU7fM7mjqHsM/B6RV
	 r301dzCSiawofqu/JCBH7RXpb4tHVRKsyv8xEWRYdIRZaOPEmw3UVGNLEANm1NxY936Ol
	 uACXAsPz8hqnfdflLFXj8hd5KVpQJWC2qc3BYRRewJaVFJsJA4BX7dgcnVUJLSxYKu79E
	 9UfSWUv1M0Zs1LpIylGMhqm7YgfZecvgSZMLOr5EY2BrKkiV9ens2DnF+cQbZaBKWhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220137;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=SjisINx9FfyaE+/G8jmqcq6Fr36sGDzrQLG+XhRJ6i3nuX3Wf9VrBGrgarR63YyxiarW
	 K2K2eVE9qVpLOFRa+HqAVAnO7PuNWOZihzgwaiFsddU+bykSL6oZvavasuZ1pAa2lEHcl
	 KgH1JUtIv8ulkvmpQf1WNmvhVv0BHqotDg+y5q0lW4y8269xGza7zEeDQzK4eEv65JSD4
	 FHVmgBHo11jBnXuifWr5B+sQ0QU8MURRvMXPm3ImR/tMzL9d0qY2lMFmpFmEuz2mpaZjN
	 UJEkC9gSpIa32BMW3A5mR6ZsGgU5KN2s7nu4wV/CIJPgQQac7ivSigfh8Yw+qQAUhKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bGWTabL7;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95596606A692;
	Sat, 21 Nov 2026 00:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95596606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=bGWTabL7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bGWTabL7KzDhuuh4YUV1Nzpm4E
	CMuXFUprmXcP17I1ethA0y0kwpqmtzPRDue5CG/IjiDC4D7zQAoCSnC40dR2RK7VB9ThdfiGnhW/2
	DI/zQ796Cie6rffq0vGVURHhvxovoGpx3h3KUN5yWt5PVUFh7j7/+/z95heuyxVqPC5kSZ+1VofqK
	VvBW70RoBxRXH4xPKl7QIX8KpyIk5rAM4MVhbUah+U/XplHYhBI9ZYKFT+6mS9mkZY7+PboRq5RvY
	hvSC0/86l4XD0kWF6byXaqgpOlLEz9l6xSKBYjoE3lkROWO6mdweeXzzLiSA9W+v3E/SpxiJ2IP8j
	n197PS+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUYlM-0000000GUHy-3gmK;
	Sat, 21 Nov 2026 00:15:28 +0000
Date: Fri, 20 Nov 2026 16:15:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Hannes Reinecke <hare@suse.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] iomap: don't update i_size of block devices on
 buffered write
Message-ID: <awDioKmT7qYBdiT6@infradead.org>
References: <20261120-iomap-bdev-isize-v2-1-f25cc668fbc1@debian.org>
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
In-Reply-To: <20261120-iomap-bdev-isize-v2-1-f25cc668fbc1@debian.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

