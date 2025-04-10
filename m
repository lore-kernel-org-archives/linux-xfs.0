Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B37D1D514E
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 07:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268461; cv=none; b=SuQZ12WqBTtXBE9uP/uzw8vEJCBCZ6TWHO5gOB4opleql1kjHIjbEYZTmVFyGBFVqyaDmvE5V85YVDDbmiTNyDo1+m2a6gcDb0G93pChvP4lGIfkb1uz4qLSC5rInR7TKh89nsOFnPFbtl6BS4QF3B7BtwcHJT6ssZymHQGcdF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268461; c=relaxed/simple;
	bh=R2i6t17jUpT640yS5sxzjkffd4tQlI+GzLbXNs9HHz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8EwuukQDcf6sxx4Kt6NdRDCV/mqLP+QeIz0POqiD1f0XINR+jJC2VbVQWpnsxc2hExH9olW2FTWgkpy02BEFiC8YcY6EUc5rLduf6Ky8/NrcO74OZP9E9k/u7RmEnOZe6JYy9YSskgI6gyXBPqVHduMoh7XMYjyuxph9oKJQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C85DD68BFE; Thu, 10 Apr 2025 09:00:55 +0200 (CEST)
Date: Thu, 10 Apr 2025 09:00:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/45] xfs_mkfs: calculate zone overprovisioning when
 specifying size
Message-ID: <20250410070055.GC31858@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-32-hch@lst.de> <20250409190614.GK6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409190614.GK6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 12:06:14PM -0700, Darrick J. Wong wrote:
> > +_("Warning: not enough zones for backing requested rt size due to\n"
> > +  "over-provisioning needs, writeable size will be less than %s\n"),
> 
> Nit: "writable", not "writeable"

Fixed, thanks.

