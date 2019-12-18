Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FFDC43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 12:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF362072B
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 12:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2U7T9dv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLRML1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 07:11:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726591AbfLRML1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 07:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576671085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HPRE62SykDMYMBgoMeU0GeBRfIbsOSQNUtaXJlqExGs=;
        b=T2U7T9dv/ZLimFqj1gxl7640TJZkWcOfymqwysrwRmhvK5ZQpS3EWIo6BnUhL9TrjNuaBn
        CBv91h2qN+Nro3IuoVn9qWusMZoOqPBKC1QafcrABordqPAq9RAydmCkYi4Kbg3r0Rm4dK
        lM657jj7m2atLAdYcDAHiautphlH+HI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-P8MichG7NhqzJ9Io39Hg0g-1; Wed, 18 Dec 2019 07:11:23 -0500
X-MC-Unique: P8MichG7NhqzJ9Io39Hg0g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20994800D48;
        Wed, 18 Dec 2019 12:11:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB6C47D909;
        Wed, 18 Dec 2019 12:11:21 +0000 (UTC)
Date:   Wed, 18 Dec 2019 07:11:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework collapse range into an atomic operation
Message-ID: <20191218121120.GB63809@bfoster>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-4-bfoster@redhat.com>
 <20191218023958.GI12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218023958.GI12765@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 06:39:58PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 13, 2019 at 12:12:58PM -0500, Brian Foster wrote:
> > The collapse range operation uses a unique transaction and ilock
> > cycle for the hole punch and each extent shift iteration of the
> > overall operation. While the hole punch is safe as a separate
> > operation due to the iolock, cycling the ilock after each extent
> > shift is risky similar to insert range.
> 
> It is?  I thought collapse range was safe because we started by punching
> out the doomed range and shifting downwards, which eliminates the
> problems that come with two adjacent mappings that could be combined?
> 
> <confused?>
> 

This is somewhat vague wording. I don't mean to say the same bug is
possible on collapse. Indeed, I don't think that it is. What I mean to
say is just that cycling the ilock generally opens the operation up to
concurrent extent changes, similar to the behavior that resulted in the
insert range bug and against the general design principle of the
operation (as implied by the iolock hold -> flush -> unmap preparation
sequence).

IOW, it seems to me that a similar behavior is possible on collapse, it
just might occur after an extent has been shifted into its new target
range rather than before. That wouldn't be a corruption/bug because it
doesn't change the semantics of the shift operation or the content of
the file, but it's subtle and arguably a misbehavior and/or landmine.

Brian

> --D
> 
> > To avoid this problem, make collapse range atomic with respect to
> > ilock. Hold the ilock across the entire operation, replace the
> > individual transactions with a single rolling transaction sequence
> > and finish dfops on each iteration to perform pending frees and roll
> > the transaction. Remove the unnecessary quota reservation as
> > collapse range can only ever merge extents (and thus remove extent
> > records and potentially free bmap blocks). The dfops call
> > automatically relogs the inode to keep it moving in the log. This
> > guarantees that nothing else can change the extent mapping of an
> > inode while a collapse range operation is in progress.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 555c8b49a223..1c34a34997ca 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1050,7 +1050,6 @@ xfs_collapse_file_space(
> >  	int			error;
> >  	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
> >  	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
> > -	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> >  	bool			done = false;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > @@ -1066,32 +1065,34 @@ xfs_collapse_file_space(
> >  	if (error)
> >  		return error;
> >  
> > -	while (!error && !done) {
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
> > -					&tp);
> > -		if (error)
> > -			break;
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> > +	if (error)
> > +		return error;
> >  
> > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> > -				ip->i_gdquot, ip->i_pdquot, resblks, 0,
> > -				XFS_QMOPT_RES_REGBLKS);
> > -		if (error)
> > -			goto out_trans_cancel;
> > -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	while (!done) {
> >  		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
> >  				&done);
> >  		if (error)
> >  			goto out_trans_cancel;
> > +		if (done)
> > +			break;
> >  
> > -		error = xfs_trans_commit(tp);
> > +		/* finish any deferred frees and roll the transaction */
> > +		error = xfs_defer_finish(&tp);
> > +		if (error)
> > +			goto out_trans_cancel;
> >  	}
> >  
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	return error;
> >  
> >  out_trans_cancel:
> >  	xfs_trans_cancel(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	return error;
> >  }
> >  
> > -- 
> > 2.20.1
> > 
> 

