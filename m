Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p540gavB044221 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 19:42:36 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF88ED72CF1
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 17:42:34 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id PMqkD9VttxANJnEv for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 17:42:34 -0700 (PDT)
Date: Sat, 4 Jun 2011 01:42:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
	infrastructure
Message-ID: <20110604004231.GV11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306998067-27659-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> @@ -278,7 +325,12 @@ void generic_shutdown_super(struct super_block *sb)
>  {
>  	const struct super_operations *sop = sb->s_op;
>  
> -
> +	/*
> +	 * shut down the shrinker first so we know that there are no possible
> +	 * races when shrinking the dcache or icache. Removes the need for
> +	 * external locking to prevent such races.
> +	 */
> +	unregister_shrinker(&sb->s_shrink);
>  	if (sb->s_root) {
>  		shrink_dcache_for_umount(sb);
>  		sync_filesystem(sb);

What it means is that shrinker_rwsem now nests inside ->s_umount...  IOW,
if any ->shrink() gets stuck, so does every generic_shutdown_super().
I'm still not convinced it's a good idea - especially since _this_
superblock will be skipped anyway.  Is there any good reason to evict
shrinker that early?  Note that doing that after ->s_umount is dropped
should be reasonably safe - your shrinker will see that superblock is
doomed if it's called anywhere in that window...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
