Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA2CEA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945390; cv=none; b=TcQM5DzeS5ZPVFF8yN6viyIqCQ1Nqtsyid2it8J070Gqxn5qtZPI9hvRmqGOEM/je6Xft5Ah0MWwdyi6gpjfHFJTW2a7Sx4HJxD7Gn65MUg2Ow0iHA8211GCx3CfB8Ge9T6a6jILqSIZtprSLLPcjuInVltfQ63X7MtinQAi8J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945390; c=relaxed/simple;
	bh=/pUzNU2QdN+3purd3Al9+nQPaNm2rtcZatyWdTfmybM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXfDOqmyTYcbWmJ1POq+KX9moj29S28zHx3y/CfGtOGSMNWhHNSTo2NE1F2TbibCJOMcb3P6BRrsURAx3MPKM1eBbiTTvyGQOOR1IQmRGrhZ29VfgzuQe50WOn2P+ji1n3iVsK655jGMUH5HHojfPJBO01xAN+MgZooUnrLpkBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J6ZU3fd/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J6ZU3fd/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/pUzNU2QdN+3purd3Al9+nQPaNm2rtcZatyWdTfmybM=; b=J6ZU3fd/uJtwL24vomxIfydtNT
	iGbkMaqMPTCU90jSlxfoWHUTjhnYWue+0xVJxpxcEuqXz+w5CYoRDHf/kEz66A16YjFtvCZLOBzn7
	V0Y/nPg+Bz0H6UGGxHoW1IBHNHLWbkvnWISxm7Ettji7ujs7WhqIlrYf2oGOoFdqVaoJ7IHILx/cO
	+0H2myQC3PV1ZI24G/tIVKu+3Bctxa9Co8VxcsLjd5j5Ps9LR1sl8fUdT694MzhrMQ6JHwU22TB9D
	0Qh7iYmw5m1QsDSUn0PvwX6wZbPo0XU5V0bmOYcbRx7Vc+dLolvW3jyv5YlUiXNp5Xx0QK6ntd4ks
	O5YCO+Mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWDd-00000007ge2-0Pya;
	Fri, 21 Jun 2024 04:49:49 +0000
Date: Thu, 20 Jun 2024 21:49:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/9] xfs: prepare rmap btree tracepoints for widening
Message-ID: <ZnUGbRS3bTMgo9Q7@infradead.org>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419266.3184396.5637689260987491987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419266.3184396.5637689260987491987.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If find the widening term a bit odd here and would have said:

"xfs: pass btree cursors to rmap btree tracepoints"

But except for that this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

