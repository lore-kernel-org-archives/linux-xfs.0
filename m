Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D57FD
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2025 05:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738127971; cv=none; b=ZuFCOVzgaT/lRhMOEAL8n8X5QBm/lHF0Kclo0Vthj0MWH4gu1hALZ1ZAn7sety71oSOHjyWv+o6IyIEhSlWFd2EnsP42x0L6Z67TPE3XdVuFQiI+e00jS/XO/7mULqE/kaIPdD6duOkQia6BlVj5/JELpP52DmC2iPjtdBRCpok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738127971; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgqssLmeRXxaa0dVhactwWjwPYJ9c8ltybxHK5XNovx4ZLCf1K/nqVx9e3GzS3L50Q2qFIAS8xKLwUVXD7eCqMQkz+1e5k5rEVn8DDfMhttcQ9JYPr6Dx4j8/r2U4IKtF1ALC5TeKHkbS2VsWJ3/BX2rG0UlPCG+mACP/6lD/2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14B4E68BEB; Wed, 29 Jan 2025 06:19:23 +0100 (CET)
Date: Wed, 29 Jan 2025 06:19:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: Re: [PATCH] xfs_repair: require zeroed quota/rt inodes in metadir
 superblocks
Message-ID: <20250129051922.GA28513@lst.de>
References: <20250129004826.GS1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129004826.GS1611770@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

