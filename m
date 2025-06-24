Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B928ECE2
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774173; cv=none; b=ijQut8NgRpVa1M6jtMER1refXnOW+OtQFV+E9T1xfMd0QOSVQ2aCZj6sU5qUE6kwGO/0t9Ubbiy/CpXxwvnECfxglfzNVCWNbhYYiP9cPjgtzEsT1uZ4if4RN2wgeLYJR6xSuQCBTz0OEoALZ4j+0jgj+l3+9VzR1cjYcsBBJN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774173; c=relaxed/simple;
	bh=hQZSOmyRYIMluXQ42oAjNLvBlUK+FP2a0+i/4q2NDBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2gu7s2ud0nX7WjTU/VEmExXUJpubMKwHeEu5T10+K1ntius8cxW/S7VO4ncDg4900TWdrNei8ycwsYl5GfVeN5FItxLHA0hj1uJjLsq079NrAq/EQaUtn5dgrA7LzDdVVLxydejwpU9WhMiJKZ2Be0PuoDRtp3ImFL/cwedFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A3EC568AFE; Tue, 24 Jun 2025 16:09:27 +0200 (CEST)
Date: Tue, 24 Jun 2025 16:09:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
Message-ID: <20250624140927.GE24420@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-5-hch@lst.de> <e8cf8a81-56c5-4279-8e19-d758543a4517@oracle.com> <20250618050821.GC28260@lst.de> <e2a54766-26a0-42c1-b5af-5a7cd5c1c0c1@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a54766-26a0-42c1-b5af-5a7cd5c1c0c1@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 18, 2025 at 07:28:19AM +0100, John Garry wrote:
> On 18/06/2025 06:08, Christoph Hellwig wrote:
>>>> -	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
>>>> +	struct xfs_groups	*g = &mp->m_groups[type];
>>>> +	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
>>>> +			mp->m_rtdev_targp : mp->m_ddev_targp;
>>> Could this be made a bit more readable?
>> Suggestions welcome.
>
> I thought that you did not like the ternary operator :)
>
> Using an if-else would bloat the code, so I suppose what you have is ok.

Initializing variables at declaration time is one of the few sane-ish
use cases for it.  Although maybe a little helpers might be even better.
