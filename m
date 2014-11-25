Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DECCA7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 17:49:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B38BAC001
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 15:49:52 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	z7oqjLvGEqVh6imS for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 15:49:34 -0800 (PST)
Date: Wed, 26 Nov 2014 10:48:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
Message-ID: <20141125234851.GB9561@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
	<20141125015332.GE27262@dastard> <20141125044508.GG31339@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125044508.GG31339@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 11:45:08PM -0500, Theodore Ts'o wrote:
> On Tue, Nov 25, 2014 at 12:53:32PM +1100, Dave Chinner wrote:
> > On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> > > Guarantee that the on-disk timestamps will be no more than 24 hours
> > > stale.
> > > 
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > 
> > If we put these inodes on the dirty inode list with at writeback
> > time of 24 hours, this is completely unnecessary.
> 
> What do you mean by "a writeback time of 24 hours"?  Do you mean
> creating a new field in the inode which specifies when the writeback
> should happen? 

No.

> I still worry about the dirty inode list getting
> somewhat long large in the strictatime && lazytime case, and the inode
> bloat nazi's coming after us for adding a new field to struct inode
> structure.

Use another pure inode time dirty list, and move the inode to the
existing dirty list when it gets marked I_DIRTY.

> Or do you mean trying to abuse the dirtied_when field in some way?

No abuse necessary at all. Just a different inode_dirtied_after()
check is requires if the inode is on the time dirty list in
move_expired_inodes().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
