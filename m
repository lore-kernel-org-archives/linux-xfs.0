Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE2E17F37
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 07:03:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE46E8F807A
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 05:03:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CLsKnYym8e3Gpjnn for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 05:03:13 -0700 (PDT)
Date: Tue, 30 Apr 2013 22:03:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
Message-ID: <20130430120306.GL23072@dastard>
References: <20130412145555.GF30622@dastard> <51799C24.8010901@sgi.com>
	<20130425214040.GQ30622@dastard> <517EE729.2030706@sgi.com>
	<20130429220952.GB23072@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130429220952.GB23072@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 30, 2013 at 08:09:52AM +1000, Dave Chinner wrote:
> On Mon, Apr 29, 2013 at 04:33:29PM -0500, Mark Tinguely wrote:
> > On 04/25/13 16:40, Dave Chinner wrote:
> > >On Thu, Apr 25, 2013 at 04:12:04PM -0500, Mark Tinguely wrote:
> > Index: b/include/xfs/xfs_dir2_format.h
> > ===================================================================
> > --- a/include/xfs/xfs_dir2_format.h
> > +++ b/include/xfs/xfs_dir2_format.h
> > @@ -40,7 +40,6 @@
> >   */
> >  typedef	__uint16_t	xfs_dir2_data_off_t;
> >  #define	NULLDATAOFF	0xffffU
> > -typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
> 
> This file is common with the kernel code, so whatever other
> definition it conflicts with is the one to remove.
> 
> > @@ -61,11 +60,6 @@ typedef	__uint32_t	xfs_dir2_dataptr_t;
> >  typedef	xfs_off_t	xfs_dir2_off_t;
> > 
> >  /*
> > - * Directory block number (logical dirblk in file)
> > - */
> > -typedef	__uint32_t	xfs_dir2_db_t;
> 
> Same here.

So looking at this in more detail, the reason these got added to
xfs_dir2.h was that there are a bunch of function prototypes I had
to move from xfs_dir2_priv.h to xfs_dir2.h so that they were visible
outside libxfs. This is one of the changes I need to propagate back
into the kernel code to bring the kernel headers inline with what is
needed by userspace.

So as a temporary measure, the above patch that just removes them
from xfs_dir2_format.h is OK. I'll fold these into the current
patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
