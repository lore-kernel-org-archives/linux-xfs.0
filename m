Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 739747F3F
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 12:27:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B48230405F
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 10:27:39 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id IFiwyePchXdHOV0D (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2014 10:27:37 -0800 (PST)
Date: Tue, 9 Dec 2014 19:27:32 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] fs: Remove security attributes on truncate
Message-ID: <20141209182732.GC22569@quack.suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
	<1417699659-14284-5-git-send-email-jack@suse.cz>
	<5481D81F.8060308@schaufler-ca.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5481D81F.8060308@schaufler-ca.com>
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
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Fri 05-12-14 08:06:55, Casey Schaufler wrote:
> On 12/4/2014 5:27 AM, Jan Kara wrote:
> > Similarly as we remove suid bit on truncate, we also want to remove
> > security extended attributes.
> 
> NAK
> 
> Are you out of your mind?
>
> In Smack and SELinux the security attributes are associated with the
> container, not the data.
  Is there some doc for this? It just seems strange to me that when a file
is written we clear the attributes but when the file is truncated we don't.
What's the rationale behind this? To me both operations modify content of
the file and thus I'd expect them to behave identically with respect to
security attributes...

								Honza

> > After this patch there's only one user of should_remove_suid() - ocfs2 -
> > and indeed it's buggy because it doesn't clear security attributes on
> > write. However fixing it is difficult because of special locking
> > constraints.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/inode.c         | 5 ++---
> >  fs/open.c          | 6 ++++--
> >  include/linux/fs.h | 6 +++++-
> >  3 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 6807a2707828..8595c7b8841c 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -1603,9 +1603,8 @@ EXPORT_SYMBOL(should_remove_suid);
> >   * response to write or truncate. Return 0 if nothing has to be changed.
> >   * Negative value on error (change should be denied).
> >   */
> > -int file_needs_remove_privs(struct file *file)
> > +int dentry_needs_remove_privs(struct dentry *dentry)
> >  {
> > -	struct dentry *dentry = file->f_path.dentry;
> >  	struct inode *inode = dentry->d_inode;
> >  	int mask = 0;
> >  	int ret;
> > @@ -1621,7 +1620,7 @@ int file_needs_remove_privs(struct file *file)
> >  		mask |= ATTR_KILL_PRIV;
> >  	return mask;
> >  }
> > -EXPORT_SYMBOL(file_needs_remove_privs);
> > +EXPORT_SYMBOL(dentry_needs_remove_privs);
> >  
> >  static int __remove_privs(struct dentry *dentry, int kill)
> >  {
> > diff --git a/fs/open.c b/fs/open.c
> > index de92c13b58be..e4e0863855d0 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -51,8 +51,10 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
> >  		newattrs.ia_valid |= ATTR_FILE;
> >  	}
> >  
> > -	/* Remove suid/sgid on truncate too */
> > -	ret = should_remove_suid(dentry);
> > +	/* Remove suid/sgid and security markings on truncate too */
> > +	ret = dentry_needs_remove_privs(dentry);
> > +	if (ret < 0)
> > +		return ret;
> >  	if (ret)
> >  		newattrs.ia_valid |= ret | ATTR_FORCE;
> >  
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index aac707cced66..c5ccc311e8fb 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2429,7 +2429,11 @@ extern struct inode *new_inode(struct super_block *sb);
> >  extern void free_inode_nonrcu(struct inode *inode);
> >  extern int should_remove_suid(struct dentry *);
> >  extern int file_remove_privs(struct file *);
> > -extern int file_needs_remove_privs(struct file *file);
> > +extern int dentry_needs_remove_privs(struct dentry *dentry);
> > +static inline int file_needs_remove_privs(struct file *file)
> > +{
> > +	return dentry_needs_remove_privs(file->f_path.dentry);
> > +}
> >  
> >  extern void __insert_inode_hash(struct inode *, unsigned long hashval);
> >  static inline void insert_inode_hash(struct inode *inode)
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
