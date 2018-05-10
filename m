Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46582 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbeEJGgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 02:36:37 -0400
Date: Thu, 10 May 2018 08:40:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/33] block: add a lower-level bio_add_page interface
Message-ID: <20180510064013.GA11422@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-2-hch@lst.de> <20180509151243.GA1313@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509151243.GA1313@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 08:12:43AM -0700, Matthew Wilcox wrote:
> (page, len, off) is a bit weird to me.  Usually we do (page, off, len).

That's what I'd usually do, too.  But this odd convention is what
bio_add_page uses, so I decided to stick to that instead of having two
different conventions in one family of functions.
