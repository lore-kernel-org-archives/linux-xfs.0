Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B539377EC2;
	Wed,  2 Sep 2026 07:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333951; cv=none; b=QTXckoNUHwg1y5RnhkFm1zVulEp8+Erq/QgO1EAJHhsqeb7kUlqh0Mud/44whDSuIa++AG995Had/m4h6ENLB1BiqXJbvKxbnJrKMDm4jOMZ/JI9P4WuFMKERb8ErtHyIlrz6d3DGLKSOUOviY7D0JZivMgjZ++cllEsmWIE1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333951; c=relaxed/simple;
	bh=/g2k4F9fi7YHi2EAsx0CXKY+d1lcsXv+i2YC/OrIXUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcM1zHD6pbBx8Ein0bDVsuc2Q87XgMs3nzg6vx5oePwjXvJSxpsmRqGSBhvuV0M9KACuCowcadgYqE2u5AUrt9urDevVArF0Ut5VeatpQ2A5ININEQCVMt/LKALQijM642DL0gyj8Q0daKZRZmJDaxc4FKaNx/CshtMEryhBCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CFC668B05; Wed,  2 Sep 2026 09:25:46 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:25:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: djwong@kernel.org, hch@lst.de, cem@kernel.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: release alleged child inode on metapath unlink
 error
Message-ID: <20260902072546.GA26840@lst.de>
References: <CGME20260901054416epcas5p13e8b9a5e5e8ebe10715f735c82ded916@epcas5p1.samsung.com> <20260901054348.808571-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901054348.808571-1-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 11:13:48AM +0530, Anuj Gupta wrote:
> If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
> succeeds, release the inode reference before returning.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
