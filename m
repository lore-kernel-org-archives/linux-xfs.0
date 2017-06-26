Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:34929 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFZR6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 13:58:36 -0400
Received: by mail-qt0-f170.google.com with SMTP id f92so7375337qtb.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 10:58:36 -0700 (PDT)
Message-ID: <1498499912.10049.2.camel@redhat.com>
Subject: Re: [PATCH v7 21/22] xfs: minimal conversion to errseq_t writeback
 error reporting
From: jlayton@redhat.com
Date: Mon, 26 Jun 2017 13:58:32 -0400
In-Reply-To: <20170626152241.GC4733@birch.djwong.org>
References: <20170616193427.13955-1-jlayton@redhat.com>
         <20170616193427.13955-22-jlayton@redhat.com>
         <20170626152241.GC4733@birch.djwong.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Mon, 2017-06-26 at 08:22 -0700, Darrick J. Wong wrote:
> On Fri, Jun 16, 2017 at 03:34:26PM -0400, Jeff Layton wrote:
> > Just check and advance the data errseq_t in struct file before
> > before returning from fsync on normal files. Internal filemap_*
> > callers are left as-is.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 5fb5a0958a14..bc3b1575e8db 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -134,7 +134,7 @@ xfs_file_fsync(
> >  	struct inode		*inode = file->f_mapping-
> > >host;
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	int			error = 0;
> > +	int			error = 0, err2;
> >  	int			log_flushed = 0;
> >  	xfs_lsn_t		lsn = 0;
> >  
> > @@ -142,10 +142,12 @@ xfs_file_fsync(
> >  
> >  	error = filemap_write_and_wait_range(inode->i_mapping,
> > start, end);
> >  	if (error)
> > -		return error;
> > +		goto out;
> >  
> > -	if (XFS_FORCED_SHUTDOWN(mp))
> > -		return -EIO;
> > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > +		error = -EIO;
> > +		goto out;
> > +	}
> >  
> >  	xfs_iflags_clear(ip, XFS_ITRUNCATED);
> >  
> > @@ -197,6 +199,11 @@ xfs_file_fsync(
> >  	    mp->m_logdev_targp == mp->m_ddev_targp)
> >  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> >  
> > +out:
> > +	err2 = filemap_report_wb_err(file);
> 
> Could we have a comment here to remind anyone reading the code a year
> from now that filemap_report_wb_err has side effects?  Pre-coffee me
> was
> wondering why we'd bother calling filemap_report_wb_err in the
> XFS_FORCED_SHUTDOWN case, then remembered that it touches data
> structures.
> 
> The first sentence of the commit message (really, the word 'advance')
> added as a comment was adequate to remind me of the side effects.
> 
> Once that's added,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 

Yeah, definitely. I'm working on a respin of the series now to
incorporate HCH's suggestion too. I'll add that in as well.

Maybe I should rename that function to file_check_and_advance_wb_err()
? It would be good to make it clear that it does advance the errseq_t
cursor.

> > +	if (!error)
> > +		error = err2;
> > +
> >  	return error;
> >  }
> >  
> > -- 
> > 2.13.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
