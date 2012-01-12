Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CNFH8j041067 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 17:15:17 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id VHXKiHvnXC073Doh for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 15:15:15 -0800 (PST)
Date: Fri, 13 Jan 2012 00:15:13 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] fs: Improve filesystem freezing handling
Message-ID: <20120112231513.GH8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-2-git-send-email-jack@suse.cz>
	<4F0F6566.4050202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0F6566.4050202@sandeen.net>
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

On Thu 12-01-12 16:57:42, Eric Sandeen wrote:
> On 1/11/12 7:20 PM, Jan Kara wrote:
> > @@ -183,6 +186,13 @@ static struct super_block *alloc_super(struct file_system_type *type)
> >  		s->s_shrink.seeks = DEFAULT_SEEKS;
> >  		s->s_shrink.shrink = prune_super;
> >  		s->s_shrink.batch = 1024;
> > +
> > +		init_waitqueue_head(&s->s_writers_wait);
> > +#ifdef CONFIG_SMP
> > +		s->s_page_faults = alloc_percpu(int);
> 
> isn't this s->s_writers?  s->s_page_faults isn't defined anywhere.
  Right. Leftover from original implementation and since I was doing
initial testing only using UML, I didn't spot this. Thanks.

> > +#endif
> > +		lockdep_init_map(&s->s_writers_lock_map, "sb_writers",
> > +				 &sb_writers_key, 0);
> >  	}
> >  out:
> >  	return s;
> > @@ -1126,6 +1136,84 @@ out:
> >  }
> >  
> >  /**
> > + * sb_start_write - drop write access to a superblock
>       ^^^^^^^^^^^^^^
> 
> s/b sb_end_write
  Fixed.

> > @@ -1136,6 +1224,7 @@ out:
> >  int freeze_super(struct super_block *sb)
> >  {
> >  	int ret;
> > +	int writers;
> >  
> >  	atomic_inc(&sb->s_active);
> >  	down_write(&sb->s_umount);
> > @@ -1151,8 +1240,36 @@ int freeze_super(struct super_block *sb)
> >  		return 0;
> >  	}
> >  
> > +	rwsem_acquire(&sb->s_writers_lock_map, 0, 0, _THIS_IP_);
> >  	sb->s_frozen = SB_FREEZE_WRITE;
> > -	smp_wmb();
> > +	/*
> > +	 * Now wait for all page faults to finish. ->page_mkwrite()
> > +	 * implementations must call vfs_check_frozen() before starting
> > +	 * a fault so that we cannot livelock here. Because of that we
> > +	 * are guaranteed that from this moment on new ->page_mkwrite()
> > +	 * calls will block and we just have to wait for s_page_faults
> 
> wait for s_writers, right?
  Yes. Fixed.

  Thanks for review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
