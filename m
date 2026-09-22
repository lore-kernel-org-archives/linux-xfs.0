Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B64B432306;
	Tue, 22 Sep 2026 05:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055283; cv=none; b=afpYQvDx9HyM3DQSYEzqDu9mui44RtarcWzFGoaHdJPwqbk8ipqqSIjEYl725RqQoMKiWejc2HNLKFq/8T544sJ1p6h1wr+QDb4MuyxzkfFGbh0ZLGUCFQRIDdyLKDAZk00QFj6aUW5LgZaJgAfkZmB41dt3WFKww0Aizx87wZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055283; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9Yl99M5NA4SXshDtiPh9iq8mAH/RyKD3EKxN/wGopdVO2M6aywH0wMQyIlIqPkCvU1y4vTPhPUHCU29pXXTf7xcC6KaZmzTOnhD6fDzXYWbo7B4FCGY3I/NhYtrPr4J0yfjTraCl40tvhX2iGngd5u9MCCwkPjMxaIlHyAR4V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jPO4ibH/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jPO4ibH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jPO4ibH/1KQ6kQquZqyUzZoHRE
	YnkwsWQKFuv1yQQN8PNhyHTyA+uFBFI73HPTKN80bm9Na6QXxu/gqamMF7hJhjipORzQr7eTleUjE
	ZFgt9cuvAQ0RmLPXbgIzeMxAlSNZWFn2r3NbyVaAjcKhRE/FCInWYutnkRBqMNDrHh0fEGGYBH8nq
	DFnbzU9fNSpd7lFhNWUxmxEBMKPbliUCFjdJs7r1hcMpoMan8Mef44t0MLf+0gdHCrhxIN3JM/gQq
	/wUOREodtOc0z/EtN1OpWcIagVjygFJDoko3NGoi5wOxftcx/fdpLhDa9xhYDTUg14XZVq9olPgXg
	Ux9sFd3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8t9N-00000004Fok-15Jl;
	Tue, 22 Sep 2026 05:34:41 +0000
Date: Mon, 21 Sep 2026 22:34:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: don't lose a fiemap iteration error when
 emitting the last extent
Message-ID: <arITccgSFxFvsftk@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-3-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921083133.2960-3-parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
