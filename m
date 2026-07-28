Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE6A43304E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 18:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263047; cv=none; b=TTnhQfzdaGrcqJQl/+maGeFHk6DrtTqAgz1ES3VhVvYhJl2qQoNC5ky0pVEA6ReEkMWxocIGxzm0vVJF5rOFkDvRqHyi2rwwfk/FMaWAxUGclrlnbzHpxgm2XxKJuQIvny+1ic96skZkb3YtCHeHmZ7KjZh106U3apivrQP/ATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263047; c=relaxed/simple;
	bh=/Ud0nKgsx+2/j59sb1lxhbRYs8GP79+nuF3MyjEG7Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTjmHZFMxF0SD1hfqPmuzrRSUcKvEFlWrrhMAYE3t2OJgWOIBteWIET5a/YkvlH5URnkBE0uc58QqLS0cbUzDZZ2tAoXDlbsQj5W2w4Zq2tv+tTOXD76THrkorVtWEjBn9hpzizzUiIRyJgjfVFEAyngxLvEu2t+K22zYnzrq6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FR6FzErh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FR6FzErh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785263044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B27/YpU+FOtDt/oAyl6DE9vSQRm3TZo5yhFd/fMG6UE=;
	b=FR6FzErhu2+KOe9FgfRuRKq8H8rG4RAkHyMYaZetPCW/8pDYT3vPz+xUgM2MuPLUd7jB4M
	Mn1hDBXJXBHZpsYpebb47o/kiSrDYyW35kNA9QQJgwskCmtaab1icN2U988AIjUndNESvk
	q4cl7y3h84+23+79ly8DyuhLFiK58lg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-YhckqFiSN2exhrMC2OYhug-1; Tue,
 28 Jul 2026 14:24:00 -0400
X-MC-Unique: YhckqFiSN2exhrMC2OYhug-1
X-Mimecast-MFC-AGG-ID: YhckqFiSN2exhrMC2OYhug_1785263037
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46C7E1956055;
	Tue, 28 Jul 2026 18:23:56 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 145A7195608A;
	Tue, 28 Jul 2026 18:23:50 +0000 (UTC)
Date: Tue, 28 Jul 2026 14:23:48 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Christian Brauner <brauner@kernel.org>, hch@lst.de,
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com,
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>, tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 01/21] iomap: split iomap_iter() logic into
 iomap_iter_next()
Message-ID: <amjztG-DisHYbV9W@bfoster>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-2-joannelkoong@gmail.com>
 <amizdHj6ICgP2xFv@bfoster>
 <20260728155508.GT2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728155508.GT2901224@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Jul 28, 2026 at 08:55:08AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 28, 2026 at 09:49:40AM -0400, Brian Foster wrote:
