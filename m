Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C898F1DC99C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 22:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740436175; cv=none; b=CnI1MZlDfdLn7T7hEfH5ISHTTCfng9bAWOVhLHLItT2QXYf2qS5st7Drz9iBqDvE+10CtP6tO56xyGj5kf2rnHjFbohTkyUis/j+3ey7XZJZzJuvRr1F1+BItdv/G2m1pMnZUCSVO1UoVViFDNkh/kYQcLkGyAHvjA0ZUfmCyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740436175; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRCXyWF+Tb3uSTRL89/wzOfSj1KnzRAPHxBts4GS6V+VJ8LQIV9wr1sU0/rwTR6Mb1yV36aC2uv18jqMTdJURaTrFjXTaNZ60kKuG4FnZ998i42XOqa/kwkWPbV8QRB5WjoSlybpI3WUYEo6Q89WC0DR6rNQhlLeRFZ7qoZI+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5F1068C4E; Mon, 24 Feb 2025 23:29:28 +0100 (CET)
Date: Mon, 24 Feb 2025 23:29:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_scrub: use the display mountpoint for
 reporting file corruptions
Message-ID: <20250224222928.GC15469@lst.de>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs> <174042401327.1205942.4120060381904924599.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174042401327.1205942.4120060381904924599.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
