Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A432BE7DD
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 04:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784609212; cv=none; b=YLwwkP2ZJ6Dv8U1/A+uElHPOY+C3UAhMjIfw0RBG5nFpUJFDb0X7OIJYdwgLk8gU1th4bj5UwmNsbXu6WbluzTjuhvU/t7ZU80VvP+eNGylrZu4/fxidX6BvhrkN6GVKUiQk2kMEoxEfJdCX+uM70rQFX+qKXboGyDRI9Lri0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784609212; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdDOj/I7KWD9Vpi/ruTGqK1AJrm1vfKwbY+j1DFEM2gd8CUwPn4UcuxWxheENk0NkpTEMsDQl21TMdMc8IvSBD4vvm/Gu+gfaWoUSF1BWsuXO/l7A9TDFOdPyGxJ72wb9WveIbdUnqQyGL0dRrhldE+UzTNeemGNyVf4HsKGrGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 112EA68C4E; Tue, 21 Jul 2026 06:46:48 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:46:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: hoist per-bucket unlinked list check to helper
Message-ID: <20260721044647.GA6644@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419511.830862.15214045306349407437.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419511.830862.15214045306349407437.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

