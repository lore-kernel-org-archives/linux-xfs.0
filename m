Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90296C2BA1B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 13:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 665BC23359
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 13:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A9bpy/LM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgDFNjF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 09:39:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728381AbgDFNjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 09:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586180344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4hfOYyTOxzNZurDoYbk07p0OyVj2lau3HQgAP5flBL8=;
        b=A9bpy/LMiiQL9NN74qpcADIcWPaxwadH5fB0bRMVjQ3Xo7mCnAVIqDWicgjuFuCL4oMSP0
        DWLphzx6W/xjha+oRm9rpIVHoboDHNx0xz2ygAIDWbCwD2px4SkCHpy8Vn7BRPclZXypmr
        F778oLsLwuusy7QarAHEvVrZkLgtrvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-DNATG152MVmicJJKl6pNWw-1; Mon, 06 Apr 2020 09:39:03 -0400
X-MC-Unique: DNATG152MVmicJJKl6pNWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13337100DFC0;
        Mon,  6 Apr 2020 13:39:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32CAC9DD9D;
        Mon,  6 Apr 2020 13:39:01 +0000 (UTC)
Date:   Mon, 6 Apr 2020 09:38:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: check if reserved free disk blocks is needed
Message-ID: <20200406133859.GB20708@bfoster>
References: <1586078239-14289-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586078239-14289-1-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 05, 2020 at 05:17:19PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We don't need to create the new quota inodes from disk when
> they exist already, so add check if reserved free disk blocks
> is needed in xfs_trans_alloc().
> 

I find the commit log to be a bit misleading. We don't actually get into
this code if the inodes exist already. The need_alloc == false case
looks like it has more to do with the scenario with the project/group
inode is shared on older superblocks (explained in the comment near the
top of the alloc function).

That aside, the code looks fine to me, so with an improved commit log:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_qm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6678baa..b684b04 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -780,7 +780,8 @@ struct xfs_qm_isolate {
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
> -			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
> +			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
> +			0, 0, &tp);
>  	if (error)
>  		return error;
>  
> -- 
> 1.8.3.1
> 

