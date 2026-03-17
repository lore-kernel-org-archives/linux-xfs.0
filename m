Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F7E3BD254
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749594; cv=none; b=HQUyMbcHHQbuLxelYcY0JlPWsvqrPb1nB62WmEXzVh0poEhAeCUYhedJcSEZaR6P5G3VxJZJWWrgwe6zmrEHmOg4cceP0Q8H2uFl77NDf3US38U87XXKQaWZaF6Pge3KFShngPb36OiouDFq+sSaVDW0VZfz+dDPAfeFxXD1OOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749594; c=relaxed/simple;
	bh=j2+gMezO+EJHDjOx4g6mDUGFKpIz1DGOvMaSdGa/Xn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApYp7SywEcAjPH1+1NOr6DbWt6KQnNeZPhLaeYGuf8sPw3rzSrNwbY0lJnQ7oZj1clPgAsjUoF/d3Vqv5azIH4SarfgTurUkHRfS4LkIgkiA9MxrsOkkDL8KNujZmcfrnOlRpWN+z9e4mFJ/QwWKEnHT2j1+C+yqzKwQSy9sKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZwGtneSF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZwGtneSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773749592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xjElnualtUEiUWiSmPb+BX2Xj9BtdgYxsyYH/MUOdBs=;
	b=ZwGtneSF63WhDSYMAT+rMlzDYSUSDTKI6iPEirzayTD94gzuVbK45124yxdoehxLBOlOrA
	pj3/odqycJ4uluBIkGMFRDQ+1eOedvgTvSfr8gVrc4JmO34X9+XkbB2dYRoGd++GSNL2yd
	22Gw0WT5vphWCqeoypKmAN9TtfsJyTc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-U5RxsatIMdSK9L7pK0KPRw-1; Tue,
 17 Mar 2026 08:13:09 -0400
X-MC-Unique: U5RxsatIMdSK9L7pK0KPRw-1
X-Mimecast-MFC-AGG-ID: U5RxsatIMdSK9L7pK0KPRw_1773749588
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4439A1800281;
	Tue, 17 Mar 2026 12:13:08 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.178])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 755B53000223;
	Tue, 17 Mar 2026 12:13:07 +0000 (UTC)
Date: Tue, 17 Mar 2026 08:13:04 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: buffer cache simplification v4
Message-ID: <ablFUL_cBSJBJHgp@bfoster>
References: <20260316154216.1598410-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316154216.1598410-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Mar 16, 2026 at 04:41:32PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series has a few old patches that simplify the LRU handling, and
> moves back to only having a per-buftarg hash now that the buffer hash
> is using the scalable rhashtable.  While some of this looks like
> performance work, performance and scalability is unchanged even on the
> 80 core dual socket system I test this on.  Besides cleaning up the
> code nice, it also happens to fix a syzcaller reported use after free
> during buffer shutdown, which happened incidentally because of how the
> tear down of the buftarg vs the perag structures is handled.
> 
> Changes since v3:
>  - split the change to handling how referenced buffers on the LRU
>    are handled into a separate patch
> 

It looks like there's a patch ordering problem or something here. It
doesn't apply to master, and looks like patch 1 is trying to modify
hunks that don't yet exist. A local rebase issue related to reordering
the change in patch 3 perhaps..?

Brian

> Changes since v2:
>  - mark b_hold as signed in patch 1 before removing it in patch 2
>  - document the changed locking in xfs_buf_rele_cached.
> 
> Changes since v2:
>  - add more details and a link to a commit message
> 
> Diffstat:
>  libxfs/xfs_ag.c |   13 ----
>  libxfs/xfs_ag.h |    2 
>  xfs_buf.c       |  148 ++++++++++++++++++++------------------------------------
>  xfs_buf.h       |   14 +----
>  xfs_buf_mem.c   |   11 ----
>  xfs_trace.h     |   10 +--
>  6 files changed, 66 insertions(+), 132 deletions(-)
> 

