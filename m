Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446A3328FC;
	Tue, 13 Oct 2026 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876772; cv=none; b=sXKeKCx4OpZeONDfbBavGRv5i6UDi3K+b6wzHOcUV3nCia4NEQnhUQJ1Ej9RktumxhLr/4BnVbj4eljEnAJy2k1aoQqv2loQOUOHWIKfF6tsjTq8zzPrc/SHTUD7BzjlHU7WwvIRQCLBalymWiY3OBsXcQOAxk+vi7DVjPxWi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876772; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfXu17jJq1cSVwR2WYvt3V1IPYM0TSWOUGUlYwW/f0LSo2B0cbT1Ke/YsMcZqKMrcmsgp5XUWOdUkek4OjqaY6xxqM4f1HHilFl8be/VpzNM510jx6efKOSR+jMwcFMAMnrFwWEU08VgdIROUYMDqmCp/crKfJLrnHJiMBnTyc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WPWV5306; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WPWV5306"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WPWV5306dkI6w2ZhfwXNxM04vE
	DvNfpn9kG2yfciBygCcQ0XrXZeqF6I71jeuxwpyyNpDkz0kx7cdfTLkx7dJQSzZLAnl6eJ/1oi8y8
	+W3My6F80onREX792DDoin7r3xbc+fDtN9SokkDr+XdAA9HgtErTwaFMuAi2WpAx22xAM0N4YbQD1
	vGMiYoURvR8AGDDoBzVNKxReTdg9R+Rjax1BTMBM1wc0wq3+ctsVvG1COcGEAWalM1NXDPNbv3BI6
	zkXJWsqsunam0TiQwCK4B9bwy8sEvfCrK6/7rdXd61wa4gwaarbsUgbmX5perJFQz7s61tYJz1ZGP
	9qdekoHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX0D-0000000CDrf-3gFC;
	Tue, 13 Oct 2026 07:32:49 +0000
Date: Tue, 13 Oct 2026 00:32:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, norbert@doyensec.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: add regression test for swapext reflux
Message-ID: <as3eoZLnEkuVIWL9@infradead.org>
References: <179185007428.1732194.3790285770700324388.stgit@frogsfrogsfrogs>
 <179185007565.1732194.18394228168172632995.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179185007565.1732194.18394228168172632995.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

