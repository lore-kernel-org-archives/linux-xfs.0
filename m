Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155BFC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4DC20724
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ve5k9kks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgCLKl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:41:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbgCLKl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:41:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584009718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w2ATDPJ5Gkq2gEfH10Fssax2JzNBwdEe4AIXcYeNhtA=;
        b=Ve5k9kks1cLZlN9L5KNuoB+fRpgDM7PYz165Qn4mdJ4a8kxrOoK8GNFR8vzWNZI8gZ7mhs
        G25Kmx0s6LySx/YcZDn++M/0NoqQckIscjoI6q6IsdqFAceAFahR7Qy8z69PTp+nZys1Zh
        eEBO63WyIpvXQ5M87GNnQDPwKWCHLvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-tUgtYj6JOy6D9rsEeRx10w-1; Thu, 12 Mar 2020 06:41:56 -0400
X-MC-Unique: tUgtYj6JOy6D9rsEeRx10w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 295C410838A0;
        Thu, 12 Mar 2020 10:41:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 954498AC4D;
        Thu, 12 Mar 2020 10:41:54 +0000 (UTC)
Date:   Thu, 12 Mar 2020 06:41:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/7] xfs: introduce new private btree cursor names
Message-ID: <20200312104152.GA60753@bfoster>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398468764.1307855.4576269889532808623.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398468764.1307855.4576269889532808623.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:44:47PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Just the defines of the new names - the conversion will be in
> scripted commits after this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> [darrick: change "bc_bt" to "bc_ino"]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 3eff7c321d43..4a1c98bdfaad 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -224,6 +224,8 @@ typedef struct xfs_btree_cur
>  #define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
>  		} b;
>  	}		bc_private;	/* per-btree type data */
> +#define bc_ag	bc_private.a
> +#define bc_ino	bc_private.b
>  } xfs_btree_cur_t;
>  
>  /* cursor flags */
> 

