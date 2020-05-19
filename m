Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35B5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85388206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6BFhWZK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgESMqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 08:46:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727077AbgESMqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 08:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589892366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kYojbHIPqe8KiUV8ibGubncF9NJnrN66q6ke+vbt7E=;
        b=A6BFhWZKME7CRb9lO58b52x1CubTWn0yN0GIKDwK8IXOPZsm1e5haimDLwtUTIgiRr4W42
        GrorEuMh+ik/No3mlvX1NvJJLoqoavakCD/Q7fP07KijG0pCPHG5YnrtPNVIFvvuSnRU4z
        JcQELmEOMFfD8Fl+SqlXOgBIl+VwbUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-kEXeaiBxPNmcSWWD-iLWDQ-1; Tue, 19 May 2020 08:46:04 -0400
X-MC-Unique: kEXeaiBxPNmcSWWD-iLWDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BE0784B8A1;
        Tue, 19 May 2020 12:46:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 329FD5D9DD;
        Tue, 19 May 2020 12:46:03 +0000 (UTC)
Date:   Tue, 19 May 2020 08:46:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/3] xfs: don't fail unwritten extent conversion on
 writeback due to edquot
Message-ID: <20200519124601.GB23387@bfoster>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984935767.619853.515097571114256885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984935767.619853.515097571114256885.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:49:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During writeback, it's possible for the quota block reservation in
> xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
> limit.  This causes writeback errors for data that was already written
> to disk, when it's not even guaranteed that the bmbt will expand to
> exceed the quota limit.  Irritatingly, this condition is reported to
> userspace as EIO by fsync, which is confusing.
> 
> We wrote the data, so allow the reservation.  That might put us slightly
> above the hard limit, but it's better than losing data after a write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bb590a267a7f..ac970b13b1f8 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -563,7 +563,7 @@ xfs_iomap_write_unwritten(
>  		xfs_trans_ijoin(tp, ip, 0);
>  
>  		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -				XFS_QMOPT_RES_REGBLKS);
> +				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> 

