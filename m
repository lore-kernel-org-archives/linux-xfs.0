Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E22937F77
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 18:04:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71143AC004
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 16:04:29 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	A2G6PB9L7FI0z6wK for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 16:04:26 -0800 (PST)
Date: Tue, 10 Feb 2015 11:04:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150210000423.GY12722@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-20-git-send-email-hch@lst.de>
	<20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
	<20150205135756.GA6386@lst.de> <20150206222047.GM12722@dastard>
	<20150206224258.GJ29783@fieldses.org>
	<20150208133435.GA27081@lst.de>
	<20150208090942.51e99687@tlielax.poochiereds.net>
	<20150209201154.GA27746@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150209201154.GA27746@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Layton <jeff.layton@primarydata.com>

On Mon, Feb 09, 2015 at 03:11:54PM -0500, J. Bruce Fields wrote:
> On Sun, Feb 08, 2015 at 09:09:42AM -0500, Jeff Layton wrote:
> > On Sun, 8 Feb 2015 14:34:35 +0100
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Fri, Feb 06, 2015 at 05:42:58PM -0500, J. Bruce Fields wrote:
> > > > You'd basically just be pulling my tree (Christoph's is just my nfsd
> > > > tree with his patches on top, and I've been testing with exactly that
> > > > locally, just putting off pushing it out till we decide this.)
> > > > 
> > > > So anyway, fine with me if you want to just pull that into the xfs tree.
> > > > Mine's ready whenever, so if I send my pull pretty soon after the merge
> > > > window and you send it a little later then we still keep the property
> > > > that Linus's merge still has a diffstat only in our respective areas.
> > > > 
> > > > (OK, it's a little more complicated because I've got the same
> > > > arrangement with jlayton, so the order is jlayton's lock pull, then my
> > > > nfsd pull, then your xfs pull.  Is this getting too complicated?
> > > > jlayton and I are both ready to so and I think it'd work.)
> > > > 
> > > > I'm also fine with duplicating those few patches, or whatever.
> > > 
> > > Maybe the better idea is to pull the xfs tree in the nfsd tree, but
> > > that would require Dave sending an early pull request so that the
> > > nfsd pull doesn't get delayed.
> > > 
> > > Or we just defer the pnfsd merge.  While I tried to get it in in time
> > > for 3.20 all the delays during review mean we're really late no and should
> > > punt it to 3.21.
> > 
> > FWIW, I plan to send a pull request for the locking changes as soon as
> > the merge window opens. Hopefully that won't be an issue for long...
> 
> This includes Christoph's branch (all but the final xfs commits):
> 
> 	git://linux-nfs.org/~bfields/linux.git for-3.20
> 
> That's what I intend to submit.  Hope that's OK.  Then it's up to Dave
> whether he wants to pull that in and include the xfs patches.

I'm about to send a pull request to Linus for the current XFS tree.
Once that is merged, I'll pull in the remaining xfs-pnfs patches
and send another pull request to Linus after the NFS tree is merged.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
