Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99917BA2;
	Wed, 22 Apr 2026 06:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776839253; cv=none; b=MAaAkc25smALiKUahR2NXVOEYATNy0umOVHTp/hNIf85QS8MldqsXPshFK5FGHKBPrSWN5AFwWQLuLlsGp0HspC7gDtZYIXmuYTquZV7wIulP2J0KmgFylYquBJZuPaGU368/HR3Sd2gGD4+YeexxstB3AJgP5F4l7d1ll04nEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776839253; c=relaxed/simple;
	bh=9IynhPfUK7/mlDj1rffHX+Ja6gIz6Eh5RRKYqKeH264=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNR8z6IeGcVmikDRjFXXAUG+mmMLzRlzPBguy2ixGczmN7MPTOJjPNLpWGuFQQNmgFb5YzHP9F74Ck3EGMUZMU71OzGGLypkpwUMe6eJXQRiwum+xWM4xNbrvXr2md9lvheVpgTQRusd4gucNx14WbxEQv+qqROGCr03ZbLV+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1193p/U1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1193p/U1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kyhRy7z6qEqzD5xuI2YLX884oQxUB5z7h8vcDrKlTVM=; b=1193p/U1Q73XHiPQTTeT3XTIMn
	mq7i/pd+z9MUZ6NFdCoaLZW0uvIOsDRfD9XnoiQDuB20uMFAudWDSx8V0mNQd4AndXLBTVxrfHaYG
	RtLwQRLFlaQ4Pn5nvWQfRwtF1DABiItMr7o6vU/Q6FBYYvfH+ocbXW9ESAl0BupIlmIFYaxMeohaK
	D52i2f8UGu7JI0Vdi+TlKD7oOnkaiwG4L+zyr6QdVjnkshZPLM0qPgB9jOoRV/lNkZPbS7uTeZQ5/
	eaFdB84TM2X0KCmw15eKj23kDtH8dtyD7SjeuuicNP6icoscKelZkUNeFNuyU3TECeZFlQ2fc1YAw
	gkkhH+Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFR3b-00000009f8w-3OVT;
	Wed, 22 Apr 2026 06:27:31 +0000
Date: Tue, 21 Apr 2026 23:27:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com,
	cem@kernel.org
Subject: Re: [PATCH v2] xfs: flush delalloc blocks on ENOSPC in
 xfs_trans_alloc_icreate
Message-ID: <aehqUzvOHUoyLqvc@infradead.org>
References: <aeBv_xvDTmuzEhV1@infradead.org>
 <20260420100637.3584-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420100637.3584-1-ravising@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Note: posting the v2 as a reply is a good way to lose track of it,
don't do that.

> + * If the block reservation fails with ENOSPC, flush all delalloc blocks to
> + * reclaim space from speculative preallocation and retry.  This is similar to
> + * the quota retry but targets FS-wide ENOSPC.

Can you move this code to sit above the code that implements the
logic?  It is much more helpful there than at the top of the file.

Otherwise this looks good.

