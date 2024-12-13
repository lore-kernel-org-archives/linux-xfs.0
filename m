Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B80157A6C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734080929; cv=none; b=mVSN/yiP/anxW9nRkHwtH8mzp8qxxU3LLA9hAP+vCVwisn4tnZQbUpR6Pwy97TcpcnyflRTe2QcS72PJEHWmaxxyKsZZhVlrkQwhZ3Q2ILoDPtPIcGi/4RHPpZgFzQp5BkO0fm3+gdRE9cpFpYTkG0oJO9R2lJuNDyv213tVoso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734080929; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u69XJG52q2Rd2TuDteMy+ShU9C4R6z9Cx/TYQ8BHbwB2Bf6xkqQTbFkF/tFuTMkR2no8wOQrN/hgBy2cb47/jNBWJ3i1cHabQixFQqMcUH9oKN3exEobt4kRZhgdGbHe8BL2obu+Fj51UA+e6O/zqEO5DFSkZlAawcKqyV2Wx0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VgQP2vcT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VgQP2vcT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VgQP2vcTTUTKRhgJjpmchueNq/
	ypmmu4eoIHRZNd4FVqoBAbZ+tG4sAO0cn/IqwgT63nLXOkOVsarLpbE2QSjqfq76ttXqJ5TtgVwWZ
	dCGMOtZvt9onSNTl6gP5rrZKTxE63NpQw3vBnnbE1M58RTRwb6TX7nirUKNdtPDheDVoXugtZR8bp
	D00M8lRniH/JlkCTISHalkpsbe9G7eRHjc1ngKifqAmSoLpR+H3/fNwN+zQkbxP5PBua+MazogT0v
	6dydi2JRrdUog8f5FLo/PpTK4v5oA7QOGKNs5D9AsOPsJWqH6YrP/ViUtDHs+L6XiwWdnA4wnlQph
	8+Hu0+Iw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1fD-00000003BlZ-3JbG;
	Fri, 13 Dec 2024 09:08:47 +0000
Date: Fri, 13 Dec 2024 01:08:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: realtime refcount btree transaction
 reservations
Message-ID: <Z1v5n6-Xi8e3xCok@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124636.1182620.10803993698212980927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124636.1182620.10803993698212980927.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

