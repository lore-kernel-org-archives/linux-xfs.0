Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 477EC7F50
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 17:01:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8801AC003
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 15:01:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lzLYB3cmJWeGZHWN for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 15:00:59 -0700 (PDT)
Date: Tue, 9 Sep 2014 08:00:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't ASSERT on corrupt ftype
Message-ID: <20140908220036.GO30012@dastard>
References: <540D011B.2000807@redhat.com> <20140908130507.GN30012@dastard>
	<540DB3FE.6010309@sandeen.net> <540DB6F3.7090407@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540DB6F3.7090407@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 08, 2014 at 09:02:27AM -0500, Eric Sandeen wrote:
> On 9/8/14 8:49 AM, Eric Sandeen wrote:
> >On 9/8/14 8:05 AM, Dave Chinner wrote:
> >>On Sun, Sep 07, 2014 at 08:06:35PM -0500, Eric Sandeen wrote:
> >>>xfs_dir3_data_get_ftype() and xfs_dir2_sf_check() get
> >>>the file type off disk, but ASSERT if it's invalid:
> >>>
> >>>    ASSERT(type < XFS_DIR3_FT_MAX);
> >>>
> >>>This might be cut & paste from the "put" functions,
> >>>which should be checking that they've not been passed
> >>>bad values, but we shouldn't ASSERT on bad values
> >>>read from disk.
> >>
> >>No, they weren't cut-n-paste from the put functions. They were
> >>actually designed for a metadata block where bad values would not be
> >>written to disk, and corrupted disk blocks would be detected by CRC
> >>validation failures. So on debug kernels it's quite appropriate to
> >>assert fail on a "should never, ever happen" condition.
> >
> >hohum, ok.
> 
> So then presumably the reason there is no ASSERT in xfs_dir3_sfe_get_ftype
> (vs in xfs_dir3_data_get_ftype) is also purely intentional and
> part of the design, but I'm unable to divine that logic... can you
> help me out?

Because that ASSERT check was put in xfs_dir2_sf_check(). Yeah, I
know, not consistent, but the shortform code is quite different to
the block/leaf/node code....

> I guess the only way forward is to create a 3rd set of ops, and have
> one for dir2, one for dir2-with-ftype, and one for dir3?  Because
> in the op, there's no way to discern between the latter 2, and
> know if we're previously CRC-protected or not...

No, just kill the asset in xfs_dir3_data_get_ftype().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
