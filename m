Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE2F13DDAA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734071072; cv=none; b=tLM/GFrIYU6G3iXQ4ElPXTr9dDK9CThWgyUJGkrH0hCFpmHg0+VqX2Eq5MSIcLHE8VSZeIOPjk8ZAAH2yMqpKD/X/kSJHc97pVfCS4K9BmGU++uluzuSMdE3E3QnQ3tMJNvV7wl9W4NH8vnRBNHfBMQl2L7cRQGam5RmKaJdBwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734071072; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ky7H8fFeeuBZFJ9Xkl6FA/EI0kYaee/xmyNb6RPE9wlWFDOfohFV0ZVI/LQUd8dzNewxFFvDT1hawww79+FEp6Jm9W7drTBs+AJUQWPdBMmf9RZmSvd3ejP0OutIz2voJKUxErhdwm16AzPtGyLq85v9Bk/3zcGFETHNtRrMxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0rQahYUJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0rQahYUJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0rQahYUJHtlWJzWF5doN3Qo0EC
	2BBs4Gz+ArJoWIDCwbcODh1cNJWhksAvqskZa5mt29EuiAczHipq1H3h0omutOD/CfdMMgNhNTyI0
	TdDZxVEeGrQY1Me4tWXfIV2EQGs0YUDIz9nGLZJVn5l7ZyYM5ff9aUpedLbBBstcfCngO3VMAwTit
	6fBtL52TtRvw+6McP2ngWjAYAT4ZtH3M65eCmOyE7bre5YbROKnxd/6p3BT7DbrA1yOH1Fek3CMjI
	M4PPZqH4S5BLIY2lg1kXvrRj+bAaGMM4GqroSZyl9DHZqHXjZwBVubrYy26icyc6JYP1bmwRUksoc
	azmR08+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLz6E-00000002rTY-42oN;
	Fri, 13 Dec 2024 06:24:30 +0000
Date: Thu, 12 Dec 2024 22:24:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/37] xfs: add realtime rmap btree operations
Message-ID: <Z1vTHlWOqXm098yc@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123416.1181370.6765657366135349371.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123416.1181370.6765657366135349371.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

