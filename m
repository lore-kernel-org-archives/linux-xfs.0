Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89770C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538D62072D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b8vYIBJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHXQ0a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:26:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXQ0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 12:26:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OGNwON120293;
        Mon, 24 Aug 2020 16:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LQ3IShqrpOwNSdFNpDQg3WtiXSFyituMd5raZU2c++g=;
 b=b8vYIBJJZsMBH2BZf3hFkcRp9lnWkf4xvqo8J/K3oV+vHnUzPTjJJr07ipEpfWU61fSa
 LsM0Lp4V0q/+HokgB0rFQfuFBdlBu2TEb+wZvqAqHdC7DcICYkNT9HS2IANfeZRvlvRi
 Tl442v8/1TytG1fkHbtLYFL48DdKzRCocgSjRqKSyHUWhwTqMBv/V6cc1c6velNQYvBn
 bEB1Jq3ZTsUvLxiy6IRj840wMSs3QWZhCwdLE+J/vXfihprebgBRzNPF1a3FfLhWAo0c
 UrZcYak/H4XhpzhPgSlXWQkxj3UBAIqmRKWZKnn5flWN7vrji/KbStHXwnjaQFbDo2Fp VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbrnk0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 16:26:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07OGEXWx176603;
        Mon, 24 Aug 2020 16:24:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333rtwqr4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 16:24:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07OGOM0Q001711;
        Mon, 24 Aug 2020 16:24:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 09:24:21 -0700
Date:   Mon, 24 Aug 2020 09:24:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200824162420.GW6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
 <20200824012527.GP7941@dread.disaster.area>
 <20200824031354.GU6096@magnolia>
 <20200824061531.GQ7941@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824061531.GQ7941@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=5
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 04:15:31PM +1000, Dave Chinner wrote:
> On Sun, Aug 23, 2020 at 08:13:54PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 25, 2020 at 11:25:27AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 20, 2020 at 07:12:21PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > > > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > > > time epoch).  This enables us to handle dates up to 2486, which solves
> > > > the y2038 problem.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > 
> > > ....
> > > 
> > > > @@ -875,6 +888,25 @@ union xfs_timestamp {
> > > >   */
> > > >  #define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
> > > >  
> > > > +/*
> > > > + * Number of seconds between the start of the bigtime timestamp range and the
> > > > + * start of the Unix epoch.
> > > > + */
> > > > +#define XFS_INO_BIGTIME_EPOCH	(-XFS_INO_TIME_MIN)
> > > 
> > > This is confusing. It's taken me 15 minutes so far to get my head
> > > around this because the reference frame for all these definitions is
> > > not clear. I though these had something to do with nanosecond
> > > timestamp limits because that's what BIGTIME records, but.....
> > > 
> > > The start of the epoch is a negative number based on the definition
> > > of the on-disk format for the minimum number of seconds that the
> > > "Unix" timestamp format can store?  Why is this not defined in
> > > nanoseconds given that is what is stored on disk?
> > > 
> > > XFS_INO_BIGTIME_EPOCH = (-XFS_INO_TIME_MIN)
> > > 			= (-((int64_t)S32_MIN))
> > > 			= (-((int64_t)-2^31))
> > > 			= 2^31?
> > > 
> > > So the bigtime epoch is considered to be 2^31 *seconds* into the
> > > range of the on-disk nanosecond timestamp? Huh?
> > 
> > They're the incore limits, not the ondisk limits.
> > 
> > Prior to bigtime, the ondisk timestamp epoch was the Unix epoch.  This
> > isn't the case anymore in bigtime (bigtime's epoch is Dec. 1901, aka the
> > minimum timestamp under the old scheme), so that misnamed
> > XFS_INO_BIGTIME_EPOCH value is the conversion factor between epochs.
> > 
> > (I'll come back to this at the bottom.)
> 
> Ok, I'll come back to that at the bottom :)
> 
> > > > +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> > > > +		uint64_t		s;
> > > > +		uint32_t		n;
> > > > +
> > > > +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > > > +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > > > +		tv->tv_nsec = n;
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> > > >  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> > > >  }
> > > 
> > > I still don't really like the way this turned out :(
> > 
> > I'll think about this further and hope that hch comes up with something
> > that's both functional and doesn't piss off smatch/sparse.  Note that I
> > also don't have any big endian machines anymore, so I don't really have
> > a good way to test this.  powerpc32 and sparc are verrrrry dead now.
> 
> I'm not sure that anyone has current BE machines to test on....

