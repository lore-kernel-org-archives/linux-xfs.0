Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752535AbeEQRY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 13:24:29 -0400
Date: Thu, 17 May 2018 10:23:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 0/2] iomap: swapfile tweaks
Message-ID: <20180517172355.GS23858@magnolia>
References: <cover.1526493125.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1526493125.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed, May 16, 2018 at 10:54:09AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Changes from v2:
> 
> - Move up inline flag check, which Christoph is going to turn into a
>   type at some point
> - Remove null address check, since it doesn't make sense for
>   IOMAP_MAPPED or IOMAP_UNWRITTEN
> 
> Omar Sandoval (2):
>   iomap: provide more useful errors for invalid swap files
>   iomap: don't allow holes in swapfiles
> 
>  fs/iomap.c | 43 +++++++++++++++++++++++--------------------

Tested ok overnight, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
