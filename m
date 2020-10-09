Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8CFC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A9AE22261
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JspyYEPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388121AbgJILcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 07:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729986AbgJILcf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 07:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602243153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ex2pa91TWIaq7ZzHGrKd2PmvPcG0nZaW0RpYK2SFSFo=;
        b=JspyYEPYezpchHWpl+ZLmZq/pUM86NmpEiE4O6H/SZLX8F32tjYRXKByM/Azb/FXvKf8Qt
        5jmlLJM3Kfrp53lkeYSpwJQPxcy+PSm0ZzQmRaG050MQZqOQT9GuzGTxZOREtO4nPL+Iuo
        djB6ePVlsBgVTFO6xCpgaVc6WTPo9pw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-CK1vCAR_O_i1FKTYhNlcAg-1; Fri, 09 Oct 2020 07:32:31 -0400
X-MC-Unique: CK1vCAR_O_i1FKTYhNlcAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E15757001;
        Fri,  9 Oct 2020 11:32:30 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DD547664F;
        Fri,  9 Oct 2020 11:32:27 +0000 (UTC)
Date:   Fri, 9 Oct 2020 07:32:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <20201009113225.GB769470@bfoster>
References: <20201005163737.GE49547@magnolia>
 <20201009111812.GA769470@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201009111812.GA769470@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 07:18:12AM -0400, Brian Foster wrote:
> On Mon, Oct 05, 2020 at 09:37:37AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The function scrub_scan_estimate_blocks naÃ¯vely uses the statvfs counts
> > to estimate the size and free blocks on the data volume.  Unfortunately,
> > it fails to account for the fact that statvfs can return the size and
> > free counts for the realtime volume if the root directory has the
> > rtinherit flag set, which leads to phase 7 reporting totally absurd
> > quantities.
> > 
> > Eric pointed out a further problem with statvfs, which is that the file
> > counts are clamped to the current user's project quota inode limits.
> > Therefore, we must not use statvfs for querying the filesystem summary
> > counts.
> > 
> > The XFS_IOC_FSCOUNTS ioctl returns all the data we need, so use that
> > instead.
> > 
> > Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: drop statvfs entirely
> > ---
> 
> This doesn't seem to apply to for-next..?
> 

Oops, never mind. Wrong tree...


> Brian
> 
> >  scrub/fscounters.c |   27 ++++-----------------------
> >  1 file changed, 4 insertions(+), 23 deletions(-)
> > 
> > diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> > index f9d64f8c008f..e9901fcdf6df 100644
> > --- a/scrub/fscounters.c
> > +++ b/scrub/fscounters.c
> > @@ -130,38 +130,19 @@ scrub_scan_estimate_blocks(
> >  	unsigned long long		*f_free)
> >  {
> >  	struct xfs_fsop_counts		fc;
> > -	struct xfs_fsop_resblks		rb;
> > -	struct statvfs			sfs;
> >  	int				error;
> >  
> > -	/* Grab the fstatvfs counters, since it has to report accurately. */
> > -	error = fstatvfs(ctx->mnt.fd, &sfs);
> > -	if (error)
> > -		return errno;
> > -
> >  	/* Fetch the filesystem counters. */
> >  	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
> >  	if (error)
> >  		return errno;
> >  
> > -	/*
> > -	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
> > -	 * blocks back to the free data counts.
> > -	 */
> > -	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
> > -	if (error)
> > -		return errno;
> > -
> > -	sfs.f_bfree += rb.resblks_avail;
> > -
> > -	*d_blocks = sfs.f_blocks;
> > -	if (ctx->mnt.fsgeom.logstart > 0)
> > -		*d_blocks += ctx->mnt.fsgeom.logblocks;
> > -	*d_bfree = sfs.f_bfree;
> > +	*d_blocks = ctx->mnt.fsgeom.datablocks;
> > +	*d_bfree = fc.freedata;
> >  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
> >  	*r_bfree = fc.freertx;
> > -	*f_files = sfs.f_files;
> > -	*f_free = sfs.f_ffree;
> > +	*f_files = fc.allocino;
> > +	*f_free = fc.freeino;
> >  

Aren't the free inode counters semantically different between statvfs
and this ioctl? I thought stat had some logic to effectively show free
data blocks as free inodes, whereas the ioctl looks like it just reads
our internal counter (which IIRC is a subset of physically allocated
inode chunks). Do we care about that semantic here either way?

Brian

> >  	return 0;
> >  }
> > 
> 

