Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHTrDj008906 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:29:54 -0600
Date: Fri, 12 Feb 2010 12:31:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] commit_metadata export operation replacing
	nfsd_sync_dir
Message-ID: <20100212173106.GA22633@infradead.org>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220500.26466.24169.stgit@case>
	<1265984620.3201.73.camel@doink1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265984620.3201.73.camel@doink1>
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
To: Alex Elder <aelder@sgi.com>
Cc: bfields@fieldses.org, Ben Myers <bpm@sgi.com>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

> In the cases you pass the child dentry, you will now be syncing
> things to disk in a slightly different way/order from before.
> I think this way is actually much better, but I thought I'd ask
> anyway:  are you sure that it's OK to sync them at the same time,
> rather than directory first, then child (or the other way around,
> depending on the case)?

The order is defined by when we commit the transactions, if we do
the log force on the later one first we already write out the first
transaction.  Note that in any transaction filesystems the changes
that create/mkdir/link/unlink do to parent and child will be in
the same transaction anyway, which is kinda the point of adding
the transactions to start with.  Only for the case where we do
a setattr in addition to the primary transaction we'll actually
have another transaction to deal with and the above applies.

> >  nfsd4_sync_rec_dir(void)
> >  {
> > -	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
> > -	nfsd_sync_dir(rec_dir.dentry);
> > -	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
> > +	vfs_fsync(NULL, rec_dir.dentry, 0);
> 
> Why do you no longer need to acquire the mutex here?
> I see it gets acquired during the ->fsync() call
> inside vfs_fsync_range(), but is there a reason
> that it needed to be held during the filemap_write_and_wait()
> (as is done in the nfsd_sync_dir() code) also?

We don't need i_mutex for filemap_write_and_wait, it's just held
because someone used the nfsd_sync_dir helper where it doesn't
fit very well.

> > @@ -415,9 +449,8 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
> >  	}
> >  	if (size_change)
> >  		put_write_access(inode);
> > -	if (!err)
> > -		if (EX_ISSYNC(fhp->fh_export))
> > -			write_inode_now(inode, 1);
> > +	if (!err && !delay_commit)
> > +		err = nfserrno(commit_metadata(fhp, NULL));
> 
> Is this sufficient even if the size has changed?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
