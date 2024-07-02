Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747CD2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897943; cv=none; b=AiCDOp+pOYC0HsIQVvBHHuZAJLF8uAHphJr4siYbIYwbM5+j6MtDjXetBH5r237a40pAVT4D8Q56AkjHirC4FnooG2whW/KHcggyT63lkcsXAR46OFoq5+Sav03ApsrluNe9WrZpBTpVyshThFpuEL03JHgRCrofqyMyTKDpNnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897943; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARklb3wycSs9nw17Hl84XZOG0pjc2+RyOtSnMaBanj9oh2Q3Cwyb7DGG8BoifWQQ83i3YFhI1HouNRyf7/vseJSKUzYLwKrgzbeJAnrRe+vLqRP+Xs5XdS+B4jwZw1GPSL/aM8r1r9Tgc0FYhPW2BqofCn65JdH/cy62BkA7UCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9ACD168B05; Tue,  2 Jul 2024 07:25:39 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:25:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 13/13] xfs_scrub: dump unicode points
Message-ID: <20240702052539.GP22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117809.2007123.1252324748291441519.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117809.2007123.1252324748291441519.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
