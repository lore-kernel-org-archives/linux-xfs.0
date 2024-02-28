Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9024B39
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135481; cv=none; b=JkV1D8ToqT8cIhgYTgVTlZlEif+IVMeXiL6llhtqAeEnNJqXn7RENiZWZZFE6qqzo441OxQ/bvNFqEFZqxvCSAiwT+i6L5ww7hGmD0Os5/Tkw+vAEE5BaaxXVy/cnLlBSVg2UaVssq7eZ8Oz5vcjyUnAy7hA2Cd4OGauPgvy+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135481; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RiApXRDyJTOOjXbXVp7soL2cmgV1Rb+GGhjSMhtHOQg743/tapDFeSoDbZmcbSU/pXyf+7LdEbbzKVASre3B04tA0SS52fU48q3v5tYJrdQvcl3m0S9YTOKY9UoZz1Y8UZlOGO6oLdd53qkwN05a7YSR8K9IdgdpIUVSb6+I9v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZcO7SStD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZcO7SStD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZcO7SStDJle4Rb+d2ZUeNaa+dP
	r4W+dvdUtvHotyXULedzQmdWfN5cD60r1gTKUw1yObmApPcA9Lxi9lYCZ6J8PzgiB8o+vEkN/UKgB
	v8qy4p5bVi8mkXc3MDZVXhO7sNqHdUIWWAO2CkgwDK400dBy1DvhWuVoGpmvdw5ghYby0RfEE0ZBC
	MW85xamQ1e2o/c1xNBBoKmZQc3UZzTykaqw+kJzGH6ABfhTfg6JbKB9As9FS2tT2Xl6c9GIgtCLW7
	XKDxwzU060es1HM2ijQjznaWd976vrWRnDCRzQxLLW8kJx4I9SXBnM0z/L8GuBjQyTIlv7wwBnERN
	tyAtWQxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMDH-00000009yzT-1gzS;
	Wed, 28 Feb 2024 15:51:19 +0000
Date: Wed, 28 Feb 2024 07:51:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/14] xfs: condense symbolic links after a mapping
 exchange operation
Message-ID: <Zd9Wd00YZqdkCfAc@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011806.938268.5490217945103828643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011806.938268.5490217945103828643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
