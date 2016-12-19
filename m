Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755459AbcLSQGX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2016 11:06:23 -0500
Date: Mon, 19 Dec 2016 08:05:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: silent -Wformat-security warning
Message-ID: <20161219160544.GA9994@infradead.org>
References: <20161219134111.5267-1-nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161219134111.5267-1-nicolas.iooss_linux@m4x.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 19, 2016 at 02:41:11PM +0100, Nicolas Iooss wrote:
> When building the XFS driver with clang, the compiler reports a
> -Wformat-security warning in xlog_recover_validate_buf_type() because
> xfs_warn() is being called with a non-literal string. Even though
> variable warnmsg is always initialized as a constant string without any
> '%' character, silent the warning by calling xfs_warn with "%s" format
> string.
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
