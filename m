Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbcLENKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 08:10:54 -0500
Date: Mon, 5 Dec 2016 04:48:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: make xfs btree stats less huge
Message-ID: <20161205124805.GB30956@infradead.org>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-2-david@fromorbit.com>
 <20161202132044.GC426@infradead.org>
 <20161205011432.GP31101@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205011432.GP31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 12:14:32PM +1100, Dave Chinner wrote:
> > > +	(offsetof(struct __xfsstats, member) / (int)sizeof(__uint32_t))
> > 
> > what's that int cast for?
> 
> Habit - prevents 64 bit division on 32 bit systems. But given this
> is evaluated at compile time, that doesn't matter. Will remove.

sizeof returns a size_t, which at least on Linux will always be
equivalent to an unsigned long, i.e. 32-bit on a 32-bit system, 64-bit
on a 64-bit system.
