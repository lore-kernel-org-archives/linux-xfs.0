Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7E817F4E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 04:58:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A30A88F8033
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 02:58:15 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qGK454pWg64WdXiU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 02:58:13 -0700 (PDT)
Date: Mon, 27 Oct 2014 10:58:12 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [vfs] WARNING: CPU: 3 PID: 2339 at mm/truncate.c:758
	pagecache_isize_extended+0xdd/0x120()
Message-ID: <20141027095812.GA16093@quack.suse.cz>
References: <20141016100913.GA8140@wfg-t540p.sh.intel.com>
	<20141016110127.GD6085@quack.suse.cz>
	<20141027010422.GA16186@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141027010422.GA16186@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>, lkp@01.org

On Mon 27-10-14 12:04:22, Dave Chinner wrote:
> On Thu, Oct 16, 2014 at 01:01:27PM +0200, Jan Kara wrote:
> > From de3426d6495f4b44b14c09b7c7202e9a86d864b9 Mon Sep 17 00:00:00 2001
> > From: Jan Kara <jack@suse.cz>
> > Date: Thu, 16 Oct 2014 12:58:42 +0200
> > Subject: [PATCH] mm: Remove false WARN_ON from pagecache_isize_extended()
> > 
> > The WARN_ON checking whether i_mutex is held in
> > pagecache_isize_extended() was wrong because some filesystems (e.g.
> > XFS) use different locks for serialization of truncates / writes. So
> > just remove the check.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  mm/truncate.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index 261eaf6e5a19..c646084e5eec 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -755,7 +755,6 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
> >  	struct page *page;
> >  	pgoff_t index;
> >  
> > -	WARN_ON(!mutex_is_locked(&inode->i_mutex));
> >  	WARN_ON(to > inode->i_size);
> >  
> >  	if (from >= to || bsize == PAGE_CACHE_SIZE)
> 
> Jan, Have you sent this patch upstream yet? I'm seeing it fire in
> my testing in 3.18-rc1 kernels, so I was wondering what your plans
> are for this...
  I did send it but it got lost somewhere. I'll resend it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
