Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741344685
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722949650; cv=none; b=thZ902jAYQXLkASbAb3hSYQ0DKtyJ8un6nKsJH3zwYsYjZZjoNXP6at0nLyPek/CEtmc5KjZSl527o3SFixldzXzNZGs5kgsCGq3FYHEAIdgULwZBTPSStjFeT92e95k/p/V3pgoSLnf62ZXaK8mB1O3L6Kr+zI/iO9ZBXPbukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722949650; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=artQ6ykzPhv7E07BdB9EHjWBQiEyZPKAwLedMhRS9fYEB3YmrBYXXGF9fby8RbZ0sEEu+jJsmOd+f4wm0PJdz+IpnTE41BdhHMNjDqJ9jvDeW7rYW0sU3yKDq0Cb6UfB3orjYOljxwVMpEagwmkfXEUoCbW3ArL03OSs4tJN7k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vj8v28xe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vj8v28xe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vj8v28xeJHY6Un1imjkuFlexTA
	V+daRn93yNraoHUo2jzr2be0KKxAq68UkhrZv+38Kb93B50mF64hMdcT4e5RsQtwcBH0SpL4fOWgc
	9DyjjSyW6FXbhZDuvBSBZXRcVg6RZg95IVNj17ylR/J6mJY6AJ/sfg3aZn+GcaxVwstcrTrwP9VzO
	divoz0Kc/sFEeHeIDPuNFOa3HY+6+mUcg5e4L4OWHRsKiaxQthgS3qfQegKgOYg021rB0S/hHF7zE
	wIL/VcxvfJWSONZQm17zYQNcGyTnqlHNWW00ZK51sVCmh9avrFKWmoct7fwpfMs84Ticf11XCcYK/
	oVqayCZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbJuT-00000001daU-0Cz2;
	Tue, 06 Aug 2024 13:07:29 +0000
Date: Tue, 6 Aug 2024 06:07:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: conditionally allow FS_XFLAG_REALTIME changes if
 S_DAX is set
Message-ID: <ZrIgERh1BuhQxpVX@infradead.org>
References: <20240805184645.GC623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805184645.GC623936@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

