Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61B11BC3E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471768; cv=none; b=LVUpz3yliIU9wNmbThBxE6HEYwbcZf0uFrYoVc+6NaKVjv5uIQLf3rdbhD7Qd+o8OXWWwkuIR6Frsaftr8AX2mnJ5z9QgD3TUTobcX7/bpZcY1atWZl4n6u/+KuHeUn1ZX6F1hrkMawW9G7P+/tn6PEzkpMjp8dJka0WwwroPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471768; c=relaxed/simple;
	bh=R78AYOS45TxptOpKupAegG/SiqIewuO8Q5e3MvLAYqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjMdXJ1M6BhQrC/fDTjMxLrdPhBEKtsxIncPGYqTZGuves9n3XAlgA8ngTDoz+WdGjt8QadXmpEHeTnXvcf1Ck0Sg7KyJvAfeDossSWqIS4BotGXUuEVyk5GM9RtNTpwuTfHPuuMeawF1J9xl7g3slVh4+yZTq6/bDQcCiQh+CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nnhFyY4J; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nnhFyY4J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uP9uOGb6wydN9C0vzzPef2MN1/g2g2NRl6wNlKY/iMA=; b=nnhFyY4JGjhAY6vqEesl8OppJz
	veIavpEABmhyN75zZ9IoHC/t70eha+edf8y7srS0uleN2eIDCUMifOIpwFquE5944hKihFoBCFn4a
	5MA46tuaNeV+C/w9PlM9d5SAFkW0W/wLW65COvQgSAOZLJpGYQ3L+ZyymC8Mjtr9g+OjUiZ0pxsKj
	O4PIKdzM7qFBALcNW25J34RBQcgXlm0/F0It/WNSbihhgaquTi+tLu1GunT95CzY3maKDkgAifVZg
	LY2OyFCHmJW36DsXuvtkzOumQFBBneg5pLOgORf+iCGfU0Q6vqTgiLjA+nRgYUytZdG19cZ/QLFVq
	pJb3nh/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rp9zK-00000005Yxq-197h;
	Tue, 26 Mar 2024 16:49:26 +0000
Date: Tue, 26 Mar 2024 09:49:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 089/110] libxfs: add xfile support
Message-ID: <ZgL8lq4M7Q7oNJwS@infradead.org>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
 <171142132661.2215168.16277962138780069112.stgit@frogsfrogsfrogs>
 <ZgJdSnLbTlY4ZW8s@infradead.org>
 <20240326164736.GK6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326164736.GK6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 09:47:36AM -0700, Darrick J. Wong wrote:
> There's not much reason.  Now that memfd_create has existed for a decade
> and the other flags for even longer, I'll drop all these configure
> checks.

The only really new and at the same time important/new one is
MFD_NOEXEC_SEAL.  That's why I'd love to just defined it if it isn't
defined so that any recent kernel (including disto backports) gets
the flag and we avoid having executable memory as much as possible.
