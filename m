Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4895D3AC0DE;
	Thu, 12 Mar 2026 07:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298858; cv=none; b=rKPiQ0TeXBN0DHrTu9HM7CW3JnhTaEMmg8E1zb7qym/XkzPOxbsPnOOisyO5uEVm6v5CQVymrRJCAsUin47BIVUadJmPoGiH4KBrOJOKK75Iyh2n8Fyakma6wZvVO3dWajul0xoXpvrN0ePe0ROcRpKd7efecu6Pb0ASJip1av0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298858; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ul64tEwTZkLQPIG44qL9VDf2FO6ZwEeiaMs8fqTJkEd+zxr4CP1AUNJKBVL52MPoerCenc+o89F/u+7L3cUuohaSi+ESbmCQFTfFjC9u48GZYb7AOsMCE1kGyae38K0YFN4Pyty8pwZeO8sJbODW9SvHREy4NTsm4oDOajEMsOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bUF14Qx3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bUF14Qx3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bUF14Qx3E1RYdB6QcKgazdlAhn
	+DNCB+5EB1QYwGwHv8AvCZiu6ErXv9IbveHjf/FwZmkVza1h01fu4JHUWSnoZr3KlxX/Q6MCHwRbf
	mXDlPaqkmQDvdeUJmj2a0F4DDGHWIbZwTP3IOyFHJKJH7CThcR/wutr0tuI81z1zZyASmIkqVTWQ1
	GjbrDWGhkzOj+UvbRnI5BDVlgjUNB8n8Gw7Y4rVDiy8wEqBuF0VMWb57/E+qPwb7wDMEYra0ADCpU
	xsVqDFVglvEsOLIN64v4Tcz+LRUyV5wEC8m4/vAbkKMhlPyizoFMTnLLDGTnE8N76KpsDhc3som2t
	5RuVtOvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0a2S-0000000DVht-3Q4j;
	Thu, 12 Mar 2026 07:00:56 +0000
Date: Thu, 12 Mar 2026 00:00:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/62[3-8]: require XFS_SCRUB_PROG
Message-ID: <abJkqAULGwynWZp8@infradead.org>
References: <20260311041443.GC6023@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311041443.GC6023@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

