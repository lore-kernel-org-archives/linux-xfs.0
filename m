Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53337 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdERGbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 02:31:10 -0400
Date: Wed, 17 May 2017 23:31:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: remove double-underscore integer types
Message-ID: <20170518063109.GB722@infradead.org>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013043.GU4519@birch.djwong.org>
 <20170518060158.GP17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518060158.GP17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

> I'm not sure that this is entirely correct when it comes to sparse
> endian notations or the way the __ types were intended to be used.
> ISTR we used the __ types were originally for the in-memory endian
> converted variable definitions that shadowed the on-disk structures.
> The cleanup plan I was planning to do was to convert these all to
> the linux kernel definitions of __[s,u][8,16,32,64] so it was clear
> they shadow on disk structures of specific sizes.
> 
> Once that was done, everything else could be converted to c99 types
> (like you've done above) and then we'd be free of all the old
> __[u]int*_t types....

Sparse doesn't care - what matters there are the __be* and __le*
types.

Otherwise it's just a decision if we want to use C99 or Linux types,
and if we want to use Linux types if we want to use the __-prefixed
ones to avoid name collisions in userspace.

I'm fine either way - I'm used to typing uXX so that'd be my first
preference, but the uintX_t is a close second, so I'd be perfectly
fine with this patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>
