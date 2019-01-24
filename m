Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfAXIwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 03:52:30 -0500
Date: Thu, 24 Jan 2019 00:52:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 6/6] xfs: use the latest extent at writeback delalloc
 conversion time
Message-ID: <20190124085230.GB24774@infradead.org>
References: <20190123184131.46188-1-bfoster@redhat.com>
 <20190123184131.46188-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123184131.46188-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

And this I really don't like.  I much prefer the full version
I've done here, which has evolved a bit from the work I've been
posting to the list for months now:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.2

Which also fixes up some layering issues we have in that code path.
