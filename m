Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED269EAFA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848163; cv=none; b=JOox1blo+oYjXIMVmbmfkmaEt8/jILZukgAEFk/BmQBo2E6rSl/wCX9PMPs6UiVmWcBmKfqp2MqXmQLYshTCM9ZKzF3AeAGREjKPaZvMtBUwMqQhU7ptvR5Hr4/0Y0DeH4GTPZf0P3Ji97br79wCFo0pUxhAecGgpRPT/ahltAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848163; c=relaxed/simple;
	bh=AHuqwfQFsxtzMlkyCZbrlQ8pDkpt+KeGqZ2oCjma3vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOrfSSWV0iWevRtstJgVgt/ywDxITJSDlZLCtPaVdGhQQUjiFhNUb5BGk4ko6F6+LY0pqVqtJ/82PwtKm9LQrpioA6rPC2cGQoPiheYSGf2kpI+pgFgAyLUVtxv0ir9ACr35Ri+8dznzgLdalu2AdA3p/9zup7vBwDieafutmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hP/X7VL8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hP/X7VL8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=id/XFy2zNd4oONSZgCyAAsQTqCgI3a/ShCTtSme+JmU=; b=hP/X7VL8jbA2nTrt99EpVF1/Zo
	z0nYm6iDmD8etrn+ObtLt5s/0hOOf11tGs+3kHURpKmMHYufOPy9VWi73LrJTa4tdPQcNEFaTIw8e
	VTgHfsCO3maplCDEMmTreDFTZcrunUoUtUbScAwfxdMaY8GHjGaWFDB2s2iSupqtMJvumqRLEO1nR
	R4EipAyoTzu/U/U6tm0IJodfUQzQHhRVAmXucByJmQvhGW2AfpDyiHkHCfNoPPSa+5D7SAesM0XmQ
	7ChFHSEP2nsjvTWIc3GKwtba/XkUi7AG3FO8p//kxLXfILZjOPvExWFiztAgK2s1On3eUqH85xFtz
	4GAvq02Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsEj-00000004rsY-2Ml6;
	Wed, 02 Oct 2024 05:49:21 +0000
Date: Tue, 1 Oct 2024 22:49:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/64] libxfs: set access time when creating files
Message-ID: <Zvze4UxgKMfROqWg@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783101977.4036371.15734675602815750733.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783101977.4036371.15734675602815750733.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 01, 2024 at 06:11:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Set the access time on files that we're creating, to match the behavior
> of the kernel.

The only caveat here could be the special use of th atime for the
rtbitmap inode, but that's taken care of by explicitly clearing the
field later, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

