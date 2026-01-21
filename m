Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46336657D
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979330; cv=none; b=AhwGlUpS8jNUox2992M47LeGV4XK1HZj68zY79kcXPYshrAivZmA1P0DezPXpPo8g0cTH2jOUJKDq4RXlWl4NBaXQwElYf4CBtesMqfgnvHS1D/WRHxJqmT/rfvswmXKlaIWlamFGNorjiU+mkJ+sozHGxsl76jn7ms4+T7oZb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979330; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5X77ArK7HJt+5px6SbT/OBIZz41Ea4QBTaCthhGCpsbukO6ISfRWB2KZIcJFwXi1m3f8eMz9idX8RT+w7Vco8zl9sbPQDiW+uIsgo8D5f2b3+Ms1S95p6SZMMkKmwqn1p1jYJWufBD4wmbVfUJ1UlJAWsZSKUeNlZLZ4HSFT9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oIUJAmLZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oIUJAmLZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oIUJAmLZZzT8apJ4vIejj4TwTX
	W4Rd4qy6AabCOv20jN7jT3ukMbYKScvl/gDNupuXPDErGUa1iqNFIzT1Elvdqb0mS743OjU2167nl
	9U69zp2bBbKDRuVlBA0ioKenDwgt2U/PPPO40f/WS29ipwrkwQy/Ur7won6GigJAq887uZulFbyIc
	Wsl32BglJXyzOk2tPxsaEsNaq/Vd0/8UnQ6iBYRy8ZRpilBw29EgvYzsVwTpYp5mnygETfqoOVIQD
	iALY+UnkIstS4fpM6t0MbrKnX9BT2r0OoT4OOSyAhC29Pzho4XoVFXmgzXbWKY1bxQ+eb5wSMv8jd
	OxroBNkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viSKe-00000004zMQ-44ZV;
	Wed, 21 Jan 2026 07:08:48 +0000
Date: Tue, 20 Jan 2026 23:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_mdrestore: fix restoration on filesystems with
 4k sectors
Message-ID: <aXB7gGGxoJusVQde@infradead.org>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
 <176893137144.1079372.18089929345976968624.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176893137144.1079372.18089929345976968624.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

