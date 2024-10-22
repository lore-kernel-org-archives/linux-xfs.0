Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA65813D279
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 05:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576448; cv=none; b=U24SW86xcVWh3MSkvx+lk1IbzCOojeiQeutX9EgC6bcDhutXw5SRzcq0R+7inNVmitVP77ZI2RPxh1s2v3U5O+VuplyfLbVD0dSHMM2hyRtXWTxkzSmVSd0Zkhipw7CO2yuXvViy39lGXQlwPbIatsBxO2BmNGMRuSfRDRkOaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576448; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTmH75pO4WhhJtsYOcc8pVTxSJ1vklX8lWiQXTB7JBuMAYDtFAx1BHiCMIKjaJEVaPyw8jQd2wHjnGOEvhr+5KKtAICZ8sjhBxOgqQI9CPxaQPbpn8OecrKFHVmWsp+HE1yMH5G8N8FSqWiXe4p0hT+e0EcIeAtLOa8N1ENuhlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZKUP5/Y4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZKUP5/Y4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZKUP5/Y4HC56zEpURyzxoRYc60
	PVF085KK3XuuaQxQuPniBeebJ4G4MdP509GfTIBxHGV3LrirZG875Pu9cegJX85xqxRN/L4a67cpW
	YlBnmDClbANs/VkR5nDWb37aHVM4lh4I7hxchGsAyGZM6RD4C4cLhhNmg9ttuFzkgsm7Yq9rhe4nz
	/UIv4Bf0K6iBN1q4nlSnerEQDwF9FbZQmZLL0fIdMYZI4Fz8G2QB/4+OIobe0JjF+38Fa/S5XYF/S
	hlNlH+mHtIf83mpDoZtFIxYXkmuT4xmwaLfaT8dGsXyB8nvmR/ozuQr/96e9UD1FdifxY9eGRjjrt
	FYt8zPXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37qI-00000009it9-2aaC;
	Tue, 22 Oct 2024 05:54:06 +0000
Date: Mon, 21 Oct 2024 22:54:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 29/34] xfs: make xfs_rtblock_t a segmented address like
 xfs_fsblock_t
Message-ID: <Zxc9_o7UE8y0VCwv@infradead.org>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
 <172919072169.3453179.4216171622252724671.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172919072169.3453179.4216171622252724671.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

