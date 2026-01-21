Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF412D5C6C;
	Wed, 21 Jan 2026 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769008111; cv=none; b=W5iu11vuPvyxyIJzjlDrCsSbXyPPiUbbcQwsSiT8Jq8bCsFD8YVjvM3CTsmhMThnc5+qAO9oR1mgjBCc71u8DyRuaMu9cFL5falCKiqcnts817zf/W+3/K1CGmJYkYb013j6mhwWM81cFEiBMe9inHHgoubOjEupRhtskCUjGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769008111; c=relaxed/simple;
	bh=OdbQkSFADoXGqkHEJLrDh4/u9QwoB6JRdm2wWrwNAcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkz8Fdu0prwZTlPtGW52zzVzcY2OS3Pso/M9VQy8166st/3COANzz6NpBmuS1jU4Re631ceGYMSzjlLIHeI2ICmzte8ZL/qSywXu6GG5gLgpIL0EAYP+htrXH6Qi/ZBgNyvMAZUe8O2yIGEyOxDQSGQIBzz5cNrdNglC5KR4Xts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wt7aIQG6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wt7aIQG6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+alVWFZy4h5DvXUOT69RDlOL3+ZLYEPA1bo+AUKl94M=; b=wt7aIQG6y9jQayhg/dTpSfRc6W
	q3iofAXe1C8iKdou7LzqtpIywuj+ElGD1QhAgsm3hdp0HuQmCxjGZnHqFdRfX5zQlM3UgMem2yBFb
	gHBgIeEKv0OLOnBZbnXtckVH8ar/V8E50bw3It4yQr575+As2ssBkulDDKhYRKfDcHvit8+YHHOI0
	T18CQNrtKatrmJkPK6LII7hIIfoy7KgOoJxcSvAF2MTdN4erK1G30Zg5np6dhoFB32+MrW5W4H2em
	PmpPunLqB/wgvx5WTvhav2hPgd47rH/QTzobmAUae/oAuWtCiqgKlZct+vvO2odGtEidQcPoxyDbn
	1eiWiITA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZor-00000005hNp-12sV;
	Wed, 21 Jan 2026 15:08:29 +0000
Date: Wed, 21 Jan 2026 07:08:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: fix the xattr scrub to detect freemap/entries
 array collisions
Message-ID: <aXDr7esBWDzANCmo@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695663.202569.9251656342143621163.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695663.202569.9251656342143621163.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 20, 2026 at 10:38:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the previous patches, we observed that it's possible for there to be
> freemap entries with zero size but a nonzero base.  This isn't an
> inconsistency per se, but older kernels can get confused by this and
> corrupt the block, leading to corruption.

A bit hard to follow between removing the helper and the logic
change, but the result looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

