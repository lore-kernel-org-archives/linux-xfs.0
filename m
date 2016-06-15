Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B6047CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 19:07:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E6768F8037
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 17:07:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1WwDMyjkDIk6NlDZ for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 17:07:34 -0700 (PDT)
Date: Wed, 15 Jun 2016 10:02:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
Message-ID: <20160615000241.GC26977@dastard>
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
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
To: "Thomas D." <whissi@whissi.de>
Cc: spender@grsecurity.net, stable@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 13, 2016 at 11:57:53PM +0200, Thomas D. wrote:
> Hi,
> 
> can anybody confirm if there's something broken with the latest XFS
> change set which is now applied on all stable kernels?
> 
> I found https://forums.grsecurity.net/viewtopic.php?t=4489&p=16355 and
> grsec changelog says
> 
> > commit 1f621dc42acbabb71bd69f6ba606cee56e7ad3bc
> > Author: Brad Spengler <spender@grsecurity.net>
> > Date:   Sat Jun 11 08:14:32 2016 -0400
> > 
> >     Fix Greg KH's broken XFS backport, caused a benign case to be detected
> >     as disk corruption
> >     Problem was due to a tree-wide conversion of error codes to their negative
> >     counterparts, which would likely never be backported to older kernels, but
> >     the backports didn't account for the change
> > 
> >  fs/xfs/xfs_inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)

Yes, the backport is busted, and needs this fix. The error sign
change occurred in 3.17. xfstests would have picked up this
regression in a couple of minutes, so I'm guessing that none of
these stable releases have had any significant regression testing
done....

> This is the change grsec applied:
> 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index fb8579d..af807d8 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3098,7 +3111,7 @@ xfs_iflush(
> >  	 */
> >  	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
> >  			       0);
> > -	if (error == -EAGAIN) {
> > +	if (error == EAGAIN) {
> >  		xfs_ifunlock(ip);
> >  		return error;
> >  	}

Yes, that is the fix that is needed. Thank you for reporting it to
us.

Mr Spender: it would be appreciated if you reported stable kernel
regressions to the relevant upstream maintainers so they can be
fixed quickly for everyone, rather than having one of your users
decide it needs to be reported.

Stable kernel maintainers: the above error sign change is needed for
stable kernels 3.16 and earlier, as a matter of critical importance.
And as a further matter of critical importance: in future, please
take the time to regression test the changes you backport.

> The bad commit according to grsec's statement is
> 
> > From b1438f477934f5a4d5a44df26f3079a7575d5946 Mon Sep 17 00:00:00 2001
> > From: Dave Chinner <dchinner@redhat.com>
> > Date: Wed, 18 May 2016 13:53:42 +1000
> > Subject: [PATCH] xfs: xfs_iflush_cluster fails to abort on error
> 
> Would be nice to get some clarification.

There's nothing wrong with that commit in the upstream kernel,
it's the backport that has a bug in it because it failed to take
into account changes outside the context of the upstream commit that
the older kernels don't have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
