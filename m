Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:12:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLCTR7031752
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:12:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 256C71273D4E
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:14:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id vbIsx8H1TWe9alGI for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:14:00 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:14:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] XFS: rename inode reclaim functions
Message-ID: <20080915211400.GE29743@infradead.org>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221315300-30336-4-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:14:57AM +1000, Dave Chinner wrote:
> The function names xfs_finish_reclaim and xfs_finish_reclaim_all
> are not very descriptive of what they are reclaiming. Rename to
> xfs_reclaim_inode[s] to match the xfs_sync_inodes() function.

Looks good, but in case you respin the series I'd move to this to
number two in the series.
