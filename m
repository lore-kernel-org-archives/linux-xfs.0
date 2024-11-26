Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2A87E9;
	Tue, 26 Nov 2024 05:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597418; cv=none; b=MxpMdHx0Ck62B+iYmvEoMTS2Tjy0hRR1I+rZiX+894/BQEU+NykRV43WrF9VP2eTmY+HZNyl1NF9WFoHvvyJQgWcJhLQ6RZbqQLmylbuvsKY4eR0Mv+2/iabOSq5GCM46ESt2+7uJ8sXSTK9lRXZDhqZYsKgw8FbRpaq2lEEjf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597418; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsSAdWd/MjzmxuMxb4ypHqBVknHAL/XjXWZQFYVW89CPE18TDPwgnOU7jx66BB/Cz7P6Br8Dgf3g/a3xp0D7tDZ6JXWYF21RY9zimKbhoFClRtY3+zEpLODaW5CTuv0ZSIb0R35mwiN6X2RaKfOtElkpHoUrqfVLAagvjNOTMDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FP9J/fyS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FP9J/fyS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FP9J/fySKVDYQsaI6kvUImfx0y
	VTpSSN6MJzB22Tx2WgvO2WwMBKMQlisj4L6BiVw1CIFbLp74xML7HDRGSNhGXJQsCxrf68+Tkpoeq
	nELTTCCN49o5/Ktlii40NXHOI8f/gy7bwAefCMGhYScEt+vTbRgHT4rjMs9cCWdRdq0U1ZNMQ/fX2
	mUBHGheiZM9C3iPxEA8kW2VSS+1uX9gHGwBdaB3GexgGOl2nLImS/hjR+TwY9J5eQJp4o2bZlgorl
	0bF6Coyhed9B5RivW2AgNPXfMJ+ktm8wWjFScHUGUztFm9ZvyLPu1QBL3j1VNCLpkPstn8la4gmme
	Lkl7oT9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnjc-00000009e2r-43u6;
	Tue, 26 Nov 2024 05:03:36 +0000
Date: Mon, 25 Nov 2024 21:03:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/21] xfs: unlock inodes when erroring out of
 xfs_trans_alloc_dir
Message-ID: <Z0VWqGs3KnGwxE7Q@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398025.4032920.17639399507003367709.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398025.4032920.17639399507003367709.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

