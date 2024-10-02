Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0116D28F4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 06:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727849043; cv=none; b=BBtMc/4bnOYY0bN1K6y/tpbNtLHoZKVHzmSpi2/L8mbWnvllnzMQi7UrSmx/blmSVf4JHKOyImvaphfutKU8o5R3rXtcJcE2qNwS6jend4dCiCoBbY7EBIRPOxQe2QKo2ZXtDacEbdo5SYhfU9mrPV13hIYtkedMDa9/g/OsvSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727849043; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZO3nR48CGhlkpujMlOMiH0/TsWdfU3CyyOhO8/4HoyKF9gbCIppMWGyPSwF7M3FL7QmRBwA3+G4ZM4yiTU+rlsah9i5VlfGURQA4A2iIn3q+KH8g8VrPGMHNQNcmkjKDvBO910f6DfMjHYtMDnSMXNr5OSxelpaeEIAJEK+Rdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k6DdqI0O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k6DdqI0O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k6DdqI0Oomi5Q9AIidNTg0UImr
	PNZfOZX4//iQYjAggt1zkMWJmAcO1K61KsENlxAZdBTp4+F9wCUq3p7aQ85xszPci42RLfisEkqjm
	JrNcli/P0azNukRdDCyMxtsdM7R9pKE486j/Lq9L5sDRoxW+BASnNxINphSLUjsLN96z8Gk0qAA+s
	5GPQ93hVFABja9mUJPx4R2o2MBwY0lO2D3xa2EA0/LBsJq2BeCJEc/vi+6fTiCLnJ84dr9X8FVL9l
	0MVfg2KN9teO8wyofBVbFfuTUPVWgdL1zKhLozkjYLX+FE7j3y7Pmf8f0wGBeVPceA4qR/FG+sgnE
	XDi/0YqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsSv-00000004tsS-1zo9;
	Wed, 02 Oct 2024 06:04:01 +0000
Date: Tue, 1 Oct 2024 23:04:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: break up the rest of the rtinit() function
Message-ID: <ZvziUX0OK1cQHNea@infradead.org>
References: <172783103720.4038865.18392358908456498224.stgit@frogsfrogsfrogs>
 <172783103750.4038865.17327935292927158281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783103750.4038865.17327935292927158281.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

