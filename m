Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C445D1BD;
	Thu, 15 Oct 2026 06:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044731; cv=none; b=UbvWADtwtaLHlB5LxeBf37ipWtSLizXnyENSGB1V1/hvmnZGbHFLT690P1J2igGKDW3pHGQcYd0rx8RHN4lKg+6CcF6ixEzwfelRXWiIGOupXuCvkNhZqf/zZDKqoTcCnEVwFuo95uJVcyuQPWCCFmn2dEu8JzP22wU9gVIq1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044731; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulsLuG8mTEfQyi0sFXqB/XXVfs+zR4Q9wIPl18glj3P5J2ZsXUHEEbyLoNr3iHD5ibik4OBlE7+jI1nLErs/rOUbrj0gVeyM8zcw/whVOWN9Md9FK+ymkdsZHhohUiCkJ0GoWzATFl34xjAAVchy6kSoDj3luZZZ+tp8YkXReug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFCF468B05; Thu, 15 Oct 2026 08:12:00 +0200 (CEST)
Date: Thu, 15 Oct 2026 08:12:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] xfs: make pNFS LAYOUTCOMMIT stable the way
 fdatasync does
Message-ID: <20261015061200.GG14035@lst.de>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com> <20261015-xfs-pnfs-batch-v3-9-54fc7b2e467d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-xfs-pnfs-batch-v3-9-54fc7b2e467d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

