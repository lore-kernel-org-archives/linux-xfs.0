Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E37A7F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 14:48:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DED7AC004
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 12:48:02 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dWiosM9LEWXl7KrC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 12:47:57 -0800 (PST)
Date: Tue, 2 Dec 2014 21:47:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Correctly lock inode when removing suid and
	security marks
Message-ID: <20141202204756.GA944@quack.suse.cz>
References: <1417532489-26580-1-git-send-email-jack@suse.cz>
	<20141202163548.GB2113@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202163548.GB2113@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 02-12-14 11:35:48, Brian Foster wrote:
> On Tue, Dec 02, 2014 at 04:01:29PM +0100, Jan Kara wrote:
> > Currently XFS calls file_remove_suid() without holding i_mutex. This is
> > wrong because that function can end up messing with file permissions and
> > security xattrs for which we need i_mutex held.
> > 
> > Fix the problem by grabbing iolock exclusively when we will need to
> > change anything in permissions / xattrs.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> Hi Jan,
> 
> This doesn't compile... it looks like we need to include the security.h
> header. FWIW, even then I get an undefined symbol error when compiling
> as a module (security_inode_need_killpriv() does not appear to be
> exported).
  Sorry, forgot to amend the include in the commit. Regarding export of
security_inode_need_killpriv() - right, I had security XFS compiled in so I
didn't notice. Before I go and fix this up in the obvious way, does anyone
have better idea how to fix this than to second guess what
file_remove_suid() does? Maybe a VFS helper like file_needs_remove_suid()
will be cleaner than what I did?

								Honza

> >  fs/xfs/xfs_file.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index eb596b419942..ad6636ac4943 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -521,6 +521,18 @@ restart:
> >  	if (error)
> >  		return error;
> >  
> > +	/* For changing security info in file_remove_suid() we need i_mutex */
> > +	if (!IS_NOSEC(inode) && *iolock == XFS_IOLOCK_SHARED) {
> > +		struct dentry *dentry = file->f_path.dentry;
> > +
> > +		if (should_remove_suid(dentry) ||
> > +		    security_inode_need_killpriv(dentry)) {
> > +			xfs_rw_iunlock(ip, *iolock);
> > +			*iolock = XFS_IOLOCK_EXCL;
> > +			xfs_rw_ilock(ip, *iolock);
> > +			goto restart;
> > +		}
> > +	}
> >  	/*
> >  	 * If the offset is beyond the size of the file, we need to zero any
> >  	 * blocks that fall between the existing EOF and the start of this
> > -- 
> > 1.8.1.4
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
