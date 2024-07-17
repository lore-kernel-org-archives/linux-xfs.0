Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517FC566A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721234602; cv=none; b=riq1GJNZWjBL/x1NurJ4J35qK0DfQJbocfFsa/W9JYleEN8sbIiq2FNzeyxk7Inb5dGYhXk/Vx1ZgC7kPTzqIpY2wfkkhk6UdPY3WfnuBZ264Oy/+0gwe/9zEfDaE6yOmvPlyRcuX2mVvkK48R7mFAnEJGmiatM3ZLitYWvbbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721234602; c=relaxed/simple;
	bh=WZ6jI8WhqL9djugPjDLwr9hyQZnKhnURnWhxpBfj3cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeYgbojn71lamwG0KEhb1ljzdy/h2fGch/g089RBo/Mz2DAZEb5Kayc8fFapJQBfgc5D4cMRhf6bmiX9CaPzDcWHjR0H6gqObyxpe7WI7xLi/QfQ/cjh2yt0cZX4yHNbSqi85QwprgixQeqqmr9kpMJ8EyImpGdudBtbMqmKSLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 08DC868B05; Wed, 17 Jul 2024 18:43:17 +0200 (CEST)
Date: Wed, 17 Jul 2024 18:43:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] misc: shift install targets
Message-ID: <20240717164316.GA21364@lst.de>
References: <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164714.GC612460@frogsfrogsfrogs> <20240717050005.GB8579@lst.de> <20240717161905.GI612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717161905.GI612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 17, 2024 at 09:19:05AM -0700, Darrick J. Wong wrote:
> > > Modify each Makefile so that "install-pkg" installs the main package
> > > contents, and "install" just invokes "install-pkg".  We'll need this
> > > indirection for the next patch where we add an install-selfheal target
> > > to build the xfsprogs-self-healing package but will still want 'make
> > > install' to install everything on a developer's workstation.
> > 
> > Maybe debian packaging foo is getting a little rusty, but wasn't the
> > a concept of pattern matching to pick what files go into what subpackage
> > without having to change install targets?
> 
> It is, and modern debhelper-based packaging workflows make this easy.
> Unfortunately, xfsprogs hasn't been updated to use it. :(

Oh well.  Maybe I'll need to dust off my packaging skills and look
into that.  Because splitting the install targets just makes it harder
to move to a more modern build system eventually.  Another one of those
projects I've started and need to eventually finish..

