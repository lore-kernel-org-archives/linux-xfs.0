Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB6446BA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711431781; cv=none; b=Li1WMLcr+FuRSA3YNud50n3KObyrHQMXv5XtC3WEbz3Hi1lbrijKsbbLV+Jxht8KQxEDv5jkps1YvuyfrBl2lXky4UWtR66TlBvDoshaiwGNXbUaz3HiITHKjYZOzpmNtUP+/oyelWj5yRgIoUQswJ5v/BvxnLCwOaNmqvN+kCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711431781; c=relaxed/simple;
	bh=FqP4qKW85Epa9C0PsrupocF0IMfOsxBotbvz7yNOmp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTL9vTZ5U3pjowiVfz/jLnOYfb6nHWPn86/LH4GS9CVuLSsuaI3OhnM40yyZ0i+nv7hxdQLnxYRt1HUx0jVJNa74NMjeRI9n1PEZKVpeCvkG1WuV+/WOrLNTVKWETTAMNcG1cXTuShF2I1hmNBxE2GlcmxfFtTa7S0QValv5rnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QnIiAU4r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QnIiAU4r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aaTBo2TeGKhjzDYJnUXTgTFpC7xqycs4ofUV7AgEWR8=; b=QnIiAU4r1K8u6g/zL3qMgwsI91
	GLo/lWOHNC4Z+ujsytc+qR6++ez9+QntBvuC1zDKnEud67QHLV8YKM4z1W1lc3MJU4V+AGdMDiGl1
	G8JJuoTBfUxQN9CGFvTR79WsraZ8BJllNPa13fkd3p+joBqQEtevXI4DHvdDbqf2OfXLBMOWbuLlm
	dUaOsPcpWYO5kZVEF6txeR1sm6mLvblRupnh3dkyJFZYD7wVGc91dN1kHa6CP87uY7f/X6/0cS22u
	0FqcGBkzF3dzcCxt5Adlofo30g4rFe+6QyJ6WDooupK6dsMRSR0JH2Ks1SqwmM3UuJNgpGDv9go1B
	FGS9LpMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozaN-00000003AQq-2oxZ;
	Tue, 26 Mar 2024 05:42:59 +0000
Date: Mon, 25 Mar 2024 22:42:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: add a realtime flag to the bmap update log redo
 items
Message-ID: <ZgJgY906jgGuqSlH@infradead.org>
References: <171142133662.2218014.2765506825958026665.stgit@frogsfrogsfrogs>
 <171142133677.2218014.4422121913066180413.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142133677.2218014.4422121913066180413.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 08:58:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Extend the bmap update (BUI) log items with a new realtime flag that
> indicates that the updates apply against a realtime file's data fork.
> We'll wire up the actual code later.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
