Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16E168BE
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808057; cv=none; b=nHsg3nvup9x2c/Z1ce6PDpu4nxydQkFtxE2oezJXkVjQgy+nEoHg/xdTHkYkZ/oN0AUmP61JZNMFmJi2YPhUNUivza2vezjUtXj9lRoSgVFgpAHnJ9z0h0jAg8e2eUfFS0FLTMdRslUuAjkq3PEpuySYFSHBrhnXGse8lrqt8uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808057; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GG3Z8ztAjNabKD2GeAGGpFBESWwLiLqtUti4oNdf1AKXGCKVH83WfIKYmYXfZmEu4V4gInuWRBMS3bxXRiVosKPqlHW3JmRnl67zfm3kgnkLBfnApCXhEi5EgJf3pj6/Xwdt/pAXBxg4r7uT8VHvGPT0tSdVWNYTEQCpngZud9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G6I3Nb4a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G6I3Nb4a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=G6I3Nb4aP5Qb/JEFX33CscBQrk
	oDjdQiUS4qb4PkRYVSMvMjcWy2j+DknmLHBWqmWNJMYikTFVLs+QmEb+IVSv5NpUsWuV0IYPI58Du
	YTKMVqbjLIkQW0Cf2cMo4hc/sOTWBg8TNbWLlHkVH2zItG/APWt0vP3sMsZuVGO6x2hiUkwBUH7Kv
	4cS/BNlmpOvYwK0sPABogxVFFYaRPC8Gc+9WlaHDn99+uUvFl04Lz0X9MzhYGQXha9SE8GMQQfDgg
	hUNxioS0MWvMWQZGXGwnfyh/IcA/gm24Aw5aC6+g4kfsiZ006EusfdyPWHp2FxXomhGhddIKu83RG
	UidKSkYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsg4-0000000AGY7-0YNz;
	Tue, 10 Dec 2024 05:20:56 +0000
Date: Mon, 9 Dec 2024 21:20:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/41] xfs_repair: truncate and unmark orphaned metadata
 inodes
Message-ID: <Z1fPuGG1fecdyPyx@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748801.122992.9829661249755090260.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748801.122992.9829661249755090260.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

