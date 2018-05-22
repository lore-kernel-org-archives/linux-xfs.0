Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47115 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751240AbeEVIPX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 04:15:23 -0400
Date: Tue, 22 May 2018 10:20:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/34] iomap: add initial support for writes without
        buffer heads
Message-ID: <20180522082036.GA9801@lst.de>
References: <20180518164830.1552-1-hch@lst.de> <20180518164830.1552-17-hch@lst.de> <20180521232700.GB14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521232700.GB14384@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Mon, May 21, 2018 at 04:27:00PM -0700, Darrick J. Wong wrote:
> Something doesn't smell right here.  The only pages we need to read in
> are the first and last pages in the write_begin range, and only if they
> aren't page aligned and the underlying extent is IOMAP_MAPPED, right?

Yes,  and I'm pretty sure I did get this right before refactoring
everything for sub-blocksize support.
