Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39BAC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 06:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861B920578
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 06:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgHXGPl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 02:15:41 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:45167 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbgHXGPl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 02:15:41 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 533291AA985;
        Mon, 24 Aug 2020 16:15:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kA5lT-0001fw-Dr; Mon, 24 Aug 2020 16:15:31 +1000
Date:   Mon, 24 Aug 2020 16:15:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200824061531.GQ7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797594159.965217.2504039364311840477.stgit@magnolia>
 <20200824012527.GP7941@dread.disaster.area>
 <20200824031354.GU6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824031354.GU6096@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=WukEltCIrTdCLUkw2XAA:9 a=iTH_tXdgWGGkBpXt:21
        a=NYAAHtNQhoSsH-xZ:21 a=CjuIK1q_8ugA:10 a=_11QY0NEt4MA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 23, 2020 at 08:13:54PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 25, 2020 at 11:25:27AM +1000, Dave Chinner wrote:
> > On Thu, Aug 20, 2020 at 07:12:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > > time epoch).  This enables us to handle dates up to 2486, which solves
> > > the y2038 problem.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > 
> > ....
> > 
> > > @@ -875,6 +888,25 @@ union xfs_timestamp {
> > >   */
> > >  #define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
> > >  
> > > +/*
> > > + * Number of seconds between the start of the bigtime timestamp range and the
> > > + * start of the Unix epoch.
> > > + */
> > > +#define XFS_INO_BIGTIME_EPOCH	(-XFS_INO_TIME_MIN)
> > 
> > This is confusing. It's taken me 15 minutes so far to get my head
> > around this because the reference frame for all these definitions is
> > not clear. I though these had something to do with nanosecond
> > timestamp limits because that's what BIGTIME records, but.....
> > 
> > The start of the epoch is a negative number based on the definition
> > of the on-disk format for the minimum number of seconds that the
> > "Unix" timestamp format can store?  Why is this not defined in
> > nanoseconds given that is what is stored on disk?
> > 
> > XFS_INO_BIGTIME_EPOCH = (-XFS_INO_TIME_MIN)
> > 			= (-((int64_t)S32_MIN))
> > 			= (-((int64_t)-2^31))
> > 			= 2^31?
> > 
> > So the bigtime epoch is considered to be 2^31 *seconds* into the
> > range of the on-disk nanosecond timestamp? Huh?
> 
> They're the incore limits, not the ondisk limits.
> 
> Prior to bigtime, the ondisk timestamp epoch was the Unix epoch.  This
> isn't the case anymore in bigtime (bigtime's epoch is Dec. 1901, aka the
> minimum timestamp under the old scheme), so that misnamed
> XFS_INO_BIGTIME_EPOCH value is the conversion factor between epochs.
> 
> (I'll come back to this at the bottom.)

Ok, I'll come back to that at the bottom :)

> > > +		uint64_t		t = be64_to_cpu(ts->t_bigtime);
> > > +		uint64_t		s;
> > > +		uint32_t		n;
> > > +
> > > +		s = div_u64_rem(t, NSEC_PER_SEC, &n);
> > > +		tv->tv_sec = s - XFS_INO_BIGTIME_EPOCH;
> > > +		tv->tv_nsec = n;
> > > +		return;
> > > +	}
> > > +
> > >  	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
> > >  	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
> > >  }
> > 
> > I still don't really like the way this turned out :(
> 
> I'll think about this further and hope that hch comes up with something
> that's both functional and doesn't piss off smatch/sparse.  Note that I
> also don't have any big endian machines anymore, so I don't really have
> a good way to test this.  powerpc32 and sparc are verrrrry dead now.

I'm not sure that anyone has current BE machines to test on....

> > > +void xfs_inode_to_disk_timestamp(struct xfs_icdinode *from,
> > > +		union xfs_timestamp *ts, const struct timespec64 *tv);
> > >  
> > >  #endif	/* __XFS_INODE_BUF_H__ */
> > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > index 17c83d29998c..569721f7f9e5 100644
> > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > @@ -373,6 +373,9 @@ union xfs_ictimestamp {
> > >  		int32_t		t_sec;		/* timestamp seconds */
> > >  		int32_t		t_nsec;		/* timestamp nanoseconds */
> > >  	};
> > > +
> > > +	/* Nanoseconds since the bigtime epoch. */
> > > +	uint64_t		t_bigtime;
> > >  };
> > 
> > Where are we using this again? Right now the timestamps are
> > converted directly into the VFS inode timestamp fields so we can get
> > rid of these incore timestamp fields. So shouldn't we be trying to
> > get rid of this structure rather than adding more functionality to
> > it?
> 
> We would have to enlarge xfs_log_dinode to log a full timespec64-like
> entity.   I understand that it's annoying to convert a vfs timestamp
> back into a u64 nanoseconds counter for the sake of the log, but doing
> so will add complexity to the log for absolutely zero gain because
> having 96 bits per timestamp in the log doesn't buy us anything.

