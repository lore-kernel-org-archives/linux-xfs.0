Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965350AbdAILID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 06:08:03 -0500
Date: Mon, 9 Jan 2017 03:08:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't print warnings when xfs_log_force fails
Message-ID: <20170109110803.GA27554@infradead.org>
References: <1482999799-11776-1-git-send-email-hch@lst.de>
 <1482999799-11776-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482999799-11776-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 29, 2016 at 09:23:19AM +0100, Christoph Hellwig wrote:
> There are only two reasons for xfs_log_force / xfs_log_force_lsn to fail:
> one is an I/O error, for which xlog_bdstrat already logs a warning, and
> the second is an already shutdown log due to a previous I/O errors.  In
> the latter case we'll already have a previous indication for the actual
> error, but the large stream of misleading warnings from xfs_log_force
> will probably scroll it out of the message buffer.
> 
> Simply removing the warnings thus makes the XFS log reporting significantly
> better.

Darrick,

any opinion on this one?  I was hoping to sneak it into 4.10-rc still..
