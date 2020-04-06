Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EFFC2BA19
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D2A20678
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYNrHK/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgDFMOo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:14:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55061 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727614AbgDFMOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586175282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0ACOiPGSnU/ktd7ZF92BYpQmOrflZGL6+MzznN+NRM=;
        b=QYNrHK/Xq7iXphmqfrWF5WAq39yKviPVFD/Ai9BgsAJY7P5ekzo9SQbIocPt0AlsdSltlY
        /yCtfO3ds4jyEEXAVOmaYrL4ZFqwcJ06I4hDazIMWHRhxVuUrmywCXPQPbtGtDMaNRDu6S
        L/M3EA6LbeCBZ2ne3r3mo7BRTTQvsr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-1C-yyz9cMreU2KGBbHT1wA-1; Mon, 06 Apr 2020 08:14:41 -0400
X-MC-Unique: 1C-yyz9cMreU2KGBbHT1wA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FE22100551A;
        Mon,  6 Apr 2020 12:14:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A607F94B5A;
        Mon,  6 Apr 2020 12:14:39 +0000 (UTC)
Date:   Mon, 6 Apr 2020 08:14:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: reflink should force the log out if mounted
 with wsync
Message-ID: <20200406121437.GB20207@bfoster>
References: <20200403125522.450299-1-hch@lst.de>
 <20200403125522.450299-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403125522.450299-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 02:55:22PM +0200, Christoph Hellwig wrote:
> Reflink should force the log out to disk if the filesystem was mounted
> with wsync, the same as most other operations in xfs.
> 

Isn't WSYNC for namespace operations? Why is this needed for reflink?

> Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")

At a glance this looks like a refactoring patch. What does this fix?

Brian

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 68e1cbb3cfcc..4b8bdecc3863 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1059,7 +1059,11 @@ xfs_file_remap_range(
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
>  			remap_flags);
> +	if (ret)
> +		goto out_unlock;
>  
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_log_force_inode(dest);
>  out_unlock:
>  	xfs_reflink_remap_unlock(file_in, file_out);
>  	if (ret)
> -- 
> 2.25.1
> 

