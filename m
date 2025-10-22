Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EB11E00A0;
	Wed, 22 Oct 2025 04:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106621; cv=none; b=aRp+U6liMa1TCasAUpfN0GzIOkMFoocGbG0oh/WD9DZCyLpM4E/vO9lb4hAgtXAKU5KSMpt6OLb1JAbhokjqfnes4C3eG4ME9ysa4k9IefhCq/TFLoZdA0O46mvpHdZn51hN9qf/87uVhDc11MEZX3TYbofBiTb3t12FYKqFGO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106621; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V5xBL8QdV0N8mvxbGaFNrNMg//EHwc/0Ml458wU+pffmrxJmsnpuXkvp3//KxrNniWSUWAu6Ai2/GclVryymRQzVfWO1YVkw9kPfWA2OBMRudtCPti+MwxSs2y+gQXaJiOsKAB+kAjoU6FQW4HlOzez1+E1KBKYANiFO2riOz8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QJyAyIY2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QJyAyIY2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QJyAyIY21NBRhk6qm22EEZ5GZj
	QpB2DrwEz9MR3HdYQWAXT/Rx14L9BdPN+cXkp/N0DnrMgyV2XBdZpv3wd35uhth0fBeARUqzh14kZ
	hVZaSVkc3P7fjnymkVg9s/tgQHG1UhZzqtF4KlVIvdhK0EtevQ0E3jR1P8cTtrbShmZU8qTQS3bya
	nkyaec0wAnHeqvY/P0fV31WOKk/HeormnH2lwz7V4RKjB4frVSweX7RTSOuJkymnyYAlSdw9FPhdI
	rPaGVRsg4cHkfrdYHRf80XjQ/FTBhYk+qngn/80NHiT6alCuLWE0zLhy+8uUKC3lz+cg0Sl9cv3F/
	yKIrQjgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQHT-00000001PvZ-0dxf;
	Wed, 22 Oct 2025 04:16:59 +0000
Date: Tue, 21 Oct 2025 21:16:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix locking in xchk_nlinks_collect_dir
Message-ID: <aPhau7RW93OVFDy2@infradead.org>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
 <176107134066.4152072.17161623808506836702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107134066.4152072.17161623808506836702.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

