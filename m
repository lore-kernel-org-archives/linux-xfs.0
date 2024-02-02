Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D261755B
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706854986; cv=none; b=ZF0qaS4eR+hpqC5i6l/lC0/rcHUZPM6RiSiJga0O8Vm0nH1813L8I2k9o4u4VV0OrB7LYkkUtIQu073AOFQX21Z8p4zgIMN6uKF+TrsZVFdfRM8UgTH4EJ2oVxOIiXCwmcZPxtq9lMO1GW7KFdwEg5JvDPWcMKM+W82/ijfnUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706854986; c=relaxed/simple;
	bh=DSwLopQzzEdhnaeynCgEEA0P2cxDThUZIaU2JkQVXac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqURQL6I1QPhnyJa9cg1/WjBJ82vrMn7gpTU4dBt13HXQZCO/nIuUz8P1ypyuOQVOMcMe7eEv+wMh01YvaRABTWziEk4gPZv7MNRfdqfFKrRoE7n4v2VCdMXqnYN41DkFdGCEXJ51rocekHUyl8fHZ4XGciumrsf+w8vAuZnRkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p54dVfup; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p54dVfup"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DSwLopQzzEdhnaeynCgEEA0P2cxDThUZIaU2JkQVXac=; b=p54dVfup1fYEdRgmFG7fo85Hts
	JPtcpFbL9WTRAzrK6o7orZnPDqu7IGTRVbTriyxFxT1HN9DjGa4Jy5herXqhcbYBHm37CWlIC93Eo
	2CYksbP5b4I/cpxgclK0ZVfvfi2fzViCy2bxMuc+xirTXW/tH9ccWPpeEgXG26eYfr1s2N4xqiCiX
	8zyUK4qJcmXGmGy7w1lKVd/cuK3gS57CtBaLEzOYCD2GCRjoYVhbDSAjUklBVmzN8h6K67wVG7wkt
	qQ8VganfdCStY4X//hu64FTr0jk7iqZN3zk2H8Ekl0DEr1NoEFBhPvVgyCWU8BXHxFLzJZKqdjvqF
	QC6BYzUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmx5-0000000APIq-1d4s;
	Fri, 02 Feb 2024 06:23:03 +0000
Date: Thu, 1 Feb 2024 22:23:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/23] xfs: encode the btree geometry flags in the btree
 ops structure
Message-ID: <ZbyKR8N9tnl2iOh4@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334034.1604831.10246753237960404458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334034.1604831.10246753237960404458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(still no huge fan of all the explicit callout of persons comments here
and in the previous patch)
