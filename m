Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 23:48:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3A6luIS014758
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 23:47:56 -0700
Date: Thu, 10 Apr 2008 02:48:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] ensure inodes are joined in xfs_itruncate_finish
Message-ID: <20080410064832.GA24941@infradead.org>
References: <20080410031405.GR108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410031405.GR108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 10, 2008 at 01:14:05PM +1000, David Chinner wrote:
> On success, we still need to join the inode to the current
> transaction in xfs_itruncate_finish(). Fixes regression from
> error handling changes.
> 
> Note that this does some comment reformatting (to wrap at
> 80 columns) for comments that were modified.

The fix looks good to me, and makes xfsqa survive a little longer.
It now fails in xfs_alloc_ag_vextent/xfs_alloc_ag_vextent_near/
xfs_alloc_fix_len.  I suspect your next patch fixes that, but while
already commited it's unfortunately not in public CVS yet..
