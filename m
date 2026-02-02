Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2162F1FFC
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057266; cv=none; b=C1hFLfkcs1M7yw8dONOly/ZdbMczDVGdU8hpHXwIILXf7HFQWNoYUc1/kuqNjaHRhEBl/dpyuSdrJ7Kv4yG37cI5TTnoIMB1kpGWmiezqMYPgz6mQ42jvp9Os1zQVzbuwn222VIg56b44UGaYAgxPs6gvT5sdi+bPJsp943vKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057266; c=relaxed/simple;
	bh=st2gunRIFmQ1p7JJtTsaRS1xasxYmMpqzB/ZRL8fUYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/kjN/VUIF9D9/2h5rjKOlZyUokvL8EwwTtmzEO+zDJr/oD4nQh8VfmMII3YwsBA3703o4777RFahUmnlxrm5fQzBuCCM72NUxdafeRl77gFtE2aOMcXjPZphH95hPHJT/8PDySeG58y3Mr9CVA4FKccsw3gWJr0aCvLde8IhSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rlfq5/bK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rlfq5/bK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770057264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OWPieg0Bvkioyg2EeqBdekXZF/DTC3okjM25F8ZVq1w=;
	b=Rlfq5/bKZIwj9J5jrbMoGCJGlDxToHaYyxc0qbGpxD1s9QfP7V9fI1rlXHopqRrwefjdzm
	05MFDjEQx9Ana5oaQAbFPblc1zHOExyQQmLEOA0OCbhFZ4aoeoFGPsVd6NElyXNto14cXj
	X6Ndfx5EKepJ2lzE0d/Pz8/0cM0iefA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-1sc3xcvPNBi-w4c044jdtA-1; Mon,
 02 Feb 2026 13:34:18 -0500
X-MC-Unique: 1sc3xcvPNBi-w4c044jdtA-1
X-Mimecast-MFC-AGG-ID: 1sc3xcvPNBi-w4c044jdtA_1770057257
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D18551954204;
	Mon,  2 Feb 2026 18:34:16 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.110])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B90631800577;
	Mon,  2 Feb 2026 18:34:13 +0000 (UTC)
Date: Mon, 2 Feb 2026 13:34:11 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Piyush Patle <piyushpatle228@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+bd5ca596a01d01bfa083@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: handle iterator position advancing beyond current
 mapping
Message-ID: <aYDuI3EqwCmnc9uq@bfoster>
References: <20260202130044.567989-1-piyushpatle228@gmail.com>
 <aYC5Utav-rTKigTw@infradead.org>
 <aYDES-sGwCEr80Z3@casper.infradead.org>
 <aYDLXHqHmkdTL-M0@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYDLXHqHmkdTL-M0@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Feb 02, 2026 at 08:05:48AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 02, 2026 at 03:35:39PM +0000, Matthew Wilcox wrote:
> > On Mon, Feb 02, 2026 at 06:48:50AM -0800, Christoph Hellwig wrote:
> > > On Mon, Feb 02, 2026 at 06:30:44PM +0530, Piyush Patle wrote:
> > > > Closes: https://syzkaller.appspot.com/bug?id=bd5ca596a01d01bfa083
> > > 
> > > This link doesn't work.  And the commit log has zero details of what's
> > > happening either.
> > 
> > Looks like this one:
> > 
> > https://syzkaller.appspot.com/bug?extid=bd5ca596a01d01bfa083
> > 
> > but there's no reproducer.  Looks like it's through the blockdev rather
> > than a filesystem being involved.
> 
> Let's wait for a reproducer.  The fix looks incorrect for anything I
> could think of, so I'd rather fix a real bug.  Given that lack of
> reproducer I'm also not confident that it fixes anything.  The fact
> that the Fixes tag points to a merge commit doesn't really increase
> the trust I have in it either.
> 
> 

+1 to this, FWIW. I've had that syzbot report marked in my inbox
expecting (hoping..) it would eventually spit out a reproducer to help
better characterize the cause.

This patch just appears to copy the warning check and force a lookup
cycle before we trigger it, which I don't think is doing us any favors.
At minimum we should have an understanding of precisely how this
happens.

Brian

