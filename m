Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54DD19DF61
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768181; cv=none; b=e1oyM4ZaZvGI7M8L9wGCBEieayTbdg+4hb4xxAa+cmyhTcqIGXAh0KfQtVsXEQXgQ2jcaKfCuElmuy6u2dmR+2RviXCQlbGeyV/bRFjGl5NJcioBqpyigC0GiFjCiGjoRyi6vF5nVXWZ219m3xdGB5gMM5f3jVJepGCINWZa6Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768181; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQ3CrmJGnoqP/rWiWI3w/oaVrSlAc7f7oy9c0Q7pILrei+ef7k7Huo8wHB3rHHoAuuff1KEv+9MyFTIwtIf1T+7xEP2xl5egp2/CbH0gcyAxJlvNanlr9Y25GH+DQLW8LgMpq5m+ZRohYG7Dg87fzFwhkmbupM3HR+4DeRD4vI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MDA+HiMW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MDA+HiMW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MDA+HiMWPUBWW7S9BN+bPHz+r0
	KbgUNLQ1H9UGGGAD+i0DWIPDHfNaLUEoSB90OITgD4Uh2S1fd3gLXea0QM6kL0dBpq8UwO/ac6PJG
	F1RXNEZdT7xuVvuRwJeKQz8INh4Yzs+ZmxX2kFH9UpHwogq7gbrK0o0IXpXwaTAkvhhx69S6y8O7l
	yH6EDOXhtkmbPLbDSyjAfiJ5y2PJ/aFYm3yZsvnZviLxRsMZ4RwY2JJW9Z3ApMVLsMyKl6g+JYQMC
	JOhtNSOPJq5uZvRLYzPZ5SKZOdk89vAQrrteF9+mIb3CuqHro0CgcCzW/H7xGn0OVuRyi1y0UgdDq
	nP58wH7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOuRv-00000006hzC-19OU;
	Sat, 21 Dec 2024 08:02:59 +0000
Date: Sat, 21 Dec 2024 00:02:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs_mdrestore: refactor open-coded fd/is_file into a
 structure
Message-ID: <Z2Z2MxkOlANqddhP@infradead.org>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
 <173463582928.1574879.5106855575792576842.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463582928.1574879.5106855575792576842.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

