Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C23338B981
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770751203; cv=none; b=XkAm+XzfwS26K6OIXFeE0fShcf8GhcVzRDBEsFHnpULyidvoWNBvQOAlz7tbPw1EcAzfIoc2fxhNJHvWqFCpNBP8IpMZ0wdoQ4YpVfg6bs2UcvG0Bdd2HOS91foSl6cKt4sj4876nqM5/ovD3YeEopHSsY37ZVnDGM7V+6tnc4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770751203; c=relaxed/simple;
	bh=smeOkN0pEoBbEQBOMDYp8EI9S/NuJmtyNPIxdgVqV1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7/n7Rxm9/PfmrdOvsNzbiKIITY5HCFFDP+eNIw+5b4BYXuwyMOA76nCB2/Ngax5mRyfQ576dPkKJ58V+Rxyz0VxIbH8aMffc094ms2kQ1Qy0mrxEsYiT+sosd4sbX5YMvJIcSMpzzNGl9aQ/XK1EGSdQpqTzGKnZpP0YGspBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IBv5z+LB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IBv5z+LB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770751201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yrTZH/JYiu3KRVUuaNiw9UxIiZxh8Yy+qtGjOysCAm8=;
	b=IBv5z+LB1SkmGEFM9GZ+Tt0m+4nUbQ8yfHy7KnsvpMsXhuCNInBDUEsWsmntFgcJJSUdFS
	8kolPTNC4Ic5bdl6PsqWQoRhcj+FqlO7D7aa+emXerjrpQRlxG/cMJTbA8uAG37JniofZR
	ezGcCFz/mWTShJSDUPuX0VOYe5HY8mk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-E4O7bXHEMHyA8l0gQE8kaA-1; Tue,
 10 Feb 2026 14:19:57 -0500
X-MC-Unique: E4O7bXHEMHyA8l0gQE8kaA-1
X-Mimecast-MFC-AGG-ID: E4O7bXHEMHyA8l0gQE8kaA_1770751196
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFAC21955F12;
	Tue, 10 Feb 2026 19:19:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.28])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CD0830001A8;
	Tue, 10 Feb 2026 19:19:55 +0000 (UTC)
Date: Tue, 10 Feb 2026 14:19:53 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] xfs: replace zero range flush with folio batch
Message-ID: <aYuE2a0DdXZAPwXC@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-6-bfoster@redhat.com>
 <aYta8A6dBpjZyb8c@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYta8A6dBpjZyb8c@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Feb 10, 2026 at 08:21:04AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 29, 2026 at 10:50:28AM -0500, Brian Foster wrote:
> > Now that the zero range pagecache flush is purely isolated to
> > providing zeroing correctness in this case, we can remove it and
> > replace it with the folio batch mechanism that is used for handling
> > unwritten extents.
> > 
> > This is still slightly odd in that XFS reports a hole vs. a mapping
> > that reflects the COW fork extents, but that has always been the
> > case in this situation and so a separate issue
> 
> I wish we could fix it eventually.  One thing that came to my mind
> a few times would be to do all writes through the COW fork, and
> instead renaming it a 'staging' or similar fork, because it then
> contains all data not recorded into the inode yet.  But that would
> be a huge lift..
> 

I failed to rework this as an initial step (as discussed in the prior
version of this series), but I got back to playing with it a bit after
posting this version and I think I have a prototype that so far seems to
work on top of this series.

For context, the idea is basically that instead of always reporting COW
fork blocks over data fork holes as a hole mapping, we report it as a
shared/COW mapping when the conditions to require zeroing are met. That
basically means that 1. only when the folio batch is not empty and 2.
only when the mapping is fully within EOF. The caveat to the latter is
that we also have to split at the EOF boundary the same way the existing
zero range code does to trigger post-eof delalloc conversion.

This adds a bit more code in the same area as this series. It doesn't
seem terrible so far, but it was one reason I was wondering if this
perhaps warranted splitting off its own callback. The behavior for zero
range here is unique enough from standard read/write ops such that might
be a readability improvement. Since I'm not the only person with that
thought, I'll take a proper look and see if it's worth a prototype to go
along with the mapping behavior change..

Brian

> The patch itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

