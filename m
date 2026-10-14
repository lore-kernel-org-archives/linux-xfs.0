Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1B486430;
	Wed, 14 Oct 2026 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983446; cv=none; b=t41uf4XPU0xnYxvlcwbiF71w/ImAKnX5mIuZTZ5gZkcrpqjhjsU3lMaLraBk17vTUxvJuIgTERwfYYzqi6lD8nmtUi5ZlujwkxHcGuZoqgxz9MOeYSQqkE1W6b4XjtZAmXJfUBCvPUeAswkDrPe8mGQjKqmaIUfm7mKScvNwfC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983446; c=relaxed/simple;
	bh=HYo6IqIx2Yrr0VdamPRqzq1gF++nwR7QYY6a0gu93T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6nfYPh8GLTTBd97dVTIv6/d1+LtbVeBsb/t8r+SiPmpbIAWKANPlDCYiqw6ypLuzPA+fe4wse0k0z/oHdqdiK7eOY46BG8DLvkdFiuU+cGMnkfylraU1/IDoVEsLklPVuZ/gc0vUKag8UxLpweCPG/wUZOIyh7mKI7XyPMH1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66B0B68BEB; Wed, 14 Oct 2026 15:10:42 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:10:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: mark the inode preallocated for pNFS write
 layouts past EOF
Message-ID: <20261014131042.GD15773@lst.de>
References: <20261014-xfs-pnfs-eof-prealloc-v2-1-f303fd5e9dfb@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-xfs-pnfs-eof-prealloc-v2-1-f303fd5e9dfb@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good, but please merge it into a single series with the other
related patches.

