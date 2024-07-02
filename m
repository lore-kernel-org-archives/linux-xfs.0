Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DDA2B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898747; cv=none; b=pjC3Fy0PkzEbHqWQlfapDR2NIqVobn2iZ8FmAWTEjdufSivMivV2q25NS9ULpipr5DOGTAQLnXRHTeC0gaD23LjQP3T9I/M1mEauSk1+nAbBaQL5EruLeRBePBSIluPWDOHFbrS4dABdCwfwFjynUIP22DHjeT5TYVSKnPekqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898747; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNSNZ2OMfZRNLN0qBvNndiqvW/5yuCjQCsTzjne5HoP6u9XmjqtEkmf9ppUM/QxWIka/1E+5Y3ehwBk/GZy5qC53QUuUC27WSJbN5PI0rO+GQT0t6sJBz0uIiIcRwlhJSZ8vRDB9kDuc9spovyV/zLmRvvthv0emTMRXGVymGPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E65B868B05; Tue,  2 Jul 2024 07:39:02 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:39:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/6] xfs_scrub_all: support metadata+media scans of all
 filesystems
Message-ID: <20240702053902.GF23155@lst.de>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs> <171988119454.2008463.33463397057054094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119454.2008463.33463397057054094.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

