Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027CF7E9
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 05:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732597868; cv=none; b=s261QQT7wFiVnR57uHQrmRwnr5SslpwdTUZ31sef06UWKZznDOzq6OyLRoj6C6fFUVrLQwhg8Z0NueL4hgSyAEsZfkLLPIAWODZo3aYflOnExAebQVfQjingcrwd3uTpPlneqER4z48QS4pIbBslUIvAfb2Sbdi8spUBoVQgSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732597868; c=relaxed/simple;
	bh=FFILvThLWeMKs5hPnth9oznYcsWHjt5MxxAcAS51HoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ps5sPYSNpOIdyslQoS5ji7Px2bC94DzFJfI/Rf7YqXxkaLXxjcpdnNJvfk1r534sPCLzx5cxpochzne2XsNvq3yTq38znbActzI9di4xFGKDiXHFUvG1VE0OLhf1acOSSADO3INQ4V0JPCxYuQfzImkPlQY41By6cZ4KPbL8N9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zask9SXK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zask9SXK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AuFYt6RFUBgLFDmjikvr8ApNNEwamwMLLEakapd/qhU=; b=zask9SXKPC91tHoZjWAkTMO6xL
	hNE7i6T9SkV9oK6qg8atF+Xhw8WEE8/3i/70ycR3kKNTtGaBu9cJ9iSCARyoi6iizc7XSoXHTkYA1
	dyzR+e2rVRpCMldAqGL39uWClm94TcvgcW7+uFLwTv9X5ggG6OEo8IPlV1h5M9/iD4/lrUY/ZlXzO
	/sQQj8Se637Xyd//7iN4RHhmvI7JfaLLjxXdYIvfT3O5nzagguxv/uPuqbnPZrujYXsh6jfH+qoLl
	nt1Ya2m6hf5RPgWpwkJv1QC8FH4dPHl7tndXrwnVMPJEpU9vxZSacB4LVqYRLKzUacnTa7a2I5EID
	1WRygEhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnqs-00000009egP-2COg;
	Tue, 26 Nov 2024 05:11:06 +0000
Date: Mon, 25 Nov 2024 21:11:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
Message-ID: <Z0VYar-LmcdXptXh@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:28:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
> __xfs_trans_commit again on the same transaction.  In other words,
> there's function recursion that has caused minor amounts of confusion in
> the past.  There's no reason to keep this around, since there's only one
> place where we actually want the xfs_defer_finish_noroll, and that is in
> the top level xfs_trans_commit call.

Hmm, I don't think the current version is a recursion, because the
is keyed off the regrant argument.  That being said the new version is
a lot cleaner, but maybe adjust the commit log and drop the fixes tag?