> > On Mon, Jul 27, 2026 at 02:17:38PM -0700, Joanne Koong wrote:
> > > In preparation for changing iomap to use an in-iter (->iomap_next())
> > > model, move the iomap_iter() logic out into the new iomap_iter_next()
> > > helper function.
> > > 
> > > iomap_iter_next() is added as an inlined helper so it can be called
> > > directly by ->iomap_next() implementations where the begin()/end()
> > > callbacks can be direct calls.
> > > 
> > > The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
> > > also provided to generate the boilerplate ->iomap_next() wrapper
> > > functions that simply forward to iomap_iter_next() with the appropriate
> > > begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
> > > where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
> > > the case where there is an explicit end() callback.
> > > 
> > > No functional change intended. The only code-level difference is that on
> > > the iomap_end() error path (ret < 0 && !advanced), the old code returned
> > > with iter.status left as the caller's last value whereas the new code
> > > zeroes it, but this is not observable in practice as there are no in-tree
> > > callers that read iter.status after the iteration loop.
> > > 
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
> > >  include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
> > >  2 files changed, 147 insertions(+), 78 deletions(-)
> > > 
> > > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > > index e4a29829591a..66ccb87441ab 100644
> > > --- a/fs/iomap/iter.c
> > > +++ b/fs/iomap/iter.c
> > > @@ -6,15 +6,6 @@
> > >  #include <linux/iomap.h>
> > >  #include "trace.h"
> > >  
> > > -static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> > > -{
> > > -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> > > -		folio_batch_release(iter->fbatch);
> > > -		folio_batch_reinit(iter->fbatch);
> > > -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> > > -	}
> > > -}
> > > -
> > 
> > So hch forwarded me a bit of Sashiko review feedback that called out a
> > potential folio batch leak on error returns from iomap_begin() or
> > iomap_end(). Note that I think the ->iomap_end() variant is currently
> > not an issue because nothing returns error there, but it should be fixed
> > regardless.
> > 
> > As such, I have the patch below as a fix based on current master. The
> > idea here is to account for failures from either callback and also the
> > fact that XFS may not necessarily transfer the iomap_flags on failure. I
> > considered a couple other options here, like changing that behavior or
> > using an iter flag, but I think this is the cleanest option.
> > 
> > However this obviously conflicts with this rework series. This isn't a
> > major conflict IMO.. I'd probably just do the same thing and include the
> > batch cleanup in the error/exit path of iomap_iter() (or maybe start
> > passing ret into iomap_iter_done()), but I would need to reintroduce the
> > helper above. Also after this series I think this could mean a duplicate
> > call in the termination case where iomap_iter_continue() would have
> > cleaned things up, but that is relatively harmless. Maybe there is
> > something incrementally cleaner, but I'm still wrapping my head around
> > the factoring here..
> > 
> > But anyways, the main thing I wanted to ask is how folks want to handle
> > this particular bug..? This rework is invasive and looks mostly reviewed
> > so I don't want to unnecessarily hold it up. I can rebase on top of this
> > and leave the patch below for -stable, or avoid the helper churn and
> > post the patch below on its own and rework it into this, or maybe just
> > tweak this to leave the helper around and avoid some churn that way..
> > thoughts?
> 
> From my 30000ft view I'd say push the folio leak fix to linus ASAP for
> 7.2 and work out the merge conflict resolution in for-next and send that
> to broonie/linus for 7.3.  But I'm not sure if people are actually
> hitting this and not realizing it; or if this is a fix for a theoretical
> problem.
> 

Sounds good to me, I'll post the current patch shortly.

I don't think anybody is actually hitting this in reality; it just came
from a Sashiko review. I had an LLM walk through and try and tell me
what error paths could lead to this in practice and it basically
narrowed it down to the startblock check in xfs_bmbt_to_iomap(). When
pressed further from there, it says this is mutually exclusive with a
populated batch in practice due to earlier validation at the time the
extents are read in from disk.

I'm not sure I trust the analysis with 100% certainty, but all in all it
seems like an unlikely or second order (i.e. memory corruption, etc.)
error scenario.

Brian

> --D
> 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index e4a29829591a..63617ec48250 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
> > @@ -6,12 +6,18 @@
> >  #include <linux/iomap.h>
> >  #include "trace.h"
> >  
> > +/*
> > + * Release the iter folio batch. Note that the iomap flag is meant to control
> > + * the I/O path for the mapping and may not be set in error situations.
> > + */
> >  static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> >  {
> > -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> > +	if (!iter->fbatch)
> > +		return;
> > +	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> > +	if (folio_batch_count(iter->fbatch)) {
> >  		folio_batch_release(iter->fbatch);
> >  		folio_batch_reinit(iter->fbatch);
> > -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> >  	}
> >  }
> >  
> > @@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  						  olen),
> >  				advanced, iter->flags, &iter->iomap);
> >  		if (ret < 0 && !advanced)
> > -			return ret;
> > +			goto error;
> >  	}
> >  
> >  	/* detect old return semantics where this would advance */
> > @@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
> >  			       &iter->iomap, &iter->srcmap);
> >  	if (ret < 0)
> > -		return ret;
> > +		goto error;
> >  	iomap_iter_done(iter);
> >  	return 1;
> > +
> > +error:
> > +	iomap_iter_clean_fbatch(iter);
> > +	return ret;
> >  }
> > 
> > 
> 

