Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C9C139D13;
	Sat, 26 Oct 2024 07:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729927777; cv=none; b=DgXfH7S6QL39Ib0t4thcei7oa3LlDn8YIQ0aGn4Z7prCtBgxdGs33gpduiPu5ze8x+utkoOVB+8t+QRF9eB5k4W7UPz2VhgCrsWtQaxxf5OAyLwWczVkk5nPi6FyjH5cUwaG28MvN2L5tktmVwJIvomV6u5Q6POsK1Lkx7zxhYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729927777; c=relaxed/simple;
	bh=8aV9nvSf8A22DAzQwLvjT8yhxGilGWC1zZAHEMLKTjc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Uy278Ekz4duCQq4VRbX2ZZVYLScRDGkouZOhS9Xo6zsaOTLQZd02673Re/FRo9ofEOpWFosY8bHr+8jbJEzbGNnX5pJepJ7zoARgov+ksqdCNvv6lT1WjHdL7sv+osVtG/yG9BKrO9sNgSeiLfzAPwt3dWhSuSGT5Eez6RusXsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGjs+Mti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGjs+Mti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FFEC4CEC6;
	Sat, 26 Oct 2024 07:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729927776;
	bh=8aV9nvSf8A22DAzQwLvjT8yhxGilGWC1zZAHEMLKTjc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=DGjs+MtiojD6Uo12MHITspWs+gBDzRIHMG5IKRB0HcIWPIOzrx/9EWR9MZ0rYcCdn
	 vueNFASnOOF1p1y1GsTTdf7faEEtBZW7h2AdhAlAQMEIXgL92rjyXTG+AqyI7eaEjv
	 yKpP1QNnTr2N5hoKZARtPD/X0bBn0bEdD2af7okNmnvCp4G5QLA1U+mjfHXMEq5EjC
	 660bWca2yCvUywmxb03LwNvMFkSNfMdTW/5DK5OQJEDygq8P1GFQWZFyR/ZwXzrOKp
	 ySecOhwbYF4O8/pgc1K/+oLm2K1BDm5STgcPg2GnU36ZmNcdeheAe0U3bLvCOpGFtU
	 8+UUbMSKR51wg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
In-Reply-To: <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
Subject: Re: [PATCH 20/29] xfs: don't fail repairs on metadata files with
 no attr fork
Message-Id: <172992777477.265510.1247208054862675396.b4-ty@kernel.org>
Date: Sat, 26 Oct 2024 09:29:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 17 Oct 2024 11:58:10 -0700, Darrick J. Wong wrote:
> Fix a minor bug where we fail repairs on metadata files that do not have
> attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.
> 
> 

Applied to for-next, thanks!

[20/29] xfs: don't fail repairs on metadata files with no attr fork
        commit: af8512c5277d17aae09be5305daa9118d2fa8881

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

