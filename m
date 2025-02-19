Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816A18C0B;
	Wed, 19 Feb 2025 06:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944880; cv=none; b=Fy1DF7+a+CkWyaJtSyNCcg0kEr3xjiZdFTyOH5Y2mjZrb8jTjhXX9X9JlyF38bn/QxW7jX7KqT49blFb+i584Oxmr76DE/fN2iE2d+x0XvwVoJkOhbPoexHcJVEnykTWqy9RsPenRDf7Ig9rZ+Y8kJQo4e44GFo5N7gQdMqdRl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944880; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qcifbH1zrr56D4BXz/R2qyUP9lhcAJ+xUq7t13RP6Epp+V9989imO/aGGnPgKNBCKG8JWMktXbEzYhmiyuXXe7UicQzPGTFi/VRnwgkzKyuX/+0ekcvwGG5mWTR1gqR44fJJALPuXPski/an2MeOGW5Fz7B4jqgQQR5iZeYVJ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PbKETibu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PbKETibu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PbKETibuf+GR1eJTlT2JsnJ65c
	xfoZmAx5l/y3nlv3/pVqckNZ+nMF56h/c3klKY8GJmoEQEke2yUCryLthcRtUf5UsEc7UcE5mwDQg
	FmeeccfJjkfaHDBTaltRu6c3X19fD1NiuKSSH/mLwnF+876yl03uc1OGith+it+LbyyjBn6HfQuWY
	pAD2zqogYUin5gJ41me11JO8gvgkdeF2AMU4nIl1Eeo9dFODzQuaq1RnBEnQ/Pku5ydY9iNJ0ZtUs
	KRbrEgdokdMcOij5OReQ7C7arhypjdMgP8JE+dpiQdkAWQSR0KoE3nbfX0Hn1ZKsJ4CGFoDrny62D
	J/RKj+Yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd95-0000000Aynl-0mWM;
	Wed, 19 Feb 2025 06:01:19 +0000
Date: Tue, 18 Feb 2025 22:01:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs/349: reclassify this test as not dangerous
Message-ID: <Z7Vzr37dSInM08z5@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587625.4078254.2974311211127532100.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587625.4078254.2974311211127532100.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

