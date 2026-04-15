Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38F318EF6;
	Wed, 15 Apr 2026 05:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776230587; cv=none; b=u4lCl/ile1WF4KFI/SPJuWOvzogbxH+cOtNPIrkidU/xrOjCr2Z4jiz74qgxLzAyRQbGqWIIe9RJ8gFBShydYkj7OFeuGFHmvfZSDkEPYiF3apjfwioAvvlRvdT+6+Cgl4XfipgT9uUtPUnJ9dT7aoI6tzCYxTXLlDXtRZqTfvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776230587; c=relaxed/simple;
	bh=AodJYpRY5hpYGNt0PC1BgggDbf7R+tNeubAi3xnI3wY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Otgfsq/hSSs7nuF1mB5m7Hcm4oDl3ZT37nbZB1mZ1pIr+20jYY9LEJrta0bPjtBZl3XU6iKd7/ZY12oExw3tXj92dVWp5/G6Ot0v4LiFyRBuxoz7RrEmRIcQv0vQRDnPofqMQGy0W9tar21y3KZisoAwHWNEA/AP0KOgf2adakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9D94F68C4E; Wed, 15 Apr 2026 07:23:03 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:23:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260415052303.GB26559@lst.de>
References: <20260409131404.1545834-1-aalbersh@kernel.org> <20260409131404.1545834-4-aalbersh@kernel.org> <20260414081301.GB11138@lst.de> <u3szxuhjrv7vyxwyrepuflwhzeucss7xj3cxj73mnpm5kal2da@jck24ig4oxxa>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u3szxuhjrv7vyxwyrepuflwhzeucss7xj3cxj73mnpm5kal2da@jck24ig4oxxa>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 14, 2026 at 03:53:36PM +0200, Andrey Albershteyn wrote:
> > > +	if (fsverity_active(inode))
> > > +		fsverity_ensure_verity_info(inode);
> > 
> > fsverity_ensure_verity_info already is a no-op for !fsverity_active,
> > so the check could be remove.
> 
> I don't think it is. For non-fsverity inodes it will try to call into
> descriptor reading callback and fail.

You're right, sorry for the noise.

