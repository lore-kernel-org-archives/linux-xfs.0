Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CLb189024517 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 15:37:01 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FI3y1JjCnBHCBcpw for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 13:36:59 -0800 (PST)
Date: Thu, 12 Jan 2012 22:36:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] xfs: Protect xfs_file_aio_write() with
	sb_start_write - sb_end_write
Message-ID: <20120112213656.GF8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-5-git-send-email-jack@suse.cz>
	<20120112212941.GI23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112212941.GI23916@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu 12-01-12 21:29:41, Al Viro wrote:
> On Thu, Jan 12, 2012 at 02:20:53AM +0100, Jan Kara wrote:
> > Replace racy xfs_wait_for_freeze() check with reliable sb_start_write()
> > - sb_end_write() locking. Due to lock ranking dictated by the page fault
> > code we have to call sb_start_write() after we acquire ilock.
> > 
> > CC: Ben Myers <bpm@sgi.com>
> > CC: Alex Elder <elder@kernel.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_file.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 753ed9b..c5f879b 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
> >  		*iolock = XFS_IOLOCK_SHARED;
> >  	}
> >  
> > +	sb_start_write(inode->i_sb);
> >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> >  	ret = generic_file_direct_write(iocb, iovp,
> >  			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> > +	sb_end_write(inode->i_sb);
> 
> What lock ordering do you have in mind?  Explicit description in fs/super.c,
> please...
  Good point. Will add explanatory comment. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
