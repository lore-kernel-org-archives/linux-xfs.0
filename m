Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE38EC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D9224677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 13:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTcDW05a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgB1NwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 08:52:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbgB1NwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 08:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582897933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xcYG6JnJT6HhDoJ5JPmyLu27+yG6rOivtk6/Eb2u7Bs=;
        b=FTcDW05awfVN9amTsq6obsrIje2FcIS9I58403wnpTKTcpNHImQ8bME7PKguOyWfrZtNWD
        P0UmbO+gnyanZdYzHUTRLvADYLIdnPTNsv8kGa5vF1xwd/DBDiLOgdIrQtaYiKoYCztOuD
        H9G5ECf45XIU8bNs1lj1HgwAfb8bs3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-HUMIGcE7N_aRmid-Tkh4aA-1; Fri, 28 Feb 2020 08:52:09 -0500
X-MC-Unique: HUMIGcE7N_aRmid-Tkh4aA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3141005F79;
        Fri, 28 Feb 2020 13:52:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C878E8C096;
        Fri, 28 Feb 2020 13:52:07 +0000 (UTC)
Date:   Fri, 28 Feb 2020 08:52:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 2/9] xfs: introduce ->tr_relog transaction
Message-ID: <20200228135206.GB2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-3-bfoster@redhat.com>
 <20200227233153.GQ8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227233153.GQ8045@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 03:31:53PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2020 at 08:43:14AM -0500, Brian Foster wrote:
> > Create a transaction reservation specifically for relog
> > transactions. For now it only supports the quotaoff intent, so use
> > the associated reservation.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c | 15 +++++++++++++++
> >  fs/xfs/libxfs/xfs_trans_resv.h |  1 +
> >  2 files changed, 16 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 7a9c04920505..1f5c9e6e1afc 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -832,6 +832,17 @@ xfs_calc_sb_reservation(
> >  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> >  }
> >  
> > +/*
> > + * Internal relog transaction.
> > + *   quotaoff intent
> > + */
> > +STATIC uint
> > +xfs_calc_relog_reservation(
> > +	struct xfs_mount	*mp)
> > +{
> > +	return xfs_calc_qm_quotaoff_reservation(mp);
> 
> So when we add the next reloggable intent item, this will turn this
> into an n-way max(sizeof(type0), sizeof(type1), ...sizeof(typeN)); ?
> 

Possibly. I'm trying to keep things simple for now. So if we suppose the
near term use cases are the quotaoff intent, the scrub EFI intent and
perhaps the writeback stale data exposure zeroing intent, then I'd
probably just leave it as a max of those. We could also multiply that by
some constant factor for a simple form of batching, since the log
reservation is still likely to be on the smaller size.

If longer term we end up with relog support for a variety of item times
and the potential for a lot of concurrent relog activity, I'd be more
inclined to consider a specific calculation or to pick off the current
max transaction size or something and require batching implement some
form of reservation use tracking (i.e., consider an
xfs_trans_add_item_try(...) interface that performed a magical size
check and failed when the transaction is full).

As it is, I don't see enough use case right now to cross that complexity
threshold from the first model to the second right away..

> > +}
> > +
> >  void
> >  xfs_trans_resv_calc(
> >  	struct xfs_mount	*mp,
> > @@ -946,4 +957,8 @@ xfs_trans_resv_calc(
> >  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
> >  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> >  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> > +
> > +	resp->tr_relog.tr_logres = xfs_calc_relog_reservation(mp);
> > +	resp->tr_relog.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> 
> Relog operations can roll?  I would have figured that you'd simply log
> the old item(s) in a new transaction and commit it, along with some
> magic to let the log tail move forward.  I guess I'll see what happens
> in the next 7 patches. :)
> 

The current scheme is that the relog transaction rolls one item at a
time. This is again, simplified for the purpose of a POC. For a
production iteration, I'd probably just turn that into a fixed count to
be able to batch 5 or 10 items at a time or something along those lines
(probably more depends on what the transaction size looks like and the
pressure put on by the scrub use case).

Brian

> --D
> 
> > +	resp->tr_relog.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > index 7241ab28cf84..b723979cad09 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > @@ -50,6 +50,7 @@ struct xfs_trans_resv {
> >  	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
> >  	struct xfs_trans_res	tr_sb;		/* modify superblock */
> >  	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
> > +	struct xfs_trans_res	tr_relog;	/* internal relog transaction */
> >  };
> >  
> >  /* shorthand way of accessing reservation structure */
> > -- 
> > 2.21.1
> > 
> 

