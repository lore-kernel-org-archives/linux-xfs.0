Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6D5192597
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 04:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262937; cv=none; b=lMdbiMtFExgntfhtR92xkHwN9l6BH+Ptc0Uy6OwBc/1EV4eFUfGyKXIVMk9KCAACWfMTRi3HFhOgjCsyGiXaI86O8/iH7/4CKkqvfXSZLZ4mUo4bhI5XFZr0P9iDj9LoQdcDN+66DmjbYvtezcQ7LjkwWKyIhH+0xTx73yaaYOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262937; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=os5IXGPCzja4RAzR82UpSKgC5k993t1hwwd5nfFlwmiD9e1GExQBKR3JBRKpH4UUT/hoCbWUENwobzLBP1njBYOrXZNXqVWQTOpCe/utPLzTsDO70zawrGCc1wcLIX0/2o1+78ADp2VvDGIhJUni+3Vo+ZcTxBZ55XreMhzhmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SSbhAWzj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SSbhAWzj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SSbhAWzjQy8HRwqjePqUkfaf7p
	kw3cHe1xZQ+TzXlMDppc7QX+IxKo47fPoDqmLCGFURolfKs6evLijnRd+wUp9qs+PGB4TeBVzphHv
	zKE0z+hoadMlUp0xwRzaYSVmpZBZI5qmvznrA+KF7jRiAAuB6cc3KFhuT5ncfX8Ge1k2J+6zhFkyj
	wjyJ5eSd+ANcKelyQn1cWzcHV4Snk3wXESd4kOAH5SHBhJjUJWxmVVVEkp0oCzb0N1/REgBjTnyH/
	/kSh0Qe6Eq5JDKU2HtvRvvKUIo1SxeeTFv26HZ4GnVmujKlDLmrPoOrQxW02Fb+SszNkkKSCodQ6d
	gVPOATUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t60Qh-0000000GgNE-1urH;
	Wed, 30 Oct 2024 04:35:35 +0000
Date: Tue, 29 Oct 2024 21:35:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 6/8] xfs_db: enable conversion of rt space units
Message-ID: <ZyG3l_gxAlmFVJXo@infradead.org>
References: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
 <173021673326.3128727.9571214053803732449.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173021673326.3128727.9571214053803732449.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

