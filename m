Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CK7vDK016746 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 14:07:57 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id klaesSs6bpH5CeqM for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 12:07:55 -0800 (PST)
Date: Thu, 12 Jan 2012 21:07:53 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Message-ID: <20120112200753.GC8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-2-git-send-email-jack@suse.cz>
	<DB1320A4-7621-44D2-B339-78CB38FAC186@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DB1320A4-7621-44D2-B339-78CB38FAC186@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu 12-01-12 12:53:35, Andreas Dilger wrote:
> On 2012-01-11, at 6:20 PM, Jan Kara wrote:
> > /**
> > + * sb_start_write - drop write access to a superblock
> > + * @sb: the super we wrote to
> > + *
> > + * Decrement number of writers to the filesystem and wake up possible
> > + * waiters wanting to freeze the filesystem.
> > + */
> > +void sb_end_write(struct super_block *sb)
> > +{
> > +#ifdef CONFIG_SMP
> > +	this_cpu_dec(sb->s_writers);
> > +#else
> > +	preempt_disable();
> > +	sb->s_writers--;
> > +	preempt_enable();
> > +#endif
> > +	/*
> > +	 * Make sure s_writers are updated before we wake up waiters in
> > +	 * freeze_super().
> > +	 */
> > +	smp_mb();
> > +	if (waitqueue_active(&sb->s_writers_wait))
> > +		wake_up(&sb->s_writers_wait);
> > +	rwsem_release(&sb->s_writers_lock_map, 1, _RET_IP_);
> > +}
> 
> Since this function is needed for calling __block_page_mkwrite(), which is
> EXPORT_SYMBOL(), both sb_start_write() and sb_end_write() themselves need
> to be EXPORT_SYMBOL().
  Good point. Fixed. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
