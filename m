Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFMW2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 18:28:38 -0400
Date: Thu, 13 Jun 2019 15:28:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Fix typos in xfs-documentation
Message-ID: <20190613222829.GI3773859@magnolia>
References: <20190613210459.52794-1-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613210459.52794-1-andrea.gelmini@gelma.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 11:04:59PM +0200, Andrea Gelmini wrote:
> ---
>  .../filesystem_tunables.asciidoc                   |  6 +++---
>  .../xfs_performance_tuning.asciidoc                |  4 ++--
>  .../extended_attributes.asciidoc                   |  2 +-
>  .../journaling_log.asciidoc                        |  2 +-
>  design/XFS_Filesystem_Structure/magic.asciidoc     |  2 +-
>  .../XFS_Filesystem_Structure/refcountbt.asciidoc   |  2 +-
>  design/xfs-smr-structure.asciidoc                  | 14 +++++++-------
>  7 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
> index c12981b..c570406 100644
> --- a/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc
> +++ b/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

<snip>

> --- a/design/XFS_Filesystem_Structure/refcountbt.asciidoc
> +++ b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
> @@ -6,7 +6,7 @@ This data structure is under construction!  Details may change.
>  
>  To support the sharing of file data blocks (reflink), each allocation group has
>  its own reference count B+tree, which grows in the allocated space like the
> -inode B+trees.  This data could be gleaned by performing an interval query of
> +inode B+trees.  This data could be cleaned by performing an interval query of

That one actually is correct, but since it's clearly confusing to people
(the primary definitions involve grain and produce) let's change
"gleaned" to "collected".  How does that sound?

The rest looks solid, though.

--D
