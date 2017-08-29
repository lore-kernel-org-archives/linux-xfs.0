Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41377 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdH2Qk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:40:58 -0400
Date: Tue, 29 Aug 2017 09:40:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflinks
Message-ID: <20170829164056.GA22055@infradead.org>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
 <d1c6f429-fc41-0e38-b704-444273aaae9e@bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1c6f429-fc41-0e38-b704-444273aaae9e@bytemark.co.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Cottam <chris.cottam@bytemark.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 02:39:56PM +0100, Chris Cottam wrote:
> Could I enquire about the severity of a few issues?

The most recent ones were:

xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent

which is a case wher we blew a transaction under extreme unlink
loads, leading to a fs shutdown in those cases.

xfs: try any AG when allocating the first btree block when reflinking

again could lead to a shutdown

xfs: fix COW writeback race

this could lead to a kernel crash

xfs: only reclaim unwritten COW extents periodically

could lead to a kernel crash
