Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A809F14B07A;
	Fri, 23 May 2025 05:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747977541; cv=none; b=MiDYXOy5WWWmGR7KC+8tK+vsRGCWcLybq7YT+L2z9LF+1Gu9Wo+dQ/sink9Nwaqs1b4llAKODXabX3kdUNAvaRVISoarjcMLFm0Hc74aU3Gf/By+Vn99rc99xduA/GccSDGAVOVLFQpbAs6sSvor1beGGhJ6+uUOJ7+R0itFLvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747977541; c=relaxed/simple;
	bh=89HX9XXnP8p29MDmoR3sOgJN43XfPpgCE8nqyIMw7p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMtqx/Nvb3WB2uq0UjxbLyKncMsY/WqcFszDdbqKsrGWk330baAkVZAUGZtkS3Au+FaaQYCsC+azzk2DJ3APn55eK7Nddums4IvvUyzWce/qhWwhmHrcZFyBr4i1gJeY5xBgFPEzvbYbrLmHJL9blUpacDt92KNpOKH/l7arU9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fXB1Qaz3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fXB1Qaz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5PjRCB3oZn4OSXpO50GQwZgo+zkrFVtCXm9ufW9EAd0=; b=fXB1Qaz3niPhdxC4JlpjjQ/WGC
	x0IPZpmqofzDRE0k3iz0danhcLPzxz+Sp7QR9LdSR6MFDs0/zbxp3AAz52VVZL0rxy1FNCzGaOppW
	1LG0pAaq89DjBNS1vtAzXaPvd/D6vGqTSauntmpz8ggpaC4mNq77FUxH7WE6lRUYd0yPhOve8ra0V
	DAsLNwSKGEHhq57xvzylaqn1KHIobUZhok+yKKJAl33qhFL0Gqs3c+YK6TXvtEIjdKRK5Yznqze19
	JTzV3oRm6MOstkFNARSOuEeWYIYOOnJpsJdPr8p30rCbYuXLB0LM/XqdtE+eIV1uOZN21jUNs0vJs
	lxqdZcqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uIKo8-00000002yxj-1mKL;
	Fri, 23 May 2025 05:19:00 +0000
Date: Thu, 22 May 2025 22:19:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <aDAFRGWYESUaILZ6@infradead.org>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 21, 2025 at 03:41:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting with 6.15-rc1, loop devices created with directio mode enabled
> will set their logical block size to whatever STATX_DIO_ALIGN on the
> host filesystem reports.  If you happen to be running a kernel that
> always sets up loop devices in directio mode

Such a kernel has some weird out of tree patches.  Why would we want
to support that?

