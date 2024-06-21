Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F500EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944891; cv=none; b=dGnXhEyUhVjSmUT4rMhTcw5tXZYlT3FXAx4X3Gg9TGcDoTnVh+VZgRfepAyMEVdmotCE8d/+UDdy1d095/nkk3EdKS5TMmhHJFgd/QOYo4w4KNuT6KAZ4jOkszfFAUsRgvOgTX+elup+91KRWUo7jLsLbJ5h2fTd+/AU1WsU8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944891; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNnf81pFNjlJothIqLtKxE1NLt62j5hXfXOiTFKkNqZigMLN3s81y7swDdtQ4YRqwtFVTqBHUIAEWu4Ij0x/n8q79C59srh+pLCeqAqEQU4Ng2G8v+J0pryGc+55LidUdPJooIoz/CxGd+gchxfMoSa76Ctm4jYE/2/t497Pwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KEl4GErW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KEl4GErW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KEl4GErWx1TAOFBpWkpqgFXXQg
	uDJskBlDugS/p8EHS5gyHP5Fl4r2yJbG4j1g1wno/Th7Kv51Em05BA0Yg6871Gmymjv4nq58HQ/1V
	Nc6nSerwGgvbydnElK1qiDAxhQvBLeAJESBywG73rir2tgDEKKN18PNpIf8no/DVeUtu4i+dGKvLL
	l242o8wu0CGcZkvvmYd/xDhbD6Hqo/0ZnxYWWnnG+wu6ZBfdCI9NrbzyqCrtfnG6pi2GcPU/2DTty
	KYqadgKVpTOs7DW+GCH3oNDPB0avG5ZZ2UCc5P4HFNlG4eg51fGXjXpgOVL1UZtryo4hRyG7jgkHR
	pd6VfMNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW5a-00000007fgG-1DVC;
	Fri, 21 Jun 2024 04:41:30 +0000
Date: Thu, 20 Jun 2024 21:41:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/24] xfs: hoist xfs_iunlink to libxfs
Message-ID: <ZnUEeqD_yTLNv9wD@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418120.3183075.7790758345120309903.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418120.3183075.7790758345120309903.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
