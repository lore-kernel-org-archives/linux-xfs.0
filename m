Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E203EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAEF42067C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pj8iuZr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHSVnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:43:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSVnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 17:43:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JLb0Xg065259;
        Wed, 19 Aug 2020 21:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MkoXUsgbjFVfEXWflGzX6keVGaEU79Y4Im5DA7vczOU=;
 b=pj8iuZr/bW3ZmsO2GcVsYs3j6RQOXmypXIQ7BorGar8dnrk5O+BKcXYeUVw+i3x60uDD
 YZdMeePeQuiIF4dPe5ZiRAR6WqRV5wc+f60GxSJfRLhxObxBYJvayJ46+z9FmQM2waIk
 k4KHiDL7PRbhQKF7VIv9urV7pt0m76g2DTTX31wN+v15Qgr5mPvsG/VATRmUWrYhaUMA
 APv2sweZ1sscqqg/QgFtRr6hG+5/RiWKMAKw475E9x7VuLad0Trt2NsTI4z2H17qfRxV
 SWxsS7oXB2IZs2l0Q9dDw7OMpoPPvmwW34mdbSm5ynntUVItEmuP9TmT5swEI4FI+zLV 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bncxvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 21:43:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07JLcI27112092;
        Wed, 19 Aug 2020 21:43:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfu3g5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 21:43:25 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07JLhNmv023024;
        Wed, 19 Aug 2020 21:43:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Aug 2020 14:43:23 -0700
Date:   Wed, 19 Aug 2020 14:43:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200819214322.GE6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <20200818233535.GD21744@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818233535.GD21744@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 09:35:35AM +1000, Dave Chinner wrote:
> On Mon, Aug 17, 2020 at 03:57:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > time epoch).  This enables us to handle dates up to 2486, which solves
> > the y2038 problem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> .....
> > +/* Convert an ondisk timestamp into the 64-bit safe incore format. */
> >  void
> >  xfs_inode_from_disk_timestamp(
> > +	struct xfs_dinode		*dip,
> >  	struct timespec64		*tv,
> >  	const union xfs_timestamp	*ts)
> >  {
> > +	if (dip->di_version >= 3 &&
> > +	    (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) {
> > +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> > +		uint64_t		s;
> > +		uint32_t		n;
> > +
> > +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > +		tv->tv_nsec = n;
> > +		return;
> > +	}
> > +
> >  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> >  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> >  }
> 
> Can't say I'm sold on this union. It seems cleaner to me to just
> make the timestamp an opaque 64 bit field on disk and convert it to
> the in-memory representation directly in the to/from disk
> operations. e.g.:
> 
> void
> xfs_inode_from_disk_timestamp(
> 	struct xfs_dinode		*dip,
> 	struct timespec64		*tv,
> 	__be64				ts)
> {
> 
> 	uint64_t		t = be64_to_cpu(ts);
> 	uint64_t		s;
> 	uint32_t		n;
> 
> 	if (xfs_dinode_is_bigtime(dip)) {
> 		s = div_u64_rem(t, NSEC_PER_SEC, &n) - XFS_INO_BIGTIME_EPOCH;
> 	} else {
> 		s = (int)(t >> 32);
> 		n = (int)(t & 0xffffffff);
> 	}
> 	tv->tv_sec = s;
> 	tv->tv_nsec = n;
> }

I don't like this open-coded union approach at all because now I have to
keep the t_sec and t_nsec bits separate in my head instead of letting
the C compiler take care of that detail.  The sample code above doesn't
handle that correctly either:

Start with an old kernel on a little endian system; each uppercase
letter represents a byte (A is the LSB of t_sec, D is the MSB of t_sec,
E is the LSB of t_nsec, and H is the MSB of t_nsec):

	sec  nsec (incore)
	ABCD EFGH

That gets written out as:

	sec  nsec (ondisk)
	DCBA HGFE

Now reboot with a new kernel that only knows 64bit timestamps on disk:

	64bit (ondisk)
	DCBAHGFE

Now it does the first be64_to_cpu conversion:
	64bit (incore)
	EFGHABCD

And then masks and shifts:
	sec  nsec (incore)
	EFGH ABCD

Oops, we just switched the values!

The correct approach (I think) is to perform the shifting and masking on
the raw __be64 value before converting them to incore format via
be32_to_cpu, but now I have to work out all four cases by hand instead
of letting the compiler do the legwork for me.  I don't remember if it's
correct to go around shifting and masking __be64 values.

I guess the good news is that at least we have generic/402 to catch
these kinds of persistence problems, but ugh.

Anyway, what are you afraid of?  The C compiler smoking crack and not
actually overlapping the two union elements?  We could control for
that...

> > @@ -220,9 +234,9 @@ xfs_inode_from_disk(
> >  	 * a time before epoch is converted to a time long after epoch
> >  	 * on 64 bit systems.
> >  	 */
> > -	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
> > -	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
> > -	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
> > +	xfs_inode_from_disk_timestamp(from, &inode->i_atime, &from->di_atime);
> > +	xfs_inode_from_disk_timestamp(from, &inode->i_mtime, &from->di_mtime);
> > +	xfs_inode_from_disk_timestamp(from, &inode->i_ctime, &from->di_ctime);
> >  
> >  	to->di_size = be64_to_cpu(from->di_size);
> >  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> > @@ -235,9 +249,17 @@ xfs_inode_from_disk(
> >  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> >  		inode_set_iversion_queried(inode,
> >  					   be64_to_cpu(from->di_changecount));
> > -		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> > +		xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> > +				&from->di_crtime);
> >  		to->di_flags2 = be64_to_cpu(from->di_flags2);
> >  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> > +		/*
> > +		 * Set the bigtime flag incore so that we automatically convert
> > +		 * this inode's ondisk timestamps to bigtime format the next
> > +		 * time we write the inode core to disk.
> > +		 */
> > +		if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
> > +			to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
> >  	}
> 
> We do not want on-disk flags to be changed outside transactions like
> this. Indeed, this has implications for O_DSYNC operation, in that
> we do not trigger inode sync operations if the inode is only
> timestamp dirty. If we've changed this flag, then the inode is more
> than "timestamp dirty" and O_DSYNC will need to flush the entire
> inode.... :/

I forgot about XFS_ILOG_TIMESTAMP.

> IOWs, I think we should only change this flag in a timestamp
> transaction where the timestamps are actually being logged and hence
> we can set inode dirty state appropriately so that everything will
> get logged, changed and written back correctly....

Yeah, that's fair.  I'll change xfs_trans_log_inode to set the bigtime
flag if we're logging either the timestamps or the core.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
