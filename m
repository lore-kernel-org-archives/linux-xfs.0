Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752C760EDC
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212955; cv=none; b=PzISz+3v/Qts9u5TvOzXCrwGSBkM/ArcPPVvXC0qFtsCUFfp1B7pi+fsnJN8h7SOY4ZPxpZ2daBlhDAwY5bmOBoAtTMgsmA5npSpwGEK/SL5R1I4FLyqcMHDH8s6sMQ6RwxMOaMzYjTP90Hf69ewWnDL0PyMsyOc9SjkEZmlLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212955; c=relaxed/simple;
	bh=GOcr9oX3AhVTAAzXmHEfhtk97erruQK7ksUD+c8Bo10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4Mhj5iE+jpEiKT1oH2gcnH6ZmofWi1K/0epmtgUwrADMTxYVBG9JidK8dUH3q6Rq3G9iQ3hDdYYWImzAhUOv+jsKTxwC9tJ7KJUbW5yBHx5lMPZiUjFfceCRUydqW++STB2sBNr2TF5oPnmVX0DVlEf3mbV/O12LRjZygdZ0Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sxjq4uIz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sxjq4uIz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ku9fxY2R2hmjXrPuVZBrfQo+sWvS8n5yR2hb92ZUWK8=; b=Sxjq4uIzZxrr2Heh/pTVnt1DMD
	41BqDyoD1uq9Wmdc35F5S2+SS/Ng7jLPpmr20ZVPTQcKFeNAy2p8C4kt60XyWdzljMB+9JnjFD3G6
	MEYfnZRA/yGAl0iKdKRJSVJdYwGjcZmmYJTTv1MxG8+nVmnqTDiIFr18f5fqGg/woHT3PPf0gI7iN
	hj5rbzYNHqHp6v5eQYV46GcHjbvD16RydSwjJB4Gjp3t1BB7fxP5VhRGNlTHsjwd6Lju3A1AFJIyZ
	F6Kqv8MZZ0PLk3SqOOVH/tXVsRcbv6cW7qwHeusrUTlQyW5w1PGqGbjKlijAsIP1m9W05OEn6Cz7o
	g0euKJtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfgMX-0000000Ddww-3IZR;
	Thu, 29 Feb 2024 13:22:19 +0000
Date: Thu, 29 Feb 2024 05:22:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <ZeCFBZVX2yjAw-5n@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
 <Zd9U4GAYxqw7zpXe@infradead.org>
 <20240228193547.GQ1927156@frogsfrogsfrogs>
 <Zd-LdqtoruWBSVc6@infradead.org>
 <20240228230057.GU1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228230057.GU1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 03:00:57PM -0800, Darrick J. Wong wrote:
> The offsets and lengths for FICLONERANGE are unsigned, so I think
> xfs_exchange_range ought to follow that.

Yes.  I though I had actually brought that up before, but I might have
wanted to and not actually sent the comments out..
