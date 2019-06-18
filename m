Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44467 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfFRHRe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jun 2019 03:17:34 -0400
Date: Tue, 18 Jun 2019 07:58:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/24] xfs: use bios directly to write log buffers
Message-ID: <20190618055847.GA2470@lst.de>
References: <20190605191511.32695-1-hch@lst.de> <20190605191511.32695-17-hch@lst.de> <20190617232751.GP3773859@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617232751.GP3773859@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 04:27:51PM -0700, Darrick J. Wong wrote:
> Ugh, I don't really like this awkwardly split else/#endif construction
> here.  Can we simply do:
> 
> error = blk_status_to_errno(iclog->ic_bio.bi_status);
> 
> #ifdef DEBUG
> if (iclog->ic_fail_crc)
> 	error = -EIO;
> #endif
> 
> instead?

Fine with me.
