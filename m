Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085B8EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945700; cv=none; b=iXUEP6uiLhuJot9MQiulVsPVRkiVtzKMetrxX9j3oXJt4wGbqlrA5nOb3K+FzTeDpoqXcs2RiEJ/3byekNVaeC1JIsuPxUn1h0fqLf1vxu1zppBz0peopYWzcqOJAmvMU/I9MdTf1rGm7Mu6uJ/LhrTIofOtOnCbgo46o84ZoF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945700; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWbjA/Rf4nQsS3a4GfahMeT0y6F0IrQ1eJ7+opOak1E68mbDiVEd9iPgFBOFLxBZMn8V4F3IoHPDSgfY8qGz1QdCB16tHhExK1mn3Z/2X1emCxiLbJuv5Kt7YY+rlXv2TcO1DKRzWIuZfQd/1FVe8EnDnvFn8lkSx9Ui9fAXaCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BHhmI0VO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BHhmI0VO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BHhmI0VOo0/TugMzQGYi4vKM2s
	dhR7OOJi4ehPBCbkrD8sV6Jw/zLc14xf7/IYq7hLXgqoQQiV+kD5vcxAtbN5ZvzkdohHukN51So1c
	lWV5VvyRCQS4WWjPPVMpFzy8e76OFYOYXmVmp13Na4xecytdO5/EzW+5SNrmiV39/bX3E9l+OBLSZ
	NOcIYZ9g6W/9hRzAK6oqUFpPKoz+ePYFSp6a4JOx+cyOlZ7LLHSV+vA18amdHD0BCpWjedQ4lGBt0
	MUqoR4RpzNAV8ZjaoaT+zbgdVOb8WUkfOOcGP0NBjMrUhEgMQgZ9Rj3KykvbhqGSqwWfoB4enSoho
	9wi9WQ5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWIc-00000007h4F-2qOR;
	Fri, 21 Jun 2024 04:54:58 +0000
Date: Thu, 20 Jun 2024 21:54:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: move xfs_refcount_update_defer_add to
 xfs_refcount_item.c
Message-ID: <ZnUHor7AEuDGz4na@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419943.3184748.2162208276846925919.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419943.3184748.2162208276846925919.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

