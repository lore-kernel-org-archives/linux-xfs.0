Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A884C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB5264E1D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhA1SM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:12:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231797AbhA1SKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611857368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/HnzrzGY6U1BV7zswYRPtSG+0Skj84dBAUfhaWADmUc=;
        b=OByFaC73f1vRQldq6c8MNZNEfAYWz2eAzWMbaMKq5gvurdjXEkN7L6Sh/sp28tspDpLpcc
        e4qU30WU4jRH9BORlTUOS2wqSM+vWFsZJAacbGosLMFgObjA62C+4PPjCwsqh7yL2qw01l
        2rKXlx0J125GLYhEV6+0cuIKfSg8DXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-1hjr5Z8GNdKcWntS8UpfwQ-1; Thu, 28 Jan 2021 13:09:26 -0500
X-MC-Unique: 1hjr5Z8GNdKcWntS8UpfwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66E121800D41;
        Thu, 28 Jan 2021 18:09:25 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3C505D9EF;
        Thu, 28 Jan 2021 18:09:24 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:09:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: fix up build warnings when quotas are disabled
Message-ID: <20210128180922.GD2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369266.1523592.14023535880347018628.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181369266.1523592.14023535880347018628.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix some build warnings on gcc 10.2 when quotas are disabled.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_quota.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index d1e3f94140b4..72f4cfc49048 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
...
> @@ -166,8 +166,8 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
>  #define xfs_qm_dqattach(ip)						(0)
>  #define xfs_qm_dqattach_locked(ip, fl)					(0)
>  #define xfs_qm_dqdetach(ip)
> -#define xfs_qm_dqrele(d)
> -#define xfs_qm_statvfs(ip, s)
> +#define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)

What's the need for the assignment, out of curiosity?

Regardless, LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +#define xfs_qm_statvfs(ip, s)			do { } while(0)
>  #define xfs_qm_newmount(mp, a, b)					(0)
>  #define xfs_qm_mount_quotas(mp)
>  #define xfs_qm_unmount(mp)
> 

