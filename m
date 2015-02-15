Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF9B97F47
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 17:26:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD3F3304053
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 15:26:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9Z1QYFdZRsphFten for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2015 15:26:03 -0800 (PST)
Date: Mon, 16 Feb 2015 10:25:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150215232514.GZ4251@dastard>
References: <20150205135756.GA6386@lst.de> <20150206222047.GM12722@dastard>
	<20150206224258.GJ29783@fieldses.org>
	<20150208133435.GA27081@lst.de>
	<20150208090942.51e99687@tlielax.poochiereds.net>
	<20150209201154.GA27746@fieldses.org>
	<20150210000423.GY12722@dastard>
	<20150213011130.GA6808@fieldses.org>
	<20150213015422.GE12722@dastard>
	<20150213133811.5c3b9f49@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150213133811.5c3b9f49@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Layton <jeff.layton@primarydata.com>

On Fri, Feb 13, 2015 at 01:38:11PM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Fri, 13 Feb 2015 12:54:22 +1100 Dave Chinner <david@fromorbit.com> wrote:
> >
> > Thanks Bruce. I might have to build a merged tree because one of the
> > changes from the review modified a header file introduced in the NFS
> > tree.
> > 
> > I'll see how it goes, and see if I can avoid doing something that
> > will make Linus yell at me :P
> 
> If its a syntactic conflict with an obvious resolution, just leave it
> (or maybe mention it in the pull request).  It gives him something to
> do so he feels useful. :-)

Heh.

It's not actually a conflict, though. The issue is that some of the
review comments on the XFS side resulted in changes files introduced
from the NFS tree. So the XFS side can't be merged without the NFS
changes being present....

> /me notes that I did not see a conflict while merging the xfs tree in
> linux-next today ...

Because I haven't pushed them yet ;)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
