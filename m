Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9555417B500
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074096; cv=none; b=SQqN9g9Qvi+Tlv86+ZSoBuZuMZlhRoz1yAam98ST6PTExei3rLuUxB1OyRDLP6eXdkV+Qtie20XE6dkk7TRRz/oSVDxE5f0+R1MMt6qf98ziPboAc37bERpfHTwJlgm7ZtrF29pJz0T6iDDAw6k27iapVtdh6Bkx5IruJtYkuc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074096; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnvnfMaxTisxZ+Ax+NVyvCkvCS7mifjRHRlaVjI27Syg35TqXiORu/gI2ROqRtc9H+ZWBf9UkSl0MP12eot1AGxnUQdF9afRQb856lQZ8HiHKROWa3Op9ZHy9OcfGBqhU1r1ov2tKSxijTxtW/i0hhe7KuKo6jJhv44I9lEs4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qIPKMOTu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIPKMOTu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qIPKMOTugQlVQ0Gg86FbHIe5d3
	7E+nN/N29VaACkTL7xF/cUWIoDfVvkn3x2X13RtyAEleIUn2LAu2cuo4HGSobhBZbnIZCYudxpSlc
	SNtftx+iaFq9jwgTj4jwrrWoIVFgUfHjusiocMgxmgvdWM0+2JuopSxltsDzozKnqig/DdB8OxOXe
	+sAZYb67OXHrqGNHg8Xqn9xyU/sirTMzgXxLrDS9G/oM31YG6nCkOEBRRpvVQnBJueNZTZJd6tIa9
	73vBWR0VLwWx7D93sNO2YW6y4rWOIaqA8NgFItPXCqtO8HmeHdiaRfHpj/CWGmyaUoA5IPfGI9KeX
	3Fk2y2mA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzt1-00000002wS3-0Wb3;
	Fri, 13 Dec 2024 07:14:55 +0000
Date: Thu, 12 Dec 2024 23:14:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/37] xfs: allow queued realtime intents to drain before
 scrubbing
Message-ID: <Z1ve73AW04ri7y4r@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123657.1181370.9809445949360319107.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123657.1181370.9809445949360319107.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

