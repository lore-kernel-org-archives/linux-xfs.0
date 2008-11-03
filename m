Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 16:47:50 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA30lbaj015623
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 16:47:38 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 062A81BDB688
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 16:47:39 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id UFzRuIBHft0kpZma for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 16:47:39 -0800 (PST)
Date: Mon, 3 Nov 2008 11:47:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] remove dead code for old inode item recovery
Message-ID: <20081103004712.GN19509@disturbed>
References: <20081027134122.GC3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134122.GC3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:22AM -0400, Christoph Hellwig wrote:
> We have removed the support for old-style inode items a while ago and
> xlog_recover_do_inode_trans is now only called for XFS_LI_INODE items.
> That means we can remove the call to xfs_imap there and with it the
> XFS_IMAP_LOOKUP that is set by all other callers.  We can also mark
> xfs_imap static now.
> 
> (First sent on October 21st)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
