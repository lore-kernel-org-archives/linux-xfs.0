Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9LMQxK2255183 for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 17:26:59 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UQrPB6TJppL6XIqt for <xfs@oss.sgi.com>;
	Sun, 21 Oct 2012 15:28:35 -0700 (PDT)
Date: Mon, 22 Oct 2012 09:28:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/10] speculative preallocation inode tracking
Message-ID: <20121021222832.GZ2739@dastard>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<5081BFFF.70603@sgi.com> <50840003.406@redhat.com>
	<5084368F.3000204@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5084368F.3000204@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Sun, Oct 21, 2012 at 12:53:19PM -0500, Mark Tinguely wrote:
> On 10/21/12 09:00, Brian Foster wrote:
> >On 10/19/2012 05:02 PM, Mark Tinguely wrote:
> >>I am just curious, what is the reason for the padding in the
> >>xfs_eofblocks structure?
> >>
> >
> >I added the padding in response to review on an early revision of the set:
> >
> >http://oss.sgi.com/archives/xfs/2012-09/msg00024.html
> >
> >The purpose is to allow adding fields to the control structure down the
> >road without breaking existing binaries.
> 
> Thank-you for the information.
> 
> I would think that changing the number of arguments would also
> involving changing the version number.

Yes, it usually does.

> The kernel should know
> that version 1 copies in 16 bytes, version 2 copies in 16+t bytes,
> version n copies in 16+n bytes...

Gets messy, pretty quickly.  Versioning and padding user facing
structures makes life a lot easy when it comes to extending
interfaces. 15-20 years of support for an ioctl is a long time, and
that's the sort of time frame we need to think about. How to make it
easy to maintain and extend over a long period of time. We should
always version and pad user facing ioctl structures for this reason.

Further, assuming that userspace knows exactly the right size for a
given feature is problematic.  If there's only one structure type
for userspace to use, then it's likely they'll get it right. If
there's a different structure for every version of the ioctl, then
it's likely they'll get it wrong.

And we get validation wrong in the kernel, too. The kernel must
validate the size of the structure as being correct given the
version number, and that gets hard to validate and easy to get wrong
when you have a different structure for every version that exists.

See, for example, struct xfs_fsop_geom_t, and XFS_IOC_FSGEOMETRY_V1/
XFS_IOC_FSGEOMETRY. The originaly was an unversioned structure with
no padding, and when the V2 log format came along, the structure had
to be extended and a new ioctl added to support it. Internally they
both used the same struture, but the copy-in/out were different and
initialisation was different. The result was leaking unitialised
data to userspace because we didn't get it right.  (c4d0c3b "xfs:
prevent leaking uninitialized stack memory in FSGEOMETRY_V1")

At least the new xfs_fsops_geom structure has a version number in it
so we don't have to add a new ioctl to extend it further. However,
it still doesn't have any padding so any further extensions will
have to be very careful to avoid structure size mismatches. This
could have been avoided is some padding was added as the time the
version number was added....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
