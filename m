Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A8BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 00:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D642078A
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 00:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHVqn2SY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgGIASB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 20:18:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgGIASB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 20:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594253879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pnsAIscQqPaD/zJLSzX7ES35Z2PT4lbp65TidAwCxi8=;
        b=LHVqn2SYp8wt1RoVMlK/UTEVf71Q6FHsvvvCJVKiBs4bekyzoEX0UiVl1DmqpwmztJKaVc
        z156MsbyYnxl2M069yPfIdnES5BMygKNQtOJFR6B65D038ctUv9Ei6Ww5wJJTnPjtlPTK2
        KMh/Ay64RtoKiHh/CiSRtvNlzeT/fUU=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-9HXskhIVO7WD-2JWS5r2UQ-1; Wed, 08 Jul 2020 20:17:57 -0400
X-MC-Unique: 9HXskhIVO7WD-2JWS5r2UQ-1
Received: by mail-pf1-f197.google.com with SMTP id d67so170607pfd.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2020 17:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pnsAIscQqPaD/zJLSzX7ES35Z2PT4lbp65TidAwCxi8=;
        b=IxluoXos47Psm1+tkLgf+x83U35QesmOFzYqRE4LqwaTnVOo4O22i6VzBih4SihdvB
         KfoD5Unq0vt1PC2CeeqL2NPJ3lQfG4srsmlB3WDVS5t7Sq+gCou5Bt+qPNHQ+bsPG40S
         BWb+nBLQT70Km8jAmxAv3jRD23w/a7U4Abov/l1b4RgK4x0bsmDtF5IIl+jrrm7OBBjZ
         6kaMZk826ze7ORb4xUss38SkMck7X3GbSnWl6qy1kgNkVnlAk/hr0X3QCzymWHpIMkpU
         owpsQPJVoCPmVn6lnObKHecUeWTntMFDkS3c2EZEp7Ek7iw2JFmbv7SKvR2AN2nS3FBt
         ZkWw==
X-Gm-Message-State: AOAM533/60hq2EX1ACNnSv9BPMHWtl1lQ5CU+0uQG2nhCGuhoEWUCVUi
        LQlwA/HOoM98QOJSulcdPu+PNhVTrxZIlFLLwMOJk/wQzg7+GzX9/maPl6se5ZRF1ubJGXy5qSf
        FqS1l9oIYTpb3i9qugQlv
X-Received: by 2002:a63:230e:: with SMTP id j14mr51182134pgj.107.1594253876754;
        Wed, 08 Jul 2020 17:17:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuKXKUmoEHmluQcLx86M/QWY4fxwamUPI/2BsxaI/ThEFADGqj07mYS5PwKTabzBmpVDbA1w==
X-Received: by 2002:a63:230e:: with SMTP id j14mr51182110pgj.107.1594253876344;
        Wed, 08 Jul 2020 17:17:56 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t73sm799589pfc.78.2020.07.08.17.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 17:17:55 -0700 (PDT)
Date:   Thu, 9 Jul 2020 08:17:45 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/2] xfs: arrange all unlinked inodes into one list
Message-ID: <20200709001745.GB15249@xiangao.remote.csb>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-2-hsiangkao@redhat.com>
 <20200708223326.GO2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708223326.GO2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Jul 09, 2020 at 08:33:26AM +1000, Dave Chinner wrote:
> >  
> > +	bucket_index = 0;
> > +	/* During recovery, the old multiple bucket index can be applied */
> > +	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
> > +		ASSERT(old_agino != NULLAGINO);
> > +
> > +		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
> > +			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
> > +	}
> 
> Ok, so you are doing this because you changed the function to pass
> in an agino rather than a bucket index from the caller context. So
> now you have to look up a structure to determine what the caller
> context was to determine what the bucket index we need to use is.
> 
> Seems like we probably should have kept passing in the bucket index
> from the caller because that's where the knowledge of what bucket we
> need to update comes from?

My thought is since bucket_index is now fixed as 0 except for the
determinated recovery path, so I think there is no need for any
exist callers or future callers to specify some bucket number.

The old formula is only used for xfs_iunlink_remove_inode() when
recovering, so old_agino won't be NULLAGINO but indicate the old
bucket_index as well (since it removes the head unlinked inode.)
That is the only determinated path.

> 
> And in that case, the higher level code should be checking for the
> log recovery case when selecting the bucket, not hiding it deep in
> the guts of the code here....

I could do that instead, it means callers should obey more rules
to call this function. e.g bucket_index should obey "old_agino % XFS_AGI_UNLINKED_BUCKETS"
rule for the old way rather than passing any possible value.

but if we specify all callers do that, I think "if (old_value != old_agino)"
isn't needed here as well but instead add an ASSERT here since all callers
should know what they are doing now, and leave only some integral check here.

> 
> > +
> >  	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
> >  	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
> >  			old_value, new_agino);
> >  
> > -	/*
> > -	 * We should never find the head of the list already set to the value
> > -	 * passed in because either we're adding or removing ourselves from the
> > -	 * head of the list.
> > -	 */
> > -	if (old_value == new_agino) {
> > +	/* check if the old agi_unlinked head is as expected */
> > +	if (old_value != old_agino) {
> >  		xfs_buf_mark_corrupt(agibp);
> >  		return -EFSCORRUPTED;
> >  	}
> 
> This looks like a change of behaviour - it no longer checks against
> the inode we are about to add/remove from the list, but instead
> checks that old inode is what we found on the list. We're not
> concerned that what we found on the list matches what the caller
> found on the list and passed us - we're concerned about doing a
> double add/remove of the current inode...

Just as I said above, this checks the bucket head validity instead
(since we get a bucket_index and the bucket head should be as
what we expect). It doesn't mean to check that old inode is what
we found on the list. So we could kill the original check in
xfs_iunlink_remove_inode() as well.

Anyway, I prefer this way since all callers won't know too much about
the bucket index. Since bucket index is much related to agino, it cannot
be specified without some rule, e.g. agino is 0 (just for a example,
should not possible), but a caller passes a bucket index 12. It doesn't
work so if we have a bucket_index argument, we have also to consider
bucket_index check in xfs_iunlink_update_bucket() just as the old
"if (old_value == new_agino) {" integral check as well. From this
perspective, xfs_iunlink_update_bucket() should also know the rule
as the proposed code does...

I could keep the old argument instead, that isn't too much for me.
I listed all my thoughts above.

Thanks,
Gao Xiang

