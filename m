Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AA168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807953; cv=none; b=ROkyWNKSM8Evn22OukgKXCwvQOy2wYCLrHyb2Rih1fPvLG6K/iC+tOLcNiZxwt3/9uzlmfc/wYyQyZsWVnfJzNYjbAiHd5ruizp8bkYmecXiMtbduoE9czzRv+6ohJK/R+J4uPGPmJPfuzb3x8dXKNPDEJqF5w5/9YKl1IIs9/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807953; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/dZ8I0Esixgj6d6avFPuIaNn2q84T0hqGq1uZilTuMNJOH7SDCJor5D/PTnf5VUcUIAdl0EwJY3YZi2juA93CWsnEaF7JJSgtgQ/LvJhkUTE+O4SSVSJ8EVhx5bdEl4hLYj8noBYxvPXvB55aADp9t/mn1+7qtqHXb7rdcbdlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OEK8Msrc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OEK8Msrc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OEK8MsrcFPLyIBH1zYaU9LLB6d
	aiGW06z41SG39zLM94p/YCDwDFZZY1gg9nMJGgwsdRow5jDpUXyazcUvkB8Ef/jHBIXJJqFRnwOeW
	hyK+nj+YzT/cZ6o5iQr956Z+pFAYsKsfxLJ0IqfaBhvhInpE+p3xrhk7v1qqBmeYvb4j8RpX1RAGr
	N2hWNgKxXbNBMSbH6TTXyGIheQKfp1zVpTFviNhni1M1ZVbuBDlYpqjb9KS8FnY6lFSRCJ1yRNaeQ
	MJmBiVuzFwOxkWxmASiLajNYVbhLDvAkKX8LdcmFUkBzn+i63PnrBP7d4p22kDpgcjppwVnaLp/UC
	1SLqm6ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKseN-0000000AGRD-3RlK;
	Tue, 10 Dec 2024 05:19:11 +0000
Date: Mon, 9 Dec 2024 21:19:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/41] xfs_repair: adjust keep_fsinos to handle metadata
 directories
Message-ID: <Z1fPT8URJb_91tzW@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748756.122992.15190773572152273320.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748756.122992.15190773572152273320.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

