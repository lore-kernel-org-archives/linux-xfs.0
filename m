Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0015E3DEAF5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553533; cv=none; b=PfOunryLUOroYrcv27L47XBUl5mtZMM2Hw8Y0IJdKw7DMgAIGCzd4jXhkQiuCSW/krh2AKUkceFoNXN18fN+y6H2PUk55gcyGrKKOI5tz4650n1aKuaL32BEsV1Aaz/uocFKhedTLCbjrF8mB2sM1ATRWCvYJmCapxKHZErz0YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553533; c=relaxed/simple;
	bh=eeEyLLNRS+fMQ+ceFS8Mpf9FrBbaneM4ebFR6sKDaxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pggfHPZ1nic++vM5FkkF2DcB3sWRLnXGvK+AFLmLPdZ/lyz3Ec21xdxRCSVoldwnOpDnvJqxCreE3tJ+boTLbsx0SAS318rrsJ8+s2wmU6MS6u15DDJK51wf1k7+6g9KyTimb/XTc+MDm7goc3RDpyz+NGzKmAtQtdALOw3lFHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qckV7x36; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qckV7x36"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hTTRZ85wz+k5k2GsQGDlBXh8eBxYBkOOEVJit3RNpKU=; b=qckV7x36m6t5U7qWKpgGvxUVRj
	TF2861ceq5aAqXiJrptQIgLxeNusR9YAUwxGA543CworH1daeXDIjZpKaJFqSvmGTk8aStfZXOMT4
	LWQt/EuE4CnVCP4Z6rDtbVxyYQ7lb3VLMF7OeUXuON1cWxKVAtvVwQre8U453dPb4NZ8m6D/jlwID
	deolwdKiy4MqzlVr4JOeXmAiJ2dwJoymVuCSiBRl1J2Chg+qSi5TkXv1EZTuhPhWjVJY7DfS3ZSeO
	TyBrE4Wv8E3H/NHwm5WJJHH2DPBjF/dKfDi4QWa0t+h8HiAR1NDy/aspKGanzikO5QOl2ec/02cJN
	LkOlbw4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS96-0000000FUhU-37h9;
	Tue, 03 Mar 2026 15:58:52 +0000
Date: Tue, 3 Mar 2026 07:58:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/26] debian/control: listify the build dependencies
Message-ID: <aacFPGYApuygDtHD@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783766.482027.4988973426565666068.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783766.482027.4988973426565666068.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:40:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This will make it less gross to add more build deps later.

Looks good, but should this go to the beginning of the series?

