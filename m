Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44481 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdEBHha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 03:37:30 -0400
Date: Tue, 2 May 2017 00:37:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] xfs: support debug mode with assert warnings
Message-ID: <20170502073730.GA19021@infradead.org>
References: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2017 at 01:29:01PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> Every now and then I find myself wanting to enable DEBUG mode code
> without having to BUG the kernel every time an assert fails. Currently,
> I end up just commenting out the BUG() call from assfail(). Any thoughts
> on something like the below to update our configuration to support the
> ability to enable debug mode with assert warnings?
> 
> While this appears as a new option in Kconfig, it just reuses the
> existing XFS_WARN definition to convert asserts into warnings regardless
> of whether debug mode is enabled or not. There are probably multiple
> other ways to do something like this (e.g., a Kconfig 'choice' selection
> for various XFS debug modes, dropping the BUG() entirely, etc.).
> Thoughts?
> 
> Brian
> 
>  fs/xfs/Kconfig     |  9 +++++++++
>  fs/xfs/xfs_linux.h | 32 +++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 35faf12..db6d830 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -96,3 +96,12 @@ config XFS_DEBUG
>  	  not useful unless you are debugging a particular problem.
>  
>  	  Say N unless you are an XFS developer, or you play one on TV.
> +
> +config XFS_WARN
> +	bool "Non-fatal Asserts"
> +	default n
> +	depends on XFS_FS && XFS_DEBUG
> +	help
> +	  Say Y here to convert DEBUG mode ASSERT failures into warnings.
> +	  Otherwise, ASSERT failures are considered fatal errors and BUG the
> +	  kernel.

I'm very confused by this patch.  At least my fs/xfs/Kconfig already
has a "config XFS_WARN" line.  What am I missing?
