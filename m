Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C9E63D
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 14:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723126061; cv=none; b=b9QyvS5jePwklLX5C7hZdhJ4JSztaGhp5H4nS3QhFNmWwH31Mj4SXtsHA0luscoJaeqzV/EPOzBi2jyDrTuXPeGzZuUa9qGv3GJNc+D1M0/wE6BhL4iTrlvbI0A7lUsxwqcOLiyFKfxbJlUIy8dDIW0Hh/69xOi66fhPmHgAPPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723126061; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbOsvdyzdabIv0Ps5fk5Wa5oUL+HpcLUORYRymKADRfIgxL5vYPn5zPFoGNvgElFTa15snLB/mqGZqThna4keMIMB2rEpCYnhUmy5CS3w9VOBaLbr2ynGrShhOiQvZB/PlaZlOHSivBZS+YW0ayE0tyeQcCfPCtGxyTL9xCHbME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8476868B05; Thu,  8 Aug 2024 16:07:34 +0200 (CEST)
Date: Thu, 8 Aug 2024 16:07:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] design: document atomic file mapping exchange log
 intent structures
Message-ID: <20240808140734.GA22326@lst.de>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs> <172305794103.969463.851368852347319574.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172305794103.969463.851368852347319574.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

