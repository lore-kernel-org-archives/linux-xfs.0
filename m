Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1149621
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902223; cv=none; b=uvqsdlURRYYtF5B6qq/c+tJ+T+K+muqUR64bzrvsLvIjpalaJibPWtDSknZEjjSg3Qy0/f7yN7xvyjCKQb96rmf9h6SdGJwLeVtNKVlpolexcORJC8iGKWfwoYWGGhTw3Nk/o9QgZLgNjaEWhlK6FmOUZGeYkfY/PM5QHkeG3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902223; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QB5L2k3ZXf9IHr3EYD0PMuIWHDErnJ4hmFJ/cq8jVZHoTSfQsNsE+K5PVhwcrzLg1LJMvX7xMwY6CiTFkCE6z+0EcYQQSiK+OMo26hHznRikTVS5sJmzZQYDOOqiex3CDJv7L2XaZOp4HfU7s4I6GMDeP9uvB333r+hrJAa8aA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1063068B05; Tue,  2 Jul 2024 08:36:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:36:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 20/24] xfs_db: add link and unlink expert commands
Message-ID: <20240702063658.GD24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121372.2009260.6118201962786865664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121372.2009260.6118201962786865664.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
