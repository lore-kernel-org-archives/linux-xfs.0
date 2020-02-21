Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7539AC11D00
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41583206EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i9S3UxCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgBUAdN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:33:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbgBUAdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 19:33:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0WjDj168407;
        Fri, 21 Feb 2020 00:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iF2ixjdsP5g/IVNqSE+p4FAoH4C8XWCEEcOrypJrOx0=;
 b=i9S3UxCdgMkHOYJ21niAmIVvVa7Dlp7Zi77c/fiyeL4t543PCeyAlHgb8GfBTp4GzU4w
 Wb8X1Erpc/69scv/3DveUtNTgvY1C+BobbQLNHKBWATjy7hrghTveZFUfvJCZFO/YR+f
 SaOGA7bqACu+4rdklbfOVX8KuyeFwXU+YbFAIw/6OGdt4pyBbuEaTX2TaiIi7/opzxve
 cTqeJ7H2NgeqL6MOK9GkWlptzLkUsFB2Q6IjIWlXkKxMU2lMizBSdjVhg0EpJ7QT8r41
 xQjaxpocFvsgHnalk+EeMfRtG80K6mUkU+z5q43XhEM3fZOOqnKmc9mXNpbJvzNa1mRg YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y8ud1daqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:33:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0Vi82129324;
        Fri, 21 Feb 2020 00:33:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y8ud53syb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:33:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01L0X60m028783;
        Fri, 21 Feb 2020 00:33:08 GMT
Received: from localhost (/10.145.178.17)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 16:33:06 -0800
Date:   Thu, 20 Feb 2020 16:33:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] libxfs: enable tools to check that metadata updates
 have been committed
Message-ID: <20200221003306.GD9506@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216292664.601264.186457838279269618.stgit@magnolia>
 <20200220234055.GQ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220234055.GQ10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 10:40:55AM +1100, Dave Chinner wrote:
> On Wed, Feb 19, 2020 at 05:42:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new function that will ensure that everything we changed has
> > landed on stable media, and report the results.  Subsequent commits will
> > teach the individual programs to report when things go wrong.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/xfs_mount.h |    3 +++
> >  libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/libxfs_io.h  |    2 ++
> >  libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
> >  4 files changed, 73 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index 29b3cc1b..c80aaf69 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
> >  extern void	libxfs_umount (xfs_mount_t *);
> >  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
> >  
> > +void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
> > +		int *rtdev);
> > +
> >  #endif	/* __XFS_MOUNT_H__ */
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index a0d4b7f4..d1d3f4df 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
> >  	}
> >  	btp->bt_mount = mp;
> >  	btp->dev = dev;
> > +	btp->lost_writes = false;
> > +
> >  	return btp;
> >  }
> >  
> > @@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
> >  	mp->m_rsumip = mp->m_rbmip = NULL;
> >  }
> >  
> > +static inline int
> > +libxfs_flush_buftarg(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	if (btp->lost_writes)
> > +		return -ENOTRECOVERABLE;
> > +
> > +	return libxfs_blkdev_issue_flush(btp);
> > +}
> > +
> > +/*
> > + * Purge the buffer cache to write all dirty buffers to disk and free all
> > + * incore buffers.  Buffers that cannot be written will cause the lost_writes
> > + * flag to be set in the buftarg.  If there were no lost writes, flush the
> > + * device to make sure the writes made it to stable storage.
> > + *
> > + * For each device, the return code will be set to -ENOTRECOVERABLE if we
> > + * couldn't write something to disk; or the results of the block device flush
> > + * operation.
> > + */
> > +void
> > +libxfs_flush_devices(
> > +	struct xfs_mount	*mp,
> > +	int			*datadev,
> > +	int			*logdev,
> > +	int			*rtdev)
> > +{
> > +	*datadev = *logdev = *rtdev = 0;
> > +
> > +	libxfs_bcache_purge();
> > +
> > +	if (mp->m_ddev_targp)
> > +		*datadev = libxfs_flush_buftarg(mp->m_ddev_targp);
> > +
> > +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> > +		*logdev = libxfs_flush_buftarg(mp->m_logdev_targp);
> > +
> > +	if (mp->m_rtdev_targp)
> > +		*rtdev = libxfs_flush_buftarg(mp->m_rtdev_targp);
> > +}
> 
> So one of the things I'm trying to do is make this use similar code
> to the kernel. basically this close process is equivalent of
> xfs_wait_buftarg() which waits for all references to buffers to
> got away, and if any buffer it tagged with WRITE_FAIL then it issues
> and alert before it frees the buffer.
> 
> IOWs, any sort of delayed/async write failure that hasn't been
> otherwise caught by the async/delwri code is caught by the device
> close code....
> 
> Doing things like this (storing a "lost writes" flag on the buftarg)
> I think is just going to make it harder to switch to kernel
> equivalent code because it just introduces even more of an impedance
> mismatch between userspace and kernel code...

Hmm.  In today's version of the code I've taken Brian's suggestions and
hidden all of the flushing and whinging details inside libxfs_umount.
This eliminates all of the external API and dependency hell (except that
_umount now returns The Usual Errorcode) which will make it easier(?) to
rip all of that out some day when we're ready to land your libaio port.
Maybe?

In the meantime, I really /do/ need to solve the user complaints about
xfs_repair spewing evidence on stderr that it hasn't fully fixed the fs
and yet exits with 0 status.

It would be much easier for me to design my patchsets to minimize your
rebasing headaches if you patchbombed your development tree on a
semi-regular basis like I do, if nothing else so that we can all see
what could be in the pipeline. :)

(I dunno, maybe we need a separate git backup^W^Wpatchbomb list. :P)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
