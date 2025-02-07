Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE13914830F
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904976; cv=none; b=LdpSkbPraO2N6mXxPHrIJuTXj1Rvb9k29wbYiprJgjLsdmbB/iFMUbcgyUCkpF0Q/FBJVXkSPgAgdcLcxUqyd8ZWHLxxLXK8iOTDn9i1BtM41L9Ozjdf3MB5d7etV67bKKhuYwUUQyW1AUCxzZbzbbIRCL65m7bVTDezds9yUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904976; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFBtDW8962f0RGaibJZ3NEZQHwrJKbXUlGa9KTF2R4wsgSlLhAEu2N4giPqL+OjhzVDB/84MthyKp9TQ3vBY1zQsNuR+OMMTOp8YSv0IbbVXIrbFhAE4Rp/JglySh4Y1lhVKl3bPqHM9HoalyAbKiebv7h6p9Lb80fDRu4+hJt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XLy46BQE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XLy46BQE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XLy46BQENxHmyPRcHVP6DSwTWb
	E8YRFjO3SYxxbOhhfkK2nDeAwwAZF1RMygU+RgXh8kd5Pq8jq+n8JZSjulaU9TiHEtFFJd6Vn2rkx
	wm4503tbyUBbg6OASrPr5eZSWeJrycT/KASgnaPqLJb+I0BHkEvt6hW0QPslGnNWx3AJXC9RfpIzJ
	vTMP00ko/3ZN3iyA4zCn5WYtR801z4mAQrpf/PdocsAhl7xywxNP9CBOV5M3WQDiN97+ST9hPDBfo
	T2Hxo4ngzto1wkbBr4CD8t9ZIGQeBYeGyC4B+/Qdfj5fHiY9uHqZnfA6PEceJvSuMF9rtsf0+EDJj
	iwdgzDfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGcR-00000008LYe-0qou;
	Fri, 07 Feb 2025 05:09:35 +0000
Date: Thu, 6 Feb 2025 21:09:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/27] xfs_db: don't abort when bmapping on a
 non-extents/bmbt fork
Message-ID: <Z6WVj_JARdlbyEao@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088187.2741033.14219812382210540594.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088187.2741033.14219812382210540594.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

