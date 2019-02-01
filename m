Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35605 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfBAQHf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 11:07:35 -0500
Date: Fri, 1 Feb 2019 17:07:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/11] xfs: don't try to map blocks beyond i_size in
 writeback
Message-ID: <20190201160733.GA6532@lst.de>
References: <20190131075524.4769-1-hch@lst.de> <20190131075524.4769-5-hch@lst.de> <20190131181108.GF36239@bfoster> <20190201072520.GB14711@lst.de> <20190201124641.GA40798@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201124641.GA40798@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 07:46:42AM -0500, Brian Foster wrote:
> Unless I'm missing something where this code is required for correctness
> or somehow provides a measureable performance benefit, I think we're
> better off keeping this path as simple as possible. It should be fairly
> easy to provide test coverage for the page granularity truncate handling
> code (generic/524 may already cover this). I'm not so sure about that
> for the block granularity handling without having some kind of
> additional instrumentation.

It should not be required for correctness.  I've done a first round
of testing with the check removed and it seems to be doing fine.
