Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E44027F4E
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 03:46:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60672AC004
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 01:46:16 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TQAKLJNks2KWr88o (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Dec 2014 01:46:14 -0800 (PST)
Date: Tue, 16 Dec 2014 10:46:09 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] fs: Remove security attributes on truncate
Message-ID: <20141216094609.GC2421@quack.suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
	<1417699659-14284-5-git-send-email-jack@suse.cz>
	<5481D81F.8060308@schaufler-ca.com>
	<20141209182732.GC22569@quack.suse.cz>
	<54874691.2010902@schaufler-ca.com>
	<20141210111123.GB25671@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141210111123.GB25671@quack.suse.cz>
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

On Wed 10-12-14 12:11:23, Jan Kara wrote:
> On Tue 09-12-14 10:59:29, Casey Schaufler wrote:
> > On 12/9/2014 10:27 AM, Jan Kara wrote:
> > > On Fri 05-12-14 08:06:55, Casey Schaufler wrote:
> > >> On 12/4/2014 5:27 AM, Jan Kara wrote:
> > >>> Similarly as we remove suid bit on truncate, we also want to remove
> > >>> security extended attributes.
> > >> NAK
> > >>
> > >> Are you out of your mind?
> > >>
> > >> In Smack and SELinux the security attributes are associated with the
> > >> container, not the data.
> > >   Is there some doc for this? It just seems strange to me that when a file
> > > is written we clear the attributes
> > 
> > This is not true for the LSM based attributes.
> > 
> > >  but when the file is truncated we don't.
> > 
> > Have I miss-interpreted what you meant by "security extended attributes"?
> > Do you mean filesystem xattrs beginning with "security.", such as
> > "security.selinux" or "security.SMACK64", or something else?
>   Sorry, I'm not a security guy so I may be using wrong terminology. I
> meant attributes that are removed when you call security_inode_killpriv().
> There's a comment in security.h like:
>  * @inode_killpriv:
>  *      The setuid bit is being removed.  Remove similar security labels.
>  *      Called with the dentry->d_inode->i_mutex held.
>  *      @dentry is the dentry being changed.
>  *      Return 0 on success.  If error is returned, then the operation
>  *      causing setuid bit removal is failed.
> 
> So from that I'd think that security_inode_killpriv() should be called if
> we are removing SUID bit (i.e. also during truncate).
  Casey, so are you OK which this change?

								Honza

> > > What's the rationale behind this? To me both operations modify content of
> > > the file and thus I'd expect them to behave identically with respect to
> > > security attributes...
> > >
> > > 								Honza
> > >
> > >>> After this patch there's only one user of should_remove_suid() - ocfs2 -
> > >>> and indeed it's buggy because it doesn't clear security attributes on
> > >>> write. However fixing it is difficult because of special locking
> > >>> constraints.
> > >>>
> > >>> Signed-off-by: Jan Kara <jack@suse.cz>
> > >>> ---
> > >>>  fs/inode.c         | 5 ++---
> > >>>  fs/open.c          | 6 ++++--
> > >>>  include/linux/fs.h | 6 +++++-
> > >>>  3 files changed, 11 insertions(+), 6 deletions(-)
> > >>>
> > >>> diff --git a/fs/inode.c b/fs/inode.c
> > >>> index 6807a2707828..8595c7b8841c 100644
> > >>> --- a/fs/inode.c
> > >>> +++ b/fs/inode.c
> > >>> @@ -1603,9 +1603,8 @@ EXPORT_SYMBOL(should_remove_suid);
> > >>>   * response to write or truncate. Return 0 if nothing has to be changed.
> > >>>   * Negative value on error (change should be denied).
> > >>>   */
> > >>> -int file_needs_remove_privs(struct file *file)
> > >>> +int dentry_needs_remove_privs(struct dentry *dentry)
> > >>>  {
> > >>> -	struct dentry *dentry = file->f_path.dentry;
> > >>>  	struct inode *inode = dentry->d_inode;
> > >>>  	int mask = 0;
> > >>>  	int ret;
> > >>> @@ -1621,7 +1620,7 @@ int file_needs_remove_privs(struct file *file)
> > >>>  		mask |= ATTR_KILL_PRIV;
> > >>>  	return mask;
> > >>>  }
> > >>> -EXPORT_SYMBOL(file_needs_remove_privs);
> > >>> +EXPORT_SYMBOL(dentry_needs_remove_privs);
> > >>>  
> > >>>  static int __remove_privs(struct dentry *dentry, int kill)
> > >>>  {
> > >>> diff --git a/fs/open.c b/fs/open.c
> > >>> index de92c13b58be..e4e0863855d0 100644
> > >>> --- a/fs/open.c
> > >>> +++ b/fs/open.c
> > >>> @@ -51,8 +51,10 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
> > >>>  		newattrs.ia_valid |= ATTR_FILE;
> > >>>  	}
> > >>>  
> > >>> -	/* Remove suid/sgid on truncate too */
> > >>> -	ret = should_remove_suid(dentry);
> > >>> +	/* Remove suid/sgid and security markings on truncate too */
> > >>> +	ret = dentry_needs_remove_privs(dentry);
> > >>> +	if (ret < 0)
> > >>> +		return ret;
> > >>>  	if (ret)
> > >>>  		newattrs.ia_valid |= ret | ATTR_FORCE;
> > >>>  
> > >>> diff --git a/include/linux/fs.h b/include/linux/fs.h
> > >>> index aac707cced66..c5ccc311e8fb 100644
> > >>> --- a/include/linux/fs.h
> > >>> +++ b/include/linux/fs.h
> > >>> @@ -2429,7 +2429,11 @@ extern struct inode *new_inode(struct super_block *sb);
> > >>>  extern void free_inode_nonrcu(struct inode *inode);
> > >>>  extern int should_remove_suid(struct dentry *);
> > >>>  extern int file_remove_privs(struct file *);
> > >>> -extern int file_needs_remove_privs(struct file *file);
> > >>> +extern int dentry_needs_remove_privs(struct dentry *dentry);
> > >>> +static inline int file_needs_remove_privs(struct file *file)
> > >>> +{
> > >>> +	return dentry_needs_remove_privs(file->f_path.dentry);
> > >>> +}
> > >>>  
> > >>>  extern void __insert_inode_hash(struct inode *, unsigned long hashval);
> > >>>  static inline void insert_inode_hash(struct inode *inode)
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
