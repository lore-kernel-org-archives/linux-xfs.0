Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59A26ED45;
	Fri, 12 Jun 2026 08:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251931; cv=none; b=El4r7vL5OSUWMGM4j0opsnCgY4yFTQqlRrA2Hwm+HIUxV4W+Idc6t3vAAcExO/Tl/jFf0pGD9tjqDfIQmKSd8ZXwL8gNL7RUqMISmGsTV2IkxIRv8FoXJQcc/tK+9y1QadCIMS7zbrSw5UR/W4w6Wpri1IYoLPBz9lTxwwwcOzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251931; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/kOA9x269LY+l+QsHg/VnKWiFFJirA1tJIDkfq+qwr7IE4XQhCvys4ki1McZJsxbPP2XaPl+Tc5YJkXXDSbSvVsPAL+7PsqNo8v501KRt8qD5+06rSVrzfqsOzBDCKk/X8SlxJsI/A2oVLLmKMAupkfkv3PsVH8vAoifj7N3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F082468BFE; Fri, 12 Jun 2026 10:12:06 +0200 (CEST)
Date: Fri, 12 Jun 2026 10:12:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] iomap: release pages on atomic dio size mismatch
Message-ID: <20260612081206.GA14414@lst.de>
References: <20260612044041.10677-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612044041.10677-1-changfengnan@bytedance.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

