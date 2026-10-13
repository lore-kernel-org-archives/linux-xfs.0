Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1644E5348;
	Tue, 13 Oct 2026 11:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892141; cv=none; b=omaXxpkxcjbea+CeYRudxT7g55l3aWAFEFyxshqPS7jOk5JPGTur9fVej3blOI0gnHtw9kuDuq+a9AFHuxNV5v1p/MXij0oVY95HDwsWO9WuUwvdhpkvBm0IVjJL5j3tLIVSx54AmdFjeqaL4sj2q2/Vb5CLzi7r3riGrESBMJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892141; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J90MMLmah9OLrqRSZtGR6jsKYGi1tpDchXTVJlmE+N7SUvOmZfu3tKb/n1XRddX+7LLEwqI/nv8APhlYyAwOMHnVHt5kn3NF7uAk631wMPotZWqZWh2HYZ/ov7orQU1MBz2b0PerxEmwePJuHgSS+kFNDnybjvEuhY87Q5tsrdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d1GRlCNj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d1GRlCNj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=d1GRlCNjzow5Io8ol1CeRaWdHF
	FjcrDnHSpnvJYg6kUKas49xV5KSVHDMC1+gStYLwGbh67nr4axfHr8QljPVRejHCMNF7rO42FvFT5
	Blt3NYBU2U1NhNLsb9idT9JIUChn6zQvwwxQtVjfeai3UsPbWCRTE+hzPKJUKp7RKhsxVZ8pWU3tg
	FY9EUmnOXcJnsiTDWnFQ2cVvF0Zk3EH6KJ6pgYm9ovtzPwP5MJGq9TCdfgdQmaejyyYSdzSJhYiYX
	E5vmzcc/4Zg8qMD6v4l2zA9saLUstbPiK/DVTuYZFUnB3H3+kylY7AUxv73i0HhV/GCKn94FkMbqy
	96LIUHcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGb06-0000000CkHG-2vnN;
	Tue, 13 Oct 2026 11:48:58 +0000
Date: Tue, 13 Oct 2026 04:48:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: update quota flags on secondary supers when
 metadir enabled
Message-ID: <as4aqn0LIsx1-ndB@infradead.org>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
 <179186107949.1898896.7157266495683086793.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179186107949.1898896.7157266495683086793.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

