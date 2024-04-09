Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD5F12FB12;
	Tue,  9 Apr 2024 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712669663; cv=none; b=SFiXLWnhHw6ry5yHtRCs9ImYlhuNFcjq4cAeBfk9qsXtEe7UQ/vxKPbKR7caIUNRTLNqaVTfLP1h5y/bL7CXa9AdMKmgkz3+hmeERAokP/LJs3VLwBBVC4bI1NCjwog4xvNVpbocm4YQdNkBxZOMQU4l1ONcLXkI09pO6xu8KlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712669663; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfBq57R55swMV/edFuX0s8fkek2Qp9JQ23PE5eLxfvWzVRTGWSi4VLbgTxRBxjok8GkIXM68OZmq6FlKXQTDblRZ7t3q53a8bHeT/a13VsjkhYgBB2HdkBxLVOsdEa8cMRdwYojl7YgAjLi9WF1hPYNP6eBZcOkzpajswiADl08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZC+uNp6g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZC+uNp6g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZC+uNp6g04cK8JoxbEiueZEx87
	mwmpsE7rFi8O+BejdETPgRqXb8Y/3YYzIbI6DiVp/1C71c/vU79EepMO/OntAUWfm0GHf3zaTd09h
	8jZAvX/oNMNF+ZrkSow4t7QIZakzt7MpFgPEwr21U0m0yAVWOBstu59cxtx7Xz8x0KdDeNVkGGveM
	vVykYKIaJy6yfmfADs4mRsWruOlniYsg7dVEmEFNFRULIiVsDdJtHnkEFXQO7AtB7xU1VKLltHzU0
	S2H0qDr4036C6SD9gqp4/m1Vl6SB24Nrfp5DVXcazbBuBObYlKgvtr4VjGdNbxctB6SSuySHiR2eK
	RceuVmIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruBcB-000000029Gk-36EF;
	Tue, 09 Apr 2024 13:34:19 +0000
Date: Tue, 9 Apr 2024 06:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: bind together the front and back ends of the
 file range exchange code
Message-ID: <ZhVD2zhg7yLnl6qq@infradead.org>
References: <171263348423.2978056.309570547736145336.stgit@frogsfrogsfrogs>
 <171263348564.2978056.4044359563518643318.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171263348564.2978056.4044359563518643318.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
