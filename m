Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64D727F54
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 19:11:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34C0B304039
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 17:11:34 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id 9HPQgJNp23KM3n0X for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 17:11:31 -0800 (PST)
Date: Thu, 12 Feb 2015 20:11:30 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150213011130.GA6808@fieldses.org>
References: <1421925006-24231-20-git-send-email-hch@lst.de>
	<20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
	<20150205135756.GA6386@lst.de> <20150206222047.GM12722@dastard>
	<20150206224258.GJ29783@fieldses.org>
	<20150208133435.GA27081@lst.de>
	<20150208090942.51e99687@tlielax.poochiereds.net>
	<20150209201154.GA27746@fieldses.org>
	<20150210000423.GY12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150210000423.GY12722@dastard>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Layton <jeff.layton@primarydata.com>

On Tue, Feb 10, 2015 at 11:04:23AM +1100, Dave Chinner wrote:
> On Mon, Feb 09, 2015 at 03:11:54PM -0500, J. Bruce Fields wrote:
> > On Sun, Feb 08, 2015 at 09:09:42AM -0500, Jeff Layton wrote:
> > > On Sun, 8 Feb 2015 14:34:35 +0100
> > > Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > On Fri, Feb 06, 2015 at 05:42:58PM -0500, J. Bruce Fields wrote:
> > > > > You'd basically just be pulling my tree (Christoph's is just my nfsd
> > > > > tree with his patches on top, and I've been testing with exactly that
> > > > > locally, just putting off pushing it out till we decide this.)
> > > > > 
> > > > > So anyway, fine with me if you want to just pull that into the xfs tree.
> > > > > Mine's ready whenever, so if I send my pull pretty soon after the merge
> > > > > window and you send it a little later then we still keep the property
> > > > > that Linus's merge still has a diffstat only in our respective areas.
> > > > > 
> > > > > (OK, it's a little more complicated because I've got the same
> > > > > arrangement with jlayton, so the order is jlayton's lock pull, then my
> > > > > nfsd pull, then your xfs pull.  Is this getting too complicated?
> > > > > jlayton and I are both ready to so and I think it'd work.)
> > > > > 
> > > > > I'm also fine with duplicating those few patches, or whatever.
> > > > 
> > > > Maybe the better idea is to pull the xfs tree in the nfsd tree, but
> > > > that would require Dave sending an early pull request so that the
> > > > nfsd pull doesn't get delayed.
> > > > 
> > > > Or we just defer the pnfsd merge.  While I tried to get it in in time
> > > > for 3.20 all the delays during review mean we're really late no and should
> > > > punt it to 3.21.
> > > 
> > > FWIW, I plan to send a pull request for the locking changes as soon as
> > > the merge window opens. Hopefully that won't be an issue for long...
> > 
> > This includes Christoph's branch (all but the final xfs commits):
> > 
> > 	git://linux-nfs.org/~bfields/linux.git for-3.20
> > 
> > That's what I intend to submit.  Hope that's OK.  Then it's up to Dave
> > whether he wants to pull that in and include the xfs patches.
> 
> I'm about to send a pull request to Linus for the current XFS tree.
> Once that is merged, I'll pull in the remaining xfs-pnfs patches
> and send another pull request to Linus after the NFS tree is merged.

Sounds good, thanks.  The nfsd tree's merged now so it should be good to
go if you haven't found any show-stoppers.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
