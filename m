Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F9C31282F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333370; cv=none; b=cYXuj9PQqPXboSYa8pF1G2WnXbNTd5qIAezNBgV4ijEqpCDGQ9oHNWhNYmKbpNTZE/WXsIC6rjkezM7nZdagv67enHjcnETavV2xASfsMKXUwAqhiaArTl2KKmC99PB6GjxvCd+hO3zbS17mKXER9zrPUgmG+/L7yRwxf+hP/tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333370; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fghRD19G6aQzo5GUo5sbPBQXmwAwavVnU0XgO4FEU8D9nw6w4ONaES3cSc+BhDQcinXrzGcMns6qWNE7XudHoV4haoMFEgoddncnOZAo49sWL/B0JByCwIvSwjkG8xVqU9hl3op3TFoTKw2KzNOmDwzuPAvp6K50EE+sCkOzf+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91FEA68B05; Wed,  2 Sep 2026 09:16:05 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:16:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: port healthmon event list to list_head
Message-ID: <20260902071605.GB25977@lst.de>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs> <178832750329.3507776.9204574745538598139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750329.3507776.9204574745538598139.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

