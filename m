Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C89C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 15:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E69EA20775
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 15:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjha0IHk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCZPmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 11:42:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgCZPmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 11:42:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFfOOS169130;
        Thu, 26 Mar 2020 15:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/Zbzq1nTMjvtAWjZr0YBmSyspxxevk93OP2ihWyLRD4=;
 b=cjha0IHktfkLwM4msDVGRJQqJJdmxZSTdJg0J28Shog3PS02Z5tgTbnx8dvPowtxdmCv
 HUQskAPWlQnB+n1kfu9EShSAeu6FdISvf3D3hORGklCiWv47U07uWcrkaAJvVNtQRAZY
 oVTILlMT35+zCOGMMd8kfbQnRrlFaaEvPoQ9QC9eUcj+yA6GSHEDIRrXHVxhE4Jj2DEo
 GceCqQoUqfewUQbIKab1uhpTS/Iq6aLqTHOD8P/3YhRmU4Z/DYtrXs2UWh/B5bMbnQcG
 wcsk4M5x64xX6+7kGj5BUX4yOJeaBPwzPVl+UfQSs0YR+WTB8wbt2yvD0+m4fycl/pYY QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk19ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 15:41:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFfrfZ158892;
        Thu, 26 Mar 2020 15:41:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3006r8nmfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 15:41:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02QFflhC006819;
        Thu, 26 Mar 2020 15:41:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 08:41:46 -0700
Date:   Thu, 26 Mar 2020 08:41:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200326154145.GD29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-2-hch@lst.de>
 <20200325123314.GC10922@bfoster>
 <20200325232500.GK10776@dread.disaster.area>
 <20200326110828.GA19262@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326110828.GA19262@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 07:08:28AM -0400, Brian Foster wrote:
> On Thu, Mar 26, 2020 at 10:25:00AM +1100, Dave Chinner wrote:
> > On Wed, Mar 25, 2020 at 08:33:14AM -0400, Brian Foster wrote:
> > > On Tue, Mar 24, 2020 at 06:44:52PM +0100, Christoph Hellwig wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > The xlog_write() function iterates over iclogs until it completes
> > > > writing all the log vectors passed in. The ticket tracks whether
> > > > a start record has been written or not, so only the first iclog gets
> > > > a start record. We only ever pass single use tickets to
> > > > xlog_write() so we only ever need to write a start record once per
> > > > xlog_write() call.
> > > > 
> > > > Hence we don't need to store whether we should write a start record
> > > > in the ticket as the callers provide all the information we need to
> > > > determine if a start record should be written. For the moment, we
> > > > have to ensure that we clear the XLOG_TIC_INITED appropriately so
> > > > the code in xfs_log_done() still works correctly for committing
> > > > transactions.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > [hch: use an need_start_rec bool]
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_log.c | 63 ++++++++++++++++++++++++------------------------
> > > >  1 file changed, 32 insertions(+), 31 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index 2a90a483c2d6..bf071552094a 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > ...
> > > > @@ -2372,25 +2359,29 @@ xlog_write(
> > > >  	int			record_cnt = 0;
> > > >  	int			data_cnt = 0;
> > > >  	int			error = 0;
> > > > +	bool			need_start_rec = true;
> > > >  
> > > >  	*start_lsn = 0;
> > > >  
> > > > -	len = xlog_write_calc_vec_length(ticket, log_vector);
> > > >  
> > > >  	/*
> > > >  	 * Region headers and bytes are already accounted for.
> > > >  	 * We only need to take into account start records and
> > > >  	 * split regions in this function.
> > > >  	 */
> > > > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > > > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > > > +	if (ticket->t_flags & XLOG_TIC_INITED) {
> > > > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > > > +		ticket->t_flags &= ~XLOG_TIC_INITED;
> > > > +	}
> > > >  
> > > >  	/*
> > > >  	 * Commit record headers need to be accounted for. These
> > > >  	 * come in as separate writes so are easy to detect.
> > > >  	 */
> > > > -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> > > > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > > > +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > > > +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> > > > +		need_start_rec = false;
> > > > +	}
> > > 
> > > Hmm.. I was asking for a comment update in v1 for this logic change.
> > > Looking through it again, what happens here if
> > > xfs_log_write_unmount_record() clears the UNMOUNT_TRANS flag for that
> > > summary counter check? That looks like a potential behavior change wrt
> > > to the start record..
> > 
> > xfs_log_write_unmount_record() clears the XLOG_TIC_INITED
> > flag before calling xlog_write(), so the current code never writes
> > out a start record for the unmount record. i.e. the unmount
> > record is a single region with the unmount log item in it, and
> > AFAICT this code does not change the behaviour of the unmount record
> > write at all.
> > 
> 
> I'm referring to the UNMOUNT_TRANS flag, not t_flags. With this patch,
> we actually would write a start record in some cases because
> need_start_rec is toggled based on the flags parameter and the summary
> counter check zeroes it.
> 
> > FWIW, that error injection code looks dodgy - it turns the unmount
> > record into an XFS_LOG transaction type with an invalid log item
> > type (0). That probably should be flagged as corruption, not be
> > silently ignored by recovery. IOWs, I think the error injection code
> > was wrong to begin with - if we want to ensure the log is dirty at
> > unmount, we should just skip writing the unmount record altogether.
> > 
> 
> That may be true... TBH I wasn't totally clear on what that logic was
> for (it isn't purely error injection). From the commit (f467cad95f5e3)
> log, the intent appears to be to "skip writing the unmount record," but
> that doesn't quite describe the behavior. Darrick might want to
> comment..? If we do revisit this, I'm mainly curious on whether there's
> a change in recovery behavior between having this specially crafted
> record vs. just writing nothing. For example, does recovery still set
> the head/tail based on this record even though we don't mark the log
> clean? If so, do we care..?

I'll have a look later today, but I think Dave is correct that the
summary recalc force code should bail out of xlog_unmount_write without
writing anything.

It's curious that recovery doesn't complain about this, but at this
point we've potentially been writing out logs with oh_flags == 0...

...though now that I look at xfs_log_recover.c, we don't ever actually
look for XLOG_UNMOUNT_TYPE, do we... heh.

--D

> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
