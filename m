Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TGFaFR178735 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 11:15:36 -0500
Date: Mon, 29 Oct 2012 11:17:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: status of userspace release
Message-ID: <20121029161722.GF31970@sgi.com>
References: <20121025151501.GV1377@sgi.com> <20121026215741.GB405@sgi.com>
	<20121028212708.GK29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121028212708.GK29378@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Engelhardt <jengelh@inai.de>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Hi Dave, 

On Mon, Oct 29, 2012 at 08:27:08AM +1100, Dave Chinner wrote:
> On Fri, Oct 26, 2012 at 04:57:41PM -0500, Ben Myers wrote:
> > Hi,
> > 
> > On Thu, Oct 25, 2012 at 10:15:01AM -0500, Ben Myers wrote:
> > > We're working toward a userspace release this month.  There are several patches
> > > that need to go in first, including backing out the xfsdump format version bump
> > > from Eric, fixes for the makefiles from Mike, and the Polish language update
> > > for xfsdump from Jakub.  If anyone knows of something else we need, now is the
> > > time to flame about it.  I will take a look around for other important patches
> > > too.
> > > 
> > > This time I'm going to tag an -rc1 (probably later today or tomorrow).  We'll
> > > give everyone a few working days to do a final test and/or pipe up if we have
> > > missed something important.  Then if all goes well we'll cut the release next
> > > Tuesday.
> > 
> > I've tagged -rc1 for the upcoming releases of dmapi, xfsprogs, and xfsdump.  If
> > we missed something important now is the time to speak up.
> > 
> > Currently there are two items of which I'm aware:
> > 
> > 1) the Polish (and German) translations of xfsdump are not working.  I'll start
> > a separate thread for that issue.
> > 
> > 2) Christoph has pointed out this patch series:
> > 
> > http://oss.sgi.com/archives/xfs/2012-05/msg00323.html
> > http://oss.sgi.com/archives/xfs/2012-10/msg00541.html
> 
> I agree with christoph - the kernel side intptr/uintptr stuff that
> Jan did needs to go into the kernel first, and then brought to
> libxfs via a kernel code sync.  A kernel code resync needs to be
> done immediately after the xfsprogs release so that usrspace is
> using the same base code for the CRC work, so splitting them to
> before/after the relases makes sense IMO....

Sounds good.  I'll pull in 2, 3, and 6 for now.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
