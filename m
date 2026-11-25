Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590054;
	b=g5gQ2+1ZtpHfwZvsmi0iAP3ULE8mBNHPdqILJqZGmm2bCK95FSdeUgPv4CSxsZDJ+T5G
	 mW/hDOOCgzn2LmpdhXdnnGdR5z3iGPZmc6TpeqKSNGNeITcRHFbB5RKiy6YGYGgt4kpiL
	 OWUl0nXGLKEC2uwZ1BmS1vwNRl2SqSdiO+eU1D1YvEEjFl1Ej6pxzogqp/SFncnsRUI8+
	 uWOpV+ETjPYRxRdo/vKPQwlWxG5xJlFgwJ3hXCLcW7XZAc9qjZidCIT+yK5qHtsKyS+DN
	 L610n10RyM1Z5kCnxv5KFnbTGe6xTbr2sFan3Y0Ywc+MildtLS5j41nf1J9OSl4HaIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590054;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=S0a4WYdz2T0aJ7H0+5MYwpxCx8YFhE/t8JwUBhZwCg1RuWQoNLaONnnRL0m+t6o5FExg
	 eppLapN5sutaCBWnAea2HOSlrUOze2gsRU6LkvE0g+6oj8sGSpvNWLVUbijCuyddlwbdd
	 SbWvPILaArw2etWHUkW4Yy66TN6o1/bxg9UREtJfjRyW7xFEVvyMTJMU4Imaf9XYWUvFN
	 L9JgXbAEah8flqi8M4pY60u3+fJfZKOr7TBffvuzyws5YAjs/nwt6rdbsbWgsQ201ikfF
	 AtcgtLMSposhCjx1W3ysGWzANdiqsRsh+nJIBJZOeOFvtE66pvMgwyYozXVreSXBIpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787C2606A323;
	Wed, 25 Nov 2026 07:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 787C2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 886ED68C4E; Wed, 25 Nov 2026 08:00:46 +0100 (CET)
Date: Wed, 25 Nov 2026 08:00:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: TAKANO Mitsuhiro <takano32@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH] iomap: fix kernel-doc warnings in iomap.h
Message-ID: <20261125070044.GA21456@lst.de>
References: <20261123091523.3976398-1-takano32@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123091523.3976398-1-takano32@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

