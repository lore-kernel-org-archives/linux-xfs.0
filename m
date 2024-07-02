Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B22D02E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897364; cv=none; b=kWUFKkfQtHIFrIzNn8afROuWUmBNGPhBw5Aa2AMG5YGBkKM335BJkAhuun2pp9EapnouzX2MHI2qy/ymotlqMlfTsOiQQZCx43yCSIhgLBlS5SDGX0rmHDlLLOppILNDqGa2lLsq7g98rKCUFsISYC3DKuvasRaR1o9pPglo1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897364; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLv4mbqZ6xf7bGE5A3u90CvRWoIPrfPd/wrojyo7t5QHocRzRmMyscN9YBbCULW1+w0bSs8L1xbjNYSx3JwNdJfXxuczrUOb3Es5pa0jmXtwGwNiqdyAnPEeSkkxfI66RaFEuKHqV96aJupX5sZlNejTS3xt1GBVYb6fpKz3KEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C4F9F68B05; Tue,  2 Jul 2024 07:15:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:15:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/12] xfs_repair: add exchange-range to file systems
Message-ID: <20240702051559.GK22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116878.2006519.18408749679790867720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116878.2006519.18408749679790867720.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

