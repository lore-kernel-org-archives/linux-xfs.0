Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49492 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdHXMTA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 08:19:00 -0400
Date: Thu, 24 Aug 2017 14:18:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
        creations
Message-ID: <20170824121859.GA23392@lst.de>
References: <20170821082404.3387-1-hch@lst.de> <20170823202213.GA4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823202213.GA4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 23, 2017 at 01:22:13PM -0700, Darrick J. Wong wrote:
> Looks ok... but is there a xfstest somewhere that can be coaxed into
> reproducing this?

The QA team that reported this to me required multiple hours to reproduce
it.  I think the key is heavy metadata ops in a full fs, but all my
simple attempts to reproduce it failed.

> I'm looking at what this code does and have been
> wondering why it even tries this weird workaround in the first place?

I think this dates to the time where we weren't very strict about
transaction space reservations - it basically plays lose when near
enospc at the cost of rarely shutting down the whole file system
due to a dirty transaction.
