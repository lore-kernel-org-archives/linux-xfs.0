Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3373820304
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730159; cv=none; b=FlKbLUJxRTS4GRezGvELFwT5Q6JQ7N9CKzfgjVNMGawFsI9DtdcaadEPt4+7B51zJufFJlWzw+NS6jkg+SLLvcFhqJDL0zWHpOdqhWEiQXv6L5zMPEBBoItApd15KBx35+JpEmJBPcbb3eSYuirfugAgXFk9ouv/J5o9an6F7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730159; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bINBGzVzNDMNfCryd1p633E5BLEiOA1uJ5RCjUCcTVA8ADu5S8teykgSUfpGjHlW0LJ1TVIq9nnMOlwqZz385OVtmYKphTHxKVOS7XDuuO54rCqkeEYajfwKlsKXBszIVu2Dt7B1pGM2HV312A6AGKiXVbiQwNH7yAsapZ0Ywrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Ud4kw5r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Ud4kw5r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1Ud4kw5ruMzhfY8okYg2dM9WjV
	Fu3jdtlAjWPtuyva6b7MWrAsIMnZ1gwRj660rN126fxx+Ll0wXYxYmRv9umsUBh/39N3ZPyN41JaM
	Fzpnu+fpdkiE/x4n6BpVaKlQ0uaWoH7UhuTnt9vD9gIm7B24cK0T0xvYT6Lu43blyqUfK10cssQqm
	hJb2Hq1FJhVMoDOoeitkiJE3H6Nna5WpKoFI2VAzXTNiM/7YLoUUM4qAElTGc4d/FdtIHw4jxSAF/
	gtzoGDzrGfcBf/sNzlZvS+CiP057N7cSvdkO+E+c45oK4TdGDRihOKuTrNJobQov8uRjbSR8xj2JZ
	2VIdqT8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRLx-00000005Mob-3AXn;
	Wed, 10 Apr 2024 06:22:37 +0000
Date: Tue, 9 Apr 2024 23:22:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: actually rebuild the parent pointer xattrs
Message-ID: <ZhYwLZTTACQikbmk@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971170.3632937.9669548372844049712.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971170.3632937.9669548372844049712.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

