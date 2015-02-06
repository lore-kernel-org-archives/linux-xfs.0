Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 968357FA5
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:43:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62E9D8F809E
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:43:00 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id vuTXD7EoRnIPgjkA for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:42:58 -0800 (PST)
Date: Fri, 6 Feb 2015 17:42:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150206224258.GJ29783@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-20-git-send-email-hch@lst.de>
	<20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
	<20150205135756.GA6386@lst.de> <20150206222047.GM12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150206222047.GM12722@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Feb 07, 2015 at 09:20:47AM +1100, Dave Chinner wrote:
> On Thu, Feb 05, 2015 at 02:57:56PM +0100, Christoph Hellwig wrote:
> > I've updated the patch and pushed out a new pnfsd-for-3.20-4 branch.
> > 
> > The changes relative to the old one are below:
> 
> Hi Christoph, with these changes I think this is fine to be merged
> with the experimental tag attached to it
> 
> Acked-by: Dave Chinner <david@fromorbit.com>
> 
> I'm expecting the merge window to open on Monday so it's kinda late
> to be adding new stuff to the XFS tree and co-ordinating it with the
> NFS tree merge - how were you planning to get this to merged?
> 
> I've already merged all but the two pNFSD support patches, so
> there's some duplicate commits in your pnfsd-for-3.20-4 branch.
> i.e. these commits in your tree:
> 
> b8d5187 xfs: factor out a xfs_update_prealloc_flags() helper
> 6d5ca2a xfs: update the superblock using a synchronous transaction in growfs
> e3ea93e xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten
> 
> are already merged into the xfs for-next branch as:
> 
> 8add71c xfs: factor out a xfs_update_prealloc_flags() helper
> f8079b8 xfs: growfs should use synchronous transactions
> d32057f xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten
> 
> A straight merge from your tree ends up with both sets of commits in
> the history. So a rebase on your side, or me pulling them into the
> XFS tree is probably required to keep the history clean.
> 
> I didn't really want to add any more to the XFS tree this close to
> the merge window opening, but I've already got a regression fix that
> needs to be added, so perhaps I'll delay sending Linus a pull
> request for a week and just merge all of these XFS changes directly.
> 
> What do you think?

You'd basically just be pulling my tree (Christoph's is just my nfsd
tree with his patches on top, and I've been testing with exactly that
locally, just putting off pushing it out till we decide this.)

So anyway, fine with me if you want to just pull that into the xfs tree.
Mine's ready whenever, so if I send my pull pretty soon after the merge
window and you send it a little later then we still keep the property
that Linus's merge still has a diffstat only in our respective areas.

(OK, it's a little more complicated because I've got the same
arrangement with jlayton, so the order is jlayton's lock pull, then my
nfsd pull, then your xfs pull.  Is this getting too complicated?
jlayton and I are both ready to so and I think it'd work.)

I'm also fine with duplicating those few patches, or whatever.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
