Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o219oUtP159641 for <xfs@oss.sgi.com>; Mon, 1 Mar 2010 03:50:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51ADE2049F9
	for <xfs@oss.sgi.com>; Mon,  1 Mar 2010 01:51:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r8yqZCbtGBO6iT7e for
	<xfs@oss.sgi.com>; Mon, 01 Mar 2010 01:51:57 -0800 (PST)
Date: Mon, 1 Mar 2010 04:51:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31
	xfs_fs_destroy_inode: cannot reclaim)
Message-ID: <20100301095153.GB2869@infradead.org>
References: <4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
	<4B72A9D1.8030101@news-service.com>
	<20100210145508.GA29047@infradead.org>
	<4B72D3F3.2040308@news-service.com>
	<4B85703A.60104@news-service.com>
	<20100225234553.GC18369@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100225234553.GC18369@discord.disaster>
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
Cc: Patrick Schreurs <patrick@news-service.com>, Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On Fri, Feb 26, 2010 at 10:45:53AM +1100, Dave Chinner wrote:
> Good to hear. The fixes are already in 2.6.33 (just released), so
> the question is whether we backport to 2.6.32 or not. Christoph,
> Alex, Eric - should we push these fixes back to .32-stable?

My latests patch to fix the locking for tag manipulations isn't in
any tree yet.   We should get it into mainline and 2.6.33-stable,
and if the previous patches are backported .32-stable as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
