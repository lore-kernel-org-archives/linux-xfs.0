Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF9359178
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367289; cv=none; b=iEWAeEF47mvTRG8FOe3ujtdWLM2qfQ5i3bY1lApTzcm4jAvkof4UdKmI3Qr7vXoc5XsWgSOHUnU9dRBs6fh1dKXIONU+HSH7sBtDO+bRz2eIcp+c+uXMTyJS6DCxWONVjhupsY5NNtaW+qvl2KoA0n/yPbvKa9gT1CJwhfQDUls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367289; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcGZndw4rOOfgAJtlyJS7RYXp9aKtXgJzp78T8YaaEwyy+jbSQVneP1eX+/mKyoTDVIT0X8+MAF/8oOyRN2NWJAI1ok9TrGez/IlYUXgAkmBoogWp3REhOg72C5KDo+6MM9N6dtLlfVURj4HiinO5q4QMBvlmo5sUUMTpLF9xMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YheGpWOO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YheGpWOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YheGpWOO+VWIV/4OfS9Hu5kDly
	FGW0USA0vigAHnBTmbOG2vpKJKBMtabRp29kL9g8nmuXXK9RJZ/9j/r92Cz531T3McxZEdKQhYflj
	uhNOySIm7/cbOjGYpu0FRa6KMRC2GtoINUgjsc11/6o+aIhkW+v/GuGAXS9vEIysTXLDo8DVnJPM5
	l9UHu1z1CJPs2w2JXmutMEj2q6kGDH8iMjJ5lKqX7dqMIPLw6RBVynGk7OakuCQrFXBkI/DgFCiAn
	uJ4S9AMEB29XGBpuclnmB41RqUJ7y4MH2CPKm95apUO0oZvkujXGGthg+Dw6NUOgVPzo53nObt0zt
	/fbYxMww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWf9-0000000C3tQ-0Ap5;
	Wed, 13 Mar 2024 22:01:27 +0000
Date: Wed, 13 Mar 2024 15:01:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] mkfs: convert utility to use new rt extent helpers
 and types
Message-ID: <ZfIiN1gvEPklT_Z-@infradead.org>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
 <171029430657.2061422.9474513570507861316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430657.2061422.9474513570507861316.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
