Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F93B9DA5;
	Mon, 29 Jun 2026 12:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736224; cv=none; b=UHtDCNw5c5AQ3pgl1XjG+1R5Phzwes/rATMypzjY0zno1IGW8Da5Y/pdxSmTnAj+FUoA2c7vghXLzmyN4nc0kzoukXBb7ueao/xvEWeDiSl6O21XvIQTPYmWHTaRN4/ubw8c4ZM5EWS9D2APAQMMdnUKlFRphAL574oQWOdu8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736224; c=relaxed/simple;
	bh=4UoCaKc1T8PngiU1Eq8UEW2pBx2FIeEUtbY2YdEEaQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJc9VlfhFRF52eNu/zh41SIpwHdV0CxKtRKLpXN+MMP0zBD9SiqBRbC1ztCKlQdqtgAvVsve8TM02f6Uand3DyPrKaJv/Gswx9xR8TawaRDse8GgHnI5QuMvrY7aYp+IWVv6RfnWLhRgmkFqpwiTwygEjX6lI/HhroDCUHWIe5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 79B7D68B05; Mon, 29 Jun 2026 14:30:20 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:30:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org,
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] quota: Don't issue audit messages on quota
 enforcing
Message-ID: <20260629123020.GB21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and that would carry over the the more verbose version if we don't
get the helper)

