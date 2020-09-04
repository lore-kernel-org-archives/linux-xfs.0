Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF76DC43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 13:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F0B20658
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 13:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgIDNqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 09:46:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730628AbgIDNqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 09:46:19 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-186IShRWP9O5AzziFvHiRg-1; Fri, 04 Sep 2020 09:37:07 -0400
X-MC-Unique: 186IShRWP9O5AzziFvHiRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BC916A29A;
        Fri,  4 Sep 2020 13:37:06 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDA1B2C31E;
        Fri,  4 Sep 2020 13:37:05 +0000 (UTC)
Date:   Fri, 4 Sep 2020 09:37:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] xfs: avoid LR buffer overrun due to crafted
 h_{len,size}
Message-ID: <20200904133704.GD529978@bfoster>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-2-hsiangkao@redhat.com>
 <20200904112529.GB529978@bfoster>
 <20200904124634.GA28752@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904124634.GA28752@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 08:46:34PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Fri, Sep 04, 2020 at 07:25:29AM -0400, Brian Foster wrote:
> > On Fri, Sep 04, 2020 at 04:25:15PM +0800, Gao Xiang wrote:
> 
> ...
> 
...
> > > @@ -3001,21 +3011,19 @@ xlog_do_recovery_pass(
> > >  		 */
> > >  		h_size = be32_to_cpu(rhead->h_size);
> > >  		h_len = be32_to_cpu(rhead->h_len);
> > > -		if (h_len > h_size) {
> > > -			if (h_len <= log->l_mp->m_logbsize &&
> > > -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> > > -				xfs_warn(log->l_mp,
> > > +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > > +		    rhead->h_num_logops == cpu_to_be32(1)) {
> > > +			xfs_warn(log->l_mp,
> > >  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> > > -					 h_size, log->l_mp->m_logbsize);
> > > -				h_size = log->l_mp->m_logbsize;
> > > -			} else {
> > > -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > > -						log->l_mp);
> > > -				error = -EFSCORRUPTED;
> > > -				goto bread_err1;
> > > -			}
> > > +				 h_size, log->l_mp->m_logbsize);
> > > +			h_size = log->l_mp->m_logbsize;
> > > +			rhead->h_size = cpu_to_be32(h_size);
> > 
> > I don't think we should update rhead like this, particularly in a rare
> > and exclusive case. This structure should reflect what is on disk.
> > 
> > All in all, I think this patch should be much more focused:
> > 
> > 1.) Add the bufsize parameter and associated corruption check to
> > xlog_valid_rec_header().
> > 2.) Pass the related value from the existing calls.
> > 3.) (Optional) If there's reason to revalidate after executing the mkfs
> > workaround, add a second call within the branch that implements the
> > h_size workaround.
> > 
> 
> I moved workaround code to xlog_valid_rec_header() at first is
> because in xlog_valid_rec_header() actually it has 2 individual
> checks now:
> 
> 1) check rhead->h_len vs rhead->h_size for each individual log record;
> 2) check rhead->h_size vs the unique allocated buffer size passed in
>    for each record (since each log record has one stored h_size,
>    even though there are not used later according to the current
>    logic of xlog_do_recovery_pass).
> 
> if any of the conditions above is not satisfied, xlog_valid_rec_header()
> will make fs corrupted immediately, so I tried 2 ways up to now:
> 
>  - (v1,v2) fold in workaround case into xlog_valid_rec_header()
>  - (v3) rearrange workaround and xlog_valid_rec_header() order in
>         xlog_do_recovery_pass() and modify rhead->h_size to the
>         workaround h_size before xlog_valid_rec_header() validation
>         so xlog_valid_rec_header() will work as expected since it
>         has two individual checks as mentioned above.
> 
> If there is some better way, kindly let me know :) and I'd like to
> hear other folks about this in advance as well.... so I can go
> forward since this part is a bit tricky for now.
> 

My suggestion is to, at minimum, separate the above two logic changes
into separate patches. Item #2 above is a functional check in that it
ensures each record fits into the record buffer size we've allocated
(based on h_size) at the start of recovery. This item is what my
feedback above was referring to and I think is a fairly straightforward
change.

Item #1 is a bit more nebulous. h_size refers to the iclog size used by
the kernel that wrote to the log. I think it should be uniform across
all records and AFAICT it doesn't serve a functional purpose (validation
notwithstanding) for recovery beyond establishing the size of the buffer
we should allocate to process records. The mkfs workaround implements a
case where we have to ignore the on-disk h_size and use the in-core
iclog size, and that is currently isolated to a single place. I'm not
fundamentally against more h_size verification beyond current usage, but
if that means we have to consider the workaround for multiple records
(which is confusing and incorrect) or make subtle runtime changes like
quietly tweaking the in-core record header structure from what is on
disk, then I don't think it's worth the complexity.

If we _really_ wanted to include such a change, I think a more
appropriate validation check might be to similarly track the h_size from
the initial record and simply verify that the values are uniform across
all processed records. That way we don't conflict or impose the
workaround logic on the underlying log format rules. It also catches the
(unlikely) case that the mkfs workaround is applied on the first record
incorrectly because h_size is corrupt and there are more records that
conflict. Also note that v5 filesystems enforce record CRC checks
anyways, so this still might be of limited value...

Brian

> > Also, please test the workaround case to make sure it still works as
> > expected (if you haven't already).
> 
> ok, will double confirm this, thanks!
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> >
>  
> 

