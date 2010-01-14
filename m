Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E6fVGu234070 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:41:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76460164FE6
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:42:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QL0PCE4LYNr3Kssa for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:42:28 -0800 (PST)
Date: Thu, 14 Jan 2010 01:42:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: implement quota warnings via netlink
Message-ID: <20100114064228.GA29458@infradead.org>
References: <20100113220547.846700560@bombadil.infradead.org>
	<20100113220603.251930871@bombadil.infradead.org>
	<20100114011948.GV17483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100114011948.GV17483@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 12:19:48PM +1100, Dave Chinner wrote:
> > Tested by running the quota_nld daemon while running the xfstest quota
> > tests and observing the warnings.  I'll see how I can get a more formal
> > testcase for it written.
> 
> Sounds like it needs something similar to the dmapi event listeners
> we use for testing that the dmapi events are generated correctly....

That's what quota_nld does, just need to tie it up properly.

> This appears to send "over block quota" warnings even when
> the error is caused by the number of inodes going over limit.
> For inode count warnings we should be sending QUOTA_NL_IHARDWARN or
> QUOTA_NL_ISOFTWARN. That could be easily done if the "hard"
> parameter is changed to the type of warning which is set up
> in the calling function.
> 
> We could probably even return the grace limit expired versions
> as well when over the soft limits with a slight change to the
> soft limit warning logic as well...

Indeed, I did copy this from gfs2 which only does the block quotas
and no differciated soft warnings.  I'll respin it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
