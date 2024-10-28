Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F015EFA1
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104525; cv=none; b=l9wwlhrTeAozRnfi1UqoFRIe2qB+srPqYl1DuvgYBxayN7msJw/ECav1+Hh/34EcTRfg4+cN8x7L8j+P0YEc//amVfomtSE1Yo2f31tUkEJKV4WC+fPB7BfeWf40aZ6gJilZtLjnoS1fdPOSpz8vZHp4M0lTiBdIbqsH+RTTT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104525; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyzjdJxpgXTs4kBFK2rigx12SzBypnvQsQYXh+tfFWW+sqBeSdYdKL9HdJrJRSNkuIe6z3R+2mxQ4Zwf4ZzrtpPHRP4aFp3Yklw45TV5b+04Nw5FAVJYdGpJq2A2scBR0vhhtD7Vt3B3/aTSCutajsU2K7u9j6psk/Gd4tbrFGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DJkb/vSM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DJkb/vSM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DJkb/vSMxTDzn9Q9FtgKYbByjJ
	7ogGVFG9eogh9ogA5Jo1EUCUE1Ejt7KVb9bHu/hQ1MJ4HCsoexrzYN3AZFTQTDohz0nCZxGS+VKHP
	U6d1OrYUvcxoQXnjPJhFJkaMfTmgXcxvhcCv8ggnIy45gRWwymQ/0O9mmufajHVZTygB2NWGAvAKq
	lS5+zB1utUTU+YvsRE/ocP5HOHRMcNVD+zmBhA0IFUTQMCBiVs8YPH22oFsXZNWZOF6Cul8NAr8wR
	SUxMCrkvOk3KX1vr/TNgRTQIOvFNXPMXFgXmgoKqrA39XER//Tcis2+ObPZ1F0OcuQvkexuAY5S8p
	fhb1flBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LDf-0000000A765-3Mvu;
	Mon, 28 Oct 2024 08:35:23 +0000
Date: Mon, 28 Oct 2024 01:35:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs_db: make the daddr command target the realtime
 device
Message-ID: <Zx9MyzMyhbEVuyqe@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773774.3041229.16383532207517050768.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773774.3041229.16383532207517050768.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

