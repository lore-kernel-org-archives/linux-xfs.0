Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F311E3596E4
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613176; cv=none; b=m/XgqaZ0znvkRbPO1BYpUsUkZs79Lr9tVsRtcNvzsDvA/LRg0Mxmu2llASK0dzCsQMTCKByNE/cEwBXrPmqUO1W5t6pgMEly9IJKcESsG7XhtiFG60JZ+tFL5s69Lnnv+E4blDfY36zAQ+nXAl5Pm/v/5wBASrw+HT98FfxbYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613176; c=relaxed/simple;
	bh=DTX7FkKMcn6aJgotxM2VLTiW/RrP0mNW8p8ymXngXCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWjYv3qgZAnkF/5hDtHPtxNJZpc3LZjmF65GXxeBDMv0PzgClEmp/yZaiOhiJbAd4a1ggO0zCmjLee3/CKioWA7mTWy8CU/N/RzMXBVb/lSOb3NByi2cTqEx4R0F4r+DH11wvNeoPt6DzYzCyOJVPywJGJ0bNUg0SwWdPtZNtgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CC4A227A88; Wed, 28 Jan 2026 16:12:51 +0100 (CET)
Date: Wed, 28 Jan 2026 16:12:51 +0100
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Message-ID: <20260128151251.GA7277@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-11-hch@lst.de> <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com> <20260128141233.GC2054@lst.de> <a589bf70-883b-43da-a6fa-438b0c0d3467@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a589bf70-883b-43da-a6fa-438b0c0d3467@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 28, 2026 at 03:11:01PM +0000, Hans Holmberg wrote:
> xs_gc_write_bytes is fine by me as (it is not wrong) but maybe xs_gc_bytes would be a better name?

Fine with me.

> (as it is the amount of data moved)
> 
> and you saw my comment on the xs_gc_write_bytes typo?

No, must have missed it, I'll take another look.

