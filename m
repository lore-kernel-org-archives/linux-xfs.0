Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54253 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcLEMtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 07:49:33 -0500
Date: Mon, 5 Dec 2016 04:48:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: optimise CRC updates
Message-ID: <20161205124840.GC30956@infradead.org>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-4-david@fromorbit.com>
 <20161202132245.GD426@infradead.org>
 <20161204221231.GM31101@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161204221231.GM31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 09:12:31AM +1100, Dave Chinner wrote:
> I thought the C standard specifically disallowed pointer arithmetic
> on void pointers because they are an incomplete type, even though
> they have the same alignment/representation as a char *.
> 
> IIRC, gcc will throw errors on such code if -pedantic-errors or
> -Werror-pointer-arith is specified...

void pointer arithmetics is a GNU extension indeed, but on that
the kernel relies on heavily.
