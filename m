Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C422054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420693; cv=none; b=hRFLx35Q1AwhheHOCtJFxvxsNq2edbs4eaQqJ4kgr4gi7AvwfcOxxRQGvto6fIxfFo2hMAQF+6HTNEO8IXoTj773qdpc3h8hu3YQVoeNM4lQLTJxsGO1kNCXlG9A7dBiHiB/9XixYI0ep+FUgazsUtOL6x12GATQOVbr0uENGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420693; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXKklSlJc8N8/UCEAwG/LGTrnvWb9IZ1I+k9kP6iitl8Y2AUFgR2q5MnXeVZVbrDKdNtuDu4lRO4EhSrq5rnf/p52Pra8IoTK4A/anHkcDU7fvIyWY+KI6eTNLXiG/ldNeLRdGf6die3yYeBpcJMGEppvLClQOYuclQ+lR5bMqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CZs4ST9U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CZs4ST9U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CZs4ST9U/qnSI1m8CqglG4m0DP
	7Nb3l7vFeqABOEbHris+paCre4yuVRmHUhA16F6QViAWNPXZzjSgUl2GhfGX+XYS33b6mbg3SoAwH
	CuLZYCat/xYIAUI+mRcy/thbzzXNFK2vDaa4wMYQHJ4ccRflP5ojccps/KKHYZGjooEMXy5fckbPT
	H1DNqdr1DOydeGVhkWLe6yTi4Kqc9Q6ESCZAPL7C92YqFwtZ1R6LoCg7rybrihFjqxdt8xqiJ+bdR
	pb2kLNAvZa6p4gVW9NNWVk0ZnHerB8N0PgLoRLQTfOAOggBBGwQbO5YIc2BuDrxMBJzzSdSrCCGMZ
	44ktllzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQmS-00000009i9I-0BGz;
	Thu, 13 Feb 2025 04:24:52 +0000
Date: Wed, 12 Feb 2025 20:24:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/22] xfs_repair: use realtime refcount btree data to
 check block types
Message-ID: <Z610FCaSlWe-qp1h@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089116.2741962.13761732561620436172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089116.2741962.13761732561620436172.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

