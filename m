Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 19:53:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L2rv71013929
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:53:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36EFA5241E1
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:55:41 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id PgRGlrP3BzL9Xm2Y for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 19:55:41 -0700 (PDT)
Date: Tue, 21 Oct 2008 13:55:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] stop using xfs_itobp in xfs_iread
Message-ID: <20081021025536.GC18495@disturbed>
References: <20081020222040.GB23662@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020222040.GB23662@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 12:20:40AM +0200, Christoph Hellwig wrote:
> The only caller of xfs_itobp that doesn't have i_blkno setup is now
> the initial inode read.  It needs access to the whole xfs_imap so using
> xfs_inotobp is not an option.  Instead opencode the buffer lookup in
> xfs_iread and kill all the functionality for the initial map from
> xfs_itobp.

Ok, looks good. Makes xfs_itobp() nice and simple now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