Sure, I understand that we only need to log a 64bit value, but we
don't actually need a structure for that as the log is in native
endian format. Hence it can just be a 64 bit field that we mask and
shift for !bigtime inodes...

Note that we have to be real careful about dynamic conversion,
especially in recovery, as the inode read from disk might be in
small time format, but logged and recovered in bigtime format. I
didn't actually check the recovery code does that correctly, because
it only just occurred to me that the logged timestamp format may not
match the inode flags read from disk during recovery...

> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -841,6 +841,8 @@ xfs_ialloc(
> > >  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> > >  		inode_set_iversion(inode, 1);
> > >  		ip->i_d.di_flags2 = 0;
> > > +		if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > > +			ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > 
> > Rather than calculate the initial inode falgs on every allocation,
> > shouldn't we just have the defaults pre-calculated at mount time?
> 
> Hm, yes.  Add that to the inode geometry structure?

Sounds like a reasonable place to me.

> > >  		ip->i_d.di_cowextsize = 0;
> > >  		ip->i_d.di_crtime = tv;
> > >  	}
> > > @@ -2717,7 +2719,11 @@ xfs_ifree(
> > >  
> > >  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
> > >  	ip->i_d.di_flags = 0;
> > > -	ip->i_d.di_flags2 = 0;
> > > +	/*
> > > +	 * Preserve the bigtime flag so that di_ctime accurately stores the
> > > +	 * deletion time.
> > > +	 */
> > > +	ip->i_d.di_flags2 &= XFS_DIFLAG2_BIGTIME;
> > 
> > Oh, that's a nasty wart.
> 
> And here again?

*nod*. Good idea - we will have logged the inode core and converted
it in-core to bigtime by this point...

> > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > index 7158a8de719f..3e0c677cff15 100644
> > > --- a/fs/xfs/xfs_ondisk.h
> > > +++ b/fs/xfs/xfs_ondisk.h
> > > @@ -25,6 +25,9 @@ xfs_check_limits(void)
> > >  	/* make sure timestamp limits are correct */
> > >  	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> > >  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> > > +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_EPOCH,			2147483648LL);
> > > +	XFS_CHECK_VALUE(XFS_INO_BIGTIME_MIN,			-2147483648LL);
> > 
> > That still just doesn't look right to me :/
> > 
> > This implies that the epoch is 2^32 seconds after then minimum
> > supported time (2038), when in fact it is only 2^31 seconds after the
> > minimum supported timestamp (1970). :/
> 
> Ok, so XFS_INO_UNIX_BIGTIME_MIN is -2147483648, to signify that the
> smallest bigtime timestamp is (still) December 1901.

Let's drop the "ino" from the name - it's unnecessary, I think.

> That thing currently known as XFS_INO_BIGTIME_EPOCH should probably get
> renamed to something less confusing, like...
>
> /*
>  * Since the bigtime epoch is Dec. 1901, add this number of seconds to
>  * an ondisk bigtime timestamp to convert it to the Unix epoch.
>  */
> #define XFS_BIGTIME_TO_UNIX		(-XFS_INO_UNIX_BIGTIME_MIN)
> 
> /*
>  * Subtract this many seconds from a Unix epoch timestamp to get the
>  * ondisk bigtime timestamp.
>  */
> #define XFS_UNIX_TO_BIGTIME		(-XFS_BIGTIME_TO_UNIX)
> 
> Is that clearer?

Hmmm. Definitely better, but how about:

/*
 * Bigtime epoch is set exactly to the minimum time value that a
 * traditional 32 bit timestamp can represent when using the Unix
 * epoch as a reference. Hence the Unix epoch is at a fixed offset
 * into the supported bigtime timestamp range.
 *
 * The bigtime epoch also matches the minimum value an on-disk 32
 * bit XFS timestamp can represent so we will not lose any fidelity
 * in converting to/from unix and bigtime timestamps.
 */
#define XFS_BIGTIME_EPOCH_OFFSET	(XFS_INO_TIME_MIN)

And then two static inline helpers follow immediately -
xfs_bigtime_to_unix() and xfs_bigtime_from_unix() can do the
conversion between the two formats and the XFS_BIGTIME_EPOCH_OFFSET
variable never gets seen anywhere else in the code. To set the max
timestamp value the superblock holds for the filesystem, just
calculate it directly via a call to xfs_bigtime_to_unix(-1ULL, ...)

> > Hmmm. I got 16299260424 when I just ran this through a simple calc.
> > Mind you, no calculator app I found could handle unsigned 64 bit
> > values natively (signed 64 bit is good enough for everyone!) so
> > maybe I got an off-by one here...
> 
> -1ULL = 18,446,744,073,709,551,615
> -1ULL / NSEC_PER_SEC = 18,446,744,073
> (-1ULL / NSEC_PER_SEC) - XFS_INO_BIGTIME_EPOCH = 16,299,260,425

Yup, I got an off by one thanks to integer rounding on the
division. I should have just done it long hand like that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
