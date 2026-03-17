Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111E126ED48
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773754601; cv=none; b=WzH1KIAq8D/tP68MY+XnMvwSm80oT5Mcm1w4EbUg7yP4GSX7apnLIEQbFPsnf4ZsKvYLO4+YF73UIMJTSSDW+WTAkh90SJ/amDAQlRb447D085SuLhviOwTzF7aKhIREpilfzszTKCYnesxWW34zGfALIg57lK1Pac1xc3VlsdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773754601; c=relaxed/simple;
	bh=X8g/hMzZ3+gb3FJKr6zaBdEJeBMiHpl0N15vo2PJvqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMpXuFuK96QUp2XQfsAfnzGNTa2KtPjXk6CzKdPOMctji7U17Upv6t/+DYWJjTKLOro/8lijnbnCJhobAq5PSCGqB/e8sgYVnGWaiqP97qolOQIFTccofOj0QSo1lkLsSwNfWLlumdKLnpIKJIswLp4f2+akoCdJ1OQ/9a/H6lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Os2ooi8n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Os2ooi8n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773754599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SzlTZXE7JFST2EzZ+y04z1vGxuYUymdym62f08xP7ck=;
	b=Os2ooi8ntkpBsg4vSKUO7CUT80Q8am3C99uz8WHhx7gotpLGMaRtw/4Rvfe9hqB0FZFYuc
	ZQutWngAGY2Pn574RRgaRrIrgUYGrHeC/0fPq6IA09AQkIV5LYWl/+2cev40USYhLq8+fa
	tNn/83j9sL8C7j4xjmMoKCsVvTi6VnU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-GV_ucursMLKmpVB9Ady4pg-1; Tue,
 17 Mar 2026 09:36:37 -0400
X-MC-Unique: GV_ucursMLKmpVB9Ady4pg-1
X-Mimecast-MFC-AGG-ID: GV_ucursMLKmpVB9Ady4pg_1773754596
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A74318002DD;
	Tue, 17 Mar 2026 13:36:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.178])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D0E319540C4;
	Tue, 17 Mar 2026 13:36:35 +0000 (UTC)
Date: Tue, 17 Mar 2026 09:36:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: buffer cache simplification v4
Message-ID: <ablY4bjxZs54FWeS@bfoster>
References: <20260316154216.1598410-1-hch@lst.de>
 <ablFUL_cBSJBJHgp@bfoster>
 <20260317125604.GA29925@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317125604.GA29925@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Mar 17, 2026 at 01:56:04PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 17, 2026 at 08:13:04AM -0400, Brian Foster wrote:
> > On Mon, Mar 16, 2026 at 04:41:32PM +0100, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series has a few old patches that simplify the LRU handling, and
> > > moves back to only having a per-buftarg hash now that the buffer hash
> > > is using the scalable rhashtable.  While some of this looks like
> > > performance work, performance and scalability is unchanged even on the
> > > 80 core dual socket system I test this on.  Besides cleaning up the
> > > code nice, it also happens to fix a syzcaller reported use after free
> > > during buffer shutdown, which happened incidentally because of how the
> > > tear down of the buftarg vs the perag structures is handled.
> > > 
> > > Changes since v3:
> > >  - split the change to handling how referenced buffers on the LRU
> > >    are handled into a separate patch
> > > 
> > 
> > It looks like there's a patch ordering problem or something here. It
> > doesn't apply to master, and looks like patch 1 is trying to modify
> > hunks that don't yet exist. A local rebase issue related to reordering
> > the change in patch 3 perhaps..?
> 
> This is against the xfs for-next tree (commit
> f8544b654f22b1138ba12bc0971a96963b20311d)
> 

Still doesn't apply.. I.e., here's a hunk from patch 1:

@@ -154,7 +155,7 @@ struct xfs_buf {

        xfs_daddr_t             b_rhash_key;    /* buffer cache index */
        int                     b_length;       /* size of buffer in BBs */
-       int                     b_hold;         /* reference count */
+       struct lockref          b_lockref;      /* refcount + lock */
        atomic_t                b_lru_ref;      /* lru reclaim ref count */
        xfs_buf_flags_t         b_flags;        /* status flags */
        struct semaphore        b_sema;         /* semaphore for lockables */

Where is b_hold an int? AFAICT that was part of the first patch in the
previous version, which isn't included here.

Brian

