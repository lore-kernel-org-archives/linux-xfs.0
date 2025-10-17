Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04033468D;
	Fri, 17 Oct 2025 04:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760674736; cv=none; b=g5RUKk+G7JroQkgTofjByjVJTt7lDFfcydBQyD1mpYrCwVW+a/sUXIreAidLcTuYReRBTEPM7k23q7HW8rnLWYDUeKVSILNTFcbMR0v1bteXVHzB6sM9Krf3LuM3mzH4TahoJaOAtZ1NFf6byzI9/Tj2si0lTkF00wtvXDMYVEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760674736; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmsIGXVbVD8JGLB0pW4wKYo/8/zGV6Tgm3CuTuTJTm2pw0I88tlcowu/5Bv8ZnUGyKC7WmEmT9GDNOPNDbCJkMmP+fPPrzq7qOUSFssKPcsZdSOyzCF0UUoRKwv8ibuE2zeZsMMxE+ezJDPbD/XKdLTxMSOOBZdS280MBwy0vN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LxNdGXZk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LxNdGXZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LxNdGXZkTzdiNpO3nDiUtqZuBq
	G5V4d/epz9uIiXA8/oxz0eiHVlCQ25oOpptw2pfvrbRolD8T77FHyN4pRAQN5O8270aMarV7WGPeI
	+pr6UX6MalBeZG/Pi5/MeBvPMAR/Mqy0vVcf+tROrLkx/nSaNlH7e9LICDGKz/8rUJQxcviikLYod
	2fVaUV0+tG7aXLzvCfA4GXy6NZhZRRFFT4eA6r60z+Pcd9/OJPrH8NfaKDnL44KHv9fwUBIM7+JsZ
	+XingEc9YnhYEMYafQz7V2XIKN8naGAwKbQQwcnr+qPpuuIKBCfEsYxfdiEF1rdbDq8GiVgq37YLy
	gvFt6Fsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bvY-00000006Vv8-0aHi;
	Fri, 17 Oct 2025 04:18:52 +0000
Date: Thu, 16 Oct 2025 21:18:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] common/rc: fix _require_xfs_io_shutdown
Message-ID: <aPHDrLn0akAWWOhw@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

