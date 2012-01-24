Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O6xnOw218172 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 00:59:50 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1colHjBhWUEFt5M0 for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 22:59:48 -0800 (PST)
Date: Tue, 24 Jan 2012 17:59:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: Move ilock before transaction start in
	xfs_setattr_size()
Message-ID: <20120124065945.GL15102@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327091686-23177-5-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@kernel.org>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Jan 20, 2012 at 09:34:42PM +0100, Jan Kara wrote:
> In xfs we first take ilock and start transaction afterwards.

The correct order is to allocate the transaction, reserve the space
for it and then take the ilock.  We cannot hold the ilock over the
transaction reservation because that can deadlock the journal.

That is, to make space for the new transaction reservation, we may
need to take the ilock to flush the inode and allow the journal tail
to move forwards to make space for the new transaction.  If we
already hold the ilock, then it can't be flushed, we can't make
space available in the journal and hence deadlock.

Maybe you confused the ilock vs the iolock.  We can hold the iolock
over the trans alloc/reserve because that lock is not required to
move the tail of the journal, so the deadlock doesn't exist.

> We should obey
> this order in all places because otherwise we can create the following deadlock
> with filesystem freezing: One process holds ilock and blocks on s_frozen ==
> SB_FREEZE_TRANS in xfs_trans_alloc(), another process has a transaction started
> (thus blocking freezing) and blocks on ilock. So we have to take ilock earlier
> in xfs_setattr_size().

Where are we taking the ilock and then calling xfs_trans_alloc()?
That's the caller needs to be fixed, not the 40-odd that do the
right thing by taking the ilock -after- the trans alloc/reserve
calls.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
