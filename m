Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B894226182
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811493; cv=none; b=L/iEbF/nyvfxOb6OIFLFZ76xMpXrefXZn0giyX8fGCngnOK9nVDxLsze9Y7y5g2GOjTPojFzo0vALYE1j9MuiNTuJKkuexf0eh//tbLnwZKhgmTStxvgw7LVIkN5KA1k0QHqdtVoYcxUDi5wrttY4rzilV49U0t1B8NOvPEzVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811493; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WrBMJUdcAJAXcjEVskf1JMJZW7BQGvf8V3VG3DuaEBlM5/el+9lvy3AqO/vSao6c6MvY0Pc8LfGnMRFptv7bAX2Avelb6MvKmmV7foKDDhhE+neDUeo8mqUgrs2zXepsv0ZMa/L7yIR+Sz+u/xyhZyAVCoi8mVEx0J4tQw6tifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CszeHdZv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CszeHdZv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CszeHdZv1ucibs11KJbbsXjXh5
	XZLEhpUExLJdK5Mn4OqUh/azHcs4A8fzQ6fmoBU+Izlw8CAUsBsj5eHmy9qWCsWuxlFw3X5nuPquY
	OCwyeSRyGc16yDu8zQWlq6FNSXesdDdNpYUDCSdxkKDHHykNZmHKG4pE+ydpMP1Kcx9kjfme+Nsph
	F34tEZhcJeR4heRQs2sJqLU1/eHD2RWrjUcyAB8+KXPZs06XKj4t35o+Bu5Aao6B83Td64p8XOqvU
	SXmD70JZ+L5VsRfe+jdbcxW2BgEkQe50XUUQvXxu1QjS2gQVVGbySFGfVa0PkYiYLVOzw3IWt49BM
	kcQuCmPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtZT-0000000AOUw-32qu;
	Tue, 10 Dec 2024 06:18:11 +0000
Date: Mon, 9 Dec 2024 22:18:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] mkfs: add quota flags when setting up filesystem
Message-ID: <Z1fdI7BE4J3Z-I9Y@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753340.129683.15235240531842313664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753340.129683.15235240531842313664.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

