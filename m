Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FCD37F63
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:22:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F87D304043
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:22:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Vg1FKIhA5ozAOkU9 for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:22:41 -0800 (PST)
Date: Sat, 7 Feb 2015 09:22:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Message-ID: <20150206222227.GN12722@dastard>
References: <001f01d041cb$39fbbc70$adf33550$@samsung.com>
	<54D45068.2030209@sandeen.net>
	<002401d041cf$570eae40$052c0ac0$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <002401d041cf$570eae40$052c0ac0$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, 'Eric Sandeen' <sandeen@sandeen.net>, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:39:56PM +0900, Namjae Jeon wrote:
> > On 2/5/15 11:10 PM, Namjae Jeon wrote:
> > > Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> > >
> > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > ---
> > >  man/man8/xfs_io.8 | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > > index cf27b99..416206f 100644
> > > --- a/man/man8/xfs_io.8
> > > +++ b/man/man8/xfs_io.8
> > > @@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
> > >  manual page to de-allocates blocks and eliminates the hole created in this process
> > >  by shifting data blocks into the hole.
> > >  .TP
> > > +.BI finsert " offset length"
> > > +Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
> > > +.BR fallocate (2)
> > > +manual page
> > 
> Hi Eric,
> > So, it looks like the fallocate(2) manpage will need an update as well.  :)
> Right, I am planning to send the manpage patch for insert range when merging linus tree..

Best to have the man page with the rest of the code changes, that
way they all get reviewed at the same time. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
