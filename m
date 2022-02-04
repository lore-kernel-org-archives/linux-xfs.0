Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AF4C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Feb 2022 21:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbiBDVgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 16:36:21 -0500
Received: from sandeen.net ([63.231.237.45]:52984 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233101AbiBDVgU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Feb 2022 16:36:20 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 43EAE7BCB;
        Fri,  4 Feb 2022 15:35:56 -0600 (CST)
Message-ID: <40c947a4-db5c-db4d-b369-de7554f3a8a4@sandeen.net>
Date:   Fri, 4 Feb 2022 15:36:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263810572.863810.13209521254816975203.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 02/17] libxfs: shut down filesystem if we xfs_trans_cancel
 with deferred work items
In-Reply-To: <164263810572.863810.13209521254816975203.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While debugging some very strange rmap corruption reports in connection
> with the online directory repair code.  I root-caused the error to the
> following incorrect sequence:
> 
> <start repair transaction>
> <expand directory, causing a deferred rmap to be queued>
> <roll transaction>
> <cancel transaction>
> 
> Obviously, we should have committed the transaction instead of
> cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
> have warned us that we were throwing away work item that we already
> committed to performing.  This is not correct, and we need to shut down
> the filesystem.
> 
> Change xfs_trans_cancel to complain in the loudest manner if we're
> cancelling any transaction with deferred work items attached.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

So this is basically:

Source kernel commit: 47a6df7cd3174b91c6c862eae0b8d4e13591df52

plus the actual shutting down / aborting part 

Seems ok; did you run into this in practice, in userspace?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/trans.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index fd2e6f9d..8c16cb8d 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -318,13 +318,30 @@ void
>  libxfs_trans_cancel(
>  	struct xfs_trans	*tp)
>  {
> +	bool			dirty;
> +
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
>  
>  	if (tp == NULL)
>  		return;
> +	dirty = (tp->t_flags & XFS_TRANS_DIRTY);
>  
> -	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
> +	/*
> +	 * It's never valid to cancel a transaction with deferred ops attached,
> +	 * because the transaction is effectively dirty.  Complain about this
> +	 * loudly before freeing the in-memory defer items.
> +	 */
> +	if (!list_empty(&tp->t_dfops)) {
> +		ASSERT(list_empty(&tp->t_dfops));
> +		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +		dirty = true;
>  		xfs_defer_cancel(tp);
> +	}
> +
> +	if (dirty) {
> +		fprintf(stderr, _("Cancelling dirty transaction!\n"));
> +		abort();
> +	}
>  
>  	xfs_trans_free_items(tp);
>  	xfs_trans_free(tp);
> 
