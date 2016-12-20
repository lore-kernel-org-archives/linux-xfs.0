Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36777 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757633AbcLTIeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 03:34:17 -0500
Date: Tue, 20 Dec 2016 00:34:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] libxcmd: don't check generic library commands
Message-ID: <20161220083416.GB12768@infradead.org>
References: <20161216044115.21287-1-david@fromorbit.com>
 <20161216044115.21287-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216044115.21287-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2016 at 03:41:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The generic "help" and "quit" commands have different methods of
> skipping user provided command check functions that may prevent them
> from running. xfs_quota use CMD_ALL_FSTYPES and xfs_io uses
> CMD_FLAG_ONESHOT.  Add a new CMD_FLAG_LIBRARY to indicate commands
> that should not be checked against application specific check
> functions so they are always present and can be run regardless of
> the context in which they are run.
> 
> This gets rid of the CMD_ALL_FSTYPES flag, and enables us to remove
> the ONESHOT check in xfs_io so we use only app specific flags for
> determining if app commands should run or not.

This should also remove the defintion of CMD_ALL_FSTYPES from init.h.

Except for that it looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
