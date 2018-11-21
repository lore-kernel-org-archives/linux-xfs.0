Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbeKVDFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 22:05:44 -0500
Date: Wed, 21 Nov 2018 08:30:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reflink should flush after an unaligned directio
 cow write
Message-ID: <20181121163034.GA27540@infradead.org>
References: <20181121011706.GO6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121011706.GO6792@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 20, 2018 at 05:17:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If userspace hands us a not-block-aligned directio write, we'll fall
> back to a buffered write for the read-modify-write operation.
> Unfortunately, we don't flush the page cache after a successful
> fallback CoW, which means we break userspace's expectation that the data
> has been sent to the drive.

There is not such expectation.  Even with O_DIRECT you need an explicit
O_DSYNC to guarantee that.  Note that generic_file_direct_write doesn't
force O_DSYNC either.
