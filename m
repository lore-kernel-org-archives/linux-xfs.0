Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C41BC2BB1D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C0220724
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G/sJtJIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCLKt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:49:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24493 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgCLKt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584010165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/GdVCtOJGGviWU39PF1XaTNddx0QUC9cwYvSRyw+MCQ=;
        b=G/sJtJIODvrudywgkGD4qlsmKKhH6/cjBRB3PurB4k3BtjpsL5X8u0E50HfUzrOLW7NiEP
        /4Uu++4gvcZH7pT118TppknrujH60jobCxE67JkBBszwa9qOlD43wUqfXzDseX/cT1uxkk
        vCDsJdX/EViztIFCQVTksy26P36yZZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-JYOa_IkWOo-3_RFnr9OGUw-1; Thu, 12 Mar 2020 06:49:22 -0400
X-MC-Unique: JYOa_IkWOo-3_RFnr9OGUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28DC018AB2C3;
        Thu, 12 Mar 2020 10:49:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74A1D277A4;
        Thu, 12 Mar 2020 10:49:20 +0000 (UTC)
Date:   Thu, 12 Mar 2020 06:49:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5/7] xfs: make btree cursor private union anonymous
Message-ID: <20200312104918.GE60753@bfoster>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398471398.1307855.8968898997868213653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398471398.1307855.8968898997868213653.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:45:14AM +0000, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rename the union and it's internal structures to the new name and
> remove the temporary defines that facilitated the change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.h |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 00a58ac8b696..12a2bc93371d 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -213,7 +213,7 @@ typedef struct xfs_btree_cur
>  			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
>  			xfs_agnumber_t	agno;	/* ag number */
>  			union xfs_btree_cur_private	priv;
> -		} a;
> +		} bc_ag;
>  		struct {			/* needed for BMAP */
>  			struct xfs_inode *ip;	/* pointer to our inode */
>  			int		allocated;	/* count of alloced */
> @@ -222,10 +222,8 @@ typedef struct xfs_btree_cur
>  			char		flags;		/* flags */
>  #define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
>  #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
> -		} b;
> -	}		bc_private;	/* per-btree type data */
> -#define bc_ag	bc_private.a
> -#define bc_ino	bc_private.b
> +		} bc_ino;
> +	};				/* per-btree type data */
>  } xfs_btree_cur_t;
>  
>  /* cursor flags */
> 

