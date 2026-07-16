Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C53E0222;
	Thu, 16 Jul 2026 08:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190390; cv=none; b=nmtyDEgaY0iQmsvWbBrtK9FYhF6Sl4V1npoQQyy3RurA5iciw6aFOXETg279Xv0QWZ0+SneBUw0LnymruwmFLTQvmH5ygjfjcFcEw9EJIrYOERuPdHxaSdv9xmFkc5ug8EVTGGHrUe/L+2oDE12exH8aBYxm2RwNVRazqqF5e/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190390; c=relaxed/simple;
	bh=2AblPf1RDbg9RsRhhAq5QD4eS5q3JpnnQYxlCwWPDw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vD32CEiIvmdTWAJx93gSlgN3FvG2Ay+7/8asdruAyq65GxjKPiGlBDkVUQ/UR+fBQvboSSTqpqwytgLpYZj24xfWIb+8y12YzA7gDwBfXo0PB5CnZfU1J8oJnO/krGKSVO/qGeRcy01zouMFXgjtiPqpnXoZdw0OhWvyFAZRpdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VQcAH+s+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VQcAH+s+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HH4vbdwXYjKWO8cYmfnVMB/RjqgWTuhXE5fLJ9fHFNk=; b=VQcAH+s+a5NBtsy/2ObcOifa2h
	7dn/S7M9Mq5zXt4I+klCW/nTc3C8DOsMsh96N38bXuyhyzWCp0MXClOwnZ1JQt+9L41xXn5b2Tzit
	OjflJbPsB55qpMv+qKQKqJ32PqlMoklBEigeV20nVXCbuLBEjq1+Lph06Z+KiSskkeITWvDCJmqU6
	Dib5+N1hro4k8iE64fKl7mVSAejqNZrS6Jzjgd1ESrp02DXY7KHZc+Y8Yqz4w6OcuqBGGadi/MwBN
	ompQcv2vbIe/TJyj4DhSnAcS6BZ8u8kT2esKPB9lcpWj/l5t3N54bKDFPy3hmv1S9GE37580nz/FY
	ciobzuZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkHQD-0000000Gkap-23xI;
	Thu, 16 Jul 2026 08:26:21 +0000
Date: Thu, 16 Jul 2026 01:26:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qiang Ma <maqianga@uniontech.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: clear zapped attr fork state when bmap repair finds
 no attr fork
Message-ID: <aliVrdJB5tAw2lpG@infradead.org>
References: <20260715103026.1701559-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715103026.1701559-1-maqianga@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 15, 2026 at 06:30:26PM +0800, Qiang Ma wrote:
> +	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
> +		/* A repaired, empty attr fork no longer has mappings to check. */

Overly long, either move it above the if or turn it into a multiline
comment.

Otherwise this looks good.
