Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 05:02:15 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AC274p007110
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 05:02:08 -0700
Date: Mon, 10 Sep 2007 14:02:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill BMAPI_UNWRITTEN
Message-ID: <20070910120206.GB3666@lst.de>
References: <20070909154103.GB19986@lst.de> <cc7060690709091234r115e793p9cc491104862a5cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690709091234r115e793p9cc491104862a5cd@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Sep 10, 2007 at 01:04:55AM +0530, Bhagi rathi wrote:
> The reason for eliminating BMAPI_UNWRITTEN is not clear. It is ideal to keep
> all the block map
> interfaces and information to go through xfs_iomap, xfs_bmapi functionality.

Despit it's name xfs_iomap_write_unwritten is not a block map interface.
Just take a look at the code, it does not use the block allocator data
structures at all, and it does not do the central xfs_bmapi call
(it uses xfs_bmapi later on but in very different ways).
