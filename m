Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4977022068F
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596215; cv=none; b=uso43tDMUR6LuqRebzraBaISm844TBgYSCysLMMq/e6NUwFK05H3s1VBt8lxV7n9JwsAISJ8ZquYSx+7t9uzgx4pnPuTBpiJq1PTkKJk71/0HFz9Zh5oG9PhyOjmWPD62IK3vrNYAV9OBPvJXPMJ0WgGjPlxZ3rL+0iYxPMoXMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596215; c=relaxed/simple;
	bh=YEWp1vDRMNWJ863JxQXCwn1rtD70qXBEQo3qZ7yAQAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hezGdA8qFVFdyvF9GNoM4Mau7GySj0spyu8RfQeU+qEWGucKb74IBmOV0ezj1nylxJDBxbpy0xnbCbMg4Qn9hfECpBpiL0udvJ8jfUjAOFhZANYZkBS5X9hDxZo/4W9k6QasfAbL6n+oUwV2Qv9DDgXUwM8utSQ0xLCbRB5YuFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMCKrpLu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMCKrpLu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752596213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RNt1gYF8rhzNdcRcfNFkSyvS8xhryuLLwlnJ0xbg9tE=;
	b=GMCKrpLuNv37D+qb54tEZc7eazqIAQK1stU3h19b8LYHHH0GGGfAflpZvHJQuM3veZrlD7
	j8in3tezyC+7NBOZ+pwzREwIkFrDe/ZPMV1xxLtjH6WghDlITV4noNvHAYQY2OucoaiDxS
	qMPtegwwxYhmbLTqRY00dxyTSAfUkXc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-WBM6xo3aNsmHwaQKp9Ur1A-1; Tue,
 15 Jul 2025 12:16:48 -0400
X-MC-Unique: WBM6xo3aNsmHwaQKp9Ur1A-1
X-Mimecast-MFC-AGG-ID: WBM6xo3aNsmHwaQKp9Ur1A_1752596206
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0B9E18002EC;
	Tue, 15 Jul 2025 16:16:46 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.43])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344B1197702F;
	Tue, 15 Jul 2025 16:16:45 +0000 (UTC)
Date: Tue, 15 Jul 2025 12:20:26 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, hch@infradead.org, willy@infradead.org
Subject: Re: [PATCH v3 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aHZ_yrgspSZPnhp2@bfoster>
References: <20250714204122.349582-1-bfoster@redhat.com>
 <20250714204122.349582-8-bfoster@redhat.com>
 <20250715052444.GP2672049@frogsfrogsfrogs>
 <aHZL55AcNnAD-uAn@bfoster>
 <20250715143041.GN2672029@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715143041.GN2672029@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 15, 2025 at 07:30:41AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 15, 2025 at 08:39:03AM -0400, Brian Foster wrote:
> > On Mon, Jul 14, 2025 at 10:24:44PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 14, 2025 at 04:41:22PM -0400, Brian Foster wrote:
> > > > iomap_zero_range() has to cover various corner cases that are
> > > > difficult to test on production kernels because it is used in fairly
> > > > limited use cases. For example, it is currently only used by XFS and
> > > > mostly only in partial block zeroing cases.
> > > > 
> > > > While it's possible to test most of these functional cases, we can
> > > > provide more robust test coverage by co-opting fallocate zero range
> > > > to invoke zeroing of the entire range instead of the more efficient
> > > > block punch/allocate sequence. Add an errortag to occasionally
> > > > invoke forced zeroing.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
> > > >  fs/xfs/xfs_error.c           |  3 +++
> > > >  fs/xfs/xfs_file.c            | 26 ++++++++++++++++++++------
> > > >  3 files changed, 26 insertions(+), 7 deletions(-)
> > > > 
> > ...
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 0b41b18debf3..c865f9555b77 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -27,6 +27,8 @@
> > > >  #include "xfs_file.h"
> > > >  #include "xfs_aops.h"
> > > >  #include "xfs_zone_alloc.h"
> > > > +#include "xfs_error.h"
> > > > +#include "xfs_errortag.h"
> > > >  
> > > >  #include <linux/dax.h>
> > > >  #include <linux/falloc.h>
> > > > @@ -1269,13 +1271,25 @@ xfs_falloc_zero_range(
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > -	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> > > > -	if (error)
> > > > -		return error;
> > > > +	/*
> > > > +	 * Zero range implements a full zeroing mechanism but is only used in
> > > > +	 * limited situations. It is more efficient to allocate unwritten
> > > > +	 * extents than to perform zeroing here, so use an errortag to randomly
> > > > +	 * force zeroing on DEBUG kernels for added test coverage.
> > > > +	 */
> > > > +	if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
> > > > +			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
> > > > +		error = xfs_zero_range(XFS_I(inode), offset, len, ac, NULL);
> > > 
> > > Isn't this basically the ultra slow version fallback version of
> > > FALLOC_FL_WRITE_ZEROES ?
> > > 
> > 
> > ~/linux$ git grep FALLOC_FL_WRITE_ZEROES
> > ~/linux$ 
> > 
> > IIRC write zeroes is intended to expose fast hardware (physical) zeroing
> > (i.e. zeroed written extents)..? If so, I suppose you could consider
> > this a fallback of sorts. I'm not sure what write zeroes is expected to
> > do in the unwritten extent case, whereas iomap zero range is happy to
> > skip those mappings unless they're already dirty in pagecache.
> 
> Sorry, forgot that they weren't wiring anything up in xfs so it never
> showed up here:
> https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
> 
> Basically they want to avoid the unwritten extent conversion overhead by
> providing a way to preallocate written zeroed extents and sending magic
> commands to hardware that unmaps LBAs in such a way that rereads return
> zero.
> 

Ack.. I'd seen that before, but hadn't looked too closely and wasn't
sure what the status was.

> > Regardless, the purpose of this patch is not to add support for physical
> > zeroing, but rather to increase test coverage for the additional code on
> > debug kernels because the production use case tends to be more limited.
> > This could easily be moved/applied to write zeroes if it makes sense in
> > the future and test infra grows support for it.
> 
> <nod> On second look, I don't think the new fallocate flag allows for
> letting the kernel do pagecache zeroing + flush.  Admittedly that would
> be beside the point (and userspaces already do that anyway).
> 

Ok. Thanks for the reviews.

Brian

> Anyway enough mumbling from me,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > +	} else {
> > > > +		error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
> > > > +		if (error)
> > > > +			return error;
> > > >  
> > > > -	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> > > > -	offset = round_down(offset, blksize);
> > > > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > > > +		len = round_up(offset + len, blksize) -
> > > > +			round_down(offset, blksize);
> > > > +		offset = round_down(offset, blksize);
> > > > +		error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> > > > +	}
> > > >  	if (error)
> > > >  		return error;
> > > >  	return xfs_falloc_setsize(file, new_size);
> > > > -- 
> > > > 2.50.0
> > > > 
> > > > 
> > > 
> > 
> > 
> 

