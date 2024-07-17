Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636A7BA45
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2024 05:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721192412; cv=none; b=pJAcDp0/QI/xA9AZO/reNvpN+KscjRIoJSHnalqAlC/SQtqnRhAkzuXtvhu/T9RmszCU6HQrw3kGX4tIQrypsIiMnhcPoU/4iI3vOlPEJTOSRAd0SeCbr7JD4Php0I+QAB/2IPM39gRfVgypYgpbdqFmWi8ZBYc1pZYGbSji/oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721192412; c=relaxed/simple;
	bh=3IoHP4t9Fxrhnq5JTwFvxpRzzbbt8v1K+wj24tUtM+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwU/YXX1I+jvREGikwPKl4EFIYmOdmeLQiGxdqEq/OkerxoCAid9seRBervGcbAoxRdHW+HCa/75mFlSJiCSWgL/L63k9SxmaqfWXDlkTAAk6SD0SyPKYM3qodommy2hoeqEZrSF3nfeAwhgN2JB32JT5Tzzp64XuJmNPNwNZgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 15E5768AFE; Wed, 17 Jul 2024 07:00:06 +0200 (CEST)
Date: Wed, 17 Jul 2024 07:00:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] misc: shift install targets
Message-ID: <20240717050005.GB8579@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164714.GC612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716164714.GC612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 16, 2024 at 09:47:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Modify each Makefile so that "install-pkg" installs the main package
> contents, and "install" just invokes "install-pkg".  We'll need this
> indirection for the next patch where we add an install-selfheal target
> to build the xfsprogs-self-healing package but will still want 'make
> install' to install everything on a developer's workstation.

Maybe debian packaging foo is getting a little rusty, but wasn't the
a concept of pattern matching to pick what files go into what subpackage
without having to change install targets?

