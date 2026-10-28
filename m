Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202573;
	b=SsfVFcrLXF/AnnLQpddPN3HocqrYlQLOT2Wr0SHUBk1jWi8VMAQPA4EIu8I62FCcXZzu
	 OnR7PoRIHEkez2zIsvUK9P+VYCCyjNr5Solr1smwVyY7nAnHeMCjxSTriIBY8/AafEc3J
	 1mUl8uqmhWmtQjWCGTsIjJpTqlP8+iSX4AiKZdyl7CQAtIOUuVRhvaSwNyR2i29m3QDQh
	 jraIysXG2ZqG/Mx/MPJIxWLFD4Lon+GPuUR9b49C+YepyLIKVPjJOY4IbCCShBy/J/JCO
	 aNatcUxORvs8g28Abg8fs9oCqRV8D6oH7gzNt2jcxFLzv6eroRUF0z/3jkaZdaS+89A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202573;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=pkfTY2mefnA4Y+HkCuJMiq0dh0yghX24A+tWAUfYhGIlj5F7EdBkTNQN3LLBykffqIqL
	 MYQBs9Dy9wklVmYsjmRMqgrPtUuPcK25/k6fbtEbjNzUmTzZNKLJkeniDoag0XWbw/zM4
	 G4iCpmzPwocQm/KYYsx079z3OguOPjSJAaQK6sLK24Xy/czL53hFng/8pCPscL1pZudJG
	 TdsljOE0WVaCSytMa4saxauTwzTLX91Xi2eeMUaw0A4lSZ4nokJs/iHhlSBIBGj9F7AHV
	 OAAeP/PcxyycnRHvIVZvyuDKAKQXqdiIdqT+51TfME8Aa17gWQFhuUKhU4ehobDaDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yLar4Jv3;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600B3606A31C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 600B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=yLar4Jv3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yLar4Jv3WS3htnzZbMV3j+5EUL
	kcQkMQ2vFDgUIDS/2RUdlDWWqGxNCLCTSCD1vcJKyBrX1k7KsIqBUo3WYlelKNM5HaVUOG7hQkzfL
	Q+awuNkLkd6nCuHL5lTsaakxZ/0GhILy7XjBkHQ4XZjAM66+GEXsy4qGdyPy09ku6rtyzFZfOOR1j
	MkIYVjnS/nr0FlnZbQoSeH7JR9iQ1VuYaiWvO38mkZhktgyHCSW2KxZ4DfQ4DF1F8M4iyQXT7zsc+
	aiB41ADY/eTuLzZed4ZnDDBtXTE6sHRhShjAahFXTdU188PgzukBQq3uIYdMNKAYfw2zvGW3PLB1m
	qEkvnBwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5u8-00000007Sjp-3eYq;
	Wed, 28 Oct 2026 15:49:32 +0000
Date: Wed, 28 Oct 2026 08:49:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: remove redundant stat check after
 rcbagbt_insert()
Message-ID: <auIZjOS1GOlhAcRn@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-5-sandeen@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-5-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

