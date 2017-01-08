Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57824 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752230AbdAHKbg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 05:31:36 -0500
Date: Sun, 8 Jan 2017 11:31:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] xfs: fix the alignment fallback in xfs_bmap_btalloc
Message-ID: <20170108103134.GB26451@lst.de>
References: <1482436822-31546-1-git-send-email-hch@lst.de> <1482436822-31546-3-git-send-email-hch@lst.de> <20170104143405.GB41989@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104143405.GB41989@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Jan 04, 2017 at 09:34:05AM -0500, Brian Foster wrote:
> Ok, but we have the following near the top of xfs_alloc_vextent():
> 
>         if (args->alignment == 0)
>                 args->alignment = 1;
> 
> ... so I'm not sure the commit log description is accurate. That aside:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Well, in that case we might not actually need it.  This was just a
a drive-by patch from investigating what the alignmnet - 1 mean in
the allocator.

Either way this could be cleaned up, but probably shouldn't be in
a minimal bugfix series.
