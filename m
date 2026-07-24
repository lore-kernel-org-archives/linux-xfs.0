Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253D3264C2;
	Fri, 24 Jul 2026 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869825; cv=none; b=d/Kgx92AsFneze5sF1R317p5Vf6Gy8rimhf6RHNkdPWaI2WzRPM5v/VMQvUyd65ccYHjmGfEV4dT3BHc3BxpyXxTTAssocXmJsTKKTETvxXC6HiXZK3XCsH0WJfZE2ayKZaqt3Gm1T7cvkDd7t5IIKoBI+AlyyCHBjqOsZ7SZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869825; c=relaxed/simple;
	bh=VU8g4/shSCvXEm7FSdEi17vsIkIkHeJU6k+bGTftiwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7ZCBwtUH1AwmWFWMmiGRZOqbecv2OltoVj8GQQ+ozA27u82/VluO6XL55Ylz3Cexpz7iimW/p4CRKdjWyhVaYlz5vi729/rfdqHPv4LT/mMWcBLk4oK9Lc7YE9lD/Q+FTUtVy8ZVwBCL9DeVYYx5OxubB6kz+fodGJOGidVw84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ctvklpJq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ctvklpJq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=d2YEf4uPTs970t6wyytT2aEZIMMUUMG3DqP/LUHpHbk=; b=ctvklpJq9UZMQWGSsJxxurNTGw
	MexQGFnCYqIWDVmERY9DvGVFAKutAbU42a/eMaariQdRiq++tzIwVfAP7qPaSzsHr3+rB2ePaKo20
	vv5goWx9dYL7EsAG1nGaHylesnXS54EC9q3acIrvDWZZnvF9vvzgjEXFif0W3iw1+uXGJYsxMJ78l
	Js2cfsHy1YB7E7vUqpC8ACKLrK0rNmGelxSuTxbHpRWg6Nq4uJzOmoIiVAaCgxZx68mAwXtvDtjEu
	3pq+VveVFFlbmedv9xSB9qF57Ld0FNucMhtAGUJGpJVGMFwSJ0nHAHUH9z7zI9iPvjwEBQ1DWVhTm
	uyjVrM4w==;
Received: from [2001:4bb8:2d1:bd34:bc05:3da8:f7ec:c468] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn8Ag-0000000FUMI-1V8F;
	Fri, 24 Jul 2026 05:10:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: fix fs-integrity for non-PI metadata v2
Date: Fri, 24 Jul 2026 07:09:40 +0200
Message-ID: <20260724051001.202741-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes incorrect calls into the PI generation helpers
when using fs-integrity on devics with non-PI metadata.

Changes since v1:
 - fix two more null pointer dereferences

(I though I already sent this out yesterday, but can't find it in the
archives.  At least this way I could pick up two more reviews from the
post as part of the larger lazy bounce buffer series.  Sorry if you
somehow got this twice)

Diffstat:
 block/bio-integrity-auto.c    |   10 ++--------
 block/bio-integrity-fs.c      |    6 +++++-
 fs/iomap/bio.c                |    2 +-
 include/linux/bio-integrity.h |    3 +++
 4 files changed, 11 insertions(+), 10 deletions(-)
