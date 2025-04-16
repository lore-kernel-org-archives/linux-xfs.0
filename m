Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8C3282F5
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744780340; cv=none; b=fY98HXjIKwoL6qlok3jBgyrzpYjQRZyv/n+tsa74KFl9JkdUXAM8+3tNq8wpMJoVK/h4+5UIbZCFvsM/S8MlRRmM6lAGQx+88CvivKGln17hWSGHqalo4Lgdrau17tR/8zznuE0byLBCCNVVsfd/axIMLjPySxLDueqKfZtVFIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744780340; c=relaxed/simple;
	bh=v0LdMNh9ZS56uDiCBkvNR58t0JByQ9a8i54V9SPogqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbYiBWCsYk+qjmNeq2HSuvVMz93u0I7/HSYgt/EMf/VcrTiTFiSrh9N668c6lPit+oV4ZvebduLdsItkcdj23D3fbKKrQI1gUN1fSW/T2T/RbvCqEy129cMYG0KtpiMHR7ZhHueOTynhTvwYZbMJ/amxthmJr2EDDhCioiEk758=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LDBG/z/D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LDBG/z/D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uS4GgXKESafzwinsO8BzLL/6Vfgz5YfaPuBTk6jk41I=; b=LDBG/z/DQhsu0lYrmCGInOrWnN
	2Y/hYsh5R9Cte+t2IHdXiMf9Z6/0Y8TU4mh00kh5rRL/DZxBaHoA6CfJ+43mdqVNd5bdktym5V0VU
	EJmIMMEGwbeXGKeIlbjBaBOX+aghRhNFBEz9L6x3scQ1VhOimzs3+XXjvQXRvyFpANbx+bm0+3eYb
	yYFv0hDQ+hltCOmX87a6Duk8rj5999u00vZp6MZfdZ7Yurx+jjqcYqeItMaMPIfqDRA9aXQOrIHLU
	eM9IxKL9SSj7RZt74pURBYuYOHhurpybSMcjSKHn+r83Ty+/NF3952G4gLXbARPn1AcTLISQsKiNF
	+fjozlpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4v4L-00000008EAH-2LkE;
	Wed, 16 Apr 2025 05:12:17 +0000
Date: Tue, 15 Apr 2025 22:12:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: fix blkid probe API violations causing weird output
Message-ID: <Z_88MWlTrrdIB03Y@infradead.org>
References: <20250416012837.GW25675@frogsfrogsfrogs>
 <Z_8zojbPUQ69-hH7@infradead.org>
 <20250416045044.GA25700@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416045044.GA25700@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 15, 2025 at 09:50:44PM -0700, Darrick J. Wong wrote:
> static int probe_apfs(blkid_probe pr, const struct blkid_idmag *mag)
> {
> 	struct apfs_super_block *sb;
> 
> 	sb = blkid_probe_get_sb(pr, mag, struct apfs_super_block);
> 	if (!sb)
> 		return errno ? -errno : BLKID_PROBE_NONE;
> 
> So I guess it's just ... super broken?

Heh.  Please just send this report to the util-linux list.

