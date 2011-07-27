Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RAXXeT186241 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 05:33:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FFCE182BB43
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 03:33:32 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1v7Aoakp6kDBzfum for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 03:33:32 -0700 (PDT)
Date: Wed, 27 Jul 2011 06:33:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
Message-ID: <20110727103308.GA20805@infradead.org>
References: <4E1C70AD.1010101@u-club.de> <201107262228.12099.rjw@sisk.pl>
	<20110727004543.GE8048@dastard> <201107271135.13297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107271135.13297.rjw@sisk.pl>
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
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph <cr2005@u-club.de>, xfs@oss.sgi.com, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>

On Wed, Jul 27, 2011 at 11:35:13AM +0200, Rafael J. Wysocki wrote:
> The Pavel's objection, if I remember it correctly, was that some
> (or the majority of?) filesystems didn't implement the freezing operation,
> so they would be more vulnerable to data loss in case of a failing hibernation
> after this change.  However, that's better than actively causing pain to XFS
> users.

The objection never made sense and only means he never read the code.
freeze_super (or freeze_bdev back then) always does a sync_filesystem
before even checking if we have a freeze method, and sync_filesystem is
what we iterate over for each superblock in sync().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
