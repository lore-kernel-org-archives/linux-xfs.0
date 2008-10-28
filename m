Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 23:40:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S6eldi023804
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:40:48 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D564EAF0D1A
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:40:47 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id CXNltfaqoI2WGOcF for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:40:47 -0700 (PDT)
Date: Tue, 28 Oct 2008 17:40:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] kill xfs_ialloc_log_di
Message-ID: <20081028064041.GR4985@disturbed>
References: <20081027133909.GE1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133909.GE1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:09AM -0400, Christoph Hellwig wrote:
> xfs_ialloc_log_di is only used to log the full inode core + di_next_unlinked.
> That means all the offset magic is not nessecary and we can simply use
> xfs_trans_log_buf directly.  Also add a comment describing what we should do
> here instead.
> 
> (First sent on October 7th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
