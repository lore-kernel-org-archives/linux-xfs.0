Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E493280CE8;
	Tue, 22 Apr 2025 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745329965; cv=none; b=DbWVW5GaIITf3GeuBibJ7b2Z/8+4q6Nixjk0/FFOTberRZQJZx90WpR1OXMEJbEr8jiYA91uB2u2zOIxFhnMK6oLPJYEDz5uZWOrdgyHbCLICUpEij4ZW/+fGsIz1fHCZuMyhT4xpWTT5bkv7KvlxJr+ZOCqQjxM+6a+YsyqyOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745329965; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlRYVc8RTSrZPIEprqlTbeD267GyNmfZpxpPAWG87U7fOQfFNir+HRnsliGySIvzv6bOQO5j7H6n2JuEdQS9R5+wG179hlXfG4m/VOUqD2k9C6igbKxeLVXyrF0iY9Pf3FdQh0tCL4VdGE4XrcbH2i+uUGEeG3RRjLWYI2nFFmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4F9867373; Tue, 22 Apr 2025 15:52:38 +0200 (CEST)
Date: Tue, 22 Apr 2025 15:52:38 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Message-ID: <20250422135238.GD23131@lst.de>
References: <20250422114854.14297-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422114854.14297-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

