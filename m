Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12552238C2A;
	Thu, 10 Sep 2026 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016517; cv=none; b=lbHv85wdvivRCesnHddFV3hJ+/1p/fqcqABNuk5zoGi8sV1Q58WaiYagJ1qYV+WYlmJX38O1UZxzNQYX13KYp+5+/OsdSRiZzqh3C4wUC8HuIxUukDYh/qdIwkC7BkF0h+Gg1Nd1HSyoMtWrCS6HKCl0j5n9jBC3PhnNs6/QAoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016517; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kN7KRygU6Jm+BWF58BcjGNQZ9sLSNC9gTjiv6pWJw/EqSISbBDMRoGc7M538P0PB1En539k69dEfnUAImMX1DtJuXR+Bs24HJUPW6abVMUKUuoPozvA8qwRILCm+wNUEIlYVf3RP57EnMebGkQxKnWlbXPibVF4drfd40eKSMT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 988A968BFE; Thu, 10 Sep 2026 07:01:52 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:01:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: fix replaying dirent removals into the
 temporary directory
Message-ID: <20260910050152.GE26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936728.4057962.9945119784451295166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936728.4057962.9945119784451295166.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

