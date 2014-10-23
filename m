Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A57577F59
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 07:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9381C304070
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 05:05:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id MmHZu0STDIiYqSbr (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 05:05:32 -0700 (PDT)
Date: Thu, 23 Oct 2014 14:05:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/12] ocfs2: Convert to private i_dquot field
Message-ID: <20141023120529.GA20067@quack.suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
	<1413902316-17997-10-git-send-email-jack@suse.cz>
	<20141023102554.GB5238@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141023102554.GB5238@localhost>
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
To: Joel Becker <jlbec@evilplan.org>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Thu 23-10-14 11:25:57, Joel Becker wrote:
> On Tue, Oct 21, 2014 at 04:38:33PM +0200, Jan Kara wrote:
> > CC: Mark Fasheh <mfasheh@suse.com>
> > CC: Joel Becker <jlbec@evilplan.org>
> > CC: ocfs2-devel@oss.oracle.com
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/inode.h |  4 ++++
> >  fs/ocfs2/super.c | 10 ++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> > index a9b76de46047..1bb2e27eaad7 100644
> > --- a/fs/ocfs2/inode.h
> > +++ b/fs/ocfs2/inode.h
> > @@ -80,6 +80,10 @@ struct ocfs2_inode_info
> >  	 */
> >  	tid_t i_sync_tid;
> >  	tid_t i_datasync_tid;
> > +
> > +#ifdef CONFIG_QUOTA
> > +	struct dquot *i_dquot[MAXQUOTAS];
> > +#endif
> >  };
> >  
> >  /*
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 93c85bc745e1..9a97986d54f5 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -143,6 +143,11 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
> >  static int ocfs2_enable_quotas(struct ocfs2_super *osb);
> >  static void ocfs2_disable_quotas(struct ocfs2_super *osb);
> >  
> > +static struct dquot **ocfs2_get_dquots(struct inode *inode)
> > +{
> > +	return OCFS2_I(inode)->i_dquot;
> > +}
> 
> Call me silly, but given that ocfs2_inode_info->i_dquot; is wrapped in
> CONFIG_QUOTA, shouldn't this accessor be as well?  Is GCC really smart
> enough to ignore the undefined member because ocfs2_get_dquots() isn't
> called?
  Actually, ocfs2 selects QUOTA so it cannot happen that CONFIG_QUOTA isn't
defined for ocfs2. I'll remove the CONFIG_QUOTA checks from ocfs2 patch.

								Honza
> 
> Joel
> 
> > +
> >  static const struct super_operations ocfs2_sops = {
> >  	.statfs		= ocfs2_statfs,
> >  	.alloc_inode	= ocfs2_alloc_inode,
> > @@ -155,6 +160,7 @@ static const struct super_operations ocfs2_sops = {
> >  	.show_options   = ocfs2_show_options,
> >  	.quota_read	= ocfs2_quota_read,
> >  	.quota_write	= ocfs2_quota_write,
> > +	.get_dquots	= ocfs2_get_dquots,
> >  };
> >  
> >  enum {
> > @@ -563,6 +569,9 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
> >  
> >  	oi->i_sync_tid = 0;
> >  	oi->i_datasync_tid = 0;
> > +#ifdef CONFIG_QUOTA
> > +	memset(&oi->i_dquot, 0, sizeof(oi->i_dquot));
> > +#endif
> >  
> >  	jbd2_journal_init_jbd_inode(&oi->ip_jinode, &oi->vfs_inode);
> >  	return &oi->vfs_inode;
> > @@ -2073,6 +2082,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
> >  	sb->s_export_op = &ocfs2_export_ops;
> >  	sb->s_qcop = &ocfs2_quotactl_ops;
> >  	sb->dq_op = &ocfs2_quota_operations;
> > +	sb_dqopt(sb)->allowed_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
> >  	sb->s_xattr = ocfs2_xattr_handlers;
> >  	sb->s_time_gran = 1;
> >  	sb->s_flags |= MS_NOATIME;
> > -- 
> > 1.8.1.4
> > 
> 
> -- 
> 
> "I'm so tired of being tired,
>  Sure as night will follow day.
>  Most things I worry about
>  Never happen anyway."
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
