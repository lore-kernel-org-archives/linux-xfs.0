Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD253371860
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083808; cv=none; b=XAKdbOoqxKHBrsMSgX2SP9jHLar6R2NxS5SssGAVgQ3OPr9BMarHpLnrUyNcP0w53wpmlmKulG0j+Y/fh4TGhqw37ggo28U8bHJkNMA0nf2tZ5H/DQW1+iaxvz7PPdEpRHkehgb7Hu2bsaoW4zo+2WhvC0kDqb8xNxya0WeZFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083808; c=relaxed/simple;
	bh=kRof5LhdVkro4ovg1OeKFWlkSJn2F+mf1wd6eZ/VKJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dk4zSN8Mv32KueC5ZegARwEVN13WVskkmvoFXETrKGLpEz9CrKAXnvy973QrFWT4MocQV40iRb8LjoOWryJnX+CN6UScDhjTtzR8hUIpruiAUSwhRVt+kowQlrpP0lcrXl6wtK0naVAxhCbOI7u3OK/MzE/LhZrDeYav/mNm2FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R4lAzNAW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R4lAzNAW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kRof5LhdVkro4ovg1OeKFWlkSJn2F+mf1wd6eZ/VKJg=; b=R4lAzNAWqK8+zkfFO5L1L+kyx3
	UkQRSzHDymmH3gmVtjrT23KHU5E8W/L8xsDXCk3Hf1Roh3j/JA8iPJRC8EJA9VUe0ik7RfyLF8z5K
	wvotTWf2MnyVAyMEGVgANW8Pl1fZ43cCV7aeRRVWftItQpCJG9OdeOv9D83xZVoUSRt6g+p3nRCmo
	wazBC3oN609uWt8U2/Nxxtm5VAaKEjRzR3pXkU07JYTfzKBUyT5gDQOpE0AKVHQ47T+i2Zv8Mj24e
	Xq0HXxZIcHYxOBwp/EoxdMsNB26tGy6sPvB3c9KvVHUbzFx9qVOZMYSjuXDdbNx0ITj9lyzTOX0Km
	qWcReXYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfdYE-000000072PY-0bq2;
	Fri, 03 Jul 2026 13:03:26 +0000
Date: Fri, 3 Jul 2026 06:03:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Celeste <celeste@collar.sh>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
Message-ID: <akezHvFoqtKWN0f4@infradead.org>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
 <178243370553.73182.935356806206037088@collar.sh>
 <aj4z3v6RGnSbxlEI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <DJOCNHYIYK0G.17Q5FWMGKKXMC@collar.sh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJOCNHYIYK0G.17Q5FWMGKKXMC@collar.sh>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 02, 2026 at 12:58:14PM -0700, Celeste wrote:
> should we then assume that this is fine to merge?

I still don't think that just papering over the misuse of the same type
for on-disk and in-memory uses with different characteristics is a good
idea.
