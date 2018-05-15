Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40367 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752090AbeEOHWJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 03:22:09 -0400
Date: Tue, 15 May 2018 09:26:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 31/33] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180515072625.GA23384@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-32-hch@lst.de> <eebcc4bf-f646-edc6-264b-124b3880f3cb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eebcc4bf-f646-edc6-264b-124b3880f3cb@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Mon, May 14, 2018 at 11:00:08AM -0500, Goldwyn Rodrigues wrote:
> > +	if (iop || i_blocksize(inode) == PAGE_SIZE)
> > +		return iop;
> 
> Why is this an equal comparison operator? Shouldn't this be >= to
> include filesystem blocksize greater than PAGE_SIZE?

Which filesystems would that be that have a tested and working PAGE_SIZE
support using iomap?
