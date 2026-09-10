Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE69B1A683E;
	Thu, 10 Sep 2026 05:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016884; cv=none; b=f1iNHhGuolEPGI49TlWLcgIXMCimvcBysayoSYly1kBXyaWVaxBHDDQOsohptMHBVbLii3YrcBA/4/L+OnxNMmfmrgp/U7QeEmhbUDTGDONu51d9wfQobthado+xIbd9JhBxJmVtMkKgyRdvcGeZJvALhSpGEYurhYtqpNrCzf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016884; c=relaxed/simple;
	bh=r2LVhQcyY4ZWNZhoaRescLzr3a2E5eh8RRKZqe82Uj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OebiYrfaET+RWf8g6EoYXWfcVwKCGJYstfDh/62h8qgOebSxZyb7nmBKLHN4clD/HmhfFVC8fBXDa5aBu8yD6gHMY7ueMgtAMswl4gjOKhZS0JF3YeLcStV+QRBj3u1oDNkB6Yy1JZfemW/4YFg5wPtLntLRjyk38ENRWmhDz3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GlqEH6Bu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GlqEH6Bu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YlF8qFkAPVP3G8cG+8ke+tIy+y/gtW4S/TJiahF87dw=; b=GlqEH6Bu/NTsyS/n8OsVQSdLLI
	UMH/mnXXHI5OnsJbKv7DFXjtxeH1YWMwxNdRf8qtxt88M4NHw/JkwVvdWl7SbrUqXB0jhbj+kJSZu
	3tCsYaomso4YR9kz4VJpqZ9FL2hBXduaC7rrOu6aO5BNGWGZkPF8AwQPeljBACfOcdTIMfNn9Km8E
	wyhtzBuHwEhlOWLRnAhL2dg1/Jjs0Ug83lw60s0q3LJOdxm0Vt6XboyYyrSP31SqCN/4HH39+/nd3
	c0BwLj7lvxz9AJmNNOOXv1CDtDNmVYIe1nuuKswNpJRmlrTldOIk4a211efP7eXnbGMfOSpFtjtbT
	+qI57q8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4X0u-0000000DQJd-3f19;
	Thu, 10 Sep 2026 05:07:56 +0000
Date: Wed, 9 Sep 2026 22:07:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <aqI7LFBkAhMSaDnx@infradead.org>
References: <20260906144629.17009-1-kartikey406@gmail.com>
 <20260907045150.GI1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907045150.GI1933798@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
> On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> > __xfs_healthmon_insert() asserts that hm->lock is held
> > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> > after allocating hm, before ever taking the lock, triggering a
> > lockdep warning.
> > 
> > Take hm->lock around the call.
> > 
> > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> Heh, I added a patch just like this one to my own tree.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Can we get this queued up ASAP?  It's also causing a lot of failures in
our zoned XFS CI.

