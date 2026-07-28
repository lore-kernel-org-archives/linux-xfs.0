Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413ED47255F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785265986; cv=none; b=DX/B6s9VSIs7niaa9CTPMyURo26VwvoX6tNkVOIRz+VJY5Rr7Aq5kACZxLrL9a7TYohI1xbEr7a+VCSbZdzVuT2CFyu35PLhxgUntULARL9fbKJCM5OnIRaUSzVeIA4scHED9bc9KMf7C0LeBXosT26lSy8ftU98GOuwcr0SwuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785265986; c=relaxed/simple;
	bh=BocaYVDOd2uRPxJPHwcfV4M/0jSqJL3WDeZViOZ+wAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aemArfA5iqfJzG3JCI6+YSN4jU4j4kXGywUUqCQv21QcNYjb5rCiBfkPfVeL01hTCTVfAWAjY5zM2L8+yuF/cKfaVdFJ+kMoA8zre+xLMASapnylojwk0RSmhDnxTPjCu7Yyhau0QENVpfw/vXBNM4l/nOSc6SojXlJLeLxAA0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNoLckyK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNoLckyK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785265976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nEMiVNtCUvqNNIVLoHIfPXUTyF7UcNCria85IBZ9edc=;
	b=jNoLckyKL5+VKGJle58b41NUXWyL15XvTWiuD5CJjOHGV2OJzZfgUn/7VDfKjSwkmsdYvN
	3b8W1HNRmZ1n4Kr8mf3ESAcLBPgTXT445NhknYWXOynp36KryXXZ3DLj678X4npxwndLek
	JHf1XjFvY5jo2uPJEkWbHdBA8hFUQHY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-ZeI836YcPDaxjJIBjIsNDw-1; Tue,
 28 Jul 2026 15:12:53 -0400
X-MC-Unique: ZeI836YcPDaxjJIBjIsNDw-1
X-Mimecast-MFC-AGG-ID: ZeI836YcPDaxjJIBjIsNDw_1785265972
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2127B180057B;
	Tue, 28 Jul 2026 19:12:52 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E169B19560AB;
	Tue, 28 Jul 2026 19:12:50 +0000 (UTC)
Date: Tue, 28 Jul 2026 15:12:48 -0400
From: Brian Foster <bfoster@redhat.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH] iomap: release the folio batch on iomap callback failures
Message-ID: <amj_MJOEzLor4jMW@bfoster>
References: <20260728183005.92395-1-bfoster@redhat.com>
 <CAJnrk1Z=qohEjesFFn-YbmU0mqSPkMH_Jy+E6qSCw4pM8niPhw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Z=qohEjesFFn-YbmU0mqSPkMH_Jy+E6qSCw4pM8niPhw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 28, 2026 at 12:07:10PM -0700, Joanne Koong wrote:
> On Tue, Jul 28, 2026 at 11:30 AM Brian Foster <bfoster@redhat.com> wrote:
> >
> > A sashiko review of an unrelated patch points out that the folio
> > batch mechanism used for iomap zero range fails to release the batch
> > in a couple error scenarios. If either calls to ->iomap_end() or
> > ->iomap_begin() fail, the direct return paths bypass the batch
> > cleanup.
> >
> > The ->iomap_end() case is not a practical issue at the moment
> > because there is no user of the mechanism that returns an error from
> > this path. The ->iomap_begin() case is theoretically possible
> > because XFS can invoke the fill helper and error out at various
> > points thereafter. This subtly complicates things because XFS does
> > not transfer iomap_flags to the iomap data structure in the error
> > path.
> >
> > To deal with both of these issues, first make sure to invoke the
> > cleanup helper in the error path for either fs callback. Second,
> > update the helper to clear the flag unconditionally and release the
> > batch so long as it is populated. This more clearly delineates the
> > purpose of the flag to control the I/O path and not necessarily the
> > status of the fbatch, so add a comment around this as well.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Assisted-by: LLM
> > Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >
> > As noted here[1], I'm aware this conflicts with the outstanding iomap
> > iter rework. I'm happy to rebase onto that if that is ultimately
> > preferred. I've got at least one vote to get this in sooner, so this
> > version is based on 7.2-rc5.
> >
> 
> Hi Brian,
> 
> As I understand your analysis of the bug in [1], given that it's an
> unlikely / second-order scenario nobody is hitting in reality, maybe
> it'd be easiest if I fold this patch into the iomap iter rework series
> as a preparatory patch (keeping your authorship and Fixes: tag), make
> the needed changes in the iomap iter series to be compatible with your
> patch, and then submit everything together to the vfs-7.3.iomap branch
> as v5 of the series? I think that avoids the nontrivial merge conflict
> Christian/Stephen would have to deal with.
> 

That's perfectly fine with me if you're Ok with doing that and nobody
otherwise objects.

Brian

> Alternatively, if you prefer to have this as part of 7.2, I can send a
> v5 of the series to try minimizing the conflict, and then send
> Christian or Stephen a diff for how to resolve the merge when they hit
> it.
> 
> Thanks,
> Joanne
> 
> [1] https://lore.kernel.org/linux-fsdevel/amjztG-DisHYbV9W@bfoster/
> 

