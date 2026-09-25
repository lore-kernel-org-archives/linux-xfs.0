Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E0A33F599
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314759; cv=none; b=HW22ib+7k0SmskxjLW553znfk+5HdBNMqiGcmgIdwHBQVIm6F6P25w1Ipn9CbqFMgA2tBehjRBjuAeharj9dbvQOHHqOutFBHQX+h1wJWPsNHbxF2xlMEld12hhazaCp3v+kD3ziO6sNWkwjWxdL0Jao9ru/Q7eEfUeD+vwhq4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314759; c=relaxed/simple;
	bh=pbcomGWUfG5Vqwd5a/T8JlTiHOdQ6mcLD929VNvaBa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCSKTUinD5LMSyEsaHUqDk9HFHJCBgu25OxCCxYz/zUJVgF9lNutT+tQ6AluCNwMBNeWHYYV5sOnY8nnaWBlALWvk/m5wpu/v7JAAEszcRT48htUTOpkr9evOPy22glEMQOCDRykK2EtcmVMlkaTsk+Zt7Rz4PYBNNpTM61s4Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JLSLb3Ny; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JLSLb3Ny"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=exjwyYmi1PAtiKfOwbXD9NfkPibGken051fe/ySDaxI=; b=JLSLb3NyBlTFGYPD6ziDAH/oUc
	dFm/panslj5dJY57m++aRxMbrtcmsXVpjfG1QldIBDa16I8Qku96fpnE8DWY9k6pYuPemkzsJ49sN
	6EZe9Bom0PkB7vzdWTOReMtEYc1XHaeap+cDfOuFBqIBh7zcz6HmIYSLyhZU9k6/tnGTRDT/e7u7u
	/85uMCQrmun4mXTniKsskCrYuuuKfSmncvfS+lmyXjckN4ymDKu8t0GsadYtiDfBKv+f0Qg3ixbfW
	TOVjBwf4wub6Z+l//1pXpF1LTsUv2SUvBGsuxp6WxHMKOMeDH2V3oq1ca3hvKXW4OKj69P/jbqMON
	GlIyxQFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yeT-0000000ChvN-2zj8;
	Fri, 25 Sep 2026 05:39:17 +0000
Date: Thu, 24 Sep 2026 22:39:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: read primary superblock from disk during scrub
Message-ID: <arYJBQswkVIENLcj@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932219.3344850.3980099326844933037.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932219.3344850.3980099326844933037.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 09:12:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The primary superblock scrubber isn't that useful right now because the
> disk contents could have been corrupted after mount time.  Perform an
> uncached re-read of the super buffer to perform a fresh verification,
> and schedule a repair if it doesn't pass muster.

Can we have a test exercising this?

The patch itself looks good assuming we have something that actually
exercises this new code:

Reviewed-by: Christoph Hellwig <hch@lst.de>

