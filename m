Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C6D3CFF44;
	Fri, 25 Sep 2026 05:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314441; cv=none; b=VyB/QcM5GoerIdkLifUyjkL3C7flhvZOYsJwxt1DNBY8hg54mby6B2S/pkJ1bD9WWHCK8JI+RLZs/BsHKhgM0O6UrX8ETUX9qD2iMSA0O6IJMNDtU2FHsLX9zEN0cv0zmvxUyTY61yoc02gNudAiKDldh3w/QTmC8V6Tsj50Nls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314441; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDkqMl/sGhYVodhlMq/XEAj+UaYHHYWnMICM4KSGNpgAzxdsax4qak9gaoh6D8IkPbveAPqcL7pZGfSZtbfAIINcNN7b3NgUMjfFW7kXuZqJEeUog0qhW6JkbnrFiqCwucEfVAOqPOb8tbD/R1CzfyDGmP4GockuA01jp3fHUFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qjvyxjox; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qjvyxjox"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QjvyxjoxRrzPQBF9I9cFQbAzkd
	3KQU8Y/h2Jw1mnGwqZ3JAcMXx7w0G5rUerfTt5/S2UZxYezlCPRBoACHTL19u/swCwoa/7UpWTZmC
	LcqBd743Ls4I+WganK3g2VCC0sIsAFf4Fhaw+WmzeFXAF0LPOX5hpr4lovHLTgvHKF9bbIt55Q/b+
	W4jciEOfDnEbj/z8VEQZr38Z24cde96SdjWMgBqEjLmoFSilZJaGWCGT8rMQtjegwdXFNX2ud3AWv
	vVRgpiPHcDYdIJsN+B0pkilYeouazDbJoU/5TNXxCbqw4flHMVQWXz7R+HbJXdNyq9ZQWc6vr+WPB
	LnjmKfNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yZL-0000000ChY6-17bh;
	Fri, 25 Sep 2026 05:33:59 +0000
Date: Thu, 24 Sep 2026 22:33:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: actually check XFS_DIFLAG2_METADATA for
 metadata btree data forks
Message-ID: <arYHx7bbWdK0_GqI@infradead.org>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
 <179030932092.3344850.8040519896432393992.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179030932092.3344850.8040519896432393992.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

