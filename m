Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 049927F63
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:21:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65B64AC00C
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:21:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pdAFX5SMCZl0ogUD for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:21:02 -0800 (PST)
Date: Sat, 7 Feb 2015 09:20:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150206222047.GM12722@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-20-git-send-email-hch@lst.de>
	<20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
	<20150205135756.GA6386@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205135756.GA6386@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 02:57:56PM +0100, Christoph Hellwig wrote:
> I've updated the patch and pushed out a new pnfsd-for-3.20-4 branch.
> 
> The changes relative to the old one are below:

Hi Christoph, with these changes I think this is fine to be merged
with the experimental tag attached to it

Acked-by: Dave Chinner <david@fromorbit.com>

I'm expecting the merge window to open on Monday so it's kinda late
to be adding new stuff to the XFS tree and co-ordinating it with the
NFS tree merge - how were you planning to get this to merged?

I've already merged all but the two pNFSD support patches, so
there's some duplicate commits in your pnfsd-for-3.20-4 branch.
i.e. these commits in your tree:

b8d5187 xfs: factor out a xfs_update_prealloc_flags() helper
6d5ca2a xfs: update the superblock using a synchronous transaction in growfs
e3ea93e xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten

are already merged into the xfs for-next branch as:

8add71c xfs: factor out a xfs_update_prealloc_flags() helper
f8079b8 xfs: growfs should use synchronous transactions
d32057f xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten

A straight merge from your tree ends up with both sets of commits in
the history. So a rebase on your side, or me pulling them into the
XFS tree is probably required to keep the history clean.

I didn't really want to add any more to the XFS tree this close to
the merge window opening, but I've already got a regression fix that
needs to be added, so perhaps I'll delay sending Linus a pull
request for a week and just merge all of these XFS changes directly.

What do you think?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
