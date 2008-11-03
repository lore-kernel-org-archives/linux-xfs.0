Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 16:47:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA30ktaF015345
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 16:46:55 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A65D91318E18
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 16:46:57 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 2OzRP0qkDNBkvNHr for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 16:46:57 -0800 (PST)
Date: Mon, 3 Nov 2008 11:46:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] stop using xfs_itobp in xfs_iread
Message-ID: <20081103004609.GM19509@disturbed>
References: <20081027134120.GB3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134120.GB3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:20AM -0400, Christoph Hellwig wrote:
> The only caller of xfs_itobp that doesn't have i_blkno setup is now
> the initial inode read.  It needs access to the whole xfs_imap so using
> xfs_inotobp is not an option.  Instead opencode the buffer lookup in
> xfs_iread and kill all the functionality for the initial map from
> xfs_itobp.
> 
> (First sent on October 21st)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
