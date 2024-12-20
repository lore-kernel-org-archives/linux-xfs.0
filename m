Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68D13A3EC
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734676399; cv=none; b=ioeC9KU6fz1tU+LU35Aqnz3eBNMl7JvKuLnHCuSzDnBXGCHuvy9DgaVU1Xc7FytANWK8N+4LieG7NROxFUknFF2tHWKKQI6UaFWuOxuDw8VkJe2SbIwSdRLUq2Rj1OBraCMlyjCS1uwSmPdGjAJHT8PrrfUobTomXxm+254DI7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734676399; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTmmB/aIVpGTtdTLMzKuXnOB6T8UKEQlkaLfy2rhJLO/wpz9m0fcChGloqDVGNjlSFqJNVMfm7h709HECILiiAVcb0JQktSoLQunoEFp4HMF+ECY7GfE+hAo0bGz40loU8xoxw6sMKD6gX682qsfmYVoiqwZa6DfoiW+CWSrBl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Bp4irr/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Bp4irr/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4Bp4irr/knEygWZ2n49PFcgw7i
	xVNhZaBeKwXfYqASNhCbiYH9DyOxo9caq4TkzbWdlYSsEfOFz1/B3Y4Dc4zlwIAN0FtQh7cidE1Cd
	TRO5UsMCxD7bz+GOTU0C/2bg19ruBEDmD9ILFHEROlTm4bMyPGW2dqtYsL3NwaXDxJ5TktUGUE4uR
	Uc5vu86rQIoPGBFZTpCd31OwP0/NqJoaDhF9C2UGDIG8qmoGjU/Gie5M2oA75iAi4itkdqNRmadVq
	NPrG5gJO5SwS0Rl3Pc2gtPH33r4xTlnTskMR7LQmKYQdwczDajlt/eTuzo1owlwYgdumFzvkCLIee
	ovghCgCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOWZZ-0000000467E-3WLS;
	Fri, 20 Dec 2024 06:33:17 +0000
Date: Thu, 19 Dec 2024 22:33:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 27/37] xfs: online repair of realtime file bmaps
Message-ID: <Z2UPrcN5GS8YorlQ@infradead.org>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
 <173463580220.1571512.12389318349614689954.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463580220.1571512.12389318349614689954.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

