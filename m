Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB228E8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 05:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732686242; cv=none; b=sIET2n5Zge3Gsen3enJMSaiVen6spQw1kQyvjQIRbMHtY3/77BGVjnCv58ZruUudAJhTxm0W5c8ri0LX+4sXw3bEJiQtCXHv+QPsdfSXpuDAv4JD7DBNLLscxUqk2W1NC2Zyljk2KvxxwlK//dnN9m7H3sLExjDxVBeqNb+kxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732686242; c=relaxed/simple;
	bh=l1pKx1Qy9a9XrLaBGzPUQdgS/mJkuHZbsll/nKglcsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDP8IkoW4CZlbpZU9o6pXYlJfnFSqihONLG7VkJ+xwag4d47jqpPY4Gk3PjewgGsFlebPJqPWVpr29jZ8oZiEigXSU65u3+0Olgn5bHqIuxlEDhgkHEWjtLJEP8mKJqYolA3iJFOiDgOGP1WTqkL0TaKefe0IU4FGCdpPMBNNio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c7KVAWBL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7KVAWBL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bo/dD2ULucrHYF01tEGERjFcjIXK6bKgly10ass2f/A=; b=c7KVAWBL1OkWPbKy9UB8jMCHPD
	uYYpxOGyBjDZ9rrnPefN1CcRuq36vyx1tVTNbSTHd9RGWXAr0lvlDgtNismD9MYLyB0iPDu/LvuOg
	eA2qVwE3qLWjzViTLAJgWKpw8VuZETMf6FvgxfvhDw8OSBlCsuTpItguSh6+ITfDa53x/J5tJyGpA
	8KXPtnnyqvVvgst/BKqMGJVEznBWM7fuUtprtDeT1MSDCDDVZG7RTmifwCCpmcnQgmPIuk4T+jR6u
	srC/NW1On8uma9QmXvjnoi2u/UXnDFr+kuRFdVKnuVClptJwxYe9ybQbSqvFCZae1Gw11q/fW6bFz
	YtXBjP2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tGAqH-0000000CHC3-161H;
	Wed, 27 Nov 2024 05:44:01 +0000
Date: Tue, 26 Nov 2024 21:44:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
Message-ID: <Z0axofQOO1hYWt-b@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
 <Z0VYar-LmcdXptXh@infradead.org>
 <Z0VYew8ATCmf-jBA@infradead.org>
 <20241126182052.GK9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126182052.GK9438@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 26, 2024 at 10:20:52AM -0800, Darrick J. Wong wrote:
> How about:
> 
> "xfs: avoid nested calls to __xfs_trans_commit
> 
> "Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which
> calls __xfs_trans_commit again on the same transaction.  In other words,
> there's a nested function call (albeit with slightly different
> arguments) that has caused minor amounts of confusion in the past.
> There's no reason to keep this around, since there's only one place
> where we actually want the xfs_defer_finish_noroll, and that is in the
> top level xfs_trans_commit call.
> 
> "This also reduces stack usage a little bit."

Sounds good.

