Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32CA1C8FDD
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946281; cv=none; b=dVIEdSm6t5KPR6T+8r1zqRJScBV2HmCtb1vOh2eLJ6Vb/0ksXjgD7MWQqKeQpf5Ntm/5hhOqa/Q/53g6NrNgcDLoHlHiOLmh7JeeWmVVwWTvyIvxQ0mcGEA2UZjhaFF85thnfbGmEjJGEGVw6PZMdbh4QAXlSH7CYZHJEV4Da6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946281; c=relaxed/simple;
	bh=EeAMfPqPWzYXeOEW9000X8vhzgMhyZN+eh5n8crqCAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTLZy/zjthVvtMoNmy4x9UUynB85FhDi5hnFZikLUj1GTi0nNjMN+dT+ISBxc3wE/bjZ+OrvcPCFt0KS82VFhpNGabQoRyDn7d42AfGEMYCS/VhUrna8wld65S/ScnSb+c2zyN6RV86kG64UzekWO9wxSqltXCwNJnmDE7LwpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FN+pdyYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FN+pdyYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F733C32781;
	Tue,  2 Jul 2024 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719946281;
	bh=EeAMfPqPWzYXeOEW9000X8vhzgMhyZN+eh5n8crqCAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FN+pdyYJ/himrgohmir8hHAzuYJWP5Lee+uAWS1qJib4Rb309UciXzmOaCwL63fjz
	 H1X22pDh9O+s3+7dPJzpQ+VLIy7c3BYe4OO1LBepsxhGIuQpQSuL4S18EMbihnlqmf
	 wVTzNXxIknQCMSaFnn5rhuNcDpRubUktSnXyaT4zj+vJT7g/ua/S+wbzvLRxOyOuvh
	 mjJewDxBTMGtNGQ/pSXvm7U8D+QsEMz4acn36DNkj83loHEEdNOPzFhvbBlegZ/r45
	 2xfaBSyrjOxruKb/o3kmtrKMpo8olvEumekdQNDRHuaS8N2vt4SDvyHcQtuPJIvgD1
	 zcl43/4ugxqqw==
Date: Tue, 2 Jul 2024 11:51:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: skip flushing log items during push
Message-ID: <20240702185120.GL612460@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-12-hch@lst.de>
 <20240620195142.GG103034@frogsfrogsfrogs>
 <20240621054808.GB15738@lst.de>
 <20240621174645.GF3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240621174645.GF3058325@frogsfrogsfrogs>

On Fri, Jun 21, 2024 at 10:46:45AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 21, 2024 at 07:48:08AM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 20, 2024 at 12:51:42PM -0700, Darrick J. Wong wrote:
> > > > Further with no backoff we don't need to gather huge delwri lists to
> > > > mitigate the impact of backoffs, so we can submit IO more frequently
> > > > and reduce the time log items spend in flushing state by breaking
> > > > out of the item push loop once we've gathered enough IO to batch
> > > > submission effectively.
> > > 
> > > Is that what the new count > 1000 branch does?
> > 
> > That's my interpreation anyway.  I'll let Dave chime in if he disagrees.
> 
> <nod> I'll await a response on this...

<shrug> No response after 11 days, I'll not hold this up further over a
minor point.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_inode.c      | 1 +
> > > >  fs/xfs/xfs_inode_item.c | 6 +++++-
> > > 
> > > Does it make sense to do this for buffer or dquot items too?
> > 
> > Not having written this here is my 2 unqualified cents:
> > 
> > For dquots it looks like it could be easily ported over, but I guess no
> > one has been bothering with dquot performance work for a while as it's
> > also missing a bunch of other things we did to the inode.  But given that
> > according to Dave's commit log the іnode cluster flushing is a big part
> > of this dquots probably aren't as affected anyway as we flush them
> > individually (and there generally are a lot fewer dquot items in the AIL
> > anyway).
> 
> It probably helps that dquot "clusters" are also single fsblocks too.
> 
> > For buf items the buffers are queued up on the on-stack delwri list
> > and written when we flush them.  So we won't ever find already
> > flushing items.
> 
> Oh right, because only the AIL flushes logged buffers to disk.
> 
> --D
> 
