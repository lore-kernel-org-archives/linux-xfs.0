Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFRRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:17:42 -0400
Date: Sat, 6 Oct 2018 03:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] xfsprogs: kill EXTERN macro
Message-ID: <20181006101500.GL28114@infradead.org>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-13-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538712196-13625-13-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 11:03:13PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> The EXTERN macro was a too-clever hack to allow a header file to both
> declare global variables and export them.  Get rid of the hack and do
> things the predictable way.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  repair/globals.c  | 123 ++++++++++++++++++++++++++++++++++++++++++++++--
>  repair/globals.h  | 136 +++++++++++++++++++++++++++---------------------------
>  repair/versions.c |  23 +++++++--
>  repair/versions.h |  16 +++----
>  4 files changed, 214 insertions(+), 84 deletions(-)
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index d00e964..e963edb 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -1,10 +1,125 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
> + * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.

This doesn't look related.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
