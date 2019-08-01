Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44695 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732797AbfHAQNe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 12:13:34 -0400
Date: Thu, 1 Aug 2019 18:13:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: Support large pages
Message-ID: <20190801161330.GA25871@lst.de>
References: <20190731171734.21601-1-willy@infradead.org> <20190731171734.21601-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731171734.21601-3-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Wed, Jul 31, 2019 at 10:17:34AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Mostly this is just checking the page size of each page instead of
> assuming PAGE_SIZE.  Clean up the logic in writepage a little.
> 
> Based on a patch from Christoph Hellwig.

FYI, all this is pending a move to iomap..
