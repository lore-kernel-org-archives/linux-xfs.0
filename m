Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5A822615;
	Fri, 30 Aug 2024 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997422; cv=none; b=btmFUsL85bcHEC/pTQjwCU7jEjbu5Ecu9G9MzLrFdfRGOiSwxYz895qSQYzbBXvXgagiD8WBGDj3vs3G/81r9WPkt66XHYYYYdKQXn/jxFZXXDIdcVYPkl3Wru+JVSouDo5EWj9OBN1f1DGW3o7YuCtC+/BEoZkBHoytXUGE4oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997422; c=relaxed/simple;
	bh=jmOpDWoN2swlkIHrg/vT35BcSNegsVRcyaRn9HlsXNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpbIefqIIieZwluWbJMXhYgzyVbltU6IC6TWlYlj1lKq5XOxWpwkj7bRjzy84eVrT/ivBTZT8fXnOmD5/hoCM7y1PzmCYW7C6PQwvVVBpXD2bav0zMHLQofWVXT19IpUuc5xCWirCAGg+m6/oMVxQUwEKCJAr0zHAbYYMevJTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eGzeLhpp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eGzeLhpp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u+wBzTECujhMn1I2HgLfgBgtRCe0JmUyUTjlW2As7bA=; b=eGzeLhppD/DOKVyNohKxiEt684
	vBu4Y81dwVAeHxGSByl1d86Om2fZFS9HZ4tObPH3qxSGd2sWnH6cGohtrvKVl/HgWV1h1AzEpGdWg
	3HARHjCZ3dJN1d42ezio9XPXuZuNef+CsozjkIS8x4EwNpXTX1y7cEr+lmPu2RPKlC+rD3ztzGJqs
	cytD2RBp3Z94sI0GLrz99sxyA8IyM1/zT2nRd70wBMnR+79sG/MALNu1nFsLlFaXSu1Ttfi4zeF53
	DN5xUbnvHHZtVqGoQKexeB2CPvAXv71cK7mTf7X6LZrCbJvywnH03pl4F3RgN8z0vt+X5/HAOzeiH
	1mbilLcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjud2-00000004sOi-3xq0;
	Fri, 30 Aug 2024 05:57:00 +0000
Date: Thu, 29 Aug 2024 22:57:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/004: fix column extraction code
Message-ID: <ZtFfLFp_mItHI_Xm@infradead.org>
References: <172478423001.2039568.8722356306961050383.stgit@frogsfrogsfrogs>
 <172478423017.2039568.10354044892529803918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172478423017.2039568.10354044892529803918.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 11:46:39AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that the xfs_db freesp command prints a CDF of the free space
> histograms, fix the pct column extraction code to handle the two
> new columns by <cough> using awk.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

.. and we really need this ASAP to not fail tests with the latest
xfsprogs.

