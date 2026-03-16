Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D24382377
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 09:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651828; cv=none; b=QyP/MyIUvIUEkIBKG+/WC4jaBEl9Vmi520Al1evqyAUnK7btujcYTaOv/4qwQ4+9EK3Ocdqju2xx722MkSPAQsSo2NrU76UQfacZZ7W6jlzGPGvR8VIC5UZFVMeST7h6jApI6vFyZ/2Evy1dE1dejyHkLtdWkb7P0l3HRTPLz1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651828; c=relaxed/simple;
	bh=o8tQdGQXInYTyJ32seALnMchzBfBnwZmKkEHgJ0S2KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC/QS+SU7O8Uf3qOTQP4KtJvr6dQ6nL8WIBF6hbQMj1M0dffEJ3qoiq2hFY+UuElzMrCoMyL6cCwgpejKDLE/z7mrc52LaZhiOHLJTqfupgo66a4ZapwKSV+IoRWi8ZHRcxIcvysEO2RVOBGx1Acl+EYupvEqhYcizjvJOOLqIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 48F1D68B05; Mon, 16 Mar 2026 10:03:44 +0100 (CET)
Date: Mon, 16 Mar 2026 10:03:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH 3/3] xfs: improve xfs_zoned_need_gc()
Message-ID: <20260316090343.GC1952@lst.de>
References: <20260314235508.183984-1-dlemoal@kernel.org> <20260314235508.183984-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314235508.183984-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good modolu the subject line.

