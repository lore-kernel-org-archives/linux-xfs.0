Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37497 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbeJATQ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 15:16:26 -0400
Date: Mon, 1 Oct 2018 14:38:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/10] xfs: handle extent size hints in
 xfs_file_iomap_begin_delay
Message-ID: <20181001123848.GA3452@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917205354.15401-8-hch@lst.de> <20180926151723.GB899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926151723.GB899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 11:17:24AM -0400, Brian Foster wrote:
> I'd guess this is due to the extent overlap check in
> xfs_bmap_extsize_align(), but I haven't verified.

The problem is that we don't honor extent size hints at all when
converting delalloc to real extents.  This will be a much bigger
change, so I'll defer it for now.
