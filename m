Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EA3C352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A8120675
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OgDW3HtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgBMB0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:26:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgBMB0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 20:26:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1MUWi156698;
        Thu, 13 Feb 2020 01:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kTFj/U7lB9ceViLtlJcrDP0hh+iMuCH6D49Oyc3ZYfc=;
 b=OgDW3HtLstjpgQYNvfQZV4lyliDMIjFLpampUKvo+vWM2n351zgfqu2lPoOJOVN4VgBJ
 UcYBK6hn3/Vd6rPK7pEK+qh4roF+GNSFT1A9V5HJ0+GkYV0gfENGriX8w8VWyOe8JCrk
 fljtCuKnbJddjJk6yVkrOepsTaPPR0W24zO24yECRGEyNCgW0jj5brpT6/dGGK1Oz8Js
 LMnssBT2mbvNCENpZl3n9hMpy7OV6hI51EHHdh5lo8Zjzaw0mt3Fp5eGSaWaiMdZ8vdu
 f98puyt6PA/AH0reo6tpkAvJKUJoRvWF6AHp3b2bmJzqW8ugAy3cnB4URhv7v9hqfqGt PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y2k88emfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:26:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1NBdo174948;
        Thu, 13 Feb 2020 01:26:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y4k9gsyqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:26:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01D1Q9eI001455;
        Thu, 13 Feb 2020 01:26:11 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:26:09 -0800
Date:   Wed, 12 Feb 2020 17:26:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: explicitly define inode timestamp range
Message-ID: <20200213012607.GW6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784106702.1364230.14985571182679451055.stgit@magnolia>
 <639ba6e0-71b3-1d81-820e-ad49a56a032c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639ba6e0-71b3-1d81-820e-ad49a56a032c@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 05:00:59PM -0600, Eric Sandeen wrote:
> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   19 +++++++++++++++++++
> >  fs/xfs/xfs_ondisk.h        |    8 ++++++++
> >  fs/xfs/xfs_super.c         |    4 ++--
> >  3 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 9ff373962d10..82b15832ba32 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -841,11 +841,30 @@ typedef struct xfs_agfl {
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
> > +
> >  /*
> >   * On-disk inode structure.
> >   *
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index fa0ec2fae14a..f67f3645efcd 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -15,9 +15,17 @@
> >  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
> >  		"expected " #off)
> >  
> > +#define XFS_CHECK_VALUE(value, expected) \
> > +	BUILD_BUG_ON_MSG((value) != (expected), \
> > +		"XFS: value of " #value " is wrong, expected " #expected)
> > +
> >  static inline void __init
> >  xfs_check_ondisk_structs(void)
> >  {
> > +	/* make sure timestamp limits are correct */
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN, 			-2147483648LL);
> > +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> 
> IMHO this really shouldn't be in a function with this name, as it's not checking
> an ondisk struct.  And I'm not really sure what it's protecting against?
> Basically you put an integer in one #define and check it in another?

Admittedly /this/ part isn't so crucial, because S32_MAX is never going
to be redefined.  However, I added this for completeness; notice that
the patch that widens xfs_timestamp_t adds similar checks for the new
minimum and maximum timestamp, whose values are not so straightforward.

Also, I get that this isn't directly checking an ondisk structure, but
given that we use these constants, there ought to be a check against
incorrect computation *somewhere*.  The BUILD_BUG_ON macros don't
produce any real code (and this function is called at __init time) so
what's the harm?

--D

> > +
> >  	/* ag/file structures */
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index f687181a2720..3bddf13cd8ea 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1582,8 +1582,8 @@ xfs_fc_fill_super(
> >  	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
> >  	sb->s_max_links = XFS_MAXLINK;
> >  	sb->s_time_gran = 1;
> > -	sb->s_time_min = S32_MIN;
> > -	sb->s_time_max = S32_MAX;
> > +	sb->s_time_min = XFS_INO_TIME_MIN;
> > +	sb->s_time_max = XFS_INO_TIME_MAX;
> >  	sb->s_iflags |= SB_I_CGROUPWB;
> >  
> >  	set_posix_acl_flag(sb);
> > 
