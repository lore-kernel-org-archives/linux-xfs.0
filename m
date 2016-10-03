Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbcJCPbo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 11:31:44 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87727745C1
        for <linux-xfs@vger.kernel.org>; Mon,  3 Oct 2016 15:31:39 +0000 (UTC)
Date: Mon, 3 Oct 2016 11:31:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add XBF_XBF_NO_IOACCT to buf trace output
Message-ID: <20161003153137.GA19245@bfoster.bfoster>
References: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 08, 2016 at 04:53:28PM -0500, Eric Sandeen wrote:
> When XBF_NO_IOACCT got added, it missed the translation
> in XFS_BUF_FLAGS, so we see "0x8" in trace output rather
> than the flag name.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Thought I caught that, apparently not. Thanks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 1c2e52b..424f6b0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -71,6 +71,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_READ,		"READ" }, \
>  	{ XBF_WRITE,		"WRITE" }, \
>  	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
> +	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
>  	{ XBF_ASYNC,		"ASYNC" }, \
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
