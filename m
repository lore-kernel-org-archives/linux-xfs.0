Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074313AA26
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 05:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729660084; cv=none; b=c44Ul3wN2tHbLBID3j/QH79hm982FO0deWkFh+YWLqC0kWallW96bq5H71Fl5aZFnPAIokLIOJsvWh/5yT8s7gar8iVefwEU/NWqV7u7hJ8j8ufSWmmo28R3P4IW2+M9kDEjcvE2B1gxFDHUbpOt/fyOXZbzze7vYWMBLHlBMOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729660084; c=relaxed/simple;
	bh=WPPs34C7ftPazk4Q3dGZMoST1SEkIgTOK0t7YRbMs8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5CROZyrunLsUPY/KIvvT2pZTwjokRZGHrzQG99w9hcDqpIW2rh2EH0j5jtS/ngRMxK9OAbJyA4AfqzN4q02lsXTnjjhoGSiNTX3RVDeHoRc3f7bV8o63NFW/ljT76tZEOxmxVo8AgPZ+w9x3aeql6YCBiJ77CRo8oAgQ/XaIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0979A227A87; Wed, 23 Oct 2024 07:07:58 +0200 (CEST)
Date: Wed, 23 Oct 2024 07:07:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] xfs: fix finding a last resort AG in
 xfs_filestream_pick_ag
Message-ID: <20241023050757.GA1051@lst.de>
References: <20241022121355.261836-1-hch@lst.de> <20241022121355.261836-3-hch@lst.de> <20241022175928.GE21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022175928.GE21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 22, 2024 at 10:59:28AM -0700, Darrick J. Wong wrote:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Nit: should trace_xfs_filestream_pick() lose its third argument?

Yes.

