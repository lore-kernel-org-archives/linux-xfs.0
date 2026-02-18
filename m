Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B882798E8
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 05:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771394065; cv=none; b=F5FMsEwUJuq+byIKnoudPYxBHu7dNwxXQ8PRKZsdZTdSROT7yMYCmchdvxRJF/b51Ws2sYYqvf/t+bAnvrFlkuuwukaeAtvgrMOMCVUwua57zkJYOjlVFY0kCgO9L9feuVdVmtu/Gt89rjMyyrwTweH6DFYawaQYRlZ8yYCI/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771394065; c=relaxed/simple;
	bh=Cw3P15D3aDWzlmrOS/bMy0BbSucExNlv8GIZw9nhck8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3xL+2iDANdKVXeaoOrSMxIN30OKjaKiZ4x4S1wToOyXpiEMq9wlYW6ffVWk/z7I4F3FfpYNx+dmWORZKRmgL3rtWNo+MnVvdo52GEdspbkT2cXDeioKSzilUKqAuY9ebntnh+guMULcVpPiVtB3M5fJExtv3J4MC/6PnNLwsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pxXtfRSV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pxXtfRSV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v0g4rwp2Vn94edkPb2G+haI9L/xM/oMCxvFYW8nYsX4=; b=pxXtfRSVm+Tz7oyGr9AMWx6ovK
	/PirHNS8U39HAK5Sh9c45yMEOXf7X3IpkzprTK3oHbVTPB6YHMeseqaglkMTUdHr/agvlaDl3RtTt
	JvpnEt0aW2/aIWiosjP9Kr1j9kzNgWDbemn7N5APLa0My81TWU/VI9Uqb0ag+GY1xix3wnzDRhVG8
	GGb9PFz1CxHf8EnD/dAgXyMutoKAvCx2cC4QB/WSSjkFwTTCLP81EsWk11msU07zfx+ZCjCGYDYFL
	k88hIRL0wqhD2CnWoqlbZCuoq0LXKRw7L6pcVcEZf29xENnM9R1YYMroIZQCfBpprVA0LrtGBu8NC
	cEfgyQcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaW0-00000009KsD-1xZx;
	Wed, 18 Feb 2026 05:54:24 +0000
Date: Tue, 17 Feb 2026 21:54:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Message-ID: <aZVUEKzVBn5re9JG@infradead.org>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 12, 2026 at 07:31:45PM +0530, Nirjhar Roy (IBM) wrote:
> Since sb_frextents is a lazy counter, update it when lazy count is set,
> just like sb_icount, sb_ifree and sb_fdblocks.

The comment you removed explains why we need a different conditional
for it, though.

The commit message also doesn't explain at all:

 - why you want to change it
 - what the chane is (AFAICS just the conditional and not how it is
   updated)
