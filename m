Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65823148A7;
	Thu, 10 Sep 2026 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021441; cv=none; b=FR3OPU5Eb+Y2xpOGmVuDqA/SiIiwAWkdgl0UllG/G09yJO9H2Q35g2Q2milnaVx6/AEVH6MlTq0J9yhqCN3+kFPThzXMv9YNNwhRsesqeL5PZi8WNC9Aej5koUfYFHCCcNgYNdGzjmSHulRDxZzThxSfgfrHWIEHz/XuhLSKUZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021441; c=relaxed/simple;
	bh=oqNZ021lQBFP6R4qPLJFbMMgHowi7bB4Z+JfnGU7YnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXT6AT3K+BPU9LwCtz6a5cUj/iohG/uS3uFcy8bG+34AiSoa1RNaAnLPXvATPq2JphIq1e5C5DwUi6D1dXXYXztM5xIf+sqSDxcQ4t7rroImv+eglI6cap0vbf60HfC8aJc100j7bqgYA94Qp7SawpWb/o6Kc4vfwsm4tvjnK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmCeedhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmCeedhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6C1F000FF;
	Thu, 10 Sep 2026 06:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789021439;
	bh=npIC6rGGOsWIpsmlmTaJVZkwqLIf9OG0BCMb+5BTeV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XmCeedhDvJpJRHOXHjIFimaBuAQ0JRjvK/ZfVFjXiMwn+dsfcAGMoDvyw0xOqeenn
	 lXtRw+XhLZu2A26PQ2VCGjP6E/UB/POUkHdTZ6+pFTaBoMD6p/7DhV2o117+fSjFN0
	 U29aD3/ni5KjpW83jKmUzvRfL7YU/fcP60wJxJGn9PsmvtaAmlcsGa9TXgvakluJ6+
	 r04KTp+TO9NNBmZiutNWAANjcO1RlFh49WN+Hj4+8WJZ2q52lnwpvi3LpQeVs5JUdX
	 LSENqR74q7eRUjE5ibNJm56cd+0kAZreQcKaOkl+U4Y7jZrswZELkXPepcsoCkmtBm
	 ty2a9vEXj5m7A==
Date: Thu, 10 Sep 2026 08:23:54 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <aqJMy0OrOqBJZ8l2@andromeda.toxiclabs.cc>
References: <20260906144629.17009-1-kartikey406@gmail.com>
 <20260907045150.GI1933798@frogsfrogsfrogs>
 <aqI7LFBkAhMSaDnx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqI7LFBkAhMSaDnx@infradead.org>

On Wed, Sep 09, 2026 at 10:07:56PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
> > On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> > > __xfs_healthmon_insert() asserts that hm->lock is held
> > > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> > > after allocating hm, before ever taking the lock, triggering a
> > > lockdep warning.
> > > 
> > > Take hm->lock around the call.
> > > 
> > > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> > > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > 
> > Heh, I added a patch just like this one to my own tree.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Can we get this queued up ASAP?  It's also causing a lot of failures in
> our zoned XFS CI.
> 
> 

Oh... this is actually already in my queue, I just need to push it :)

I'm just trying to get darricks attr fsblock fix in too because that is
also failing my own testing here.
