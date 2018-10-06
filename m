Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:45583
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbeJFHxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 03:53:07 -0400
Date: Sat, 6 Oct 2018 10:51:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 00/22] xfs-4.20: major documentation surgery
Message-ID: <20181006005154.GM12041@dastard>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153862669110.26427.16504658853992750743.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net

On Wed, Oct 03, 2018 at 09:18:11PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series converts the existing in-kernel xfs documentation to rst
> format, links it in with the rest of the kernel's rst documetation, and
> then begins pulling in the contents of the Data Structures & Algorithms
> book from the xfs-documentation git tree.  No changes are made to the
> text during the import process except to fix things that the conversion
> process (asciidoctor + pandoc) didn't do correctly.  The goal of this
> series is to tie together the XFS code with the on-disk format
> documentation for the features supported by the code.
> 
> I've built the docs and put them here, in case you hate reading rst:
> https://djwong.org/docs/kdoc/admin-guide/xfs.html
> https://djwong.org/docs/kdoc/filesystems/xfs-data-structures/index.html
> 
> I've posted a branch here because the png import patch is huge:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=docs-4.20-merge
> 
> The patchset should apply cleanly against 4.19-rc6.  Comments and
> questions are, as always, welcome.

Jon,

Can you let us know whether the CC-by-SA 4.0 license is acceptible
or not? That's really the only thing that we need clarified at this
point - if it's OK I'll to pull this into the XFS tree for the 4.20
merge window. If not, we'll go back to the drawing board....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
