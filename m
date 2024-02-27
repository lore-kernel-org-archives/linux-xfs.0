Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5014534F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057761; cv=none; b=ZBy4bQIMuBghPpBK1Rx7umQABnbiH2PAmgOUlAF+z0R4rRd9grqvxAQuQRSczhhrm2BkJv7X2YDgSHB7z/Enm30ZXc9orliFNpcu4yLOdQkYmnjKhA82YKxZdalF/v2qBx9qAkdH3Yxjy49c56ipmxCIO/fAhH91xNWFHOLzrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057761; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEZ4tIg8Jy/laTvpMtoIKUyrm1SSjs8TIbzI4WHgZ7CTPy7XKxD2AEKwzKv2VEyAVDLEEfi3fFG8vbVDGrfPMYL5qAsBm4iJ50wL1V8sFztdz7OtopgslH4YO26oFlXVI4xr9O2+GB04BTgYVtG1OBoaUhK2BeEvkawamkN4YpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=we/nQc7Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="we/nQc7Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=we/nQc7QezUwirYunYWjNC23eP
	OW4wb3FUUbUuXfsjTN6Om/qGvi3jfozVADzxE5+Xs0PlKQjvGnd7o//56YwNMiYLv6BWIasM7A5Q/
	ZRBzk+fp8SKnmdtaAZ52gX4wsNk1csbValyF5xTFPadPAOuiJSBlDbMXZw8zlYxBh20i2jVIXxI6H
	KDW+Bcn4hVyrEq9xQfK79HJv56gANyo17A2Q299GLzVc0bHXn3+VNsS4M50mCA1c+0/v7+4eVGRX1
	qcIaEhu0Xyrx8i8SIgZGMdlsnrWy1lCmYlzvuQofF/U/ncRHwP9VNW4AZOoQ/7oQO1Y/Xa0MJCiQC
	wcTlbn7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1zk-00000006OSU-0Mky;
	Tue, 27 Feb 2024 18:16:00 +0000
Date: Tue, 27 Feb 2024 10:16:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: create temporary files and directories for
 online repair
Message-ID: <Zd4m4I6aItYDAP06@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012248.938660.1076834138892216129.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012248.938660.1076834138892216129.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
