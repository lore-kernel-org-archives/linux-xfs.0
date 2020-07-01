Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45790C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2311220747
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ghVhmGHO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgGAKub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 06:50:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57888 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729791AbgGAKub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 06:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593600630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJhMasmkPY8AKZJe24l74aZcMfQxb2QcFMExGWdHPAA=;
        b=ghVhmGHO7LZ8IlRZ7wKt21cN0uztL5rICPPToAJG3kib8vzBkSOdlICYSYplBRoimgaIbI
        gT4U2NDyCeBgVSeCOFs4L3W68IdTQCW61nHgmb8yLfaQMhqDuQuJx5wTllh1ChziWWSheG
        oO0Tb4Y1NuPpCWZfifTX5G3o6LWhi2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-DcpAYkABN26cnKih_guzyw-1; Wed, 01 Jul 2020 06:50:27 -0400
X-MC-Unique: DcpAYkABN26cnKih_guzyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD3719117F;
        Wed,  1 Jul 2020 10:50:25 +0000 (UTC)
Received: from bfoster (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D8575FC05;
        Wed,  1 Jul 2020 10:50:25 +0000 (UTC)
Date:   Wed, 1 Jul 2020 06:50:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix quota off hang from non-blocking flush
Message-ID: <20200701105023.GA64483@bfoster>
References: <20200701075144.2633976-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701075144.2633976-1-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 05:51:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Found by inspection after having xfs/305 hang 1 in ~50 iterations
> in a quotaoff operation:
> 
> [ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
> [ 8872.302538] Call Trace:
> [ 8872.303193]  __schedule+0x2d2/0x780
> [ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
> [ 8872.305198]  schedule+0x6e/0xe0
> [ 8872.306021]  schedule_timeout+0x14d/0x300
> [ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
> [ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
> [ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
> [ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
> [ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
> [ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
> [ 8872.314163]  xfs_quota_disable+0x3a/0x60
> [ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
> [ 8872.316196]  ? __do_sys_newstat+0x51/0x80
> [ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
> [ 8872.318266]  do_syscall_64+0x46/0x90
> [ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 8872.320490] RIP: 0033:0x7f46b5490f2a
> [ 8872.321414] Code: Bad RIP value.
> 
> Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
> XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
> free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
> flag to go away on the dquot that leaked it via -EAGAIN.
> 
> Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_qm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d6cd83317344..938023dd8ce5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -148,6 +148,7 @@ xfs_qm_dqpurge(
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
>  		} else if (error == -EAGAIN) {
> +			dqp->dq_flags &= ~XFS_DQ_FREEING;
>  			goto out_unlock;
>  		}
>  		xfs_dqflock(dqp);
> -- 
> 2.26.2.761.g0e0b3e54be
> 

