Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdIEGbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 02:31:39 -0400
Date: Mon, 4 Sep 2017 23:31:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
Message-ID: <20170905063139.GA679@infradead.org>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> physical sector size of loop devices. On ppc64, this causes loop devices
> to have 64k as the physical sector size.

Eek.  We'll need to revert the loop change ASAP!

