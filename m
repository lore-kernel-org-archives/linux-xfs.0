Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794D930EF63;
	Thu, 10 Sep 2026 06:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020427; cv=none; b=MfkI4ylW/6t0OvBt3YKE+mcL16j5ujQtCURUCEaMPtwEis/dqeEtGap6BMII2vkKhhhR9N35+j/TyNEyS+UBgiPLZFC9lPrKx54eNArkOXjEdtpbGOF4l06aE+Prio+KHpAm5uUFUlW6nnu8KqthX2cuHqkyusZt+oNa5pLu2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020427; c=relaxed/simple;
	bh=GuklswbYRk8EYb82mABzcr7LBu8iWQdB0WrzQvfyrf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gskvIEMTuRy7v6+2wph5b1yzsn5Naq0cim2dlXOjK3TQ4sJ0Ww2BjswGKlWDOzNFauyfOxF9V26oZfdLhZ7CRUV41KKs8NOdSbKZB1lxQ88iGWAQTxfWAAxuT4/v+V7/GtZEj+7k2SjWFf8c0SIWi9xfpFVzDl7d13NO9FpbZ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjqdE17x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjqdE17x"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0DF431F000FF;
	Thu, 10 Sep 2026 06:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020426;
	bh=nOylofx3XljWsfWb1rgg2Z8rQlbMXk1v7xJM3t4UkSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jjqdE17xFtq86Ik5aSiQ67i6gtXd+ynBI2lrwVfYA0zuXjgU31NEyhSiCB73Ikn/v
	 jDDUKPhYAHD1vTFRh1zn++I5dlp6obwoUkabyC1ocuQy+kZcdSdGU2YMqPczXG3Bzy
	 J/ULaw+WHRVaCRrAvuOf7JOgiK/DHDfHT/N2LXF3oT3UJeuEDfitXvxL/JLSm/qdRP
	 4Q3TDdcuSdCpMPByMNuMPazqnh2+rwjRV9Xl+MkfpPpoW7Q3Pl4mLRGj0z8adVuMSJ
	 17DdVS/UloQT8ABhf4xBWQfBy2038qjcdbc+e3q+MxetpRMKYxNbr2ihG5lxGRZ5KF
	 0Ii8eQ210zevQ==
Date: Wed, 9 Sep 2026 23:07:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
	cem@kernel.org, akpm@linux-foundation.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Yun Zhou <yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <20260910060705.GB6253@frogsfrogsfrogs>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqJEWmUN3Jsajoyl@infradead.org>

On Wed, Sep 09, 2026 at 10:47:06PM -0700, Christoph Hellwig wrote:
> Adding Yun Zhou, whoch touched this area recently.
> 
> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > xfs_trans_clear_context() on the caller's transaction, overwriting
> > tp->t_pflags with the worker's NOFS state. When the caller already has
> > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > the caller's NOFS protection.
> > 
> > Use memalloc_nofs_save/restore with a local variable instead so
> > tp->t_pflags is never touched.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, if you have some spare time, it would be nice to kill
> xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> they keep causing confusion.

Yes please, the wrappers have not been useful for making anyone's life
easier. :/

--D
