Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D82383C8F
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772718916; cv=none; b=TwzKt7KWIt6yPvsfDSH3R1GfQ3RCXEhT2+4/J0iTFrKoYRMoSjY10DXNKOKnMPRPD1cEu3UTwCWb3bzva5/hQ1f7r3P9/ZaMTCY/E7PHA0gkD3PYpKbPH1HLafq4oLVVctF5M3MMiFLcS59rWblcZSGotg1d9AO0QVavzd/O6gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772718916; c=relaxed/simple;
	bh=HMSQaKn0lD4x/vvsute6EAj7YULL18+mHi89Pb4SzEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEsgjzbt8MlRINyUqzNHII26GM7kFk0/StYCahMPbOzNTqZAQCwg2M654GX2bPAAoRY6QHufpygKEh26AzFutnD0/XE59adT+6Lr48WgkhQ0xbpyrbUseXrlnENXoLYBUGCNkd5e6+L4xkK7aayqBrND/Bm1V0sgKdM/OswhWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vTlu6N9Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vTlu6N9Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RxWnOjCgFctzBTY9tizu9Q7hQav4zfGxWD7WRY4yDAc=; b=vTlu6N9QlSp34/WPDRlnUsMCGj
	i4S7gRiyLeK8XtFHxu17Q0SkEFcQKlQrwd2izye72/nnm5/pqxmQPbiNaXPNilct2WY25tTovbq93
	oFdDIwpNr2rkdiH4ofpLoImorAkWx5QlIT1kaLipOD3nOPQ7Fkm8+TI/XZsfKqbLzanIM7qz6Iye4
	pUz0U+6loQ9WvynbnBgka6DhvJaOUpTQI5Vq7AlD6IJdEXp4xro4uNtwDUlOBoKQAitqxRU9cHhNF
	dAtlD+u63T7Fh5OdQPPUMPQcLYHJgsv+KA0Ek2Yg4DtC7lTDGUES7P8dw32+FohE5YRXK2jM5Yf5b
	hOkN0Jmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9AV-00000001ufB-1MUL;
	Thu, 05 Mar 2026 13:55:11 +0000
Date: Thu, 5 Mar 2026 05:55:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <aamLP5UnWiPhvKqh@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304163502.GV57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 08:35:02AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 04, 2026 at 05:04:18AM -0800, Christoph Hellwig wrote:
> > On Tue, Mar 03, 2026 at 09:29:16AM -0800, Darrick J. Wong wrote:
> > > (That was a long way of saying "can't we just keep using xfs_io as a
> > > dumping ground for QA-related xfs stuff?" ;))
> > 
> > I really hate messing it up with things that are no I/O at all,
> > and not related to issuing I/O or related syscalls.  Maybe just add
> > a new little binary for it?
> 
> How about xfs_db, since normal users shouldn't need to compute the
> service unit names?

Still seems totally out of place for something not touching the
on-disk structures.  What's the problem with adding a new trivial
binary for it?  Or even just publishing the name in a file in
/usr/share?

