Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdHaOHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:07:00 -0400
Date: Thu, 31 Aug 2017 07:06:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170831140657.GA26555@infradead.org>
References: <20170830155517.GI4757@magnolia>
 <20170830163825.GQ4757@magnolia>
 <20170831131723.GD19544@infradead.org>
 <20170831133420.GB21939@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831133420.GB21939@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Thu, Aug 31, 2017 at 09:34:20AM -0400, Brian Foster wrote:
> Don't we need to check that v3 flags are actually attempted on the v2
> inode before returning failure? Also, what about the just previous
> di_flags update if an error occurs and the transaction ends up
> cancelled?

True.  Let me think about this a bit more.
