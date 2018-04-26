Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeDZF52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Apr 2018 01:57:28 -0400
Date: Wed, 25 Apr 2018 22:57:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap: add a swapfile activation function
Message-ID: <20180426055727.GA24887@infradead.org>
References: <20180418025023.GM24738@magnolia>
 <20180424173539.GB25233@infradead.org>
 <20180425234622.GC1661@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425234622.GC1661@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, Aleksei Besogonov <cyberax@amazon.com>

On Wed, Apr 25, 2018 at 04:46:22PM -0700, Darrick J. Wong wrote:
> (I mean, we /could/ just treat the swapfile as an unbreakable rdma/dax
> style lease, but ugh...)

That is what I think it should be long term, instead of a strange
parallel I/O path.

But in the mean time we have a real problem with supporting swap files,
so we should merge the approaches from you and Aleksei and get something
in ASAP.
