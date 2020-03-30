Return-Path: <SRS0=hGtO=5P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BD2C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 00:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8221320757
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 00:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ye1C4jtI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC3AQK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:16:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35136 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC3AQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 20:16:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02U0G6Lc084738;
        Mon, 30 Mar 2020 00:16:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uYfMAS1Vgq8RwqVjVByJSNJ3Ta5VqPXhAdZIyz/wX3U=;
 b=Ye1C4jtIhIjs33Yzfs34iFj74dggDuTu8jIzqe3SrqR3Ph+qe0z3itoNeTWEGi0oW78X
 vU8CReT7LxmD4QsEMC1oO5TRiADyfC2fnP5vpc3aKYTLDDO1UhjJm7OpvKIoO+GMBwdN
 FPh1fjJ1acYjT1NLL1TVZF1u1G/fTyj17Hr9kwX1Aw7jPGr2tdxIb4p7lZvneAaVaxiT
 LvAtWyDT3qjpJMGXhABTVnYKhspqM6JDeQDREaeY2vyoKxUL46MBV8pPiajrrbIMgdgY
 z+0jtZk5PNp9+6TiCWOguloe3CAxednws4T9oKku82M/7uwFUqGWxW0gcMNqw8q6ElpY bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 301y7mm0ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 00:16:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02U0CiLK021691;
        Mon, 30 Mar 2020 00:16:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 302g2anxtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 00:16:06 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02U0G4G8028656;
        Mon, 30 Mar 2020 00:16:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 29 Mar 2020 17:16:03 -0700
Date:   Sun, 29 Mar 2020 17:16:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: ratelimit inode flush on buffered write ENOSPC
Message-ID: <20200330001602.GB80283@magnolia>
References: <20200329172209.GA80283@magnolia>
 <20200329220802.GS10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329220802.GS10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003300000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003300000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 30, 2020 at 09:08:02AM +1100, Dave Chinner wrote:
> On Sun, Mar 29, 2020 at 10:22:09AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > A customer reported rcu stalls and softlockup warnings on a computer
> > with many CPU cores and many many more IO threads trying to write to a
> > filesystem that is totally out of space.  Subsequent analysis pointed to
> > the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> > which causes a lot of wb_writeback_work to be queued.  The writeback
> > worker spends so much time trying to wake the many many threads waiting
> > for writeback completion that it trips the softlockup detector, and (in
> > this case) the system automatically reboots.
> > 
> > In addition, they complain that the lengthy xfs_flush_inodes scan traps
> > all of those threads in uninterruptible sleep, which hampers their
> > ability to kill the program or do anything else to escape the situation.
> > 
> > If there's thousands of threads trying to write to files on a full
> > filesystem, each of those threads will start separate copies of the
> > inode flush scan.  This is kind of pointless since we only need one
> > scan, so rate limit the inode flush.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_mount.h |    1 +
> >  fs/xfs/xfs_super.c |   14 ++++++++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 88ab09ed29e7..50c43422fa17 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -167,6 +167,7 @@ typedef struct xfs_mount {
> >  	struct xfs_kobj		m_error_meta_kobj;
> >  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
> >  	struct xstats		m_stats;	/* per-fs stats */
> > +	struct ratelimit_state	m_flush_inodes_ratelimit;
> >  
> >  	struct workqueue_struct *m_buf_workqueue;
> >  	struct workqueue_struct	*m_unwritten_workqueue;
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 68fea439d974..abf06bf9c3f3 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -528,6 +528,9 @@ xfs_flush_inodes(
> >  {
> >  	struct super_block	*sb = mp->m_super;
> >  
> > +	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> > +		return;
> > +
> >  	if (down_read_trylock(&sb->s_umount)) {
> >  		sync_inodes_sb(sb);
> >  		up_read(&sb->s_umount);
> > @@ -1366,6 +1369,17 @@ xfs_fc_fill_super(
> >  	if (error)
> >  		goto out_free_names;
> >  
> > +	/*
> > +	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> > +	 * quarter of a second.  The magic numbers here were determined by
> > +	 * observation neither to cause stalls in writeback when there are a
> > +	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> > +	 * regressions.  YMMV.
> > +	 */
> > +	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> > +	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> > +			RATELIMIT_MSG_ON_RELEASE);
> 
> Urk.
> 
> RATELIMIT_MSG_ON_RELEASE prevents "callbacks suppressed"
> messages when rate limiting was active and resets via __rate_limit().
> However, in ratelimit_state_exit(), that flag -enables- printing
> "callbacks suppressed" messages when rate limiting was active and is
> reset.
> 
> Same flag, exact opposite behaviour...
> 
> The comment says it's behaviour is supposed to match that of
> ratelimit_state_exit() (i.e. print message on ratelimit exit), so I
> really can't tell if this is correct/intended usage or just API
> abuse....

This flag (AFAICT) basically means "summarize skipped calls later",
where later is when _exit is called.  It's very annoying that this
printk thing is mixed in with what otherwise is a simple ratelimiting
mechanism, since there isn't much to be gained by spamming dmesg every
time a buffered write hits ENOSPC, and absolutely nothing to be gained
by logging that at umount time (with comm being the umount process!)

Since there's no design documentation for how the ratelimiting system
works, the best I can do is RTFS and do whatever magic gets the outcome
I want (which is to set the flag and skip calling _exit.  Only one of
the ratelimit state users calls ratelimit_state_exit, so it's apparently
not required.

This all is poor engineering practice, but you /did/ suggest
ratelimiting (on IRC) and I don't want to go reimplementing ratelimit.c
either, and it /does/ fix the xfs_flush_inodes flooding problems.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
