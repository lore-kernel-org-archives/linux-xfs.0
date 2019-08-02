Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-114.smtp-out.amazonses.com ([54.240.9.114]:52100 "EHLO
        a9-114.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbfHBOy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 10:54:27 -0400
Date: Fri, 2 Aug 2019 14:54:26 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC 0/2] iomap & xfs support for large pages
In-Reply-To: <20190731171734.21601-1-willy@infradead.org>
Message-ID: <0100016c52d32b18-8593625f-bf32-4005-be04-79af900ac112-000000@email.amazonses.com>
References: <20190731171734.21601-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org

On Wed, 31 Jul 2019, Matthew Wilcox wrote:

> Christoph sent me a patch a few months ago called "XFS THP wip".
> I've redone it based on current linus tree, plus the page_size() /
> compound_nr() / page_shift() patches currently found in -mm.  I fixed
> the logic bugs that I noticed in his patch and may have introduced some
> of my own.  I have only compile tested this code.

Some references here to patches from a long time ago. Maybe there are
useful tidbits here ...

Variable page cache just for ramfs:
https://lkml.org/lkml/2007/4/19/261

Large blocksize support for XFS, ReiserFS and ext2
https://www.mail-archive.com/linux-fsdevel@vger.kernel.org/msg08730.html
