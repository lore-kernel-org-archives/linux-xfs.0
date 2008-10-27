Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 18:20:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R1KEmr028740
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 18:20:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28572549397
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 18:20:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id I1COHqqokz0VPeyp for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 18:20:13 -0700 (PDT)
Date: Mon, 27 Oct 2008 12:20:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] wire up ->open for directories
Message-ID: <20081027012008.GD11948@disturbed>
References: <20081026203437.GB4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026203437.GB4173@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Oct 26, 2008 at 04:34:37PM -0400, Christoph Hellwig wrote:
> Currently there's no ->open method set for directories on XFS.  That
> means we don't perform any check for opening too large directories
> without O_LARGEFILE, we don't check for shut down filesystems, and we
> don't actually do the readahead for the first block in the directory.
> 
> Instead of just setting the directories open routine to xfs_file_open
> we merge the shutdown check directly into xfs_file_open and create
> a new xfs_dir_open that first calls xfs_file_open and then performs
> the readahead for block 0.

Looks good to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
