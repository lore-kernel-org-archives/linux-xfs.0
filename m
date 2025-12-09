Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68621CC79
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 06:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765263465; cv=none; b=iWE+yfMTV+eQe8MbQDnIG3hT5fXGgyk/ukMsXu10Cd6O994vslZdSqxBS/KZXsmxkZOBIt+0lhfamU2kpIiypy9x34CC2Rwx4rccy7A3gurlICTqEBGdSq5wAg5KsnMrG06e2fJzM8VPAW1Gt8q3a6J8N/N/WLkM0mCAeWrnSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765263465; c=relaxed/simple;
	bh=Lnit5G0jrbn13Hbgb8ki0h2to6W+5ni7FKA+ov5pN68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTmThZxrb3Hb7W8S4WNnxFXXl2sJvppJzL/kTC0g652JW3GHCVSRx+IWpa5RUcnZOEA5QSkN9AoNzKDOe9Y/cpr5TV0hbKUHUQO3AzF7ym1JiHUzVbFWYZNmSdnlJmsOp11Tgrh/Z95IYu45/aH4eLxIt7rpKBHB5SJV5Tqloos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA03768AFE; Tue,  9 Dec 2025 07:57:32 +0100 (CET)
Date: Tue, 9 Dec 2025 07:57:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251209065731.GA29178@lst.de>
References: <20251208071128.3137486-1-hch@lst.de> <20251208071128.3137486-3-hch@lst.de> <20251208173642.GS89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208173642.GS89472@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 08, 2025 at 09:36:42AM -0800, Darrick J. Wong wrote:

Can you trim your mails?  I've scrolled half a dozen pages and still
not found any actual reply.

