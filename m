Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05D1192D7E;
	Wed, 19 Feb 2025 06:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945197; cv=none; b=gFM29jWE0B++m2z9CBniejJJk32JDfpX2GMvLJ1yo2Q/9NNz2C/olIvsHFrSh12GbOUjWN1JS2O4qtwV3ZWLYWKQCHx/7eY1Bvhjw9nkefhc6uNT7SYRoVbhXrlxfoNUheW5E0tSZ30+yWm8C/Xy4bqBM7q8tTaCHpCcamaBM1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945197; c=relaxed/simple;
	bh=DaRZZO+POgKmIZnF50CpGCPOKIzVZwbXH4UwhoOu7qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUuvYm6mqkBKs3ujFfptB5WOluLdyfqjuMPz0OyjWXdndWyR8860+nvjYt22dUZiEwOvfN/dRLw4FvpabUJkti8ozaKqXKzqRofij98U/2oBP5XqLu716x0u+anU8vVc2+XxdjVDJMpH1K5WAjE1UzexqQ2UCGsdmA3l2UqIZ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0/3aQcpo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0/3aQcpo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BUZgZdaatiJqtxMg4XlJWZ+g7Dq45Tnlz1YR4vSFF0o=; b=0/3aQcpoKPv7kT8hWloGBQvAeU
	G4sxS10JZFEsevgD1u4wCR2lSXR04PdagKM8gnubbShNHFAXFRrUnz6W0WsSPDJo87Ibiw1CjOAsJ
	XTvwQEFUWy5MdJSDHj4q7gsPKVgnJkTEIvKISfw2Z6Cm/hzdv1jP2hfQm5LtIUGnDotpZTfEtVuN/
	WzZJGHP4dEv6LfMnDqzsdI0Ee3CfK8Ekwih2PwpELua/whQU93oTH++w7KsOC7Agf62xbOn4Vzh9o
	iJXOdz/uB6P+KV+RjmPfWGRG5urDULam8WwiLxV9NXwNs/+X4q2JC5lSxo3okl9WgzTScEwwiBF2A
	wJ1xPF+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdEB-0000000AzsV-2CER;
	Wed, 19 Feb 2025 06:06:35 +0000
Date: Tue, 18 Feb 2025 22:06:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs/122: disable this test for any codebase that
 knows about metadir
Message-ID: <Z7V06w4_J46lBiTk@infradead.org>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
 <173992588226.4078751.3774851302421682128.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992588226.4078751.3774851302421682128.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:55:47PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All of the ondisk structure size checks from this test were copied to
> the build time checks in xfs_ondisk.h.  This means that the kernel and
> xfsprogs build processes check the structure sizes, which means that
> fstests no longer needs to do that.

Looks good;

Reviewed-by: Christoph Hellwig <hch@lst.de>

