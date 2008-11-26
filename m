Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ2NX6Y029075 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 20:23:33 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB6C115F9B76
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:23:31 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	UEpQ9Y72VOYXu2BE for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 18:23:31 -0800 (PST)
Date: Wed, 26 Nov 2008 13:00:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081126020009.GF6291@disturbed>
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C9FB9.3090204@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492C9FB9.3090204@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 26, 2008 at 12:00:41PM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
> > On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
> >> There's a few branches there already:
> >>
> >> 'master'      This will contain all the latest xfs changes not yet pushed
> >>                to mainline.
> >> 'mainline'    This is vanilla mainline and will updated regularly.
> >> 'for-linus'   Our staging branch for pull requests
> >> 'xfs-dev'     This branch will contain KDB and other supporting code for
> >>                development and should be identical to the old CVS tree.
> >>
> >> Feel free to start using it and let us know if you have any issues.
> > 
> > Any chance to have these as separate git trees instead of branches?
> That was the original plan.  Not sure why that got changed.  If there is
> good reason for it we can change it.
> 
> > 
> > In either case, do you expect patches against the xfs-dev or the master
> > tree?  It would also be useful if the trees and which one to be used
> > could be documented on oss.sgi.com/projects/xfs or xfs.org.
> We would prefer patches based on the master branch but patches can be
> against the mainline, master or xfs-dev branches. If a patch against
> mainline or xfs-dev doesn't apply cleanly to the master branch we may
> ask the author to rebase that patch against the master branch. If a
> patch to the master branch needs auxillary changes to files that only
> exist in the xfs-dev branch (ie xfsidbg stuff) we may ask for an
> additional patch from the author.

IIUC correctly, you are saying that we'll have to provide two
different versions of every patch set? i.e. one that applies to
the -master branch and potentially another that applies to the
-xfs-dev branch?

If so, this really means that if I write a patch for xfs-dev, I
can't just merge it to -master because the merge won't always apply
cleanly and I'll have to munge the patch set before I can commit the
changes. Hence if I have to change the xfs-dev version as a result
of reviews, I'll need to redo the merge to -master and all of the
required changes.

IOWs, to do this cleanly the -xfs-dev patches need to be exported
as patches and then imported into the -master branch so that it
is a separate set of commits. i.e. it needs rebasing. At that point,
the two branches may as well be separate trees - the point of
having branches is that commits can be merged between branches
without modification....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
