Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F833C2BB84
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 14:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D29C2078E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 14:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgIDOCP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 10:02:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38651 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730629AbgIDNqS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 09:46:18 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-nzhHMkqUP7mZiIwa5JV5rw-1; Fri, 04 Sep 2020 09:37:24 -0400
X-MC-Unique: nzhHMkqUP7mZiIwa5JV5rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98C9E18BE169;
        Fri,  4 Sep 2020 13:37:23 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A0EB7E410;
        Fri,  4 Sep 2020 13:37:23 +0000 (UTC)
Date:   Fri, 4 Sep 2020 09:37:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200904133721.GE529978@bfoster>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-3-hsiangkao@redhat.com>
 <20200904112548.GC529978@bfoster>
 <20200904125929.GB28752@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904125929.GB28752@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 08:59:29PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Fri, Sep 04, 2020 at 07:25:48AM -0400, Brian Foster wrote:
> > On Fri, Sep 04, 2020 at 04:25:16PM +0800, Gao Xiang wrote:
> 
> ...
> 
> > >  
> > > +static inline int xlog_logrecv2_hblks(struct xlog_rec_header *rh)
> > > +{
> > > +	int	h_size = be32_to_cpu(rh->h_size);
> > > +
> > > +	if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
> > > +	    h_size > XLOG_HEADER_CYCLE_SIZE)
> > > +		return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> > > +	return 1;
> > > +}
> > > +
> > > +static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
> > > +{
> > > +	if (!xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> > > +		return 1;
> > > +	return xlog_logrecv2_hblks(rh);
> > > +}
> > > +
> > 
> > h_version is assigned based on xfs_sb_version_haslogv2() in the first
> > place so I'm not sure I see the need for multiple helpers like this, at
> > least with the current code. I can't really speak to why some code
> > checks the feature bit and/or the record header version and not the
> > other way around, but perhaps there's some historical reason I'm not
> > aware of. Regardless, is there ever a case where
> > xfs_sb_version_haslogv2() == true and h_version != 2? That strikes me as
> > more of a corruption scenario than anything..
> 
> Thanks for this.
> 
> Honestly, I'm not quite sure if xfs_sb_version_haslogv2() == true and
> h_version != 2 is useful (or existed historially)... anyway, that is
> another seperate topic though...
> 

Indeed.

> Could you kindly give me some code flow on your preferred way about
> this so I could update this patch proper (since we have a complex
> case in xlog_do_recovery_pass(), I'm not sure how the unique helper
> will be like because there are 3 cases below...)
> 
>  - for the first 2 cases, we already have rhead read in-memory,
>    so the logic is like:
>      ....
>      log_bread (somewhere in advance)
>      ....
> 
>      if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
>           ...
>      } else {
>           ...
>      }
>      (so I folded this two cases in xlog_logrec_hblks())
> 
>  - for xlog_do_recovery_pass, it behaves like
>     if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
>          log_bread (another extra bread to get h_size for
>          allocated buffer and hblks).
> 
>          ...
>     } else {
>          ...
>     }
>     so in this case we don't have rhead until
> xfs_sb_version_haslogv2(&log->l_mp->m_sb) is true...
> 

I'm not sure I'm following the problem...

The current patch makes the following change in xlog_do_recovery_pass():

@@ -3024,15 +3018,10 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
+		hblks = xlog_logrecv2_hblks(rhead);
+		if (hblks != 1) {
 			kmem_free(hbp);
 			hbp = xlog_alloc_buffer(log, hblks);
-		} else {
-			hblks = 1;
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);

My question is: why can't we replace the xlog_logrecv2_hblks() call here
with xlog_logrec_hblks()? We already have rhead as the existing code is
already looking at h_version. We're inside a _haslogv2() branch, so the
check inside the helper is effectively a duplicate/no-op.. Hm?

Brian

> Thanks in advance!
> 
> Thanks,
> Gao Xiang
> 
> 
> > 
> > Brian
> 

