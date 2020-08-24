Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500EBC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B661206F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MlwMFQ78"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHXCgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:36:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39410 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXCgO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:36:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2ZA9W095785;
        Mon, 24 Aug 2020 02:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uSxDCLA78QLJndPuUYSLmP/t2SmuCK9NnHTspAqIM7Q=;
 b=MlwMFQ784jCr/9l7daR9YLJTj2l1ZZTyvQcAVGA3HwVHMR2FOWiXkQZdhPgCPyhzyUTs
 rK1XZRzsBOybmEUXCgV5Twkmk4XdBIe6hmXGwpAP2vBl9D7hTIVDbxUhoimIovlQS/BL
 pxKM9968dhhXUn3Z3NtMuHuJhxA+8RYndxCb0q3qT+VkqEKLCzFLy1PZ/Dy9GvL9z8ki
 aRXQn56tU4qAipq44d5N/I7qXqY5+Qb3i1RrMX6RmHf3lSdVofp9HnzLC/Ul1+cck57j
 Fr7XjilWed1efBkIQhgiJXAtcLpWohH1n9H9UxwuycYa4CJM5HXz5hkLOrErSD+ObM+Q GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6tgkft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:36:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2UUkv112508;
        Mon, 24 Aug 2020 02:34:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333rtvvaa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:34:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07O2Y8Q0008364;
        Mon, 24 Aug 2020 02:34:08 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:34:08 -0700
Date:   Sun, 23 Aug 2020 19:34:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200824023407.GO6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797589388.965217.3068074933916806311.stgit@magnolia>
 <20200823235429.GJ7941@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823235429.GJ7941@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 09:54:29AM +1000, Dave Chinner wrote:
> On Thu, Aug 20, 2020 at 07:11:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Formally define the inode timestamp ranges that existing filesystems
> > support, and switch the vfs timetamp ranges to use it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   19 +++++++++++++++++++
> >  fs/xfs/xfs_ondisk.h        |   12 ++++++++++++
> >  fs/xfs/xfs_super.c         |    5 +++--
> >  3 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index be86fa1a5556..b1b8a5c05cea 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -849,11 +849,30 @@ struct xfs_agfl {
> >  	    ASSERT(xfs_daddr_to_agno(mp, d) == \
> >  		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
> >  
> > +/*
> > + * XFS Timestamps
> > + * ==============
> > + *
> > + * Inode timestamps consist of signed 32-bit counters for seconds and
> > + * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> > + */
> >  typedef struct xfs_timestamp {
> >  	__be32		t_sec;		/* timestamp seconds */
> >  	__be32		t_nsec;		/* timestamp nanoseconds */
> >  } xfs_timestamp_t;
> >  
> > +/*
> > + * Smallest possible timestamp with traditional timestamps, which is
> > + * Dec 13 20:45:52 UTC 1901.
> > + */
> > +#define XFS_INO_TIME_MIN	((int64_t)S32_MIN)
> > +
> > +/*
> > + * Largest possible timestamp with traditional timestamps, which is
> > + * Jan 19 03:14:07 UTC 2038.
> > + */
> > +#define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
> 
> These are based on the Unix epoch. Can we call them something like
> XFS_INO_UNIX_TIME_{MIN,MAX} to indicate what epoch they reference?

I'll update the comment and name to make it clear that this is the Unix
epoch we're talking about.

> >  /*
> >   * On-disk inode structure.
> >   *
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index acb9b737fe6b..48a64fa49f91 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -15,6 +15,18 @@
> >  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
> >  		"expected " #off)
> >  
> > +#define XFS_CHECK_VALUE(value, expected) \
> > +	BUILD_BUG_ON_MSG((value) != (expected), \
> > +		"XFS: value of " #value " is wrong, expected " #expected)
> > +
> > +static inline void __init
> > +xfs_check_limits(void)
> > +{
> > +	/* make sure timestamp limits are correct */
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> > +}
> 
> Not sure this really gains us anything? All it does is check that
> S32_MIN/S32_MAX haven't changed value....

Will remove.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
