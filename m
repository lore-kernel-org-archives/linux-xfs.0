Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B9148827;
	Wed, 19 Feb 2025 07:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949310; cv=none; b=Mu/iEc+SA2tZg4MObi89qc0Jzh/37ilrY555HqDiDttuPRjvkT7K3+v5blSjSrAcobpv45f0xayyauqay+5kQEq4mqjYfkGvK3XgLQeBbHkKztEZKSga4LpIth8YdNuYe2tXT/qLRsYVC7zDKXuGms4PG1DOObGAk8Hg8R5HOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949310; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWgpqzWoDXOxKLRQtZ2GtTpJJ2B/57MqttqM9K6RZI3XbBL+7tJqaXcfcB72m4d1/jTfFKD3n5YjOso6IR2JCu73bXNybz8izQi1/Y4hmqMdwMmQpNFm+3hZWBuY+KsFb2NWG/uuJHC3WYlSHADjTE134xqWiFVcGAzjTaMPCaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E1uwHmeO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E1uwHmeO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E1uwHmeOWZk37wKVtx54jtS2UX
	safu+tkOrjvrVmYlMlauBk5OujVILuRLeGdA4tKhtfGCqiF57kTMoLHKRIzK8H2i+k+0t1N1uk5Bq
	08fq4oI6wjUgQe7kMelROKQ2la4zJFlv/N7oo26E2nLnGtCtw3HdrdasLeTxFpuAXMl5HqocDZACg
	p2tvGRhtEweGn5iypX8trM+3AwtKPpuPZoyoFiDOo3PoXLeaq6WHNSxUl+3pvEQij8rKFaX4KWvJG
	Uj5dO2nSywieh9IejAw6rHL4/4N5TbjhBH+1+0eFBy1vYlA/TbVHgn5sx/YxbR3pV0pKeJU5vIHdO
	LCLFIj4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeIX-0000000BBkW-1XFF;
	Wed, 19 Feb 2025 07:15:09 +0000
Date: Tue, 18 Feb 2025 23:15:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs/206: update mkfs filtering for rt groups
 feature
Message-ID: <Z7WE_Se169IdTOF0@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589327.4079457.1787652822219676386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589327.4079457.1787652822219676386.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

