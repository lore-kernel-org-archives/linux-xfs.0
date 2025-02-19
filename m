Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773808C0B;
	Wed, 19 Feb 2025 07:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949645; cv=none; b=IhjjP+N9VTmNi0zXiPlNQ/i9HJAjG1zCRFIhKuAPpB5HGaG7z4XKsCkPBxyIKKK0Z/jDvjyJ+bS23A6CaMnahp4J/xOoxAEQg2x3AMo5e9H3A6NdRFvtE2ScNimsshTiACigbuCX0i8ZtgFrVI3M6nEkBUYZx+gWf54bd+pb8rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949645; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRy8MV1gIBIGMhXDImWQbXMPNKWPjCvrDAWQmr0h4KSu3sBNeyrhhS+WpQHeel1T6XKDWnc5CZPMDUOrpC9uZHg1V9tRPOhaRyArxfMoc4W1y+gZUMq7W3lwPOtX4+GXtLluSMMup+0svQ5DeWawOtLOr6+7Wo3H9/gwNb0WHmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KWMH+EUV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KWMH+EUV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KWMH+EUVJlkicfH0TD3TpQeNTa
	Tx0fV1+1o7z/dWrWMeZlvBNzYVZ4EONTsa82YkFNuELCWG3wvPy9OjzLGtPR3jH0OiAO94q6T2Yfz
	qi1rJr/GfUuw0hI5UrnnYfHAcf35ReTKmAc7nhpsnQd/MZcv2kM5rx5NrtiTSdsJgad0/v0+pti3r
	/EXFEWPfZBd9heSGwtbmn8Q7UwS2O9myugs7/elr4FfB+FZYingQho9e+WKJJJHaOaotUxmnCviYO
	QrWhzJgODAzzBFdTx91gTWYDqKKvgeUOLk28+arVu94BO7Ka1FRgch7IJ5VvasT4lqxq7Y3mYjGpY
	5k+yHEgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeNw-0000000BD9q-0w3p;
	Wed, 19 Feb 2025 07:20:44 +0000
Date: Tue, 18 Feb 2025 23:20:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix tests for persistent qflags
Message-ID: <Z7WGTHoQWNEfF_ps@infradead.org>
References: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
 <173992589915.4080063.10358866862152064609.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589915.4080063.10358866862152064609.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

