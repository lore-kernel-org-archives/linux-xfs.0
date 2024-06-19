Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182186F2E2;
	Wed, 19 Jun 2024 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777220; cv=none; b=K7K51Q7bZX6KMCo1wBj6t7ixoHAG2+bRNR23bO8FlQzwyjOiBd1cMLB/do16i6u1gBhw8CabHH765mIsRyK/mYCQ0d+UXsfRw9n3zUqWy/PjHoKzTw4nOYoR3PBkZo8sKYObO8fOyfiq7QPrEs8gK5QXS+SiUDRQOwX/h4AMq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777220; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMtRL2k2hUv3bKVQjEAje+AJ3pqWDi2MjhL55aT6sW77z/B+5UnSaKB2q4/tbWkt72zHfhYFv0tQaKAxHZO64hMia0nZa3QhfmBzzJzY2T2xdrdWHcYLVKELGiSuC5ZgJb+zs4S9KLf9aQrl3Yzqkz7soiuVrNgnVXHuPU5/SW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YlBmjJvP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YlBmjJvP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YlBmjJvPRga3PHzZkf9oG+Ve67
	hoBMDpnbRRuLdlq0jocEPeQijfryYAdE+gGvGw+kMsNT8hBPlBWoAdteiUKD3Wwe3rhpJdwA9MqdI
	u007g69a7uvgkIWcPKaEPeqG3QSyhWm3rzpiveXbJ0GYEMtcJdG60BSpoBmuL4mSn8N1ITdl5lw8+
	Hzhl7vVngrNZJWf2ktWUC3JnLbi2lt1NEImLfwPeEYpZUPg2qFxa5QbGnSs61c7BylZ+uOF7gdJ5Y
	M1HEYSlfD5jRtl7raQeHmBdEoE4vFQCFFUJvKZghIZTKIRCsh8CJd1InCZRFVunc2CZTEjHhT+0pF
	vnQVeVYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoTA-000000000Y4-3IGd;
	Wed, 19 Jun 2024 06:06:56 +0000
Date: Tue, 18 Jun 2024 23:06:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] misc: split swapext and exchangerange
Message-ID: <ZnJ1gEkBx4HG5cxA@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145313.793463.3476248924058022268.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145313.793463.3476248924058022268.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
