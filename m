Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A024388E4F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552649; cv=none; b=I6kNIispyc12Px7SJ+rQeygwSle4YneaHaWybbxG+2dvtunS/Q7n3TUZpflcolD5nlUWQxm9cWZ1dJgo2nhEmTFq/JOe7f5PkO5XMwvbd+1OQp1SpqWy4ZJtvq5yTPQe24xTPZHXTn5g9ajsAhNUoQornZag6kNKw/Y8YsVqCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552649; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JM6E0LBbF+T7hH0EzmO4QOsutsacoaSWChNau3Wwe+PnG88UCJB8qgeTRG53mZNUQ4fwnqNQkoD1uDCfh75mjdegBtHGF5zwdkv2DOuGnNLoNmKhwjCYlEkvu+P4obveoGMDpW1uCjsQcSWOnKFhI+85QywsN5Lh1sgbnC0giFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wiMW3wVm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wiMW3wVm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wiMW3wVmK2dW90w4jTuGNmb6HS
	uJrv8trStcnR4UvQpi25b0zeXK/00OdyLJl3d3srkMyWMBZh7SOIIzHMlrq/1N5sL/fcIgLil5vXy
	gE+NqvNMiLIgQST9bLTX+aokXbcyAUacawoo+OukBRRRfs1q4lrGE/8w7U1RFcSg0uSwwWNoVtDHl
	jf5TPTDi9NusqN/E+VMevaVZZO1EM8d67wZg3Sn7sJAPSt8PWsV21jD8ml6vGKdamTatn/UCE7Iz3
	CbbgFl/ROQc3IVLFgtkutxXSZ/qWYKVCx7Y6nEi/rtcE5hzsanZnHDAXaaqisTW8To2pnCZnqAw0Q
	WZqnuTjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRup-0000000FRwd-3Mss;
	Tue, 03 Mar 2026 15:44:07 +0000
Date: Tue, 3 Mar 2026 07:44:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/26] libfrog: add a function to grab the path from an
 open fd and a file handle
Message-ID: <aacBx3nHS6V7HOIq@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783310.482027.11917142460939036196.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783310.482027.11917142460939036196.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

