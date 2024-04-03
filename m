Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFDA142E87
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 11:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712144609; cv=none; b=gsYLDmCxJgCKpurWjIjoCsHvN33o9I2MIetVCsd2z1cgDprhXmiSQfzVkQLkOEnbiyDJFLdtbqB9pNuaR6BWL+AmNs1X+s+GCp462uMg/rflQIpoJXfgxzIXy/kHaZUYtF2T6ccYMln8vsdrb+eeQQ0XdPTI9tbottA0cBd5YBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712144609; c=relaxed/simple;
	bh=T/LS/sQgjbYfGLNnGOh3INx7cSbKONm/v3qI0cJOvQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOwyWqoS0jwyewsWINoyKCm/qYvsjLSG0EOqQa2TP4Lam7OwtH6kY4P5L2nGFhjMqQjMqydU1wG5oLN2PXVkSUq/W3hre805ub/vEDANKCrfGTJcUCXEGo/0pDezFTBMreLAra9q8Tx6BJzbusFHHBdK0r5BMOONknRlMaPeUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ssoyq7RB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ssoyq7RB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z0BTCEYpoZRwTDAJd5LIvJL/wkqij2Zd8XIqDsD/u8E=; b=ssoyq7RBFEzOHgj7aXigqayZxV
	YoaNZCnW5h+UEgokI/EBbgFraZTAehVE3Fj080r2mkRGvy/JPvUHyxKlhqVVUY8krq5vxBvyQnp7f
	R8/wWSgzJKvpvUdMEcKQRvG8gO3k3RcBsgOlMu8EKYkBYl/6rnITEwNRblQJ8Y7uOz4BNSv47lhK/
	1rG61v+1Nc96RFok5b/rj44NQDWSD954PyvCmkmTJXRufnjb007n1rwnP87krzrHvdaYJxeNwYKa9
	f63b0ToZr2HK8mOKngJIfd5LoRVJ+BuEm7zUFgDiQKjcVNZyicLjdIJG3ylZehJvJeQKeI5h0lC95
	N93Q8LyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrz1b-0000000FpWd-02et;
	Wed, 03 Apr 2024 11:43:27 +0000
Date: Wed, 3 Apr 2024 04:43:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: expose xfs_bmap_local_to_extents for online
 repair
Message-ID: <Zg1A3vRm5QyPYC6P@infradead.org>
References: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
 <171212114806.1525560.3907483686132876442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212114806.1525560.3907483686132876442.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 02, 2024 at 10:12:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Allow online repair to call xfs_bmap_local_to_extents and add a void *
> argument at the end so that online repair can pass its own context.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
