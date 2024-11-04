Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D116EB76
	for <linux-xfs@vger.kernel.org>; Mon,  4 Nov 2024 04:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694403; cv=none; b=TGmqqpSoAOxwGW7ZMFNf+InzOpjo+AfjPf2w6cDA5ejbC8ZQpv+y3rvrfOBx1o3dKlIk5xgKi2pdkXKaaKA9Rn1uzL7DHQS2+vtzTMu+HwK/CXwjAGJAiNxbKvRQFNuF8/wFFId/qDlI0pvssZc0N5WQM8EDAgNolfFKIIg4HZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694403; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghyUEJw4g/a0nvrJcOwqw75E1uyHoImxNZN3V2SpAZxzu1vPyg1NF6TB+NrdP73FXRCU1fnpgfq2dBztdNT6/2gO9efZbs3iSrzpA66J9Mpr6slqFKf1UEj3vc0dLecK5+5WB6xVQmf07DoyCkFg13giw5usrQjuGiS0PgRqrGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4BD1868AFE; Mon,  4 Nov 2024 05:26:30 +0100 (CET)
Date: Mon, 4 Nov 2024 05:26:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: convert struct typedefs in xfs_ondisk.h
Message-ID: <20241104042629.GA17773@lst.de>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs> <173049942768.1909552.16910486013106825236.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173049942768.1909552.16910486013106825236.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

