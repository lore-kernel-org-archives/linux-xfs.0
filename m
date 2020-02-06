Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F57C35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 23:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1C320730
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 23:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfNFXf00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgBFXvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 18:51:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726502AbgBFXvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 18:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581033090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0W0LWfWw/WGgN81jT5NiZ2GMI7OKNdKdktAwrck/540=;
        b=XfNFXf00xg19M7/efWy/WEj5WbZDN6gctEYgm7L28n35OhNir28NQxmhlASzUk0KIeriRR
        xozVO8KRFXETTh+hM+6HLtexWvqC1/woVglADV7R7/+aUurEPcVN6xj1TKti9oqc3H5gJs
        3yh7GHqGpoYvMKqPM1JZqZbr/Wvhabc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-rZI0o3eiPNypt2IrunH6sQ-1; Thu, 06 Feb 2020 18:51:28 -0500
X-MC-Unique: rZI0o3eiPNypt2IrunH6sQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 827DE1007270;
        Thu,  6 Feb 2020 23:51:27 +0000 (UTC)
Received: from redhat.com (ovpn-123-99.rdu2.redhat.com [10.10.123.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C9B45C1D8;
        Thu,  6 Feb 2020 23:51:27 +0000 (UTC)
Date:   Thu, 6 Feb 2020 17:51:25 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xchk_xattr_listent() fix context->seen_enough to
 -ECANCELED
Message-ID: <20200206235125.GA3570914@redhat.com>
References: <20200205190455.1834330-1-billodo@redhat.com>
 <20200206230731.GH6870@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206230731.GH6870@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 06, 2020 at 03:07:31PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 05, 2020 at 01:04:55PM -0600, Bill O'Donnell wrote:
> > Commit e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
> > replaced *_ITER_ABORT values with -ECANCELED. The replacement
> > in the case of scrub/attr.c xchk_xattr_listent() is in
> > error (context->seen_enough = 1;). Instead of '1', use
> > the intended -ECANCELED.
> > 
> > Fixes: e7ee96dfb8c (xfs: remove all *_ITER_ABORT values)
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/scrub/attr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index d9f0dd444b80..5d0590f78973 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -171,7 +171,7 @@ xchk_xattr_listent(
> >  					     args.blkno);
> >  fail_xref:
> >  	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > -		context->seen_enough = 1;
> 
> Hmm.  The attr list functions do:
> 
> 	if (context->seen_enough)
> 		break;
> 
> to stop iteration of the attributes.  Any nonzero value will work,
> positive or negative.  Further down in the scrub/attr.c, xchk_xattr
> does:
> 
> 	/* Did our listent function try to return any errors? */
> 	if (sx.context.seen_enough < 0)
> 		error = sx.context.seen_enough;
> 
> Which means that if seen_enough is set to a negative value, we'll return
> that negative value all the way back to userspace, which means that the
> userspace buffer is not updated and xfs_scrub will think there was a
> runtime error.
> 
> > +		context->seen_enough = -ECANCELED;
> 
> So this will cause xfs_scrub to abort with "Operation Canceled" if it
> found a corruption error.  The patch I sent to the list had -ECANCELED,
> but then I noticed the scrub breakage and changed it to 1 before
> committing.  Other parts of the attr code use 1 to stop an attr walk
> without returning errors to userspace.

That is what had me confused. 

> 
> Perhaps it's time to replace that novel use of "1" (and audit all the
> branching and whatnot) with -ECANCELED so that we can go on cargoculting
> negative int errors in peace.
> 
> (*UGH* I remembered that I was the one who applied negative int error
> semantics to seen_enough in the first place; before that, its meaning
> was purely boolean.  It's still screaming for a cleanup though...)

Agreed.
Thanks-
Bill

> --D
> 
> >  	return;
> >  }
> >  
> > -- 
> > 2.24.1
> > 
> 

