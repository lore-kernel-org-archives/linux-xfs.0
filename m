Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A991DFFB
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 17:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559126; cv=none; b=b/3vAzAQUcKX0Jb0dWxM/Z57vRkgh7ZBHDB/NtyP+s8JEi3DkswHbcK13TLl36rHCdd4o2JyByHSug38mOzb4PyTqOL+e89zNPTJLEcJdFzLvENgk6gyXam49tkRVZWlVJeVA/vKT5p/TuO0osgYddXNWUsnyNLBfQBtOKGvmpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559126; c=relaxed/simple;
	bh=WnLYxMtZuEeAa6XtAJDh+5dhYnIo2K7ygMWPfujxR+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAHnv0ustN+p2vkiKy4PjLjhupY/RDhf5a0mxjG8KEmiAqRDmdboMko1pzo9wuyQ6/JidvGsPOU5h+TXUZHesqcdr6I2v4wy4LgsveM2OKi5+xktnPnciTPqoJKaLzfx08vqBUkq5UT1H6/1DtATU5tTZFsyqPHDtdqa2XUVq4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9174A68B05; Wed, 27 Mar 2024 18:05:20 +0100 (CET)
Date: Wed, 27 Mar 2024 18:05:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240327170520.GB32019@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-10-hch@lst.de> <20240327152022.GB6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327152022.GB6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 08:20:22AM -0700, Darrick J. Wong wrote:
> Hmm this looks nearly the same as V4, right?  I couldn't spot the
> differences, and I used to follow Hocus Focus every Sunday as a kid. :)

Yes, no changes here.  Sorry for missing the rvb tag.

