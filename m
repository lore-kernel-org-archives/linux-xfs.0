Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C256F06D;
	Wed, 19 Jun 2024 06:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777240; cv=none; b=JA+Sc0+XOvX7pOgVQCv8nBTeT9LHIRdrB3yUfKLI4a8Mlcoa0A8JautnFsFqxk3N/nAiqPdHoKRvv0Rn9vi45QlRYOwmWz4RLirn+7DrlBLkRbJE7ClVHQO2ZSjBFKr8t1BGnaSx2hdZkC/DBdRXDggiCHHgdkadfuKLlpYIlDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777240; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZNbnnT7zh+ZSry+O+Dssjn5g1qfkq6BCAnW3B++UtuSR2dirNIlYmAPxB4Vicvx6RcL65DZGZjCwPTtnrh3KdaqLreIZZQQeozzP+ndNic45ulksY7aPV/1L2wFx3B34qjDc3+6CiFYDGn3tnU17GOvCujhKdSXwgVor1E7ntc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jmXGtxkC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jmXGtxkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jmXGtxkC+W4n0LvHgFTE7WQt4i
	2hKbvLD+C8bx2q1oHGWMUbTxKUDHOLCV7qLxqXgjbrzDO4a3XraPeEvdG6t36AUUzYUDDEtKsqRki
	LA1Zgsf+xEorLaVpOzDxibWZAAz1p9Y7ctbxVL9EJz3v089R0c0t8PoH41EpT+ijJCc5+3bioqMha
	q5wrfsluOIKBpcBMi/pwucWv7i/ATlQXKRgiZMv4iramzaAutL68drSn2GBxeyZ9OuMLuIxCyVseO
	5jm85L0llbtrwRl6NwBpamnuyeQbtHFWiLBhgW0uNwZkQ3Yb7/2beWH0y/VkY6gZQGQ5BeOAtTJ1x
	tdfJwy+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoTW-000000000hK-1TZP;
	Wed, 19 Jun 2024 06:07:18 +0000
Date: Tue, 18 Jun 2024 23:07:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] misc: change xfs_io -c swapext to exchangerange
Message-ID: <ZnJ1luWU-BLKWVyw@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145328.793463.10222758181268779892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145328.793463.10222758181268779892.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
