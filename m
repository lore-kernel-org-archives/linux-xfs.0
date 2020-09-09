Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6EEC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 21:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534CE21D7E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 21:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIIVpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 17:45:02 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58870 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgIIVpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 17:45:01 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9F50982480E;
        Thu, 10 Sep 2020 07:44:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kG7tf-00025R-Al; Thu, 10 Sep 2020 07:44:55 +1000
Date:   Thu, 10 Sep 2020 07:44:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: EFI recovery needs it's own transaction
 reservation
Message-ID: <20200909214455.GQ12131@dread.disaster.area>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-2-david@fromorbit.com>
 <20200909133111.GA765129@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909133111.GA765129@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=YmwVEFAiMb9cPKlH9xUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 09:31:11AM -0400, Brian Foster wrote:
> On Wed, Sep 09, 2020 at 06:19:10PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recovering an EFI currently uses a itruncate reservation, which is
> > designed for a rolling transaction that modifies the BMBT and
> > logs the EFI in one commit, then frees the space and logs the EFD in
> > the second commit.
> > 
> > Recovering the EFI only requires the second transaction in this
> > pair, and hence has a smaller log space requirement than a truncate
> > operation. Hence when the extent free is being processed at runtime,
> > the log reservation that is held by the filesystem is only enough to
> > complete the extent free, not the entire truncate operation.
> > 
> > Hence if the EFI pins the tail of the log and the log fills up while
> > the extent is being freed, the amount of reserved free space in the
> > log is not enough to start another entire truncate operation. Hence
> > if we crash at this point, log recovery will deadlock with the EFI
> > pinning the tail of the log and the log not having enough free space
> > to reserve an itruncate transaction.
> > 
> > As such, EFI recovery needs it's own log space reservation separate
> > to the itruncate reservation. We only need what is required free the
> > extent, and this matches the space we have reserved at runtime for
> > this operation and hence should prevent the recovery deadlock from
> > occurring.
> > 
> > This patch adds the new reservation in a way that minimises the
> > change such that it should be back-portable to older kernels easily.
> > Follow up patches will factor and rework the reservations to be more
> > correct and more tightly defined.
> > 
> > Note: this would appear to be a generic problem with intent
> > recovery; we use the entire operation reservation for recovery,
> > not the reservation that was held at runtime after the intent was
> > logged. I suspect all intents are going to require their own
> > reservation as a result.
> > 
> 
> It might be worth explicitly pointing out that support for EFI/EFD
> intents goes farther back than the various intents associated with newer
> features, hence the value of a targeted fix.

Ok.

> > @@ -916,6 +916,16 @@ xfs_trans_resv_calc(
> >  		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> >  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > +	/*
> > +	 * Log recovery reservations for intent replay
> > +	 *
> > +	 * EFI recovery is itruncate minus the initial transaction that logs
> > +	 * logs the EFI.
> > +	 */
> > +	resp->tr_efi.tr_logres = resp->tr_itruncate.tr_logres;
> > +	resp->tr_efi.tr_logcount = resp->tr_itruncate.tr_logcount - 1;
> 
> tr_itruncate.tr_logcount looks like it's either 2 or 8 depending on
> whether reflink is enabled. On one hand this seems conservative enough,
> but do we know exactly what those extra unit counts are accounted for in
> the reflink case?

Right, in the reflink case we may have to roll the transaction many more
times to do the refcount btree and reverse map btree modifications.
Those are done under separate intents and so we have to roll and
commit the defered ops more times on a reflink/rmap based
filesystem. Hence the logcount is higher so that the initial
reservation can roll more times before regrant during a roll has to
go and physically reserve more write space in the log to continue
rolling the transaction.

> It looks like extents are only freed when the last
> reference is dropped (otherwise we log a refcount intent), which makes
> me wonder whether we really need 7 log count units if recovery
> encounters an EFI.

I don't know if the numbers are correct, and it really is out of
scope for this patch to audit/fix that. I really think we need to
map this whole thing out in a diagram at this point because I now
suspect that the allocfree log count calculation is not correct,
either...

> Also, while looking through the code I noticed that truncate does the
> following:
> 
> 		...
>                 error = xfs_defer_finish(&tp);
>                 if (error)
>                         goto out;
> 
>                 error = xfs_trans_roll_inode(&tp, ip);
>                 if (error)
>                         goto out;
> 		...
> 
> ... which looks like it rolls the transaction an extra time per-extent.
> I don't think that contributes to this problem vs just being a runtime
> inefficiency, so maybe I'll fling a patch up for that separately.

Yeah, I'm not sure if this is correct/needed or not. 

> >  	 * The following transactions are logged in logical format with
> >  	 * a default log count.
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > index 7241ab28cf84..13173b3eaac9 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > @@ -50,6 +50,8 @@ struct xfs_trans_resv {
> >  	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
> >  	struct xfs_trans_res	tr_sb;		/* modify superblock */
> >  	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
> > +	struct xfs_trans_res	tr_efi;		/* EFI log item recovery */
> > +
> 
> Extra whitespace line.

Will fix.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
