Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF91EC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C96B2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 13:21:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+BCw+U2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgIJNTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 09:19:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730378AbgIJNSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 09:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599743895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iwhHctCuNIO5pnD3hTu6bCERI9RxI1Zhye3eWWC+hMs=;
        b=a+BCw+U2lGgViMheYRtmjkcXuYDG4hKP94Brj28G29WmWfWfuMZlwuaK/1kFNWModQUIun
        pO5lfTIf+J8NoZW3thrcuWMNnlV3But4pobojqBdNcklzbo9N+huQAAa7BWPX6isB35MfQ
        +lercEQ0F9JOZiI627JaWaz4GVEMVrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-gr00WfjUNaSIBLDDwRD_Ig-1; Thu, 10 Sep 2020 09:18:13 -0400
X-MC-Unique: gr00WfjUNaSIBLDDwRD_Ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 634C5801FDF;
        Thu, 10 Sep 2020 13:18:12 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 120895C1DC;
        Thu, 10 Sep 2020 13:18:11 +0000 (UTC)
Date:   Thu, 10 Sep 2020 09:18:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: EFI recovery needs it's own transaction
 reservation
Message-ID: <20200910131810.GA1143857@bfoster>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-2-david@fromorbit.com>
 <20200909133111.GA765129@bfoster>
 <20200909214455.GQ12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909214455.GQ12131@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 10, 2020 at 07:44:55AM +1000, Dave Chinner wrote:
> On Wed, Sep 09, 2020 at 09:31:11AM -0400, Brian Foster wrote:
> > On Wed, Sep 09, 2020 at 06:19:10PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Recovering an EFI currently uses a itruncate reservation, which is
> > > designed for a rolling transaction that modifies the BMBT and
> > > logs the EFI in one commit, then frees the space and logs the EFD in
> > > the second commit.
> > > 
> > > Recovering the EFI only requires the second transaction in this
> > > pair, and hence has a smaller log space requirement than a truncate
> > > operation. Hence when the extent free is being processed at runtime,
> > > the log reservation that is held by the filesystem is only enough to
> > > complete the extent free, not the entire truncate operation.
> > > 
> > > Hence if the EFI pins the tail of the log and the log fills up while
> > > the extent is being freed, the amount of reserved free space in the
> > > log is not enough to start another entire truncate operation. Hence
> > > if we crash at this point, log recovery will deadlock with the EFI
> > > pinning the tail of the log and the log not having enough free space
> > > to reserve an itruncate transaction.
> > > 
> > > As such, EFI recovery needs it's own log space reservation separate
> > > to the itruncate reservation. We only need what is required free the
> > > extent, and this matches the space we have reserved at runtime for
> > > this operation and hence should prevent the recovery deadlock from
> > > occurring.
> > > 
> > > This patch adds the new reservation in a way that minimises the
> > > change such that it should be back-portable to older kernels easily.
> > > Follow up patches will factor and rework the reservations to be more
> > > correct and more tightly defined.
> > > 
> > > Note: this would appear to be a generic problem with intent
> > > recovery; we use the entire operation reservation for recovery,
> > > not the reservation that was held at runtime after the intent was
> > > logged. I suspect all intents are going to require their own
> > > reservation as a result.
> > > 
> > 
> > It might be worth explicitly pointing out that support for EFI/EFD
> > intents goes farther back than the various intents associated with newer
> > features, hence the value of a targeted fix.
> 
> Ok.
> 
> > > @@ -916,6 +916,16 @@ xfs_trans_resv_calc(
> > >  		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> > >  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > >  
> > > +	/*
> > > +	 * Log recovery reservations for intent replay
> > > +	 *
> > > +	 * EFI recovery is itruncate minus the initial transaction that logs
> > > +	 * logs the EFI.
> > > +	 */
> > > +	resp->tr_efi.tr_logres = resp->tr_itruncate.tr_logres;
> > > +	resp->tr_efi.tr_logcount = resp->tr_itruncate.tr_logcount - 1;
> > 
> > tr_itruncate.tr_logcount looks like it's either 2 or 8 depending on
> > whether reflink is enabled. On one hand this seems conservative enough,
> > but do we know exactly what those extra unit counts are accounted for in
> > the reflink case?
> 
> Right, in the reflink case we may have to roll the transaction many more
> times to do the refcount btree and reverse map btree modifications.
> Those are done under separate intents and so we have to roll and
> commit the defered ops more times on a reflink/rmap based
> filesystem. Hence the logcount is higher so that the initial
> reservation can roll more times before regrant during a roll has to
> go and physically reserve more write space in the log to continue
> rolling the transaction.
> 
> > It looks like extents are only freed when the last
> > reference is dropped (otherwise we log a refcount intent), which makes
> > me wonder whether we really need 7 log count units if recovery
> > encounters an EFI.
> 
> I don't know if the numbers are correct, and it really is out of
> scope for this patch to audit/fix that. I really think we need to
> map this whole thing out in a diagram at this point because I now
> suspect that the allocfree log count calculation is not correct,
> either...
> 

I agree up to the point where it relates to this specific EFI recovery
issue. reflink is enabled by default, which means the default EFI
recovery reservation is going to have 7 logcount units. Is that actually
enough of a reduction to prevent this same recovery problem on newer
fs'? I'm wondering if the tr_efi logcount should just be set to 1, for
example, at least for the short term fix.

Brian

> > Also, while looking through the code I noticed that truncate does the
> > following:
> > 
> > 		...
> >                 error = xfs_defer_finish(&tp);
> >                 if (error)
> >                         goto out;
> > 
> >                 error = xfs_trans_roll_inode(&tp, ip);
> >                 if (error)
> >                         goto out;
> > 		...
> > 
> > ... which looks like it rolls the transaction an extra time per-extent.
> > I don't think that contributes to this problem vs just being a runtime
> > inefficiency, so maybe I'll fling a patch up for that separately.
> 
> Yeah, I'm not sure if this is correct/needed or not. 
> 
> > >  	 * The following transactions are logged in logical format with
> > >  	 * a default log count.
> > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > > index 7241ab28cf84..13173b3eaac9 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > > @@ -50,6 +50,8 @@ struct xfs_trans_resv {
> > >  	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
> > >  	struct xfs_trans_res	tr_sb;		/* modify superblock */
> > >  	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
> > > +	struct xfs_trans_res	tr_efi;		/* EFI log item recovery */
> > > +
> > 
> > Extra whitespace line.
> 
> Will fix.
> 
> Thanks!
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

