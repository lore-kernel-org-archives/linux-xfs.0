Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16AE3D45D0
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 06:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320818; cv=none; b=oZAA2fccqEWCBS5JjjmriqPeFiG7FN/DFvKUe35YlXgbKt9XuFCTkPAjR2DTEIOETWjsfSR6FByFj3vBpsRHcpLpsJx46Puw9hIzxZYZis/K6XJ9/Z7xL0m6ICG3eUYx8j3XHab9PWveTGF+djpnQ1eE3rmeRwLQc5XJ/2Hudz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320818; c=relaxed/simple;
	bh=WcEa3oZEn1AQF4pEj09Yq011Ys/AdQjriuZit6GuDIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLiyWK5nJbDhKkblE/Vr4cN87bO7DHGvOCQhqDxIuzNkoszPl3C1C+KU2yb0c4mEgmX7TzjFzVe7JhAloPxHZi83epm8MClSeqr+GW7kUqq1kjpWG9KsPT8xxHi6rdJvFcjNjkutcgLoy/INqDpR4sPbHhE+o43eQzlcUOUw7qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QX+6OXJr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QX+6OXJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qL7I2vANqlzJzu/RMd+W1HbTo1i2RH8N7J5TFIR2NVA=; b=QX+6OXJrBS7LAnOL3h71CSS4EQ
	7rFxd3MaYRw9uP21m036TgUuRESNkIEkIZOpCLK0i88kN0XjbGmYZI7zNGYQD0/eW5vHg/MSb82Pt
	XYKXXkFAUYQKiUG0glCOFF5XWnYqxtPa0d1VOVYODBHRrTTGAPZ8BxcLQefsK5XqbojmjN6Q4POGr
	iaEzJ8UWLSopm0ypVWha0mGRoSfQFsTW/q2vGAmcSAnF0HUtOPBdh2rSbq9I/+CiT1qmG2YM96fgr
	5ySsDL4bRSrgcF+8EhX5G8+diSvFPwiO4so1WLG43xHPsLywRFS3LDVFENnpBIVKbaWxb/GJVQT9z
	TP2Z5Z9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgdCr-0000000BfMr-0svi;
	Mon, 06 Jul 2026 06:53:29 +0000
Date: Sun, 5 Jul 2026 23:53:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-ID: <aktQ6V7zbZ1MK7zd@infradead.org>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
 <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With this, the old user space  version in xfs_trans.h can go away.

