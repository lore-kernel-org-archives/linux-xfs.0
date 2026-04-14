Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA0A386554;
	Tue, 14 Apr 2026 07:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153466; cv=none; b=ZDuJqUerinpQuqgb8HZAozO7nI2ta/ox944rA/KlBOHiOtHOyyzyjNlJgPfbGEeJFUfKswuMKV2ntVFv0sKnYCcjgll2kAFGW8Vuo1ocEWpvg2NUwC6Kvemnn1/N25THlyXbldXgB9aKYnNd8B54Acr7WPt59h+xBGFa+oAaWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153466; c=relaxed/simple;
	bh=xL/+GluBLGBFGJOXYdkFY/oEoWaE/YWNhJuCRf62Yoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOIXOCNdNeNMZnrng5/HQGHR29I1SBZnVQFAJCWVeGte6vSLmBs6eSnt7C+YwHLOb2xfC4JQLqqLs+S+/OToyJLmvjl3ZjWylW4J0YhY5RIocUs7JNH8MwJj2/kWsIVQmrZrYFJquQVnOhgAT58QE2MAJzFjKRkJhRC9/ZyFsds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o5SH2E+X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o5SH2E+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FDnZa6QdSqPgbgDRRjU20tZ/AWvg7OkEaYmzjltAxCE=; b=o5SH2E+Xnz3ewgEnr3Bdt3kY24
	rmF8Fp5YzgpDK578Tsh4HmdqE+TvMTgEJPSPqQTMfL5/L9nKuUSMCapOVQuQObImD+MHK77OhDSKN
	enQRz6Q1b2ee/iF7c0ca+0vbCwnsOnDWx45wm85xr0/svKvELj05WKymfiAoQ2lgnXPjBn+KjUmy0
	jUDLofzl2JWhRsY9V6Q6qTdvHWw9/PN/CpApreMN9soO0L3hZH5lMgJnvmUKWvsyTg0O50zkO+WDb
	OiRNSWTGGfVwiETaubPNZ4rjQcSLbFuLtKqqzyBWiV3DxXJgjngIHMJy5oRpgZ7osNDvvlEkGZVxW
	kWPrIe4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYeW-0000000GvkQ-3GE6;
	Tue, 14 Apr 2026 07:57:44 +0000
Date: Tue, 14 Apr 2026 00:57:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/841: actually compare the new filesystem
 contents to the proto dir
Message-ID: <ad3zeBEZLsnds4PZ@infradead.org>
References: <177610262208.115281.12661076175365005191.stgit@frogsfrogsfrogs>
 <177610262227.115281.16238274168034903377.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177610262227.115281.16238274168034903377.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 13, 2026 at 10:50:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We should confirm that the directory tree was correctly copied into the
> new filesystem, not just that the image files all have the same
> checksum.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

