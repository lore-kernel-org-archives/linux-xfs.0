Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OBqcNV249841 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 05:52:38 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 84hnEWWBx0SjoK5l (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 03:52:37 -0800 (PST)
Date: Tue, 24 Jan 2012 12:52:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] xfs: Move ilock before transaction start in
	xfs_setattr_size()
Message-ID: <20120124115234.GD15974@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-5-git-send-email-jack@suse.cz>
	<20120124065945.GL15102@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124065945.GL15102@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue 24-01-12 17:59:45, Dave Chinner wrote:
> On Fri, Jan 20, 2012 at 09:34:42PM +0100, Jan Kara wrote:
> > In xfs we first take ilock and start transaction afterwards.
> 
> The correct order is to allocate the transaction, reserve the space
> for it and then take the ilock.  We cannot hold the ilock over the
> transaction reservation because that can deadlock the journal.
>
> That is, to make space for the new transaction reservation, we may
> need to take the ilock to flush the inode and allow the journal tail
> to move forwards to make space for the new transaction.  If we
> already hold the ilock, then it can't be flushed, we can't make
> space available in the journal and hence deadlock.
  Thanks for clarification!

> Maybe you confused the ilock vs the iolock.  We can hold the iolock
> over the trans alloc/reserve because that lock is not required to
> move the tail of the journal, so the deadlock doesn't exist.
  Ups! I now had a look at what xfs_rw_ilock() does. I always thought it's
just a plain rw semaphore and now I see it takes several locks depending on
the argument. Ugh, a bit surprising for XFS newcomer as me ;) But now
things become clearer so I fix my patches with this new knowledge in mind.
So just disregard my locking comments. They were likely bogus.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
