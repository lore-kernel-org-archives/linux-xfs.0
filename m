Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510F18C93C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071110; cv=none; b=fs7vx4EXFoKSGTIufnE16QICzDQdWILv4W8/CeeQSHEZ2C6b9OsYyOxdgpTFSAzfxM/RSl8Ip42ADsaQjbWAgAw/7IzaKITq33R7o5VN7kVfzmvYpvzsDIPI861jez8xaJBXAj/f5G9iPilAHhIwwXUaMfOPGkNOszAXHJJCTI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071110; c=relaxed/simple;
	bh=I8xPEoIL2Va6N4ESB0WfiLGXecS1hh9ls6dWuilcdKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tk4GQjDj68r6juTBJGLo+ufBmV8VU79NQ3tufNBy1y+In8pw9460tsGr1ybzQeXtr87knlp5Cls5YfxAlCcSaUcQHuMI9ew+IUAHFbilMGtUuh4gCpiDuStqfQOi3EY0/aCIhON2Ri2/Y3aCpoMyz2vij2A+2eQbvJg5BAyvYjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NNHN+a7a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NNHN+a7a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5WIs50Upg/ht2YO2rxfZVpi3R22sdNAzPL57DOkLNUk=; b=NNHN+a7au2cy9j6Pu53lj4CBfF
	vSgKE2lRrswGbcaAk4Jcuq+nZi31YI2ku+WTX8WP0HDHL8EQtnYX2+H/PyLWOpvU/R4wOYzUiBTcu
	HtxREJ10Vd3pairgXk1C5+5c1Jd61V2f2iboGkX6IDXD55XQysjHrSHIylDVwIbLlIfNExqjOXiTS
	vAEqTFR+BHK9zWkbTZXlzkWifeyholsAO6pNbTnd/gEE1QdhDo7pm5fBzZ1gL+76nQZCxg9HHFNbY
	fn5imXoJljd6yzXZ+xKHQYd8UbTY56lV+zoEXCHDL5Xyc+8wbnGj07TfQLniXjhXrn9/TyIhqZglK
	8qjQy3TQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz6q-00000002rXQ-1hNK;
	Fri, 13 Dec 2024 06:25:08 +0000
Date: Thu, 12 Dec 2024 22:25:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/37] xfs: prepare rmap functions to deal with rtrmapbt
Message-ID: <Z1vTRDdaanmbUczY@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123434.1181370.2967234809192965405.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123434.1181370.2967234809192965405.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:02:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prepare the high-level rmap functions to deal with the new realtime
> rmapbt and its slightly different conventions.  Provide the ability
> to talk to either rmapbt or rtrmapbt formats from the same high
> level code.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

