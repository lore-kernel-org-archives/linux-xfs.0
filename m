Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F05C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E2664E33
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhBCSGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:06:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232682AbhBCSD2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 13:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612375321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RtzrHmvuTkLVaRCZI2Pdj/UsmzG9RetkXfYHmb99qCU=;
        b=CP1DbPRsLqdJIOJUF7ZZaxhGmT4NkpJ2xqV2El319is7+NCBlx1vhSIfhPPJnjbT4HNazU
        yQhUOihKi5P6inB+/zP+NXfnYTWC7o+d63AfJivWOBLX+blv9qzfvSCRYWlPwzhCwNY5cf
        ERvVdIKAg36rUBv8jK51AZis0yLCLD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-KJlICUmeMSOMKLVn-hZ9Lw-1; Wed, 03 Feb 2021 13:01:58 -0500
X-MC-Unique: KJlICUmeMSOMKLVn-hZ9Lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4454B1084452;
        Wed,  3 Feb 2021 18:01:48 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DC8658899;
        Wed,  3 Feb 2021 18:01:42 +0000 (UTC)
Date:   Wed, 3 Feb 2021 13:01:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v6 7/7] xfs: add error injection for per-AG resv failure
 when shrinkfs
Message-ID: <20210203180140.GI3647012@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-8-hsiangkao@redhat.com>
 <20210203142359.GC3647012@bfoster>
 <20210203150132.GB935062@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203150132.GB935062@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 11:01:32PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Wed, Feb 03, 2021 at 09:23:59AM -0500, Brian Foster wrote:
> > On Tue, Jan 26, 2021 at 08:56:21PM +0800, Gao Xiang wrote:
> > > per-AG resv failure after fixing up freespace is hard to test in an
> > > effective way, so directly add an error injection path to observe
> > > such error handling path works as expected.
> > > 
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.c       | 5 +++++
> > >  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
> > >  fs/xfs/xfs_error.c           | 2 ++
> > >  3 files changed, 10 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > > index c6e68e265269..5076913c153f 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.c
> > > +++ b/fs/xfs/libxfs/xfs_ag.c
> > > @@ -23,6 +23,7 @@
> > >  #include "xfs_ag_resv.h"
> > >  #include "xfs_health.h"
> > >  #include "xfs_error.h"
> > > +#include "xfs_errortag.h"
> > >  #include "xfs_bmap.h"
> > >  #include "xfs_defer.h"
> > >  #include "xfs_log_format.h"
> > > @@ -559,6 +560,10 @@ xfs_ag_shrink_space(
> > >  	be32_add_cpu(&agf->agf_length, -len);
> > >  
> > >  	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > > +
> > > +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
> > > +		err2 = -ENOSPC;
> > > +
> > 
> > Seems reasonable, but I feel like this could be broadened to serve as a
> > generic perag reservation error tag. I suppose we might not be able to
> > use it on a clean mount, but perhaps it could be reused for growfs and
> > remount. Hm?
> 
> I think it could be done in that way, yet currently the logic is just to
> verify the shrink error handling case above rather than extend to actually
> error inject per-AG reservation for now... I could rename the errortag
> for later reuse (some better naming? I'm not good at this...) in advance
> yet real per-AG reservation error injection might be more complicated
> than just error out with -ENOSPC, and it's somewhat out of scope of this
> patchset for now...
> 

I don't think it needs to be any more complicated than the logic you
have here. Just bury it further down in in the perag res init code,
rename it to something like ERRTAG_AG_RESV_FAIL, and use it the exact
same way for shrink testing. For example, maybe drop it into
__xfs_ag_resv_init() near the xfs_mod_fdblocks() call so we can also
take advantage of the tracepoint that triggers on -ENOSPC for
informational purposes:

	error = xfs_mod_fdblocks(...);
	if (!error && XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
		error = -ENOSPC;
	if (error) {
		...
	}

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> 

