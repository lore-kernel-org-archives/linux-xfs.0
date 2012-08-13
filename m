Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7D8GmfN237301 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 03:16:48 -0500
Date: Mon, 13 Aug 2012 04:16:42 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <793053708.1130825.1344845802020.JavaMail.root@redhat.com>
In-Reply-To: <20120809234758.GE2877@dastard>
Subject: Re: [PATCH v3] xfs: check for possible overflow in xfs_ioc_trim
MIME-Version: 1.0
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
Cc: lczerner@redhat.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>


> [ Trimmed lkml from cc list.  There's no need to cc lkml on XFS
> specific stuff. ]
> 
> [ Trimmed linux-xfs@vger.kernel.org as that is not a list any XFS
> developer is subscribed to. ]

Oh, it's good to know (I used get_maintainer script before).

> 
> On Thu, Aug 09, 2012 at 11:07:09AM +0200, Tomas Racek wrote:
> > If range.start or range.minlen is bigger than filesystem size,
> > return
> > invalid value error. This fixes possible overflow in BTOBB macro
> > when
> > passed value was nearly ULLONG_MAX.
> > 
> > Signed-off-by: Tomas Racek <tracek@redhat.com>
> > ---
> >  fs/xfs/xfs_discard.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index f9c3fe3..4e07a56 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -179,12 +179,14 @@ xfs_ioc_trim(
> >  	 * used by the fstrim application.  In the end it really doesn't
> >  	 * matter as trimming blocks is an advisory interface.
> >  	 */
> > +	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
> > +	    range.minlen > XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
> > +		return -XFS_ERROR(EINVAL);
> 
> That's not correct for minlen. The maximum minlen we can
> support is the length of the largest freespace extent in the
> filesystem, and that is limited to the size of an AG. i.e.
> XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp))

Will do, thank you!

Tomas

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
