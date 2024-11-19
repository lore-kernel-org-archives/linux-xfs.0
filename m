Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E12150981;
	Tue, 19 Nov 2024 06:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996706; cv=none; b=dZ6JMoL55pB7dSlMfQv+49v2lFO+4SfntazSGO7gpX+tG0CmmwrcXLcLa89A2SN2vvrUeEHmP/kD19QhplOltI6pO7GEBdYrwiZpUs7o5c0hCoq7d6Jl61FtaLzRrsb8Ufguw6e2CZY5w3RGD/LVpRHxidmwrGmAr5hPxaA+geM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996706; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XsWf43rzPQUy78lcgl8pEkXdzmEdcPYHNFsJfDE/5BUdE9kTe0Yjo3gvWOv7KyyW0TRODlntjGJRV/x8CfPZspXy3p2PgwHEwgL7KMN+7Z/AZ7d4DX1rtVtRJR2bm+k6iTRbQ7MzFXHtC6i1pvNe2yRxYFSXy8gJxnu+XvQjv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1PN+xlfU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1PN+xlfU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1PN+xlfUSRQyCuJHAtZ3MWRpZ2
	Vxq9EdiMXW88cpTfOu5diweaLuVgvmHIvAUmwmJf+qxjTdePFKj+8SEuiJyOZ+4moffWEqbr7WbEy
	2bxa+tQEafwsS7RFhbWuI8qZeDnuBo3F/CyW1Y+WDIblHlQUUA2T3b2ixu65nt1Fjoo7nTNDrdIeg
	Cma7bwSRJ1GkTiw90Rx2RbpDa+NjvgEl1TC8VEN+yGb1QA/vzmpuBKkwx+YI9hB2kyzUeBqRw0oam
	78dbfzS4LFGsvWvjhNABWffKEphETI/+u2Ea/WK8ulIikucdCIl36GKY0JpGkZ4+68DQFOa223Eg+
	YKpEmi1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHSi-0000000BVAv-2vII;
	Tue, 19 Nov 2024 06:11:44 +0000
Date: Mon, 18 Nov 2024 22:11:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 08/12] generic/251: use sentinel files to kill the fstrim
 loop
Message-ID: <ZzwsIGFn4qKi507L@infradead.org>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064547.904310.14473736825696277411.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064547.904310.14473736825696277411.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

