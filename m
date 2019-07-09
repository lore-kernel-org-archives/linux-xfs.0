Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbfGISMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 14:12:14 -0400
Date: Tue, 9 Jul 2019 11:12:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190709181214.GA31130@infradead.org>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190708184652.GB20670@infradead.org>
 <20190709164952.GT1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709164952.GT1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

I looked over it and while some of the small files seem very tiny
they are reasonably split.

What rather annoys me is the page.c/read.c/write.c split.  All these
really belong mostly together, except maybe the super highlevel
write code that then either calls into the buffer_head vs iomap_page
based code.  By keeping them together we can eliminate most of
iomap_internal.h and once the writeback code moves also keep
iomap_page private to that bigger read.c file.

A few other minor notes:

 - I think iomap_sector() should move to linux/iomap.h as an inline
   helper.
 - iomap_actor_t / iomap_apply should probaby just move to linux/iomap.h
   as well, which would avoid needing the awkward subdir include in
   dax.c
 - some of the copyrights for the small files seem totally wrong.
   e.g. all the swapfile code was written by you, so it should not have
   my or rh copyright notices on it
