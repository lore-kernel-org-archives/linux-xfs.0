Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E11891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553439; cv=none; b=FzSwUrwn2HmBaYIgWUkANKe95o5yWIc2GytA8k1jzi2Nen8C4/WWRPRvIUJGdRx+zftDnGGJLWQHpfT/nlSJV1tVNzAOzTzi8TK241NzGLQhH+EeX9GfdeEqD79LnMDBn6P/kd/D10vSIv5to4avGzZ1wooR5CEXoVSB50qufME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553439; c=relaxed/simple;
	bh=Wp+bFtbdmfNqm/OwKWIYgKuHgr46AeZulY19ryHXIDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ir1cWe3tZZmjnbvjhtopALiTtJJKPKDt8JmN6A82WluU39KykXOqIJqIMQ+z3ZPjEvyAfEDS/Px27ZKDmS74xcDv+24kXOtq9w4DfIVFK+fMW692WPNmiPdeLC1snstWEepDtrAzSEVSFtBt3JwEwQnHfMAIatKYNaTualZ8Icg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tcvNr2Kf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tcvNr2Kf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CcGkAXz2UlUCABLvID0/er/2n0iKtNdDTUFHJFjMrgA=; b=tcvNr2Kf5h3muKgEVEf40Aeblz
	RDCbjZ5b/cqm0Gq68UKxFKBHBg8uQwBJINbir6tpvUJ4rFMos1CUAK4w4/dyb+AXxDZ4CA64NcYFI
	h7h5qj0TBVcwaHVFY60+QaWEw/3iaC3ZN7Si/wW9rHnJ+f3Lelj5I2pKP5FF1ulB8VJJ6Y/rwQu8Q
	CiFfiNLuzTuHFc39x+4S7AAEkDqWLnL2danXDQlTIruPOMGBs7EiwmV4rxl/TINABJn8WUDWYAT6o
	v1iRk2nQGMWr3cQS6b60THGwh7G77bPnysOnh5cG5+MWtLgdShI07edNzVs2TaEn2QqKC2uPCYnko
	DqDChWXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS7a-0000000FUWm-0o0b;
	Tue, 03 Mar 2026 15:57:18 +0000
Date: Tue, 3 Mar 2026 07:57:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <aacE3gW9j6pKrspy@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


The idea of this is good, but is xfs_io really the right place for
it?  I'd expect scrub or healer to just output this somewhow.

