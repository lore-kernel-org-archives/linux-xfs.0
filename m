Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E23168D0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712775194; cv=none; b=WsjCAj4QkGSoJIAVUU7XlpffbOHkIM9lUDw6pxx7PvnV877Y4BZwisxxskUhKCfai0S0h1GADxVZi/CkuBMKtRt9xOLpypkkihjE4ViHSfCF3KH5XyulD607UdcQNpgvMNOjQDsJszctpz+TdPSq/L4+EDh4//qO/KOqdMxasoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712775194; c=relaxed/simple;
	bh=3N95UymSLbVY4hN/BQXAJ3MiRjMuQNEkt/Xx5dp3ELU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFEDHEQnyuhnxKQE+ObTSUPmV+yTg6EPzI8EZgLC/BQ3ohVTXT1VSmagO/U7EUvDyjzJhBG6F0fFflWX2hBJK9RdUkRN85f/7TWbES6kBFEcsCmKDH3YzOKaIFvthZJn7wzfy4Nq5d7lFybbyKPzZP+X9sPXUNOeW12jnWaI6UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLNcu7Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLNcu7Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7648CC433C7;
	Wed, 10 Apr 2024 18:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712775193;
	bh=3N95UymSLbVY4hN/BQXAJ3MiRjMuQNEkt/Xx5dp3ELU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLNcu7Mr8F2gY1K0c7NYC47RMtkokT55dJToaNXtGn/nf/qfVZfDFblij1nfcZEHZ
	 bnhuO5oS0nuSUFuEdHV22F3FTSUdziWxt27NXHXMSqboFalpKEj+XUPqptSXKLuyS/
	 IeRwUe+zLkTJu/fFab38VBU/qr2MN+REYOyLyTNuzq75vZ9IVe6zrSzpaI/vKoUscT
	 DYN2giSPTUiwiJDgMKs7mRnvmPWR8c+9GJex7neLNyV7jmNJuyfDwA6EJdTY7CCjnT
	 lSvL17KAySYd6w52hMvjppU+4JXPiaLM10gZZatFUR+WVT7ONWJUbHKPnaUcg9bLcz
	 B1NRix41PHWPw==
Date: Wed, 10 Apr 2024 11:53:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/32] xfs: add parent pointer validator functions
Message-ID: <20240410185312.GY6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969790.3631889.2339349798519269452.stgit@frogsfrogsfrogs>
 <ZhYkHh2TUmhPPdaw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYkHh2TUmhPPdaw@infradead.org>

On Tue, Apr 09, 2024 at 10:31:10PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:57:09PM -0700, Darrick J. Wong wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Attribute names of parent pointers are not strings.
> 
> They are now.  The rest of the commit log also doesn't match the code
> anymore.  The code itself looks good, though.

How about this, then:

    xfs: add parent pointer validator functions

    The attr name of a parent pointer is a string, and the attr value of a
    parent pointer is (more or less) a file handle.  So we need to modify
    attr_namecheck to verify the parent pointer name, and add a
    xfs_parent_valuecheck function to sanitize the handle.  At the same
    time, we need to validate attr values during log recovery if the xattr
    is really a parent pointer.

    Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    [djwong: move functions to xfs_parent.c, adjust for new disk format]
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>

--D
