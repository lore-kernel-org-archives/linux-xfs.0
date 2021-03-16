Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE708C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC7F6508C
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbhCPOvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:51:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235775AbhCPOvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yHk2/NBWq5V1+4WqQv4LhLLj88F94gLvCTbISzM/aDI=;
        b=FhP92Tf2eEU+XJGA3aiuBgwRTJKS520AM29uge8WlZVDniXUNmoJIdPX1sjoSpFomtJxgv
        pY7t7Bit7oJE9GfWPtzZTOkqB59FiWWMqsHw+92xVezzE6WKt2f7Ecv2zP4OcTvu99ooRz
        xJdVTEqWNcS+Ai4yCrLHZG7u2Y1zkjo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-9-wCjRjzN16E0-H8ouYfWA-1; Tue, 16 Mar 2021 10:51:08 -0400
X-MC-Unique: 9-wCjRjzN16E0-H8ouYfWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 549A1101F017;
        Tue, 16 Mar 2021 14:51:07 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5DF619D9F;
        Tue, 16 Mar 2021 14:51:06 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:51:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/45] xfs: only CIL pushes require a start record
Message-ID: <YFDF2fNGM+smC8SK@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-21-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So move the one-off start record writing in xlog_write() out into
> the static header that the CIL push builds to write into the log
> initially. This simplifes the xlog_write() logic a lot.
> 
> pahole on x86-64 confirms that the xlog_cil_trans_hdr is correctly
> 32 bit aligned and packed for copying the log op and transaction
> headers directly into the log as a single log region copy.
> 
> struct xlog_cil_trans_hdr {
> 	struct xlog_op_header      oph[2];               /*     0    24 */
> 	struct xfs_trans_header    thdr;                 /*    24    16 */
> 	struct xfs_log_iovec       lhdr;                 /*    40    16 */
> 
> 	/* size: 56, cachelines: 1, members: 3 */
> 	/* last cacheline: 56 bytes */
> };

FWIW, this doesn't match the structure defined in the code.

> 
> A wart is needed to handle the fact that length of the region the
> opheader points to doesn't include the opheader length. hence if
> we embed the opheader, we have to substract the opheader length from
> the length written into the opheader by the generic copying code.
> This will eventually go away when everything is converted to
> embedded opheaders.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c     | 90 ++++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c | 44 ++++++++++++++++++----
>  2 files changed, 81 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f54d48f4584e..b2f9fb1b4fed 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2425,25 +2420,24 @@ xlog_write(
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
>  			/*
> -			 * Before we start formatting log vectors, we need to
> -			 * write a start record. Only do this for the first
> -			 * iclog we write to.
> +			 * The XLOG_START_TRANS has embedded ophdrs for the
> +			 * start record and transaction header. They will always
> +			 * be the first two regions in the lv chain.
>  			 */
>  			if (optype & XLOG_START_TRANS) {
> -				xlog_write_start_rec(ptr, ticket);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						sizeof(struct xlog_op_header));
> -				optype &= ~XLOG_START_TRANS;
> -				wrote_start_rec = true;
> -			}
> -
> -			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
> -			if (!ophdr)
> -				return -EIO;
> +				ophdr = reg->i_addr;
> +				if (index)
> +					optype &= ~XLOG_START_TRANS;

So ophdr points to the lv memory in this case, but we're going to memcpy
this into iclog anyways.

Presumably the index check is intended to track processing the first lv
in the chain (with the two embedded headers). That seems Ok, but flakey
enough that I hope it doesn't survive the end of the series.

> +			} else {
> +				ophdr = xlog_write_setup_ophdr(log, ptr,
> +							ticket, optype);
> +				if (!ophdr)
> +					return -EIO;
>  
> -			xlog_write_adv_cnt(&ptr, &len, &log_offset,
> +				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
> -
> +				added_ophdr = true;
> +			}
>  			len += xlog_write_setup_copy(ticket, ophdr,
>  						     iclog->ic_size-log_offset,
>  						     reg->i_len,
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b515002e7959..e9da074ecd69 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -652,14 +652,22 @@ xlog_cil_process_committed(
>  }
>  
>  struct xlog_cil_trans_hdr {
> +	struct xlog_op_header	oph[2];
>  	struct xfs_trans_header	thdr;
> -	struct xfs_log_iovec	lhdr;
> +	struct xfs_log_iovec	lhdr[2];
>  };
...

This is all hairy enough that I think it's helpful to at least separate
the two vectors from crossing inside an array boundary. For example,
something like the appended diff (untested).

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index e9da074ecd69..76cb82f1142e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -651,10 +651,16 @@ xlog_cil_process_committed(
 	}
 }
 
+/*
+ * Consolidated structure for the first two iovecs in a CIL checkpoint.
+ */
 struct xlog_cil_trans_hdr {
-	struct xlog_op_header	oph[2];
-	struct xfs_trans_header	thdr;
-	struct xfs_log_iovec	lhdr[2];
+	struct xlog_op_header	op;	/* log start record */
+	struct {			/* trans header*/
+		struct xlog_op_header	op;
+		struct xfs_trans_header	thdr;
+	} t;
+	struct xfs_log_iovec	lhdr[2];/* region pointers for embedded hdrs */
 };
 
 /*
@@ -682,27 +688,27 @@ xlog_cil_build_trans_hdr(
 	memset(hdr, 0, sizeof(*hdr));
 
 	/* Log start record */
-	hdr->oph[0].oh_tid = tid;
-	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
-	hdr->oph[0].oh_flags = XLOG_START_TRANS;
+	hdr->op.oh_tid = tid;
+	hdr->op.oh_clientid = XFS_TRANSACTION;
+	hdr->op.oh_flags = XLOG_START_TRANS;
 
 	/* log iovec region pointer */
-	hdr->lhdr[0].i_addr = &hdr->oph[0];
+	hdr->lhdr[0].i_addr = &hdr->op;
 	hdr->lhdr[0].i_len = sizeof(struct xlog_op_header);
 	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
 
 	/* log opheader */
-	hdr->oph[1].oh_tid = tid;
-	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
+	hdr->t.op.oh_tid = tid;
+	hdr->t.op.oh_clientid = XFS_TRANSACTION;
 
 	/* transaction header */
-	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
-	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
-	hdr->thdr.th_tid = tid;
-	hdr->thdr.th_num_items = num_iovecs;
+	hdr->t.thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
+	hdr->t.thdr.th_type = XFS_TRANS_CHECKPOINT;
+	hdr->t.thdr.th_tid = tid;
+	hdr->t.thdr.th_num_items = num_iovecs;
 
 	/* log iovec region pointer */
-	hdr->lhdr[1].i_addr = &hdr->oph[1];
+	hdr->lhdr[1].i_addr = &hdr->t.op;
 	hdr->lhdr[1].i_len = sizeof(struct xlog_op_header) +
 				sizeof(struct xfs_trans_header);
 	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;

