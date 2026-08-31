Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A23BBA0A
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159263; cv=none; b=aB7+flDhUWOv4YjinKxYJYtqBxw/oPPbElJ8IlRTBZY3xo7J3GzQUTvXgrM/RLcqAltur6vhz6b8O2u7ZyMbAu1Z7FZenxGaO+OP3D27jd/F/khPgRY2jz5OwoJd0f/KtgIcdZ1sF4kn/im4eeWA8ovfmlM880fNCQ7IQzgayLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159263; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qR+Heti8bzyvh0eslOAvkMuLWq8YT/L2IfqkhA6KZARHDOqZMJh6chTkUui1F0q83QkWIvnICEvWQtrGokOalujvKruoQl/SlfcYMUhqrgFMYqk70ttg/7p7PyrwdvZWUud0wTXoYPbsMskUUGZQiuCAIUAYqBPD4MFgiv8xXy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1FB6268BFE; Mon, 31 Aug 2026 08:54:09 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:54:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260831065408.GA24602@lst.de>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs> <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

