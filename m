Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3234C2E8DFD;
	Thu, 12 Feb 2026 10:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770891289; cv=none; b=Z1n7VCiEnw+u5/Ex0Bf5Hid+f/MCWJojpAqmqqQ5Jvl3pVDMVXMgl4PN57LyEGQMkB9Ndo2bvUGG8d9NdKNWreEAO5ebAaZ3emoPQqtHAbrGgkdLpD4rJdt8AqjE5raQUGcxEFhmMRgJ2BOJSAzq8AMFkqEqYwqZI/3LrJW1X+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770891289; c=relaxed/simple;
	bh=ZLXMLOT7zP1HWPcFqfar+QtEZTZSRsZZbFqOHeAo4Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgHdm+N3wCdLPozC1W3LRpoW7Y48NjA3IO2MA5/58hSnPxWs2KyfNlOaK4zBgDGAB/fa3vzuU/E1ZV7q9ICecgJqqlwxai7L010DdP62oLdVt7FSteSlXe1VIOt0SyI2dvfEQdCLWbfteBne38yTRprSkIl13uC/8Wo5k+gi3UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 188D468D0A; Thu, 12 Feb 2026 11:14:45 +0100 (CET)
Date: Thu, 12 Feb 2026 11:14:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: fixup some alignment issues in xfs_ondisk.c
Message-ID: <20260212101444.GA8615@lst.de>
References: <20260212020437.259170-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212020437.259170-2-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 12, 2026 at 12:04:38PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Fixup some code alignment issues in xfs_ondisk.c

That code should probably go into the subject as well, as that
initially made me think of data structure or load/store alignment.

But maybe Carlos can just fix this up when applying.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

