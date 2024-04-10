Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EBC2837A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730240; cv=none; b=SgJx/8Swb1Zs+2iUhFtvIj3FcaoqN9b7ydw/yupkUa2Rx3wt+LlzzQtdqXqpmkjB/QiQFAib0BKOzJ73XyA+ul5N991TvQ2l8wtRfnNwJm23/mdcOS4xPcDeJ8hV6U9cwPSgKk0Q388Grb2U4GnWGppiYAorWK0q9FTTasqcDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730240; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/1e2/EC/VFU80HDx1/EDmfCDzLhwD90rQ11+hqfkexZ49h3FHt8vwvZlOO78cuSgOG85gVIdyuCEfAYPV2z06s2C8KFMO89i04vyF8t9rCRgewB7EBbu5fGEIeZwXRkymgMCnBEo0f07SI8KaM/1Ug2+fDqKG6v0jMzbTkP3LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Noe+HQap; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Noe+HQap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Noe+HQapYQODCD/hjzx/6DYDwz
	6WbgQCYszkW3yCTkD6GTWYBSULBalJU9aYV8ghmLEze8UaP2Gj2hMHh65eEcN2EzDKauMKTu1rZdu
	duGhwxAV2DsnPNCbNA5+6ns5DjWuFT+Axzsd2L/H4L6/3UgVNfSLF5t9NWqKvW3+WvwzWmVoyX/Az
	gS41jF4G1hdmOPvHXdjx4cB/dLKwVJQEeesGUGQmXVebf+qxGlTOekLBDB5JxZX7WUwE0SK7hQ2OC
	A+018y4WOWDfJYfpkK1GjCq462gIHTbO20Lg15yVUKXUVzDH+NWp8LYakOtY+kjEegyZJ7Fkyjkwq
	Q62Q8uvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRNG-00000005NFF-47q3;
	Wed, 10 Apr 2024 06:23:58 +0000
Date: Tue, 9 Apr 2024 23:23:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: adapt the orphanage code to handle parent
 pointers
Message-ID: <ZhYwfpD8YN7pkZCM@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971187.3632937.7590627404157821233.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971187.3632937.7590627404157821233.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

