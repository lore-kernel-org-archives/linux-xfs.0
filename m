Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21B037F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 18:56:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CBC6AC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:56:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FhfNaL8Gk4mK4rgq for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 16:56:22 -0800 (PST)
Date: Tue, 3 Dec 2013 11:56:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfstests: introduce _require_xfs_crc_sb pre-checkup
	routine
Message-ID: <20131203005619.GL10988@dastard>
References: <52983C41.8000004@oracle.com>
 <20131203003759.GI10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203003759.GI10988@dastard>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 03, 2013 at 11:37:59AM +1100, Dave Chinner wrote:
> On Fri, Nov 29, 2013 at 03:03:29PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > Introduce _require_xfs_crc_sb to rc.  We can use it in pre-checkup
> > procedures to verify if the XFS test environment is configured with
> > CRC enabled or not for some particular test cases.
> > 
> > Introduce a new helper _xfs_sb_version to get XFS super block version
> > to make the test case more flexiable if possible. e.g, if that is
> > v5 super block, the tests behavior might be different to old v4 sb.
> > 
> > Refactor xfs/299 to use it.
> > 
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> > ---
> >  common/rc     | 19 +++++++++++++++++++
> >  tests/xfs/299 |  9 +--------
> >  2 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index f73414b..9f45279 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1579,6 +1579,25 @@ _check_xfs_filesystem()
> >      return 0
> >  }
> >  
> > +# Get XFS super block version
> > +_xfs_sb_version()
> > +{
> > +	sb_version=`$XFS_DB_PROG -r -c version $SCRATCH_DEV | \
> > +		    awk -F= '{print $2}' | awk -F, '{print $1}' | \
> > +		    cut -c3-`
> > +	echo $sb_version
> > +}
> 
> Ugh. I missed how nasty that code was originally. Maths, not string
> manipulations shoul dbe used here. i.e:
> 
> 	versionnum  filesystem  version  information.   This value is
> 		    currently 1, 2, 3, or 4 in the low 4 bits.
> 
> [ Oh, look, xfs_db man page updates are needed ]
> 
> So:
> 
> 	$XFS_DB_PROG -r -c "sb 0" -c "p versionnum" $SCRATCH_DEV | \
> 		awk '{ printf "%d\n", and(strtonum($3), 15) }'

I just realised that the way this is being used is invalid. WE need
to check that mkfs supports -m crc=1, and that the filesystem that
is created can be mounted by the kernel.

i.e. You can't just look at the
superblock version number on the scratch device
and say that the test can run because:

	a) the scratch device has not been initialised by the test
	   and so can contain garbage from previous tests; and
	b) the kernel might not support CRCs even though the
	   userspace utilities do.

Hence we need to test for both userspace and kernel support here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
