Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 22:31:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m545V3sa028337
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 22:31:03 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EF8417784AA
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 22:31:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id L5IiSXBDGB1O5ee8 for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 22:31:57 -0700 (PDT)
Date: Wed, 4 Jun 2008 01:31:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Questions for article
Message-ID: <20080604053156.GB6509@infradead.org>
References: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas King <kingttx@tomslinux.homelinux.org>
Cc: xfs@oss.sgi.com

On Tue, Jun 03, 2008 at 03:48:49PM -0500, Thomas King wrote:
> For the most part, XFS is used for massive filesystems (hundreds of petabytes)

I think undreds of petabytes is not something we commonly see today :)
hundreds of TB is more reasonable.

> -Does/Will XFS support NFS v4.1?

I suspect he means support for PNFS.  PNFS is just like CXFS over
sunrpc, so for anyone whoe cares adding an XFS layout driver shouldn't
be a problem, and not actually require changes to the disk format or
low-level XFS code.  Note that I think pnfs a really good idea.
