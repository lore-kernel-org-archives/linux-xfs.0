Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592603D541
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057815; cv=none; b=ZEt9IGc5blaGirY6IM4QvpEzGA6fA/KUYh0B2aa4GYf6Vb4jze8No0w3XJx9RkZH4fucWwK14hsmuknqnJvG/UHpadBxaHWoNbNN4H7+zwWEyYqznqbHJQ6ddBsCeaBDMYArIxoxiETdTa/lcetKJcxMTwPmmU0oINb92tol7zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057815; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPbrPS4n6qEaoiBgIlXHtTJhUDBXnRdKnf0W1LY8s7UgZOlwVV0R/XDTggolzeYoMbnVMoH1Az1WJR4LGnzbDV+j3z0TPcsjP/Gnw7XGlDTcvL+hD6g/hasskltwa3oQGi/Zk0U0cupvR41wcHgMttR6DZm0byRnrY6IJOSVQA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W20T1631; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W20T1631"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=W20T16313wzrzM3KLOSV/g/1eH
	iKPm9brPWx0wXsghumW0o+Rb0/LBAE/wQzLoD0sVQXmVp1pARHPMB2JnOMFfLUgfTeWSItWbRlweg
	jhCBfduuuiO5JEcp7wWIzVaSzbGDQXh+EcGP1sUsabNROkUnjgTjX0G92RbnW/Iyg5uethGuIByi8
	kwiKl8+AtVUi7KT5d4AHFMb4/IqCFXNxmxxMcetLate883Xw//yk/l0O0Nr8CC1kpcTB8VLH08pl0
	VYOBuAadWBQr5RKggMQF8Hi4hkOYDNAzC+Wep427b1tPKjvL4RN93nN+srrpyDA9c2uletsvnlVp0
	NX15afDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf20b-00000006OfW-41pc;
	Tue, 27 Feb 2024 18:16:53 +0000
Date: Tue, 27 Feb 2024 10:16:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add the ability to reap entire inode forks
Message-ID: <Zd4nFfLeAKeOszar@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012281.938660.6031369283118824629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012281.938660.6031369283118824629.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
