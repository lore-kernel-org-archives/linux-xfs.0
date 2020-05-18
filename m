Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BD8C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD9D20671
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iTzgmGDz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgERNQe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 09:16:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20018 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726726AbgERNQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 09:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589807792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pl5HEkTFeR7BveXegRDxg6sO7CyuQ/4cqeeVObmx3gQ=;
        b=iTzgmGDzBTIjQodPNYY6G5eXOeJSN8floJPuYZ+qJCDVA1aThoFz6AOXIoxFnTvvc8vppc
        VU9sIpzCQWF96dnbhF+80xQLA3OK9xAMTaGipwvSv91zEDtNj/hKIDJzBxsfyMdH9zKgef
        dC5dxnA3R0Oxfk0MarLCY4VMkP9hNfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-3SoYoNEPPQy3Z9Xt3BKi-w-1; Mon, 18 May 2020 09:16:29 -0400
X-MC-Unique: 3SoYoNEPPQy3Z9Xt3BKi-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01464872FE0;
        Mon, 18 May 2020 13:16:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CD7E5C1B2;
        Mon, 18 May 2020 13:16:27 +0000 (UTC)
Date:   Mon, 18 May 2020 09:16:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, david@fromorbit.com
Subject: Re: [PATCH v2] xfs: use ordered buffers to initialize dquot buffers
 during quotacheck
Message-ID: <20200518131625.GC10938@bfoster>
References: <20200514165658.GC6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514165658.GC6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 09:56:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
...
> 
> Fix this by changing the ondisk dquot initialization function to use
> ordered buffers to write out fresh dquot blocks if it detects that we're
> running quotacheck.  If the system goes down before quotacheck can
> complete, the CHKD flags will not be set in the superblock and the next
> mount will run quotacheck again, which can fix uninitialized dquot
> buffers.  This requires amending the defer code to maintaine ordered
> buffer state across defer rolls for the sake of the dquot allocation
> code.
> 
> For regular operations we preserve the current behavior since the dquot
> items require properly initialized ondisk dquot records.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: rework the code comment explaining all this
> ---
>  fs/xfs/libxfs/xfs_defer.c |   10 +++++++
>  fs/xfs/xfs_dquot.c        |   62 ++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 58 insertions(+), 14 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 52e0f7245afc..f60a8967f9d5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
...
> @@ -238,11 +240,45 @@ xfs_qm_init_dquot_blk(
...
> +
> +	/*
> +	 * When quotacheck runs, we use delayed writes to update all the dquots
> +	 * on disk in an efficient manner instead of logging the individual
> +	 * dquot changes as they are made.
> +	 *
> +	 * Hence if we log the buffer that we allocate here, then crash
> +	 * post-quotacheck while the logged initialisation is still in the
> +	 * active region of the log, we can lose the information quotacheck
> +	 * wrote directly to the buffer. That is, log recovery will replay the
> +	 * dquot buffer initialisation over the top of whatever information
> +	 * quotacheck had written to the buffer.
> +	 *
> +	 * To avoid this problem, dquot allocation during quotacheck needs to
> +	 * avoid logging the initialised buffer, but we still need to have
> +	 * writeback of the buffer pin the tail of the log so that it is
> +	 * initialised on disk before we remove the allocation transaction from
> +	 * the active region of the log. Marking the buffer as ordered instead
> +	 * of logging it provides this behaviour.
> +	 *
> +	 * If we crash before quotacheck completes, a subsequent quotacheck run
> +	 * will re-allocate and re-initialize the dquot records as needed.
> +	 */

I took a stab at condensing the comment a bit, FWIW (diff below). LGTM
either way. Thanks for the update.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (!(mp->m_qflags & qflag))
> +		xfs_trans_ordered_buf(tp, bp);
> +	else
> +		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
>  }
>  
>  /*
> 

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f60a8967f9d5..55b95d45303b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -254,26 +254,20 @@ xfs_qm_init_dquot_blk(
 	xfs_trans_dquot_buf(tp, bp, blftype);
 
 	/*
-	 * When quotacheck runs, we use delayed writes to update all the dquots
-	 * on disk in an efficient manner instead of logging the individual
-	 * dquot changes as they are made.
+	 * quotacheck uses delayed writes to update all the dquots on disk in an
+	 * efficient manner instead of logging the individual dquot changes as
+	 * they are made. However if we log the buffer allocated here and crash
+	 * after quotacheck while the logged initialisation is still in the
+	 * active region of the log, log recovery can replay the dquot buffer
+	 * initialisation over the top of the checked dquots and corrupt quota
+	 * accounting.
 	 *
-	 * Hence if we log the buffer that we allocate here, then crash
-	 * post-quotacheck while the logged initialisation is still in the
-	 * active region of the log, we can lose the information quotacheck
-	 * wrote directly to the buffer. That is, log recovery will replay the
-	 * dquot buffer initialisation over the top of whatever information
-	 * quotacheck had written to the buffer.
-	 *
-	 * To avoid this problem, dquot allocation during quotacheck needs to
-	 * avoid logging the initialised buffer, but we still need to have
-	 * writeback of the buffer pin the tail of the log so that it is
-	 * initialised on disk before we remove the allocation transaction from
-	 * the active region of the log. Marking the buffer as ordered instead
-	 * of logging it provides this behaviour.
-	 *
-	 * If we crash before quotacheck completes, a subsequent quotacheck run
-	 * will re-allocate and re-initialize the dquot records as needed.
+	 * To avoid this problem, quotacheck cannot log the initialised buffer.
+	 * We must still dirty the buffer and write it back before the
+	 * allocation transaction clears the log. Therefore, mark the buffer as
+	 * ordered instead of logging it directly. This is safe for quotacheck
+	 * because it detects and repairs allocated but initialized dquot blocks
+	 * in the quota inodes.
 	 */
 	if (!(mp->m_qflags & qflag))
 		xfs_trans_ordered_buf(tp, bp);

