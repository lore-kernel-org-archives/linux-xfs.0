Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74F8C7F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 09:59:55 -0500 (CDT)
Date: Thu, 21 Mar 2013 09:59:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/21] xfs: add CRC checks to remote symlinks
Message-ID: <20130321145951.GV30652@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-11-git-send-email-david@fromorbit.com>
	<20130320211457.GM22182@sgi.com> <20130321012237.GI17758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130321012237.GI17758@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Thu, Mar 21, 2013 at 12:22:37PM +1100, Dave Chinner wrote:
> On Wed, Mar 20, 2013 at 04:14:57PM -0500, Ben Myers wrote:
> > Hi Dave,
> > 
> > On Tue, Mar 12, 2013 at 11:30:43PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Add a header to the remote symlink block, containing location and
> > > owner information, as well as CRCs and LSN fields. This requires
> > > verifiers to be added to the remote symlink buffers for CRC enabled
> > > filesystems.
> > > 
> > > This also fixes a bug reading multiple block symlinks, where the second block
> > > overwrites the first block when copying out the link name.
> > 
> > Huh.  This commit message doesn't say anything about moving symlink related
> > code from xfs_vnodeops.c to a new file xfs_symlink.c.
> 
> I'm sure I added it at one point. Maybe I lost it when folding and
> splitting various patches as I originally wrote this code in the
> userspace libxfs tree...
> 
> I'll split it back out.

Much appreciated.

> > If you're going to cut
> > and paste code en masse from one file to the next, that's perfectly fine with
> > me.  But please do that in a separate patch than the code you're adding for a
> > feature so that I can focus on the new code in the review.
> > 
> > Looks like you need to add a GPL notice.
> 
> It isn't actually necessary. All code in the kernel is covered by
> the GPLv2, and so notices on individual files are not technically
> necessary. Just because it isn't explicitly stated in the file, it
> doesn't mean the GPL does not apply to the code - the kernel is
> licensed according to what is in the COPYING file (i.e. the full
> GPLv2 license w/ clarifications noted by Linus), and so that is the
> license that applies to the new file. All that actually matters in
> individual files is the copyright statements themselves...

IANAL.  ;)
 
> But, seeing as you are concerned, I'll add the boiler plates.

Thanks.  It appears this will sync into libxfs eventually and we've been trying
to make sure the boilerplate is in place in xfsprogs.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
