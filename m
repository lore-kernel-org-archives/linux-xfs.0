Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E581AC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C2420826
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 15:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFXrWUaN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIBP17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:27:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728157AbgIBP1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 11:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599060421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tv05HY6q0ycV4iM0WGj7GEc6sJWZ5pi+8O+BKVVihrA=;
        b=XFXrWUaNCwPrX/fEmvwOXtE9NzK+S62byZgm3b3DzhT6V1GTAnNTVWgdCyjdqEY6BTso55
        iS99gZUZcGh9maNDdMOvki04mkHnfTI6APEYJ8/dEcj5FD4v7JRDlkpjTXoO9aaQgaK9jo
        1QgFULYGs0lUbaudNnjoh4w4Bzmsv40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-I4jd_5nDNlWj_T1JZj71HA-1; Wed, 02 Sep 2020 11:26:59 -0400
X-MC-Unique: I4jd_5nDNlWj_T1JZj71HA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1FF78015A5
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 15:26:58 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0E435D9CC;
        Wed,  2 Sep 2020 15:26:58 +0000 (UTC)
Date:   Wed, 2 Sep 2020 11:26:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up calculation of LR header blocks
Message-ID: <20200902152656.GC289426@bfoster>
References: <20200902140923.24392-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902140923.24392-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 10:09:23PM +0800, Gao Xiang wrote:
> Let's use DIV_ROUND_UP() to calculate log record header
> blocks as what did in xlog_get_iclog_buffer_size() and
> also wrap up a common helper for log recovery code.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h | 10 +++++++++
>  fs/xfs/xfs_log.c               |  4 +---
>  fs/xfs/xfs_log_recover.c       | 37 ++++++++--------------------------
>  3 files changed, 19 insertions(+), 32 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2ec91b2d0f4..5fecc0c7aeb2 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -489,15 +489,10 @@ xlog_find_verify_log_record(
>  	 * reset last_blk.  Only when last_blk points in the middle of a log
>  	 * record do we update last_blk.
>  	 */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> -		uint	h_size = be32_to_cpu(head->h_size);
> -
> -		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
> -		if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -			xhdrs++;
> -	} else {
> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> +		xhdrs = xlog_logv2_rec_hblks(head);
> +	else
>  		xhdrs = 1;
> -	}

Can we fold the _haslogv2() check into the helper as well (then perhaps
drop the 'v2' from the name)? Otherwise looks like a nice cleanup to
me..

Brian

>  
>  	if (*last_blk - i + extra_bblks !=
>  	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
> @@ -1184,21 +1179,10 @@ xlog_check_unmount_rec(
>  	 * below. We won't want to clear the unmount record if there is one, so
>  	 * we pass the lsn of the unmount record rather than the block after it.
>  	 */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> -		int	h_size = be32_to_cpu(rhead->h_size);
> -		int	h_version = be32_to_cpu(rhead->h_version);
> -
> -		if ((h_version & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> -		} else {
> -			hblks = 1;
> -		}
> -	} else {
> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
> +		hblks = xlog_logv2_rec_hblks(rhead);
> +	else
>  		hblks = 1;
> -	}
>  
>  	after_umount_blk = xlog_wrap_logbno(log,
>  			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
> @@ -3016,15 +3000,10 @@ xlog_do_recovery_pass(
>  			}
>  		}
>  
> -		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
> -		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
> -			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> -			if (h_size % XLOG_HEADER_CYCLE_SIZE)
> -				hblks++;
> +		hblks = xlog_logv2_rec_hblks(rhead);
> +		if (hblks != 1) {
>  			kmem_free(hbp);
>  			hbp = xlog_alloc_buffer(log, hblks);
> -		} else {
> -			hblks = 1;
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -- 
> 2.18.1
> 

