Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A6B2AE95;
	Wed, 19 Feb 2025 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949157; cv=none; b=hp1W4Ya+2/j08XqzMp6utkMDGwFDiV/iTv6aUndeSNTIcqYXGZKeYeU9S+R7gbzzXdcqdMznqsfzUD6jJh2SiAg0ZIVWFVMzC/bCsYxLKfDkO6k7qvp7a9zDxxMtdRJzP1dPLkUXHfzHRhmL+TmcwID4BM9uGeqPT5AeAhH+1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949157; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezqviAqQth6YrhzSB/Bgx0jH0VGw8R6wW4UzhmV0ST1DWiq7wd4rILx4/tIjJjgsDhM3GK4UtAy8d9DuBkOnjz68XwVBrIgoePAFda4TDMW+Cg+ywxIVbwgOQQ5apnSkI/AkXe6c/uSZMJtNWTncqjLuSt7M5gwPJidymFrdq1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ocoBQVu/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ocoBQVu/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ocoBQVu//UThRbqtZTQ3LpAIU8
	JVb3d+27cyByQkfKsWc6ZKaEosAd+I+0SS7uVHmpoOzWG31jDhiSC6AcqhzmAeFW4lp60IvP/ODwt
	vcwPjyzbKPc2h0QA2v8tC5dPLcWkKr+9JRr3BYanAP9gGsT50EuJinb+j+fdQM0cwWko8Sv7xWPPM
	pFJ/yCABdzQSefggdyzZmklOc6G0j6KGf2ZL2pu56Yr+ZE4Spic1GrVFUi2txWAOWzguMdhFBAf34
	ZA/wBYIu74MgrvJOTmE16ccg8gjPP6tGw/i3D0ph4ln25pocX8MEK5wl6R4Q8wCgAYiSDbMDrFrlP
	UCquBMPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeG2-0000000BAwq-2pma;
	Wed, 19 Feb 2025 07:12:34 +0000
Date: Tue, 18 Feb 2025 23:12:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/15] common/populate: refactor caching of metadumps to
 a helper
Message-ID: <Z7WEYiU0Tlss44Cy@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589198.4079457.6813508569185087856.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589198.4079457.6813508569185087856.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

