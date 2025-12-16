Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4907231A54A;
	Tue, 16 Dec 2025 05:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765861971; cv=none; b=BB6mZVj+8IqD4ZrMGU/K6ljx7b9m71S0qnK7vx8xfWix7t7aBcOV/ovd3rYpQ8LWR5AFsBYoBPMHMciLtIAqwda/fJdp/9KD3dsxK4nnu0DM86qFtIjpTw77fFh36nOrF7vh3PHbbTwPIrKqdO/weK3fZn39uHQUyZhkJVCkqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765861971; c=relaxed/simple;
	bh=10w6NuCrHd0ZGcT35bF3fI5MNsVjDEIOZqqgYSH+aEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4hVZ6mAGqZVf0GrOR1KHrS1/neDPovkBeDqhqO3YVhWFdU8eu0HJDFBYDyTMRXO5paRkatC5Yq1p4FAInkCx6YHX8bfY3XiHgXKa/s6wGUcQBzu78cjwcHat5Jw3ohHQQLlfHh3DNgD/PplZ15VfKlrdASUjaHuyioCI8p7c1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27A28227A87; Tue, 16 Dec 2025 06:12:30 +0100 (CET)
Date: Tue, 16 Dec 2025 06:12:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: test that RT growfs not aligned to zone size
 fails
Message-ID: <20251216051229.GC26237@lst.de>
References: <20251215095036.537938-1-hch@lst.de> <20251215095036.537938-3-hch@lst.de> <20251215192821.GL7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215192821.GL7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 15, 2025 at 11:28:21AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 15, 2025 at 10:50:28AM +0100, Christoph Hellwig wrote:
> > Check that a file system with a zoned RT subvolume can't be resized to
> > a size not aligned to the zone size.
> > 
> > Uses a zloop device so that we can control the exact zone size.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> It seems to me that this test is creating a 10G zoned volume with a zone
> size of 256M, and then growfs'ing to (12G + 52K) which is supposed to
> fail, correct?

Yes.  Any way to make this more clear?

