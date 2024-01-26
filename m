Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3645C1BC28;
	Fri, 26 Jan 2024 13:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275869; cv=none; b=LM92ACysWIvKpaUzxwGYnzpgKMnM6I8OX1TINfmir/KFliGcrKq+ZTt7JSXP5tLfG17iNViN9eIaJ7L4vpmlKsiMBS/TiXkMUfpjc3pBSJwnvL9h2PG25wqu4syhHh5nSn6DsPCEqnAY91fGz9xlNsWaZNVWrGNvIbxkmMhGLek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWH0mZDx3a0HpPndYmfAqv12Xi32Qpih/Vbi+y5YWFAVsmxEmn8qiiUOgHJEhkUsN/ayQF2yWmHutaiPWOeAy5FHJgoEbliKtUkYAcPq+OMNr+5ehkAXeWBp9/3ihXkMfW+0KGcaAOnQVz0RC/k0/Q22Gzhyazp/dG73qFhiArU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0WJKrCRN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0WJKrCRN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0WJKrCRN+Xfz5pSeK/435Pc7Ai
	VjDEYADazdpYTgVhOkbxdWBkha/tmzirZmTLhIdZPsaMGMw6tyIfL0giiHud28Oi6I0Q5UGfPuzIg
	1xQgTHHYzw20tcD5JN7SVbwoTitkMbZhMrCOm1isRf3SHjrcEUS5M1kGKQJQylsZxO+twode9YCbw
	/vCTckZZ4w4peb1+H/yo3vdBCgqmE3tFVp+/vAUqiPm3U059gUWO6bkMi9Q3Q1F4L6AgDyqenDtuv
	BwOe59+D1jCZHHnhQzw+Cz8qiB6Nb/gGLkDzS69MI56IqtV87NMQ27To2ar/xa3sbSY8npqqFE9Z3
	n/F7K0DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMIV-00000004DC0-3kyh;
	Fri, 26 Jan 2024 13:31:07 +0000
Date: Fri, 26 Jan 2024 05:31:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 02/10] common/xfs: simplify maximum metadump format
 detection
Message-ID: <ZbO0G7hibDlfaSj3@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924396.3283496.16690906003840940544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924396.3283496.16690906003840940544.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

