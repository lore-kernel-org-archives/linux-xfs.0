Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3D3C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA30B20787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0o6PBz8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgEALYd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:24:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728581AbgEALYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588332271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZGbUnT1Fcre7gFMGXxzxVHZxC8GSSvtKoflwogNaLU=;
        b=Z0o6PBz8LelNZvZ6XWCQbivnBbIW6+mPa/wrK/Y3CRCilPTx38WcYMR0yeo58eG3MnkfCy
        +uYTcKuL+bxbEgaLxIOngRbcs7dnvMKgzwWZ1/c0bJu2V6zhyQPn1uwfRKTtORwT15ji4Y
        6JmsNtlkPjiJyy4+KlX1ieciiyN0l8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-2q6NELr7PoKeTJ_xHBLVhg-1; Fri, 01 May 2020 07:24:29 -0400
X-MC-Unique: 2q6NELr7PoKeTJ_xHBLVhg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AE67107ACCA;
        Fri,  1 May 2020 11:24:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D87161524;
        Fri,  1 May 2020 11:24:28 +0000 (UTC)
Date:   Fri, 1 May 2020 07:24:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 08/17] xfs: fix duplicate verification from
 xfs_qm_dqflush()
Message-ID: <20200501112426.GC40250@bfoster>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-9-bfoster@redhat.com>
 <20200430184553.GI6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430184553.GI6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:45:53AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 01:21:44PM -0400, Brian Foster wrote:
> > The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
> > read verifier by checking the dquot in the on-disk buffer. Instead,
> > verify the in-core variant before it is flushed to the buffer.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Fixes: 7224fa482a6d ("xfs: add full xfs_dqblk verifier") ?
> 

Ok, added.

Brian

> Otherwise this looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_dquot.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index af2c8e5ceea0..265feb62290d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1116,13 +1116,12 @@ xfs_qm_dqflush(
> >  	dqb = bp->b_addr + dqp->q_bufoffset;
> >  	ddqp = &dqb->dd_diskdq;
> >  
> > -	/*
> > -	 * A simple sanity check in case we got a corrupted dquot.
> > -	 */
> > -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> > +	/* sanity check the in-core structure before we flush */
> > +	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(dqp->q_core.d_id),
> > +			      0);
> >  	if (fa) {
> >  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> > -				be32_to_cpu(ddqp->d_id), fa);
> > +				be32_to_cpu(dqp->q_core.d_id), fa);
> >  		xfs_buf_relse(bp);
> >  		xfs_dqfunlock(dqp);
> >  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -- 
> > 2.21.1
> > 
> 

