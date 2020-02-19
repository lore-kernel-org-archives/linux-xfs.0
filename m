Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4454AC34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB721D56
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OhMghpgg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBSVvr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 16:51:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSVvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 16:51:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JLhttT068124;
        Wed, 19 Feb 2020 21:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=q27HVx5tN3snPbqQoNlL/us/9tkDqerkBYyAeUXOQ94=;
 b=OhMghpggmkPh0nyug8zculcViaiOSVaLeZhDvfmrsWxvKbCQh+fjONDELBRcWUTn7oeY
 t2m3tu6vAwR/JGDeeDSw4FuvtLQkPz/amx68AUhfE49VLs/h2YK1na42TXfzCWpwp83m
 5tn2PSViurzw/gEydy9U9zrprPJ/dxRkbx2Vx/yXxDQ2i5AzTKzMQmHHTIbfzaLzRq2r
 oAYzshKsjwEPto3jwIZo5cAjiYYsoQrVL3uS1Pev+wGWv1JBWMLL787ntKkk08LHLXoO
 MabWl6ttB4dl7CMTRUbqQodbagAgzCJej+Qm3U7Sc1ndOPWPg0cXEKoju8/T26V6Dhd5 BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udke2qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 21:51:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JLfhCm107217;
        Wed, 19 Feb 2020 21:51:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2y8ud232g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 21:51:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01JLpgQD011678;
        Wed, 19 Feb 2020 21:51:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 13:51:41 -0800
Date:   Wed, 19 Feb 2020 13:51:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200219215141.GP9506@magnolia>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200219131232.GA24157@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219131232.GA24157@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:12:32AM -0500, Brian Foster wrote:
> On Wed, Feb 19, 2020 at 08:52:43AM +1100, Dave Chinner wrote:
> > On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> > > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > > l_icloglock held"), xlog_state_release_iclog() always performed a
> > > locked check of the iclog error state before proceeding into the
> > > sync state processing code. As of this commit, part of
> > > xlog_state_release_iclog() was open-coded into
> > > xfs_log_release_iclog() and as a result the locked error state check
> > > was lost.
> > > 
> > > The lockless check still exists, but this doesn't account for the
> > > possibility of a race with a shutdown being performed by another
> > > task causing the iclog state to change while the original task waits
> > > on ->l_icloglock. This has reproduced very rarely via generic/475
> > > and manifests as an assert failure in __xlog_state_release_iclog()
> > > due to an unexpected iclog state.
> > > 
> > > Restore the locked error state check in xlog_state_release_iclog()
> > > to ensure that an iclog state update via shutdown doesn't race with
> > > the iclog release state processing code.
> > > 
> > > Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > v2:
> > > - Include Fixes tag.
> > > - Use common error path to include shutdown call.
> > > v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/
> > > 
> > >  fs/xfs/xfs_log.c | 13 +++++++++----
> > >  1 file changed, 9 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index f6006d94a581..796ff37d5bb5 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -605,18 +605,23 @@ xfs_log_release_iclog(
> > >  	struct xlog		*log = mp->m_log;
> > >  	bool			sync;
> > >  
> > > -	if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > -		return -EIO;
> > > -	}
> > 
> > hmmmm.
> > 
> > xfs_force_shutdown() will does nothing if the iclog at the head of
> > the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
> > submitted. In general, that is the case here as the head iclog is
> > what xlog_state_get_iclog_space() returns.
> > 
> > i.e. XLOG_STATE_IOERROR here implies the log has already been shut
> > down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
> > was set when the iclog was obtained from
> > xlog_state_get_iclog_space().
> > 
> 
> I'm not sure that assumption is always true. If the iclog is (was)
> WANT_SYNC, for example, then it's already been switched out from the
> head of that list. That might only happen if a checkpoint happens to
> align nicely with the end of an iclog, but that's certainly possible. We
> also need to consider that ->l_icloglock cycles here and thus somebody
> else could switch out the head iclog..
> 
> > > +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > > +		goto error;
> > >  
> > >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > +			spin_unlock(&log->l_icloglock);
> > > +			goto error;
> > > +		}
> > >  		sync = __xlog_state_release_iclog(log, iclog);
> > >  		spin_unlock(&log->l_icloglock);
> > >  		if (sync)
> > >  			xlog_sync(log, iclog);
> > >  	}
> > >  	return 0;
> > > +error:
> > > +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > +	return -EIO;
> > 
> > Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
> > just like is in xfs_log_force_umount() when this pre-existing log
> > IO error condition is tripped over...
> > 
> 
> I think this change is fundamentally correct based on the simple fact
> that we only ever set XLOG_STATE_IOERROR in the shutdown path. That
> said, the assert would be potentially racy against the shutdown path
> without any ordering guarantee that the release path might see the iclog
> state update prior to the log state update and lead to a potentially
> false negative assert failure. I suspect this is why the shutdown call
> might have been made from here in the first place (and partly why I
> didn't bother with it in the restored locked state check).
> 
> Given the context of this patch (fixing a regression) and the practical
> history of this code (and the annoying process of identifying and
> tracking down the source of these kind of shutdown buglets), I'm
> inclined to have this patch preserve the historical and relatively
> proven behavior as much as possible and consider further cleanups
> separately...

That sounds reasonable to me (who has at this point missed most of the
discussion about this patch).  Is there going to be a v3 of this patch?
Or has all of the further discussion centered around further cleanups,
and this one is good to go?

--D

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
