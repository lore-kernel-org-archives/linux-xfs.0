Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67431642B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243193; cv=none; b=DahKSPXdJg/7IL4T3syUsAbDuRPXtigst6sDbaFNN6QBpQU/4mSZ1EWdz7iAP2MApAM14U2obMmL5MyAu0wiMgbaKe5FKYWV/aAXP/SfzxGSeaBwapGNF2FCkKj/Vx+qkVGnSgYpyspEz4Ow4v6YqfHt6lias2jm080CpaVIw1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243193; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmGTOZkxPV9xv9PVoM1OCN5QjJToqXvrQ0hYReO4k0hvayI8cxMM6cnI7JZyxFdVuibjl71CqjrBveI8Pkf0Fn8W1dTYibVuuyWNyukTxRS3npyJ8mi3MjmsuFlNbBqrubIts0ibl65NbKC2R97VsnnZsZkpVP4APCQ5ZXFASgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D5R2H4g/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D5R2H4g/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D5R2H4g/5kMDNrIBLj6IR/s5mO
	9BSwVYYft2/nEs5wndxuVt14PTLbRoc2tCCEsYAjN4nkRsQCKKaGGanKnBUiMNiVNK1y0lPmOrZlo
	I0x48IuX+98Zwi1euUujhfQ4WW038edTIYXHQ2lPskr8odj9jOsrNojMgBS9BTXk5po6+O/DkFl7e
	bkOaE5djDMVT5uD34IA4M8u91mPRmPGFSYlVVQHpSdiTPzM3R75lQLy1UbO279hp2qCPNjUsYLKBe
	KG59nkSBtZm+cDBXPqJc+gEutn3bHlEqAbesLAWSlnLlWtfjqmct3hFgjpQ7kqb/0fAvf+hUGeWoM
	DNLwRcjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwaog-0000000Arm0-1NtO;
	Tue, 16 Apr 2024 04:53:10 +0000
Date: Mon, 15 Apr 2024 21:53:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 2/5] xfs_db: improve number extraction in getbitval
Message-ID: <Zh4ENi0qN3xz4Q8p@infradead.org>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
 <171322881835.210882.6715743182101731750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322881835.210882.6715743182101731750.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

