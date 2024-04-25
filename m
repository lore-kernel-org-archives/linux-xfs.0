Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC08A149C69
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051803; cv=none; b=FRUldLj/hN6oqyMBtoCgvbGHJZso4aavRFOOiyMQ1gGF6806ZccbSXBTl5FrAcukIMMYZB+t41CdxNlg7CRLyNQAAMUOCiySdmgxpomyySEWscO7a/jaF8eB3kVvWh8shzQvI2m71zwqJN1I4pf3/jESlajf7I0DY5XWLEM2qQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051803; c=relaxed/simple;
	bh=+Gdi3orApNpUzgEcw+vjlQoL2G6x6Fg2xXfhzdSvOYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IvTVU1bt77bOJ7J69FnS78PFmIW33MLayyfyEbHywNKZ2A5wY7+DQjJ8xmfplTgNagOeG7cynN6V/Mk0faeOsSLaGPLmOQq6Nb8Ys6kTtrdECbP5HZ3QZcTzRPr8POTpF3EtBqNZRYfeMTiujtvrN0IaQBbG4Ot+JiQGtfJEPgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BAdGY/XK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BAdGY/XK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RzupKfsWciaLqWdZaKUtBfg1+KP2+4gjAJB+fBSHK7E=; b=BAdGY/XKZA1Mhq/Hhu3m8jaLt0
	Bevm020qKhVSLivXGUYKnqRRPyUpQ3x37rnX+bXIVhLrc8lSRdxAAJ8ciUEC2mRjdfHOo5cmn5CnS
	KWwFwsSnGh/RLd/rHyKw7fD/Oyv1bXLyhifwwRXIBTcX/v0iyK70M/YkiAiLboepL/Gs6JdM2omKE
	EQsNMkIQHhGw201gPh9OfwneL1gTFmrJhw0lmlnxRzx9ikaUYrjJjvWMs6GcGwojOJzZPKJOU8Oh7
	y5UxKchu7wmtI1iSZXA33AyntgIXWYiN2a3klFXCv5djQwj5ELX4b36jfub2ua+EagSBMedhayUA3
	EZydss2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzzAm-00000008VtH-0MxV;
	Thu, 25 Apr 2024 13:30:00 +0000
Date: Thu, 25 Apr 2024 06:30:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, chandan.babu@oracle.com,
	djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Message-ID: <Zipa2CadmKMlERYW@infradead.org>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 25, 2024 at 02:24:28PM +0100, John Garry wrote:
> On 25/04/2024 13:17, Christoph Hellwig wrote:
> > On Thu, Apr 25, 2024 at 12:08:45PM +0000, John Garry wrote:
> > > +	struct xfs_inobt_rec_incore __maybe_unused	*irec;
> > 
> > I've never seen code where __maybe_unused is the right answer, and this
> > is no exception.
> 
> Then what about 9798f615ad2be?

Also not great and should be fixed.

(it also wasn't in the original patch and only got added working around
some debug warnings)
