Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B63090D5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571903; cv=none; b=hJcINfPEiZhg792EC8EzGDWS7O3s6QwaVBgt5lULRdxud6wEtRmFDi9p7gMQ6CKuoC480JGbRH3WgIO/Yr+CiWrcW758qzAQC928x34LuA4dsOr1jmuLF6KpfeLePJ8cmlmjxORpZXFPbvSSgE6m90BBDdcRvPTiFGz5OigzVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571903; c=relaxed/simple;
	bh=+ssdpbAJNaWjAJiGNtDk1Jgd3f3uibMFgS5QREE3Kfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N93fP10wB4iw1N1GygoXXCHUiGcQmDBMFnLSX6Yl0f0MSVTM+pEZgq89/HkJDn25Fw5gsoC+UGyUmRhEDEtlRnAHc2674G/bhaD9d36DOCbK4cxOfqA7XzLZF4y6ertQH7pgOHahllpy6P9mODU6Ii9XmemFhPYgAdR5SnfKa9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC807227A8E; Wed, 28 Jan 2026 04:44:59 +0100 (CET)
Date: Wed, 28 Jan 2026 04:44:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128034459.GB30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-5-hch@lst.de> <20260128013525.GD5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013525.GD5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:35:25PM -0800, Darrick J. Wong wrote:
> > +	xfs_warn_ratelimited(mp,
> > +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> > +		delay, file, line,
> > +		mp->m_super->s_id);
> 
> Hrm.  This changes the logging ratelimiting from per-injection-site to
> global for the whole kernel.

True.  But this has a total of three callsites and now matches what the
more common XFS_TEST_ERROR does.  So if this was an issue, we'd have
noticed it with XFS_TEST_ERROR.

Talking about dmesg - one thing that annoys me for both of them is
that the messages is prefixed with the file system ID, but then
also adds ', on filesystem \"%s\"' at the end, which is a bit silly.
