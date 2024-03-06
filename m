Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3514B13440D;
	Wed,  6 Mar 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736346; cv=none; b=pecfBWN89e5ja6xH0T1khFwl8aQVCPxfjZ1gFUNBSNJLGkrAgS0uIH/OHGcmsmwcnnrFbnhlrDo6fL/+/6R/AQyWl4aEivfdQBOuKYzx3XYel4cJ8w4vAzz5fAmSiMscyOqYRUra6tivjziGg7ni79I9C2pmh3n94PdhFYsij20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736346; c=relaxed/simple;
	bh=ngbvudzA6VDuUQUJf3SQII680pki1OnsAS6IxtL20HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBRfQcyRGbOf5PHXMsPeQJGhPW3mT7AwOLMO2m8bUu7wIHcMim6ZctxXMAA1DvybxeFlJps9teqJ+oDH1HsEmZ5j5wA4KeK2acuAPHPuiqbxzuU9ja5Eghm+1p/n+Yg+Nor+f5fCMfjwoBBNoEIRApwzuIJZRkcMt/FglRAbK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gmH5SDUY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gmH5SDUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ngbvudzA6VDuUQUJf3SQII680pki1OnsAS6IxtL20HU=; b=gmH5SDUY7Sd+zKywayj4dBnbzD
	SZsINypiyEAHjNjuLVoSXPRhTTuNK1nesp8Z4bcSYkCntwAkbB+MqTgE3LYDzktl0X78bhVTD2kMm
	SXyFlB7PI9qqRsvybz2CKSehBE4JdDhcLGCJ9OjdAsosvRNSeOOOsdgHqbT81dKSfuig3ZU+OSpgx
	C4Ml9aqZAZScJxvty/Wqejh8ptZi9ZKlzE4z0RYvxai/4Ad5vh9qXyrh0MxqUfH782GBRfQ3JbswZ
	fNV2rvoVdfYHzg9cAzmMNN3fDp3dYgZ0DZSZEY7tYYHEnSyPO3rjMQR8dK7il9KTEb1vIWs7xviD2
	c4BimzwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhsWe-00000000dcY-3CKr;
	Wed, 06 Mar 2024 14:45:44 +0000
Date: Wed, 6 Mar 2024 06:45:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <ZeiBmGXgxNmgyjs4@infradead.org>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
 <Zeh_e2tUpx-HzCed@kbusch-mbp>
 <ZeiAQv6ACQgIrsA-@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeiAQv6ACQgIrsA-@kbusch-mbp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 06, 2024 at 07:40:02AM -0700, Keith Busch wrote:
> Oh my mistake: xfs_discard_extents() does this in a loop and chains
> along the previous iteration's bio. Your update is needed and looks
> good.

Yeah, the whole point for the in/out biop parameter is to allow
this kind of chaining.
