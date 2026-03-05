Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0970022258C
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719485; cv=none; b=VipYuY5kaA4pQBSeMGKXd+fju1omI5R/MgIStfFFtLjl0vIettnWbXTviD+0AopQXNWIboGvp1yLh/3CGFOBI87byNPNHD+PQIMR1uFJMH6wIpMLcCLqcchRUld/DFl4XR3yx6aY/GqiMtwv5ULM2gtkY3vPeSiF5sForY2ohFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719485; c=relaxed/simple;
	bh=zf77GdfGmSDfVyHaiLaVDX8qGCVwTSCW+wnmk4/oWpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOPlzmcKqGk28dLePqS1wEGIu/cjutMNoGTSn0mfHc6DnS99QHSemIraqz6cszjEIDdwjUSmhwSEdPWqUfi9EzRrk7I1awZa+Y/ba2BteP1TiUYT+hrm0tnzK7lIlyw5Ary0NtSt+q/JfaaAJIoSOO1CGy0y1w1zpCe6NJdEDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g1MEwvPI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g1MEwvPI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bzlv2gxDLV3CCMCiq32cu9zki9T+Fn2myiO0VWj979E=; b=g1MEwvPI9ePTPXw/DRpDgo4kOb
	H/85OROfRfS3SXofLKX7+WGYEsfkh/dF1EPPd0MraV+GjQzhh0E08oYUeihMLpzA7ATXke/KW4IGz
	vpf3uoi3dK4do+ZgtuSzNbRDPHs0EQqS/9uLPXpEQl0XwDlLpgxsKLXIzwvd5pGpz+SQraEh5p5/W
	dWs+3WgRJGN2iVZBJkROP88v68/kksy20+FRkLZCngi5V6u2/rjdPASVGS/U8CZBUdCkAouTbD+uT
	y1gIXjgTtpsD3J9UwYcTsCWIOxeq206fNDHjiUC9hPtq/7CKIkoQeVGKlfEqTaIUO4RTy0nk4+AXD
	CY3FgMMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9Jj-00000001vCi-2E4s;
	Thu, 05 Mar 2026 14:04:43 +0000
Date: Thu, 5 Mar 2026 06:04:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: fix protofile data corruption when in/out file
 block sizes don't match
Message-ID: <aamNe8Z_a-BEyxhV@infradead.org>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
 <177268457065.1999857.17773222106097875153.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177268457065.1999857.17773222106097875153.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +		hole_pos = roundup_64(hole_pos, mp->m_sb.sb_blocksize);
> +		if (hole_pos > statbuf.st_size)
> +			hole_pos = statbuf.st_size;

use min() here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
