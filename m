Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7111E495
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576216; cv=none; b=uuEtUb4WCuQcsGV6cEMHWcM7iOZbzXGlU3qYOu6Cu94ihrfzC2O8mAwSPs/Q3u3NZ3T4CvfCwL5j2GhfXiGP9DhNB8sfNhvZNv30DQn2qVl7jy+pOZydnqrp455jtdNfx1Bu1Nb7s619WcwhvCJ0Dxbtf1P5vbp8qRH5cK3T/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576216; c=relaxed/simple;
	bh=3CtiilMsIt92EGdPA135CP6JN7/ZduKraOsouUOQ3Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdHvinb5maixKbxFGRMXasnc28pQmXFplHtrw9sNIoYeIl/y4ZtqGA3oAMPAHYftJJ/E/auoTbGsAqaCrQB/p1vgN8YpUq0R+V+YqLIalIH8XC/IlH8TGCoycmhJoOlXSmO9NjsIDVRAdrA9fTwpvn2Y1+pnjXcXG5U+Soue7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0rKp100Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0rKp100Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q5gCFQdKCp2WL8mB+3ZDL6BPfsN8msq9eFA3C+GnMpg=; b=0rKp100Qb/l6HOTlYVoNEAefhs
	dFx4hHbpWNEArl0r+wdrKLJ3yN9Pb/7xUqm+HRDEcscXZTgLBN4Q6xjyFvf8RUfT192qdtMwbno/u
	XtEcZ1sLHtuv1sNOp00bWHo/0Y96sSSCMBoIMipZiJX758HNDs7lTsgDwDk/QMr4QQ9sgN/8uRTde
	uciSCH1KBI9kVcsDl9LK01A4jQeSZLTwtMhc4jQKvozHG6y6CpffN5L2brYe61P7dsWtKj5g3SYAC
	xJksofmRRl7fJEknB6G6Pe/RGSEGyMe0jXF2A57t/rxvOmF5fsLWZqHRbzPBOoqXQsBFrKyDVjPTX
	CNyx4IXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37mZ-00000009ibQ-0N31;
	Tue, 22 Oct 2024 05:50:15 +0000
Date: Mon, 21 Oct 2024 22:50:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/29] xfs: standardize EXPERIMENTAL warning generation
Message-ID: <Zxc9F98G-YezFSPZ@infradead.org>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069514.3451313.9614601838519113907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172919069514.3451313.9614601838519113907.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 17, 2024 at 11:55:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the open-coded warnings about EXPERIMENTAL feature use into a
> standard helper before we go adding more experimental features.

Feels like a bit of overkill, but the code looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

