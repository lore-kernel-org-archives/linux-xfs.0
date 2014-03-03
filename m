Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AFDA7F5A
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 16:56:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACA27AC002
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:56:09 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7cbDGgUpOlrLr6Q9 for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 14:56:07 -0800 (PST)
Date: Tue, 4 Mar 2014 09:55:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix use after free in inode_item_done()
Message-ID: <20140303225540.GN13647@dastard>
References: <5314E912.9080708@redhat.com> <20140303223617.GL13647@dastard>
	<531506BD.80209@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531506BD.80209@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 04:48:29PM -0600, Eric Sandeen wrote:
> On 3/3/14, 4:36 PM, Dave Chinner wrote:
> > On Mon, Mar 03, 2014 at 02:41:54PM -0600, Eric Sandeen wrote:
> >> Commit "3a19fb7 libxfs: stop caching inode structures"
> >> introduced a use after free.
> >>
> >> libxfs_iput() already does the check for ip->i_itemp, and a
> >> kmem_zone_free() if it's present, and then frees the ip pointer.
> >> Re-checking ip->i_itemp after the libxfs_iput call will access
> >> the freed ip pointer, as will setting ip_>i_itemp to NULL.
> >>
> >> Simply remove the offending code to fix this up.
> > 
> > which leaves the rest of the ili_done: code looking a little
> > strange.
> > 
> > can you convert that now to be:
> > 
> > ili_done:
> > 	if (iip->ili_lock_flags) {
> > 		iip->ili_lock_flags = 0;
> > 		return;
> > 	}
> > 	/* free the inode */
> > 	libxfs_iput(ip, 0);
> > }
> 
> yeah, I actually had that first.  Not sure why I didn't go with it ;)
> 
> (Still looks strange to my untrained eye; "if lock flags are set, unset them and don't free the inode, otherwise free it")

If the lock falgs are set, it means the caller expects the
transaction commit to return the inode to it in a locked state.
Exactly the same semantics as the kernel code - the lock flags track
how the transaction releases the inode...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
