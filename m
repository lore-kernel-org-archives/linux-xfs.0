Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2339713A3EC
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676430; cv=none; b=ZTSiwZWXML+f+3YMC7iZ4sMrRDtHnO5vGHI2CyigF79am5R0L4Oqj4Bo0T8HjJ+TaAhUPtdnX87C6alQEVHkDFDCZftEBPW/IoG5wMUT2dUL6lgUGrjkNvpRbKhEI0t+cgcNUoh4xg+Axnv4uon1UQL5qjiMzZ19imSL52A+MPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676430; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mcd5JH6V6Lln2V/v/+Hq6QjEXkuVDMFMFnSkaI3A6dDf+C6IdOwIoMbazYUH44yeloXEL5Sb54j6uh3+tk7ueoSVsvbyWXCvsmurZD8LlmyJTbQ82oSJbjv8R7dLoGftN+lrraqV22KjYt3uwCLU3sc37KIkGhH3n9VUE02iWv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Buws7+AM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Buws7+AM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Buws7+AMQy3Uk/u3Pzsi+qnGaF
	aWuhfwBRDrePqEVOw3zVlUpqRhZ6MIAkqv7a+obzOizu30mc4vEurhz2GlGYWB0bYUnfvJfbCV2/3
	IRbPPnExVdvEwxxJ8j/ym5mLsx7VX28EVWEV1mey3SvsHN8Rj2VTIcy1FQFr8WoZOq4kEOEWUkv45
	AfUkoBN4PmN5gAvY5EKAjxms+e9vtMvnb5iGHvYhkgR/tFlf9RGfA1+ChhOZJVKFYiT6Apfje6m7g
	PUYAX4hJ+Ux95nccS/PO+TMbIIsil358eJ9unlrPO3qPLlMvN+bX1fcA4XAYSFWP6qYMg5Ikzz0ZN
	NoiMXCkQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWa4-000000046Ca-3PXu;
	Fri, 20 Dec 2024 06:33:48 +0000
Date: Thu, 19 Dec 2024 22:33:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 32/37] xfs: online repair of the realtime rmap btree
Message-ID: <Z2UPzNQ03SdExEJo@infradead.org>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
 <173463580306.1571512.3126512103638820643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463580306.1571512.3126512103638820643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

