Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D881C11C94
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712726299; cv=none; b=TM0nWU0PJxCz6reZXQe5rgt5hlU2XT247B3bFMxwLZr/YHhk8q9ACAiDug3Po3gtEZDMdQwZRYdhFUYAqa2XB3XhctQ1uol/iRDkufC8C71Ol2UtFNHOXd5X5nR+oT2Ptus4cfEqTst/Rb/1bLxTHUYqfsc5gW0yM5JVGvL/+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712726299; c=relaxed/simple;
	bh=M0Q24ewgfM/0KfBIauTJMKUMC0rC7INBde9hdCg/loE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5GjXUKjPAn+ngjbOSROZJhnt29fkwKZxr5WwTX/MSjP0xRHlADuKrPuqtyEgWFd+DnLbwLvKlXTfUe3Bh74MzR2t3X6pGezgZs3UnOPnsgpT5vhKXGJDjF0cvgUt9FrmV2XBioSzSEQeUaE/31dcMKJSwYV3UNewRQatVCWjcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xVaLg0Pu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xVaLg0Pu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mQDMie2zyxt7EFBROf/DUVhuXzGv4kTPoxj+1BUUsWU=; b=xVaLg0PupR53HFSAmFwk3hnZN3
	5sIJI7Wn38U6XLCbYpuIIR9BZMVl5ZTd8VJFjOoRbI+03tXvK44rFlvjOTD7T8jKCwLatbAS74VjE
	tiZIIbka6zDHhPYPO6zD8gc5HRYksUrQ+/CrmKt+ZKlTVjBeOacwQFeruLRidxihSSLVnxZtH7Fhu
	4s6ax1Tk4wPH++Wk5dqJC0IwUZ8nMuARyZzK3ZJ+224BapVL5ryQhX1rjQw3yxHJaK5SVyL9FNU66
	WHxB+bmXNV70usoT/dm7sEi8Fed8zogm+720JpZ3vfrwqXjRbq9MdSraDgOflAfqDP+UbjjY2OHVc
	f+alj4HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQLh-00000005AI2-29k5;
	Wed, 10 Apr 2024 05:18:17 +0000
Date: Tue, 9 Apr 2024 22:18:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/32] xfs: allow logged xattr operations if parent
 pointers are enabled
Message-ID: <ZhYhGbiC3Cp6SmL5@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969690.3631889.15408823864477343629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969690.3631889.15408823864477343629.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:55:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't trip this assertion about attr log items if we have parent
> pointers enabled.  Parent pointers are an incompat feature that doesn't
> use any of the functionality protected by
> XFS_SB_FEAT_INCOMPAT_LOG_XATTRS, which is why this is ok.

I'd move the checks into the switch on op below, so that we check the log
attrs feature for the "normal" logged attrs and the parent pointers flag
for the parent pointer ops.

