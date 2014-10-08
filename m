Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B502F7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 03:45:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D42FAC00C
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 01:45:14 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jeJTNyx9ivD8HAEc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 01:45:12 -0700 (PDT)
Date: Wed, 8 Oct 2014 10:45:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/12] fs: Generic infrastructure for optional inode fields
Message-ID: <20141008084509.GC11781@quack.suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-5-git-send-email-jack@suse.cz>
	<3BFF1023-E198-4797-A96A-EA158137157E@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3BFF1023-E198-4797-A96A-EA158137157E@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Wed 01-10-14 15:05:46, Andreas Dilger wrote:
> On Oct 1, 2014, at 1:31 PM, Jan Kara <jack@suse.cz> wrote:
> > There are parts of struct inode which are used only by a few filesystems
> > (e.g. i_dquot pointers, i_mapping->private_list, ...). Thus all the
> > other filesystems are just wasting memory with these fields. On the
> > other hand it isn't simple to just move these fields to filesystem
> > specific part of inode because there is generic code which needs to peek
> > into the fields and it is cumbersome to provide helpers into which fs
> > has to stuff the field it is storing elsewhere.
> > 
> > We create a simple infrastructure which allows for optional inode fields
> > stored in the fs-specific part of the inode. Accessing these fields has
> > a slightly worse performance as we have to lookup their offset in the
> > offset table stored in the superblock but in most cases this is
> > acceptable. Notably, this offset-table mechanism is faster than having
> > fs-specific hook functions which would need to be called to provide
> > pointers to desired fields.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > include/linux/fs.h | 24 ++++++++++++++++++++++++
> > 1 file changed, 24 insertions(+)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 94187721ad41..977f8fb6ca88 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -615,6 +615,11 @@ struct inode {
> > 	void			*i_private; /* fs or device private pointer */
> > };
> > 
> > +/* Optional inode fields (stored in filesystems inode if the fs needs them) */
> > +enum {
> 
> This should be a named enum, like "enum inode_field" or similar, so it
> can be referenced below.
> 
> > +	IF_FIELD_NR	/* Number of optional inode fields */
> > +};
> > +
> > static inline int inode_unhashed(struct inode *inode)
> > {
> > 	return hlist_unhashed(&inode->i_hash);
> > @@ -1236,6 +1241,11 @@ struct super_block {
> > 	void 			*s_fs_info;	/* Filesystem private info */
> > 	unsigned int		s_max_links;
> > 	fmode_t			s_mode;
> > +	/*
> > +	 * We could have here just a pointer to the offsets array but this
> > +	 * way we save one dereference when looking up field offsets
> > +	 */
> > +	int			s_inode_fields[IF_FIELD_NR];
> > 
> > 	/* Granularity of c/m/atime in ns.
> > 	   Cannot be worse than a second */
> > @@ -1286,6 +1296,20 @@ struct super_block {
> > 	struct rcu_head		rcu;
> > };
> > 
> > +static inline void *inode_field(const struct inode *inode, int field)
> 
> This should use "enum inode_field" instead of int, so the compiler could
> warn about invalid parameter values.  It might make sense to add a check:
  OK, makes sense.

>         if (field < IF_FIELD_NR)
> 
> but I'm not sure if the overhead is worthwhile, unless it can always be
> resolved at compile time.  That might be possible since this is a static
> inline function.
  Well, I can stick there BUG_ON(field >= IF_FIELD_NR). That looks like a
sensible debugging measure with negligible overhead.

								Honza
> > +{
> > +	int offset = inode->i_sb->s_inode_fields[field];
> > +
> > +	if (!offset)	/* Field not present? */
> > +		return NULL;
> 
> > +	return ((char *)inode) + offset;
> > +}
> > +
> > +static inline void sb_init_inode_fields(struct super_block *sb, int *fields)
> > +{
> > +	memcpy(sb->s_inode_fields, fields, sizeof(int) * IF_FIELD_NR);
> > +}
> > +
> > extern struct timespec current_fs_time(struct super_block *sb);
> > 
> > /*
> > -- 
> > 1.8.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
