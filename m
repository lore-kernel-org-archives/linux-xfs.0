Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40D032F747
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794451; cv=none; b=U1acuPIdHR6IyIvI342vOSziYpp5IlCscJ9/JLLrz+hd9twCA8LsgcSxRE3ZW/9IgMrLJbD2Z6TvBURS6cErPJ4y0q+vd/tCygD2c/ce1Thjbr9IbOysx90YVLkcXOJDY4bOkEunjN7wYfzMlwM3zgwsmlfDpWKDBWrpY6PylgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794451; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfCFT7x2N+mlJqxw9XzQ2WbqW/b0Pz6tuHLUb+kDxeTQ2ARx9YnwVcL/qBoLCq7e7oqMpoAdcrzqNOxtjzj9O3VW6OTgvaqFaJHpHpL/3u9VK8nSN63SmjxXL3hxRfaQ2I7Q0pHVvJh0D+9AvQZWKBfD2hDofMRXWvJ7pw3pWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 435E068AA6; Tue,  2 Sep 2025 08:27:26 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:27:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: compute file mapping reap limits dynamically
Message-ID: <20250902062725.GF12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126584.761138.3241277838690114723.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126584.761138.3241277838690114723.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

