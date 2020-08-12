Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32768C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 11:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074FC20781
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 11:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKNuSSMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHLLMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 07:12:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgHLLMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 07:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597230766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oUEnp0Yj02JG1pY1UUZcnloHZpZB6Q+kugMnDRFsOkA=;
        b=XKNuSSMsFFJWs+zLcd4zXfBKVENbwIX/D5jO/T+5lrIJhalyzp1F8eANkLSZNPl1QlXC1v
        tGQwNv0lAaTHveXBMWB8TGEMTOGca6A5vS/WINPk9sttgAc4ts60th5s0QwgdHLeBD/otF
        bcpfOSqm5wrGsXhnu/5nsdLkCEGKurw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-YYA-z5VpN-q6F5jYb_75ZA-1; Wed, 12 Aug 2020 07:12:44 -0400
X-MC-Unique: YYA-z5VpN-q6F5jYb_75ZA-1
Received: by mail-pj1-f71.google.com with SMTP id e2so1492234pjm.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 04:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oUEnp0Yj02JG1pY1UUZcnloHZpZB6Q+kugMnDRFsOkA=;
        b=YYm2iXpaHAijmH8LEGQkKiopq29vCgzmxj/Rg8D9yxCWetAbA/xlpdTZkeK5U6HC55
         Nw4M+KSrzSqwhNjnbL/ZEMwwiNMI3GkgsKE//zZwzmbPf/NZj0QUKZ2oPuO4FQoalPx7
         x89KMn41ig0J63oVqOB7txpyCa5LonOS5MluBuLUQt0jEdrUFAX77txc75fklpb7MPMr
         EEnbAlNXuRI9TdWxIRxDy+FadD0J5W64ZIByVw0zsJmKtrRXeylkdsv3A3zQ039eQeIW
         XP7L9w2/pB4ZLe8M80kvcDQZveAa7GZuQAq9K9hwfbJK8j0RsQIBCWinmO4J45WjACQu
         jyBg==
X-Gm-Message-State: AOAM532hazYNW/9G0eEtlONtvk63uXAAB1p57GBx3q3erePZvT3GQXny
        pM2ak4Iygrr/lo9Humfsbx7jae/r4evrEh2pE6UJ+GuIXaEmrmuGkh2YzHMPtM9nY5nIRkUdQcK
        6NIH5hzYnnrMeRZDBxsHh
X-Received: by 2002:a63:565d:: with SMTP id g29mr4817693pgm.220.1597230763710;
        Wed, 12 Aug 2020 04:12:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmHjJkPyplPHeQPa3CO+ZmZCuRc/v1OU0jUS91KTswxeQpYcxy7xNY0LQQSXO9PnmgCir+hQ==
X-Received: by 2002:a63:565d:: with SMTP id g29mr4817670pgm.220.1597230763366;
        Wed, 12 Aug 2020 04:12:43 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q17sm2120463pfh.32.2020.08.12.04.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 04:12:42 -0700 (PDT)
Date:   Wed, 12 Aug 2020 19:12:33 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs: reorder iunlink remove operation in xfs_ifree
Message-ID: <20200812111233.GB759@xiangao.remote.csb>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-14-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The O_TMPFILE creation implementation creates a specific order of
> operations for inode allocation/freeing and unlinked list
> modification. Currently both are serialised by the AGI, so the order
> doesn't strictly matter as long as the are both in the same
> transaction.
> 
> However, if we want to move the unlinked list insertions largely
> out from under the AGI lock, then we have to be concerned about the
> order in which we do unlinked list modification operations.
> O_TMPFILE creation tells us this order is inode allocation/free,
> then unlinked list modification.
> 
> Change xfs_ifree() to use this same ordering on unlinked list
> removal. THis way we always guarantee that when we enter the
> iunlinked list removal code from this path, we have the already
> locked and we don't have to worry about lock nesting AGI reads
> inside unlink list locks because it's already locked and attached to
> the transaction.
> 
> We can do this safely as the inode freeing and unlinked list removal
> are done in the same transaction and hence are atomic operations
> with resepect to log recovery.

Yeah, due to all these constraints, such reorder is much cleaner,
otherwise it needs forcely taking AGI lock in xfs_iunlink_remove()
in advance as what I did in my new v3 ( due to exist AGI lock in
xfs_difree() )...
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/tree/fs/xfs/xfs_inode.c?h=xfs/iunlink_opt_v3#n2511
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/fs/xfs/xfs_inode.c?h=xfs/iunlink_opt_v3&id=79a6a18a7f13d12726c2554e2581a56fc473b152

Since the new based patchset is out, I will look into this patchset
and skip sending out my v3 (looks like the previous logging order
issues has been resolved) and directly rebase the rest patches
into v4.

Thanks,
Gao Xiang

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ce128ff12762..7ee778bcde06 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2283,14 +2283,13 @@ xfs_ifree_cluster(
>  }
>  
>  /*
> - * This is called to return an inode to the inode free list.
> - * The inode should already be truncated to 0 length and have
> - * no pages associated with it.  This routine also assumes that
> - * the inode is already a part of the transaction.
> + * This is called to return an inode to the inode free list.  The inode should
> + * already be truncated to 0 length and have no pages associated with it.  This
> + * routine also assumes that the inode is already a part of the transaction.
>   *
> - * The on-disk copy of the inode will have been added to the list
> - * of unlinked inodes in the AGI. We need to remove the inode from
> - * that list atomically with respect to freeing it here.
> + * The on-disk copy of the inode will have been added to the list of unlinked
> + * inodes in the AGI. We need to remove the inode from that list atomically with
> + * respect to freeing it here.
>   */
>  int
>  xfs_ifree(
> @@ -2308,13 +2307,16 @@ xfs_ifree(
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> -	 * Pull the on-disk inode from the AGI unlinked list.
> +	 * Free the inode first so that we guarantee that the AGI lock is going
> +	 * to be taken before we remove the inode from the unlinked list. This
> +	 * makes the AGI lock -> unlinked list modification order the same as
> +	 * used in O_TMPFILE creation.
>  	 */
> -	error = xfs_iunlink_remove(tp, ip);
> +	error = xfs_difree(tp, ip->i_ino, &xic);
>  	if (error)
>  		return error;
>  
> -	error = xfs_difree(tp, ip->i_ino, &xic);
> +	error = xfs_iunlink_remove(tp, ip);
>  	if (error)
>  		return error;
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 

