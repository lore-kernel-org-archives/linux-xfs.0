Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD1A3CF68F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553129; cv=none; b=YXHHU2179ez3ZNDv+QFyIH1X18SwDtAKBr7hHR5gcbBrMeNw+hJhQtLiMmlJQPl1Sc74OO/3471y3MB5huAiubSX8w/qtp2Ty1oKlsVxWfSwpHLeCRNmz8FJ/lauLNBPR46gh00qbuHVpBpdbm7lt3PLicQW4rsH2tZEhjprdQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553129; c=relaxed/simple;
	bh=FMGSPEzV+/8bjj/TR2/XEe85Lhkq0QgYAfgWQUeteYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ql9a+1HjSMRvtYMMqHaNzXUC0Vuc3FuMXAjiZr06JnQIyGv8kFAFrFMhtxubnPo8JKQ3qm++Gl3DoIs/+hrGzJlwCJIuQ8q2guqbXIDIyghuoOz1KcsFxKuPxgbfqS4hPo23M3QBXXa0Ecu8FH8Q9FHaxRNs0G1zbI6yPJhQIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sNG+0JJM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sNG+0JJM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vlSYadNO9ELEyKfdFmV3BiPLkjurMEcI4T2kIdjD2eM=; b=sNG+0JJMtMyaHKOwp7tfycNDoT
	iVJaCifXLTlwzjCxP6oYYgs6pgf2mqdWNeSCSts8+nzs83wlIU4fJ8I3KQaE9xCmJRuziMbpI5zgl
	ARxXNYBnVI1mpFZtUczAvt2S4kEgX92/aaACGtznuSHbvmDCzXlS4tmQPl/HGA7wDpaLEcxvWUCyU
	LGnupa3/zZJGTeBxSUYc6Zks6mqaWHLgjiGGMESVStFxUaOZHzkRfgmEktbkSidZ+pa7JjGnn1i8z
	7p4eQfX4aQufdvcnA4dDyYAUNN72dFZT+f16hB5QOi5njM9MJO6EtHHPO0DY/gYSX6QQO4O0uX4W/
	2T4Q7/lA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS2Z-0000000FTGv-0SXt;
	Tue, 03 Mar 2026 15:52:07 +0000
Date: Tue, 3 Mar 2026 07:52:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/26] xfs_healer: validate that repair fds point to the
 monitored fs
Message-ID: <aacDpxODc-28GPH1@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783619.482027.5192762904110510597.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783619.482027.5192762904110510597.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 02, 2026 at 04:38:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When xfs_healer reopens a mountpoint to perform a repair, it should
> validate that the opened fd points to a file on the same filesystem as
> the one being monitored.

.. and if we'd always keep the week handle around we would not need
this?

