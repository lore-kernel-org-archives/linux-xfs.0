Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16FHnUN142206 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 09:17:50 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id LjVJFL96HeydMJ9K (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 07:17:48 -0800 (PST)
Date: Mon, 6 Feb 2012 16:17:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/8] fs: Improve filesystem freezing handling
Message-ID: <20120206151745.GD6890@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-2-git-send-email-jack@suse.cz>
	<4F2C9FF8.2010207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2C9FF8.2010207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri 03-02-12 21:03:20, Eric Sandeen wrote:
> On 1/20/12 2:34 PM, Jan Kara wrote:
> > vfs_check_frozen() tests are racy since the filesystem can be frozen just after
> > the test is performed. Thus in write paths we can end up marking some pages or
> > inodes dirty even though filesystem is already frozen. This creates problems
> > with flusher thread hanging on frozen filesystem.
> > 
> > Another problem is that exclusion between ->page_mkwrite() and filesystem
> > freezing has been handled by setting page dirty and then verifying s_frozen.
> > This guaranteed that either the freezing code sees the faulted page, writes it,
> > and writeprotects it again or we see s_frozen set and bail out of page fault.
> > This works to protect from page being marked writeable while filesystem
> > freezing is running but has an unpleasant artefact of leaving dirty (although
> > unmodified and writeprotected) pages on frozen filesystem resulting in similar
> > problems with flusher thread as the first problem.
> > 
> > This patch aims at providing exclusion between write paths and filesystem
> > freezing. We implement a writer-freeze read-write semaphores in the superblock
> > for each freezing level (currently there are two - SB_FREEZE_WRITE for data and
> > SB_FREEZE_TRANS for metadata). Write paths which should block freezing on given
> > level (e.g. ->block_page_mkwrite(), ->aio_write() for SB_FREEZE_WRITE level;
> > transaction lifetime for SB_FREEZE_TRANS level) hold reader side of the
> > semaphore. Code freezing the filesystem to a given level takes the writer side.
> > 
> > Only that we don't really want to bounce cachelines of the semaphore between
> > CPUs for each write happening. So we implement the reader side of the semaphore
> > as a per-cpu counter and the writer side is implemented using s_frozen
> > superblock field.
> > 
> > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> ...
> 
> > @@ -135,6 +157,11 @@ static struct super_block *alloc_super(struct file_system_type *type)
> >  #else
> >  		INIT_LIST_HEAD(&s->s_files);
> >  #endif
> > +		if (init_sb_writers(s, SB_FREEZE_WRITE, "sb_writers_write"))
> > +			goto err_out;
> > +		if (init_sb_writers(s, SB_FREEZE_TRANS, "sb_writers_trans"))
> > +			goto err_out;
> > +
> >  		s->s_bdi = &default_backing_dev_info;
> >  		INIT_LIST_HEAD(&s->s_instances);
> >  		INIT_HLIST_BL_HEAD(&s->s_anon);
> > @@ -186,6 +213,17 @@ static struct super_block *alloc_super(struct file_system_type *type)
> >  	}
> >  out:
> >  	return s;
> > +err_out:
> > +	security_sb_free(s);
> > +#ifdef CONFIG_SMP
> > +	if (s->s_files)
> > +		free_percpu(s->s_files);
> > +#endif
> > +	destroy_sb_writers(s, SB_FREEZE_WRITE);
> > +	destroy_sb_writers(s, SB_FREEZE_TRANS);
> 
> You probably ran into this already but the writer percpu vars need
> to be torn down in destroy_super() as well.
  Actually not. Thanks for spotting this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
