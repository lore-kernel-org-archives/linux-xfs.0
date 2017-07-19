Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbdGSGyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 02:54:39 -0400
Date: Tue, 18 Jul 2017 23:54:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
Message-ID: <20170719065438.GA18386@infradead.org>
References: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org>
 <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Kujau <christian@nerdbynature.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 17, 2017 at 12:47:16AM -0700, Christian Kujau wrote:
>  | and I'm pretty sure that the USB mass storage interface/driver does not 
>  | pass through cache flushes or support FUA operations.

The usb-storage driver of course implements cache flushes and FUA
properly - it's just a SCSI transport after all.  But that doesn't mean
that the device itself can't have issue, of which there have been
plenty.
