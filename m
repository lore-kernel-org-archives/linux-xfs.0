Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GLrNG4183789 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 15:53:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B04B1CD7399
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 13:54:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bEYF2tm7IImQhkXJ for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 13:54:40 -0800 (PST)
Date: Tue, 16 Feb 2010 16:54:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/10] quotactl fixed and cleanups
Message-ID: <20100216215438.GA23628@infradead.org>
References: <20100216084446.377980079@bombadil.infradead.org>
	<20100216183627.GC3153@quack.suse.cz>
	<20100216191207.GA3856@infradead.org>
	<20100216212634.GI3153@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216212634.GI3153@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

On Tue, Feb 16, 2010 at 10:26:34PM +0100, Jan Kara wrote:
>   The semantics I've chosen for OCFS2 is that if "USRQUOTA" filesystem
> feature is enabled, we always do accounting of users' usage (as this is
> essntially filesystem metadata). 'usrquota' mount option is just ignored
> and used only to make life easier to quota-tools (so that they don't have
> to parse superblock to find whether quota is supported or not). Enforcement
> is enabled / disabled by quotactl call.
>   I'd eventually love to convert ext3/4 to this behavior as well (and move
> quota files to be invisible "system" inodes) so if XFS would be consistent
> with this, it would be nice.

XFS is almost but not quite consistant with that.  XFS has mount
options for accounting and enforcement, but no superblock bit yet.
Accounting always needs to be enabled at mount time, and enforcement
can be enabled/disabled with quotactl / xfs_quota in addition to the
mount option.  We have been thinking about optionally also adding the
superblock flag as that would make a lof of things easier, especially
for quotas on the root filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
