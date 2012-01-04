Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q049RWh3124919 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 03:27:34 -0600
Date: Wed, 4 Jan 2012 04:27:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: remove xfs_itruncate_data
Message-ID: <20120104092728.GA27447@infradead.org>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200130.784802192@bombadil.infradead.org>
	<20120103215345.GA6390@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120103215345.GA6390@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> You've tossed xfs_isize_check in the round filer, but you didn't mention
> that in your commit message.  Isn't this still useful code?

It falls under the removal of a few asserts in the debug build.  I don't
think it's a useful check.

> > -	if (ip->i_size != new_size) {
> > -		ip->i_d.di_size = new_size;
> > -		ip->i_size = new_size;
> > -	}
> > -
> > -	ASSERT(new_size != 0 || ip->i_delayed_blks == 0);
> 
> You didn't pull this assert along with 
> 
> > -	ASSERT(new_size != 0 || ip->i_d.di_nextents == 0);
> 
> this one into xfs_qm_scall_trunc_qfile.  Was that intentional?


We never have delayed blocks on the quota files, so there's not much
of a point to have this assert.

> > -	error = xfs_itruncate_data(&tp, ip, 0);
> > +	ip->i_d.di_size = 0;
> > +	ip->i_size = 0;
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +
> > +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
> 
> It it worth a comment that you log the size here because of the
> possibility of another file being allocated these extents in the face of
> a crash?

I don't think there's a point in duplicating that comment.  Eventually
I'll see if we can simply use the existing truncate code for the quota
files anyway.

> > -		error = xfs_itruncate_data(&tp, ip, 0);
> > +		ip->i_d.di_size = 0;
> > +		ip->i_size = 0;
> > +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> Maybe a comment here too?

We log inodes in tons of places without adding a comment ever time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
