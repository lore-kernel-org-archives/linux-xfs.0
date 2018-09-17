Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeIQV7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 17:59:03 -0400
Date: Mon, 17 Sep 2018 09:30:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix transaction leak in xfs_reflink_allocate_cow()
Message-ID: <20180917163056.GA11440@infradead.org>
References: <20180907015113.32448-1-david@fromorbit.com>
 <20180910070241.GB30888@infradead.org>
 <20180917162912.GC4607@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917162912.GC4607@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, git.user@gmail.com

On Mon, Sep 17, 2018 at 09:29:12AM -0700, Darrick J. Wong wrote:
> > +find_trim_cow_extent(
> 
> /me prefers that we try to prefix all the xfs functions, even if they
> are static...

Heh, I actually just did that.  I have a series that starts with this
respin that I plan to post later today.
