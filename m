Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38169 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbcLTIoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 03:44:34 -0500
Date: Tue, 20 Dec 2016 00:44:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs_io: make various commands one-shot only
Message-ID: <20161220084432.GA29727@infradead.org>
References: <20161216044115.21287-1-david@fromorbit.com>
 <20161216044115.21287-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216044115.21287-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2016 at 03:41:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It makes no sense to iterate the file table for some xfs_io
> commands. Some commands are already marked in this way, but lots of
> them are not and this leads to bad behaviour. For example, the open
> command will run until the process fd table is full and EMFILE is
> returned rather than just opening the specified file once.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
