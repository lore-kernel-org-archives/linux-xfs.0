Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 16:37:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNbEdl021801
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D49A12AE0C9
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:13 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id vyp3HLqVKgTenOdF for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:37:13 -0700 (PDT)
Date: Tue, 28 Oct 2008 10:36:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] wire up ->open for directories
Message-ID: <20081027233659.GH4985@disturbed>
References: <20081027133013.GB30607@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133013.GB30607@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:30:13AM -0400, Christoph Hellwig wrote:
> Currently there's no ->open method set for directories on XFS.  That
> means we don't perform any check for opening too large directories
> without O_LARGEFILE, we don't check for shut down filesystems, and we
> don't actually do the readahead for the first block in the directory.
> 
> Instead of just setting the directories open routine to xfs_file_open
> we merge the shutdown check directly into xfs_file_open and create
> a new xfs_dir_open that first calls xfs_file_open and then performs
> the readahead for block 0.
> 
> (First sent on September 29th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by; Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
