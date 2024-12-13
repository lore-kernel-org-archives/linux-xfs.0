Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE431130A54
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081566; cv=none; b=uPwQKnewh8i8ta2nyC3GMFzxL+uo99qGvlzkGgNmSVzHs3nvk8FHnHuXTttFf562Pr9yWBLHX6Mhj0EDlPWx8Y9VikVaR5D7sj1pHBYjDsJ9gq3vLOgpWpF43L3pqtUmZddFf9jEbaU2jlhGceCvtYJUxfapC7tyPy9+xwhN3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081566; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAgAc/KOUzwcM6+ztQawEmbqM0dHYiKjfX2OXMuxCw4ov2Wmv1owa/90J2URKgzWkWSaEijYOnMhS82s1mpYcsc38LHhC9k5rapY9DhhYP+8BuFaJ+oQIUDhiXZVlbxoyue2Y1ufCVIqRuoaHgy9LDRu0rqUoRQVAXu6edBZ3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EDNL2BtC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EDNL2BtC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EDNL2BtCAprAIPT5IP804E4xnJ
	WkPhNUEMdFu1g0dJapctcJBT1n3rVjkmUNVxWJ8cuznO4a4RVZNoJiaApydmLkpOZaSHGfM29LFg+
	qvrHBnoJF3lCSHeGX88FP1s0Ej3uwNDZdQ2f9JTw+5hHtS4M3wYh7p0K4j4pcCSsh4P+yxIpFzj8b
	i+JQEueICrjuDJQdjr++LMAw3WJnNZcP1o8MJraQGtDGpcMUO5hniyeYnHMUJdW6EWb/YKBAdnP1m
	MNrbgzF5nq+Q/BDNtQQdyhuC2LvrVPdaSby0iPtuEmmI46SLtYp+Ji25b/t0QN5SVW6GAG4QNJDGA
	XFzCwZxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1pV-00000003Dyp-23Iq;
	Fri, 13 Dec 2024 09:19:25 +0000
Date: Fri, 13 Dec 2024 01:19:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/43] xfs: check reference counts of gaps between rt
 refcount records
Message-ID: <Z1v8Hf58-bxX7nNR@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125099.1182620.9815814824279528010.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125099.1182620.9815814824279528010.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

