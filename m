Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61BF2E03EF
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582930; cv=none; b=YCG/HGen7wFiXJs5n/1N7ISmb5Qu3+6ppmVNWQcIpveJhiA+wwUOUhtNM7qLNBJFMMR+vXT7hFrhkXhjx4yLnVCYq8wOl9T/tn7c/WtG9tgPJcSE5YhiMQSJMsie3I09de0uu5u90UgnQI4CHTumlKNkNPWChOrqMrm+5bTMAPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582930; c=relaxed/simple;
	bh=Qtdak9JNN7BaWa4bDojpMglgNmQkIlOTttetk6g27OQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCqIQue0ZsgqQ2fuvQnxqw6B1250xJWihvzISwpIh1Qsnmdtjn4OU0W7xVSAHbLyK6IFUvmwO39/AYXb8iJZv1atQyTVR8Z6MiBLNKcpIMt1T0fOd3f3wAVCr0AZfWr41fTHWPo5YBiJomjrZDwca3mpgoMilc7niBYbVDtw1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NnVvDVh+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NnVvDVh+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752582927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCgiUZcwT6C9cPLH2UufX6wt62EgnsmD7bHGYbxxqSQ=;
	b=NnVvDVh+8MDVwKQomDQFeNEBZDjb5edDERmgjs9iGKkHzUFYq9TPW8xKgYVbA3MR/x1Aav
	/tOeBJBnN8OIPdfUEiGLvp1Hiu+axeasE3CvkuDUefD1Vu4lZQbNjRsoPW3c9hnIqYs7OB
	cHvf4tdNstxQFYc8Gi7y1M23GSrFKa0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-WhJq1xnwNICfvmFowoSl_A-1; Tue,
 15 Jul 2025 08:35:24 -0400
X-MC-Unique: WhJq1xnwNICfvmFowoSl_A-1
X-Mimecast-MFC-AGG-ID: WhJq1xnwNICfvmFowoSl_A_1752582923
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16F7519560BA;
	Tue, 15 Jul 2025 12:35:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A98B7180045B;
	Tue, 15 Jul 2025 12:35:21 +0000 (UTC)
Date: Tue, 15 Jul 2025 08:39:03 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, hch@infradead.org, willy@infradead.org
Subject: Re: [PATCH v3 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aHZL55AcNnAD-uAn@bfoster>
References: <20250714204122.349582-1-bfoster@redhat.com>
 <20250714204122.349582-8-bfoster@redhat.com>
 <20250715052444.GP2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715052444.GP2672049@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Jul 14, 2025 at 10:24:44PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 14, 2025 at 04:41:22PM -0400, Brian Foster wrote:
> > iomap_zero_range() has to cover various corner cases that are
> > difficult to test on production kernels because it is used in fairly
> > limited use cases. For example, it is currently only used by XFS and
> > mostly only in partial block zeroing cases.
> > 
> > While it's possible to test most of these functional cases, we can
> > provide more robust test coverage by co-opting fallocate zero range
> > to invoke zeroing of the entire range instead of the more efficient
> > block punch/allocate sequence. Add an errortag to occasionally
> > invoke forced zeroing.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
> >  fs/xfs/xfs_error.c           |  3 +++
> >  fs/xfs/xfs_file.c            | 26 ++++++++++++++++++++------
> >  3 files changed, 26 insertions(+), 7 deletions(-)
> > 
...
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 0b41b18debf3..c865f9555b77 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -27,6 +27,8 @@
> >  #include "xfs_file.h"
> >  #include "xfs_aops.h"
> >  #include "xfs_zone_alloc.h"
> > +#include "xfs_error.h"
> > +#include "xfs_errortag.h"
> >  
> >  #include <linux/dax.h>
> >  #include <linux/falloc.h>
> > @@ -1269,13 +1271,25 @@ xfs_falloc_zero_range(
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> > -	if (error)
> > -		return error;
> > +	/*
> > +	 * Zero range implements a full zeroing mechanism but is only used in
> > +	 * limited situations. It is more efficient to allocate unwritten
> > +	 * extents than to perform zeroing here, so use an errortag to randomly
> > +	 * force zeroing on DEBUG kernels for added test coverage.
> > +	 */
> > +	if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
> > +			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
> > +		error = xfs_zero_range(XFS_I(inode), offset, len, ac, NULL);
> 
> Isn't this basically the ultra slow version fallback version of
> FALLOC_FL_WRITE_ZEROES ?
> 

~/linux$ git grep FALLOC_FL_WRITE_ZEROES
~/linux$ 

IIRC write zeroes is intended to expose fast hardware (physical) zeroing
(i.e. zeroed written extents)..? If so, I suppose you could consider
this a fallback of sorts. I'm not sure what write zeroes is expected to
do in the unwritten extent case, whereas iomap zero range is happy to
skip those mappings unless they're already dirty in pagecache.

Regardless, the purpose of this patch is not to add support for physical
zeroing, but rather to increase test coverage for the additional code on
debug kernels because the production use case tends to be more limited.
This could easily be moved/applied to write zeroes if it makes sense in
the future and test infra grows support for it.

Brian

> --D
> 
> > +	} else {
> > +		error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> > +		if (error)
> > +			return error;
> >  
> > -	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> > -	offset = round_down(offset, blksize);
> > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > +		len = round_up(offset + len, blksize) -
> > +			round_down(offset, blksize);
> > +		offset = round_down(offset, blksize);
> > +		error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > +	}
> >  	if (error)
> >  		return error;
> >  	return xfs_falloc_setsize(file, new_size);
> > -- 
> > 2.50.0
> > 
> > 
> 