...which makes me all the more nervous about replacing the timestamp
union with open-coded bit shifting.  We know the existing code does the
conversions properly with the separate sec/nsec fields since that code
has been around for a while.  We can use BUILD_BUG_ON macros to ensure
that inside the union, the bigtime nanoseconds counter is overlayed
/exactly/ on top of the old structure.  There's a feature flag within
the ondisk structure, which means that reasoning about this code is no
more difficult than any other tagged union.

Flag == 0?  Use the same old code from before.
Flag == 1?  Use the new code.

I was about to say that I'll experiment with this as a new patch at the
end of the series, but I guess converting xfs_timestamp back to a
typedef is more churn and belongs at the start of the series...

> > > > +void xfs_inode_to_disk_timestamp(struct xfs_icdinode *from,
> > > > +		union xfs_timestamp *ts, const struct timespec64 *tv);
> > > >  
> > > >  #endif	/* __XFS_INODE_BUF_H__ */
> > > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > > index 17c83d29998c..569721f7f9e5 100644
> > > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > > @@ -373,6 +373,9 @@ union xfs_ictimestamp {
> > > >  		int32_t		t_sec;		/* timestamp seconds */
> > > >  		int32_t		t_nsec;		/* timestamp nanoseconds */
> > > >  	};
> > > > +
> > > > +	/* Nanoseconds since the bigtime epoch. */
> > > > +	uint64_t		t_bigtime;
> > > >  };
> > > 
> > > Where are we using this again? Right now the timestamps are
> > > converted directly into the VFS inode timestamp fields so we can get
> > > rid of these incore timestamp fields. So shouldn't we be trying to
> > > get rid of this structure rather than adding more functionality to
> > > it?
> > 
> > We would have to enlarge xfs_log_dinode to log a full timespec64-like
> > entity.   I understand that it's annoying to convert a vfs timestamp
> > back into a u64 nanoseconds counter for the sake of the log, but doing
> > so will add complexity to the log for absolutely zero gain because
> > having 96 bits per timestamp in the log doesn't buy us anything.
> 
> Sure, I understand that we only need to log a 64bit value, but we
> don't actually need a structure for that as the log is in native
> endian format. Hence it can just be a 64 bit field that we mask and
> shift for !bigtime inodes...
> 
> Note that we have to be real careful about dynamic conversion,
> especially in recovery, as the inode read from disk might be in
> small time format, but logged and recovered in bigtime format. I
> didn't actually check the recovery code does that correctly, because
> it only just occurred to me that the logged timestamp format may not
> match the inode flags read from disk during recovery...

Oh my, you're right, that xfs_log_dinode_to_disk_timestamp needs to be
more careful to convert whatever we logged into something that is
agnostic to disk format, and then convert it to whatever is the
xfs_dinode format.

I'll throw that on the fixme pile too.

> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -841,6 +841,8 @@ xfs_ialloc(
> > > >  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> > > >  		inode_set_iversion(inode, 1);
> > > >  		ip->i_d.di_flags2 = 0;
> > > > +		if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > > > +			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > > 
> > > Rather than calculate the initial inode falgs on every allocation,
> > > shouldn't we just have the defaults pre-calculated at mount time?
> > 
> > Hm, yes.  Add that to the inode geometry structure?
> 
> Sounds like a reasonable place to me.
> 
> > > >  		ip->i_d.di_cowextsize = 0;
> > > >  		ip->i_d.di_crtime = tv;
> > > >  	}
> > > > @@ -2717,7 +2719,11 @@ xfs_ifree(
> > > >  
> > > >  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
> > > >  	ip->i_d.di_flags = 0;
> > > > -	ip->i_d.di_flags2 = 0;
> > > > +	/*
> > > > +	 * Preserve the bigtime flag so that di_ctime accurately stores the
> > > > +	 * deletion time.
> > > > +	 */
> > > > +	ip->i_d.di_flags2 &= XFS_DIFLAG2_BIGTIME;
> > > 
> > > Oh, that's a nasty wart.
> > 
> > And here again?
> 
> *nod*. Good idea - we will have logged the inode core and converted
> it in-core to bigtime by this point...
> 
> > > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > > index 7158a8de719f..3e0c677cff15 100644
> > > > --- a/fs/xfs/xfs_ondisk.h
> > > > +++ b/fs/xfs/xfs_ondisk.h
> > > > @@ -25,6 +25,9 @@ xfs_check_limits(void)
> > > >  	/* make sure timestamp limits are correct */
> > > >  	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> > > >  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> > > > +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_EPOCH,			2147483648LL);
> > > > +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MIN,			-2147483648LL);
> > > 
> > > That still just doesn't look right to me :/
> > > 
> > > This implies that the epoch is 2^32 seconds after then minimum
> > > supported time (2038), when in fact it is only 2^31 seconds after the
> > > minimum supported timestamp (1970). :/
> > 
> > Ok, so XFS_INO_UNIX_BIGTIME_MIN is -2147483648, to signify that the
> > smallest bigtime timestamp is (still) December 1901.
> 
> Let's drop the "ino" from the name - it's unnecessary, I think.

Ok.

> > That thing currently known as XFS_INO_BIGTIME_EPOCH should probably get
> > renamed to something less confusing, like...
> >
> > /*
> >  * Since the bigtime epoch is Dec. 1901, add this number of seconds to
> >  * an ondisk bigtime timestamp to convert it to the Unix epoch.
> >  */
> > #define XFS_BIGTIME_TO_UNIX		(-XFS_INO_UNIX_BIGTIME_MIN)
> > 
> > /*
> >  * Subtract this many seconds from a Unix epoch timestamp to get the
> >  * ondisk bigtime timestamp.
> >  */
> > #define XFS_UNIX_TO_BIGTIME		(-XFS_BIGTIME_TO_UNIX)
> > 
> > Is that clearer?
> 
> Hmmm. Definitely better, but how about:
> 
> /*
>  * Bigtime epoch is set exactly to the minimum time value that a
>  * traditional 32 bit timestamp can represent when using the Unix
>  * epoch as a reference. Hence the Unix epoch is at a fixed offset
>  * into the supported bigtime timestamp range.
>  *
>  * The bigtime epoch also matches the minimum value an on-disk 32
>  * bit XFS timestamp can represent so we will not lose any fidelity
>  * in converting to/from unix and bigtime timestamps.
>  */
> #define XFS_BIGTIME_EPOCH_OFFSET	(XFS_INO_TIME_MIN)
> 
> And then two static inline helpers follow immediately -
> xfs_bigtime_to_unix() and xfs_bigtime_from_unix() can do the
> conversion between the two formats and the XFS_BIGTIME_EPOCH_OFFSET
> variable never gets seen anywhere else in the code. To set the max
> timestamp value the superblock holds for the filesystem, just
> calculate it directly via a call to xfs_bigtime_to_unix(-1ULL, ...)

<nod>

--D

> > > Hmmm. I got 16299260424 when I just ran this through a simple calc.
> > > Mind you, no calculator app I found could handle unsigned 64 bit
> > > values natively (signed 64 bit is good enough for everyone!) so
> > > maybe I got an off-by one here...
> > 
> > -1ULL = 18,446,744,073,709,551,615
> > -1ULL / NSEC_PER_SEC = 18,446,744,073
> > (-1ULL / NSEC_PER_SEC) - XFS_INO_BIGTIME_EPOCH = 16,299,260,425
> 
> Yup, I got an off by one thanks to integer rounding on the
> division. I should have just done it long hand like that...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
