Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p541qGTB046372 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 20:52:16 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6EA049D514
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 18:52:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7XGurlq7Z4vW6WAX for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 18:52:14 -0700 (PDT)
Date: Sat, 4 Jun 2011 11:52:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
	infrastructure
Message-ID: <20110604015212.GD561@dastard>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-9-git-send-email-david@fromorbit.com>
	<20110604004231.GV11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110604004231.GV11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jun 04, 2011 at 01:42:31AM +0100, Al Viro wrote:
> > @@ -278,7 +325,12 @@ void generic_shutdown_super(struct super_block *sb)
> >  {
> >  	const struct super_operations *sop = sb->s_op;
> >  
> > -
> > +	/*
> > +	 * shut down the shrinker first so we know that there are no possible
> > +	 * races when shrinking the dcache or icache. Removes the need for
> > +	 * external locking to prevent such races.
> > +	 */
> > +	unregister_shrinker(&sb->s_shrink);
> >  	if (sb->s_root) {
> >  		shrink_dcache_for_umount(sb);
> >  		sync_filesystem(sb);
> 
> What it means is that shrinker_rwsem now nests inside ->s_umount...  IOW,
> if any ->shrink() gets stuck, so does every generic_shutdown_super().
> I'm still not convinced it's a good idea - especially since _this_
> superblock will be skipped anyway.

True, that's not nice.

> Is there any good reason to evict
> shrinker that early?

I wanted to put it early on in the unmount path so that the shrinker
was guaranteed to be gone before evict_inodes() was called. That
would mean that it is obviously safe to remove the iprune_sem
serialisation in that function.

The code in the umount path is quite different between 2.6.35 (the
original version of the patchset) and 3.0-rc1, so I'm not surprised
that I haven't put the unregister call in the right place.

> Note that doing that after ->s_umount is dropped
> should be reasonably safe - your shrinker will see that superblock is
> doomed if it's called anywhere in that window...

Agreed. In trying to find the best "early" place to unregister the
shrinker, I've completely missed the obvious "late is safe"
solution. I'll respin it with these changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
