Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3C8C43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 16:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF7B2073B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 16:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgIDQcj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 12:32:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23379 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgIDQcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 12:32:39 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-VWbfWaerNumMQAVaRi5ZWA-1; Fri, 04 Sep 2020 12:32:35 -0400
X-MC-Unique: VWbfWaerNumMQAVaRi5ZWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65CF2393B1;
        Fri,  4 Sep 2020 16:32:34 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA1627E41B;
        Fri,  4 Sep 2020 16:32:31 +0000 (UTC)
Date:   Fri, 4 Sep 2020 12:32:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Message-ID: <20200904163229.GH529978@bfoster>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-3-hsiangkao@redhat.com>
 <20200904112548.GC529978@bfoster>
 <20200904125929.GB28752@xiangao.remote.csb>
 <20200904133721.GE529978@bfoster>
 <20200904150730.GB17378@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904150730.GB17378@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 11:07:30PM +0800, Gao Xiang wrote:
> On Fri, Sep 04, 2020 at 09:37:21AM -0400, Brian Foster wrote:
> > On Fri, Sep 04, 2020 at 08:59:29PM +0800, Gao Xiang wrote:
> ...
> > > Could you kindly give me some code flow on your preferred way about
> > > this so I could update this patch proper (since we have a complex
> > > case in xlog_do_recovery_pass(), I'm not sure how the unique helper
> > > will be like because there are 3 cases below...)
> > > 
> > >  - for the first 2 cases, we already have rhead read in-memory,
> > >    so the logic is like:
> > >      ....
> > >      log_bread (somewhere in advance)
> > >      ....
> > > 
> > >      if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> > >           ...
> > >      } else {
> > >           ...
> > >      }
> > >      (so I folded this two cases in xlog_logrec_hblks())
> > > 
> > >  - for xlog_do_recovery_pass, it behaves like
> > >     if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> > >          log_bread (another extra bread to get h_size for
> > >          allocated buffer and hblks).
> > > 
> > >          ...
> > >     } else {
> > >          ...
> > >     }
> > >     so in this case we don't have rhead until
> > > xfs_sb_version_haslogv2(&log->l_mp->m_sb) is true...
> > > 
> > 
> > I'm not sure I'm following the problem...
> > 
> > The current patch makes the following change in xlog_do_recovery_pass():
> > 
> > @@ -3024,15 +3018,10 @@ xlog_do_recovery_pass(
> >  		if (error)
> >  			goto bread_err1;
> >  
> > -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> > -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> > -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> > -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> > -				hblks++;
> > +		hblks = xlog_logrecv2_hblks(rhead);
> > +		if (hblks != 1) {
> >  			kmem_free(hbp);
> >  			hbp = xlog_alloc_buffer(log, hblks);
> > -		} else {
> > -			hblks = 1;
> >  		}
> >  	} else {
> >  		ASSERT(log->l_sectBBsize == 1);
> > 
> > My question is: why can't we replace the xlog_logrecv2_hblks() call here
> > with xlog_logrec_hblks()? We already have rhead as the existing code is
> > already looking at h_version. We're inside a _haslogv2() branch, so the
> > check inside the helper is effectively a duplicate/no-op.. Hm?
> 
> Yeah, I get your point. That would introduce a duplicated check of
> _haslogv2() if we use xlog_logrec_hblks() here (IMHO compliers wouldn't
> treat the 2nd _haslogv2() check as no-op).
> 

Yeah, I meant it as more as a logical no-op. IOW, it wouldn't affect
functionality. The check instructions might be duplicated, but I doubt
that would measurably impact log recovery.

> I will go forward like this if no other concerns. Thank you!
> 

Thanks.

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > Thanks in advance!
> > > 
> > > Thanks,
> > > Gao Xiang
> > > 
> > > 
> > > > 
> > > > Brian
> > > 
> > 
> 

