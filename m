Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD1BC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB612078A
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yCZM6DrG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgHXCjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:39:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgHXCjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:39:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2YnxP151972;
        Mon, 24 Aug 2020 02:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=puusuTCLugDoYgJ0KJDHGfRVYaw4XBuSnDZXNpsn8T4=;
 b=yCZM6DrGDmjx8gxxCk901lz1R2LVIUnNID7dsCXqsc/jkrIOtsDLYP4qVE/0Y4TEDbRu
 vMT/BHBIeA6Kw+ptF8YDJMY9LfuclxAPOXujN3GP9AAURgdZmdmcn/tjjh/1CJ0TEdhN
 tKIz2HlOTpSSuuGO322isDbeYj599OWFp8qK9C0A0zwf6fUa0jLEdsBijGs8DZbK8pna
 Pjq6Dnz9XDDSgtz9oJUIQ2me8PtoLV8tf5tYGYhZ+yx83zWhe+3/F7rxkBzaclzky0kg
 8yxmLCbmeVW+1uKKe7yf1WgkCHMyQwT9Zfz496N1xGSY/y1MJIHipQ3EQ5p+lzpfwCv7 CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 333csht44a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:39:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2ZBSw063898;
        Mon, 24 Aug 2020 02:39:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 333r9gmaa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:39:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07O2dcnh005656;
        Mon, 24 Aug 2020 02:39:39 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:39:38 -0700
Date:   Sun, 23 Aug 2020 19:39:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 10/11] xfs: enable bigtime for quota timers
Message-ID: <20200824023937.GS6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797595474.965217.7111215541487615114.stgit@magnolia>
 <20200822073600.GJ1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822073600.GJ1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:36:00AM +0100, Christoph Hellwig wrote:
> On Thu, Aug 20, 2020 at 07:12:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Enable the bigtime feature for quota timers.  We decrease the accuracy
> > of the timers to ~4s in exchange for being able to set timers up to the
> > bigtime maximum.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_dquot_buf.c  |   32 ++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_format.h     |   27 ++++++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_quota_defs.h |    3 ++-
> >  fs/xfs/xfs_dquot.c             |   25 +++++++++++++++++++++----
> >  fs/xfs/xfs_dquot.h             |    3 ++-
> >  fs/xfs/xfs_ondisk.h            |    7 +++++++
> >  fs/xfs/xfs_qm.c                |    2 ++
> >  fs/xfs/xfs_qm_syscalls.c       |    9 +++++----
> >  fs/xfs/xfs_trans_dquot.c       |    6 ++++++
> >  9 files changed, 101 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > index 7f5291022b11..f5997fbdd308 100644
> > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > @@ -69,6 +69,13 @@ xfs_dquot_verify(
> >  	    ddq_type != XFS_DQTYPE_GROUP)
> >  		return __this_address;
> >  
> > +	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
> > +	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> > +		return __this_address;
> > +
> > +	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
> > +		return __this_address;
> > +
> >  	if (id != -1 && id != be32_to_cpu(ddq->d_id))
> >  		return __this_address;
> >  
> > @@ -296,7 +303,15 @@ xfs_dquot_from_disk_timestamp(
> >  	time64_t		*timer,
> >  	__be32			dtimer)
> >  {
> > -	*timer = be32_to_cpu(dtimer);
> > +	uint64_t		t;
> > +
> > +	if (!timer || !(ddq->d_type & XFS_DQTYPE_BIGTIME)) {
> > +		*timer = be32_to_cpu(dtimer);
> 
> I don't think setting *time makes any sense if time is NULL..

Oops, yeah, I introduced that bug when reworking this function. :(

> > +		return;
> > +	}
> > +
> > +	t = be32_to_cpu(dtimer);
> > +	*timer = t << XFS_DQ_BIGTIME_SHIFT;
> 
> Why not:
> 
> 	*timer = (time64_t)be32_to_cpu(dtimer) << XFS_DQ_BIGTIME_SHIFT;
> 
> or (with my previous suggestion):
> 
> 	return (time64_t)be32_to_cpu(dtimer) << XFS_DQ_BIGTIME_SHIFT;

<nod>  Looks good to me.

--D

> 
> ?
> 
> > @@ -1227,13 +1227,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  #define XFS_DQTYPE_USER		0x01		/* user dquot record */
> >  #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
> >  #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> > +#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
> >  
> >  /* bitmask to determine if this is a user/group/project dquot */
> >  #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
> >  				 XFS_DQTYPE_PROJ | \
> >  				 XFS_DQTYPE_GROUP)
> >  
> > -#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
> > +#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
> > +				 XFS_DQTYPE_BIGTIME)
> >  
> >  /*
> >   * XFS Quota Timers
> > @@ -1270,6 +1272,29 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  #define XFS_DQ_GRACE_MIN	((int64_t)0)
> >  #define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
> >  
> > +/*
> > + * When bigtime is enabled, we trade a few bits of precision to expand the
> > + * expiration timeout range to match that of big inode timestamps.  The grace
> > + * periods stored in dquot 0 are not shifted, since they record an interval,
> > + * not a timestamp.
> > + */
> > +#define XFS_DQ_BIGTIME_SHIFT	(2)
> > +#define XFS_DQ_BIGTIME_SLACK	((int64_t)(1ULL << XFS_DQ_BIGTIME_SHIFT) - 1)
> > +
> > +/*
> > + * Smallest possible quota expiration with big timestamps, which is
> > + * Jan  1 00:00:01 UTC 1970.
> > + */
> > +#define XFS_DQ_BIGTIMEOUT_MIN		(XFS_DQ_TIMEOUT_MIN)
> > +
> > +/*
> > + * Largest supported quota expiration with traditional timestamps, which is
> > + * the largest bigtime inode timestamp, or Jul  2 20:20:25 UTC 2486.  The field
> 
> This adds and > 80 char line.
