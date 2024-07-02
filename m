Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB912A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897405; cv=none; b=BENYjERFowqliWXSnbYR6MIj1hTPDytSBRoQciYJCZn++dPWMvVkthHe3GXYnlqiFIRSF3A4R1+vOw00gFNIS/sB8ZE3M01ypeLTJ5Te6toRMahPVUCh4OuclAJ5tl/+cvLs8yrOjGOz24iD2WQWyDVwuAEYUfg7QePc3UpHuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897405; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5MkOKHmCzgv6ETLIwAPuWsa5mNdJoQth0Tulse0rR0ueFvhcBvhsOpgXhJnYjIvEZtqzqc+Stw3Vw4CQuP1NZncCY/4W9ezs4EMuPYDnO+YvSKUaxazk9dLp1xNEHQlTSx9fYdnG41JV+x3Qsz+XXfNJhHyDC4sNWJc5r38q74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A70A68B05; Tue,  2 Jul 2024 07:16:41 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:16:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs_{db,repair}: add an explicit owner field to
 xfs_da_args
Message-ID: <20240702051640.GA22536@lst.de>
References: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs> <171988117239.2006964.2035449041267157890.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117239.2006964.2035449041267157890.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

