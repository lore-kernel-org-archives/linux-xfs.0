Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BFF447801
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 13:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785246600; cv=none; b=jQqfMEQmkII2GHFYVOMzLRsgt/wBswDHmrDtFXPaI2tFGNY4WThlU94/1x8pwm77vQhsJUMF24DTSdE4IJ7zCa1gvdbzrA3UXyNyKK1hZ12HHL3e8V5Fxr0RVyyP+sKe8eMZaFtS8QNEn2gOPdIjsQ7yIA2Elu/Uu+jICneqnCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785246600; c=relaxed/simple;
	bh=Zt7l5myQ2WXobQN8tGRWBSvTO+sRbD1pPUAXv4U4maU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKirH8hwH0OqP3ONhkjoRHvFbB21QPbHg9unzOWPvbEzNMEXQxZq9jlty4pmrhMKcr6YdOMNy/K7n/VXc1YMlC1NfrB6KzVa5YMGiA6QCF1cKxGI3W2GN5qFBk7vkh2+YBhyOl0xVjMvtbJeEYrFzjnVREt6X69vxn6W8MGdrVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRJwYaQ8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRJwYaQ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785246597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xq5CTHITws8PjVCNXvkWRBi305FHJPXL2e4BqYPiiCQ=;
	b=dRJwYaQ8hK7y/zIRjI7VfeY8prGc3JcLtCXepGxahf0qaAVTvRPH+6SW13Ld+PVRiTZrME
	LnvEERW6vxso5dzWBLmtiBcxNGWjtH+DwlhGar5tMx/HrvZ9FNOTXeEvUbObzZpQ5G6PFZ
	Ox70eC/qMnm7wglzMxlWTClR5yVramA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-511-WEhzMV-CNJSzMZOhlwpung-1; Tue,
 28 Jul 2026 09:49:52 -0400
X-MC-Unique: WEhzMV-CNJSzMZOhlwpung-1
X-Mimecast-MFC-AGG-ID: WEhzMV-CNJSzMZOhlwpung_1785246589
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C949C19560A2;
	Tue, 28 Jul 2026 13:49:47 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.46])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B491404;
	Tue, 28 Jul 2026 13:49:42 +0000 (UTC)
Date: Tue, 28 Jul 2026 09:49:40 -0400
From: Brian Foster <bfoster@redhat.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
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
Message-ID: <amizdHj6ICgP2xFv@bfoster>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727211758.1116539-2-joannelkoong@gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Mon, Jul 27, 2026 at 02:17:38PM -0700, Joanne Koong wrote:
> In preparation for changing iomap to use an in-iter (->iomap_next())
> model, move the iomap_iter() logic out into the new iomap_iter_next()
> helper function.
> 
> iomap_iter_next() is added as an inlined helper so it can be called
> directly by ->iomap_next() implementations where the begin()/end()
> callbacks can be direct calls.
> 
> The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
> also provided to generate the boilerplate ->iomap_next() wrapper
> functions that simply forward to iomap_iter_next() with the appropriate
> begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
> where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
> the case where there is an explicit end() callback.
> 
> No functional change intended. The only code-level difference is that on
> the iomap_end() error path (ret < 0 && !advanced), the old code returned
> with iter.status left as the caller's last value whereas the new code
> zeroes it, but this is not observable in practice as there are no in-tree
> callers that read iter.status after the iteration loop.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
>  include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
>  2 files changed, 147 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index e4a29829591a..66ccb87441ab 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -6,15 +6,6 @@
>  #include <linux/iomap.h>
>  #include "trace.h"
>  
> -static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> -{
> -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> -		folio_batch_release(iter->fbatch);
> -		folio_batch_reinit(iter->fbatch);
> -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> -	}
> -}
> -

So hch forwarded me a bit of Sashiko review feedback that called out a
potential folio batch leak on error returns from iomap_begin() or
iomap_end(). Note that I think the ->iomap_end() variant is currently
not an issue because nothing returns error there, but it should be fixed
regardless.

As such, I have the patch below as a fix based on current master. The
idea here is to account for failures from either callback and also the
fact that XFS may not necessarily transfer the iomap_flags on failure. I
considered a couple other options here, like changing that behavior or
using an iter flag, but I think this is the cleanest option.

However this obviously conflicts with this rework series. This isn't a
major conflict IMO.. I'd probably just do the same thing and include the
batch cleanup in the error/exit path of iomap_iter() (or maybe start
passing ret into iomap_iter_done()), but I would need to reintroduce the
helper above. Also after this series I think this could mean a duplicate
call in the termination case where iomap_iter_continue() would have
cleaned things up, but that is relatively harmless. Maybe there is
something incrementally cleaner, but I'm still wrapping my head around
the factoring here..

But anyways, the main thing I wanted to ask is how folks want to handle
this particular bug..? This rework is invasive and looks mostly reviewed
so I don't want to unnecessarily hold it up. I can rebase on top of this
and leave the patch below for -stable, or avoid the helper churn and
post the patch below on its own and rework it into this, or maybe just
tweak this to leave the helper around and avoid some churn that way..
thoughts?

Brian

--- 8< ---

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..63617ec48250 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,12 +6,18 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Release the iter folio batch. Note that the iomap flag is meant to control
+ * the I/O path for the mapping and may not be set in error situations.
+ */
 static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
+	if (!iter->fbatch)
+		return;
+	iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
+	if (folio_batch_count(iter->fbatch)) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
 }
 
@@ -79,7 +85,7 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 						  olen),
 				advanced, iter->flags, &iter->iomap);
 		if (ret < 0 && !advanced)
-			return ret;
+			goto error;
 	}
 
 	/* detect old return semantics where this would advance */
@@ -110,7 +116,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
 	if (ret < 0)
-		return ret;
+		goto error;
 	iomap_iter_done(iter);
 	return 1;
+
+error:
+	iomap_iter_clean_fbatch(iter);
+	return ret;
 }

