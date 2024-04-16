Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85B022F14
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245215; cv=none; b=FAqrf8QyNoyPnnRAf3zUttfuCsy8+G5lHuqUrG25+u++RNlUY5tvY/uphUpcQ34bfwqV8Ksz35j6A1eb3oSSAeuayiWfhRBVRZ7QVpSl0Sy3a3/rowIADHpGPraX0RPC9jstnA2Y8OkJ1fT3dFsmF45O2NJKoxB6o/kgUb9xAnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245215; c=relaxed/simple;
	bh=eRnfyl/zenqi0dch7sW96/+npbnl4hFrrebYjF1C+L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVhvMrj1tF7SilPOpAj+WXhGCCyjPd6IPOnHij5CH6Ee9LLNE+81sjBNZCUNSYBiy5jauceKdYAhvHT2l/hK1XNJQwDXbKID7Tv9f/Ob+k9X0YWrre/CzmXbNoxUV9UPOwo7+SNq1ipyaxhmnl1Q169jz/13ShjsCZ8hCX8XWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qK2o8sbc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qK2o8sbc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aA3EraQBaq2MeXMIOPxtBKlVIhaga7cLC51HPAkLbno=; b=qK2o8sbcz95RN8rqNgLe31crSv
	iNSf7Z1PVN/EW1hSP1zSXssvU3thBuEY3gYe/xjGPY2poaGYq32rnFJwxPuvJ905NVBL0uXDzev10
	AZH+um5uZl1cquYW52Ej+ugAh7LxA33eumkwx4YPK+4pHjYk+LpUuy/iJhhYx9wTMVUbeftkOblTA
	wBBFjCXbNcoteRkT7wIYJ9bOh0Qam8bv3TUeysoZQZzdaNpS2RguiuJvIMgBPs9VD2j/J8S238m7e
	u6H9aJTzbCxV5RMiEKG4ANNqXeWPaZViOuVyY+kMqml4eL2OxYIXSp5hZebdOyheCfiVnR7EHSJIm
	93izpELw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbLJ-0000000Aw27-2Vze;
	Tue, 16 Apr 2024 05:26:53 +0000
Date: Mon, 15 Apr 2024 22:26:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: allison.henderson@oracle.com, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 02/17] xfs: make the reserved block permission flag
 explicit in xfs_attr_set
Message-ID: <Zh4MHW8quhfR-afb@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029218.253068.3901233919366892527.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323029218.253068.3901233919366892527.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 06:36:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the use of reserved blocks an explicit parameter to xfs_attr_set.
> Userspace setting XFS_ATTR_ROOT attrs should continue to be able to use
> it, but for online repairs we can back out and therefore do not care.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

