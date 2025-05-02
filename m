Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEA5221FB8;
	Fri,  2 May 2025 07:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746169934; cv=none; b=DjrrHIWTaA5aQLBG+0sM/bDX/D74NZa10zmzPQtqiEWpNHdyAf3NLHYVbuWHJlFX5nKPrL4fqs+23BLTfdF7gUn/ph3oMUC81S+ig6lXnhf3NRi+rsNykvUY4+3en5hVFiIhNQjbIwonsr57ASICuYL4KZ7KDNItBgDkMd+aMEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746169934; c=relaxed/simple;
	bh=POHhh+igl2+Qj8pja1hK6kR9Va3Wc6dkHIRjW38L3ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfu99fo8O1v7Vr4eHDFRZnGJlfcl9E6WMXBPRon0cfFXtTABoOF+WZ/YWToe37e3G0Yk7ZYfmSQuSEv2c1PxcXeOFB5Xksero0FzhXYIibjrB8Xj8YA6XmClk6XrUK1nsEX3T6IvH8Eyx2GfXLiiP67+yc6rnx5Qe2ZWoh3JPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N7mkR6Tj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N7mkR6Tj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=POHhh+igl2+Qj8pja1hK6kR9Va3Wc6dkHIRjW38L3ag=; b=N7mkR6TjmIazz2Hwc98FXX1qy7
	rVnkTvhHB/5ZpToOA0R3RLm5v9jK5PAc03o4jj0FfISf4CtHOEyDmYTD8LwRcdIYbT0t5RQzw5Ean
	k38Y30BnNQ7QNeeF+4W2JWIkLE3F7IleQz+uil4EPCwAcgJEXHQZl/1ezgQ+LJI7tx8QNQzz/Y31X
	65rlQq8r9rhBmEroDbRu17aNMai0OeSXHGscdU+om1fMRiKoaTLRFfxIhGtMzM990Q/fv6SgQng1P
	CKHFsMBnIuq1G4JpAdte6j4R3RDwwOJITMllC+uoAwm2l/qz3hExykCWqzTrauhO9CCjZtrlMBuxH
	dwLpNmxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkZA-000000014O7-1ySS;
	Fri, 02 May 2025 07:12:12 +0000
Date: Fri, 2 May 2025 00:12:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <aBRwTFxik14x-hyX@infradead.org>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410042317.82487-1-catherine.hoang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fails in my zoned device tests with;

mkfs.xfs: error - cannot set blocksize 512 on block device /dev/nvme3n1: Invalid argument

that error turns to be because the scratch rtdev /dev/nvme3n1 has a 4k
LBA size, while the main scratch device has a 512 byte sector size,
which is a configuration common for but not exclusive to zoned device,
and which means that we can't use a 512 byte block size for the file
system.

I'm not really sure how to best add the case of a larger LBA size on
the rt device to this test, though.

