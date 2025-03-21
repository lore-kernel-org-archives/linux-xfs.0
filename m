Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5433F6
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 05:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742536716; cv=none; b=uG1B84vzHszSSo06LZO66igfNfvf3I8JbfoFEFu8ydg5bvYnad6i9H73a7FEjx1oBAX9qy+paxnlh4/HWi7bTuLq0Hqru5Da9NxOHCXum9x2K++c/ucUTXMH2l5AmUSO3pIP9j+HSbHuFRCkFIJDgsdT5QpH1PLSR+8kdcfTU7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742536716; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3zPoxMrHJE1bWeCcfntW18YoEvToUvhwrh9Zk937vRfTwc0Bqzm3VDRbhzYhYHPt8Xk0NNXjF5HqAMa3bl0tveCwvWyS3YHnAQVKe8Le0dUJPpf44Pso3wWXgdoBQPE5+Kzaj6bkJMYHcSgnpI0YBX66IGjlkYxy2AtA8VAqQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0AE1268AA6; Fri, 21 Mar 2025 06:58:31 +0100 (CET)
Date: Fri, 21 Mar 2025 06:58:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] design: document changes for the realtime refcount
 btree
Message-ID: <20250321055830.GB2893@lst.de>
References: <20250320162836.GV89034@frogsfrogsfrogs> <20250320163600.GD2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320163600.GD2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

