Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B5373C12;
	Thu, 23 Jul 2026 04:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782449; cv=none; b=FiVJR4ztgDXlxl6Y3qSQa6ODx2cbrODo7xmdjD5wZH6YMNtuTaxYU0q07ZqQwtTBplg4tgaOudeqHo9h4MjDSCJHHwQ4ucK9gZf9H+8GKiAMuI/L3vNZBKPI+5HY44vfsDLfHOiJasGAHTfDeHAN/7UjCVAkhp4htMgnVdB0s0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782449; c=relaxed/simple;
	bh=cGE8Z/r/0+pKLCZdFC1DoP/YlIO7LBzyul/58/Clexk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIfKOx7Z272jq7++9G9RvcRbqrvW/IsaUwt9qGnwjChdCKD2hjJp2D5nRwl9igT1uCvNxXc5zazyZ8idcyJvobVZMjdiG/G5BD7jCTK+C+57Eie8NaktKyoVEp5omiAFGRSmWL3FEUWxY4b8OBdXabDOtQSF2mbqdRHMZuW/3SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CF7F68AFE; Thu, 23 Jul 2026 06:53:48 +0200 (CEST)
Date: Thu, 23 Jul 2026 06:53:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, changfengnan@bytedance.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <20260723045347.GA6641@lst.de>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-3-hch@lst.de> <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 22, 2026 at 12:03:49PM -0700, Joanne Koong wrote:
> > +ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> > +               struct iomap_iter *iomi);
> 
> Might be nice to have _read_ in this name as well, eg __iomap_dio_read_simple

Yeah.  I wanted the read out of the guts of the implementation, as
most of the code is not strictly limited to reads.  But with the public
API needing it, we might as well be consistent in the function naming.

> > +       if (!ret)
> > +               ret = __iomap_dio_simple(iocb, iter, &iomi);
> > +       if (ret <= 0 && ret != -EIOCBQUEUED)
> > +               inode_dio_end(iomi.inode);
> 
> afaict, the inode_dio_end() error handling has to be done by
> __iomap_dio_simple() to properly account for the synchronous case. I
> ran into this earlier when doing the iomap_next_fn inlining. For the
> synchronous case, __iomap_dio_simple() calls
> iomap_dio_simple_complete() which calls inode_dio_end() even on
> errors.

Yes.  Sashiko also reported that yesterday and I replied with a patch,
but I now noticed the report and thus my reply only went to me,
a sashiko-review list and Ted, but not everone else or the lists.

WTF?

