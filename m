Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB5443B6D1
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444565; cv=none; b=DfQ0V4Q2i/7r9UxU/e0Nm+TVybmDIwSFc5JoHG5t7gp8ON7vUOu/ykUPtmbaF6oIW4QsudFFb7wovRLJz0EhnpW91u3kDpRcviw2u/g6S7NzpEWWALLAFkEr5/9DzLWs0Gk+F+/28Etgv7BroDRXc4K4pHhTvCqG5kRnJKXcjlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444565; c=relaxed/simple;
	bh=ZzDyuhV7qD+8faG3p8t+lSXH9asxOD7QJV8qER63EtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZSaR3GKNI3xDBCsQQVzw2NmExQouioPNSHYss8DxPRaigm1D63G6GrJAVDoZuNbT+GNzqrpRWue1ENKyltPhkUr1KLlAKIuBnhzYKPPlA+xEXubWDI5E4GXaq4/f6c8N2F6zqTowcB8kfKLCTkZ89f2LjFXQxEreG5vKN2AZnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7J4SeQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7J4SeQX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C56901F000E9;
	Tue,  7 Jul 2026 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783444563;
	bh=+9KBn9iZ+wQ+u+9QqIe1jeckOjEzFGFnVE2pak/g768=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7J4SeQXseQP2eG3Nqo37iaaHQS9icNUYy60O/YjIkECBYbIadJQKmOV55gupew8E
	 DVkKzR9MdcU6XGQX7W/bKHXjY9aVJihgk9Fx6lkIt2ZE9zRwS9eMvQLscCeYj0peMC
	 wKvGNo9B1MrCStRdnDzIT515icxnVWaN2RJdKbTuTNN8yuuGHOYCQSrD2JjLX6RqWg
	 tRduqtvbuLLgQfhozRanfM7yrKum28KZa1P+E6RP1RoVsWcDC6bymP7ipMb1jnDgbY
	 JN9pH5df1rHztbfXwGU+OaJDPixKZHpN/YPL7PjtEeo3r7Wp7/LbSOwcDMDMr4aULF
	 oVbIDSCiBw2VA==
Date: Tue, 7 Jul 2026 10:16:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-ID: <20260707171603.GG9407@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
 <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>
 <aktQ6V7zbZ1MK7zd@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aktQ6V7zbZ1MK7zd@infradead.org>

On Sun, Jul 05, 2026 at 11:53:29PM -0700, Christoph Hellwig wrote:
> With this, the old user space  version in xfs_trans.h can go away.

Will fix, thanks.

--D
