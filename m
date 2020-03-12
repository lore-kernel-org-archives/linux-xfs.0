Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D416BC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE242071C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvAscvfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgCLKtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:49:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726023AbgCLKtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584010174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55Biwz74AiYG0AajH9uCNekeFp+pd+CA31Z+IcP3DZQ=;
        b=SvAscvfkiI0fNP+00C08/mYFGZEibOGzwY79VT7pYtlDWvDKazSAkGXZr4OA2G6Hlr1/ag
        qbjE/Mp9AW87450lWQ5H8dSsTR3oTN7HPXiRWzEu38LHLWK1ECY52uGAopklSw8nammJLc
        CmS8vCpAcWvK9upt/bbhBvXmGiIXhg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-qbTAcf-cNPOCFX2E6i9xhQ-1; Thu, 12 Mar 2020 06:49:33 -0400
X-MC-Unique: qbTAcf-cNPOCFX2E6i9xhQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F121800D5A;
        Thu, 12 Mar 2020 10:49:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CAF8272CB;
        Thu, 12 Mar 2020 10:49:31 +0000 (UTC)
Date:   Thu, 12 Mar 2020 06:49:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 6/7] xfs: make the btree cursor union members named
 structure
Message-ID: <20200312104929.GF60753@bfoster>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398472029.1307855.3111787514328025615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398472029.1307855.3111787514328025615.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:20PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> we need to name the btree cursor private structures to be able
> to pull them out of the deeply nested structure definition they are
> in now.
> 
> Based on code extracted from a patchset by Darrick Wong.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.h |   36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 12a2bc93371d..9884f543eb51 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -188,6 +188,24 @@ union xfs_btree_cur_private {
>  	} abt;
>  };
>  
> +/* Per-AG btree information. */
> +struct xfs_btree_cur_ag {
> +	struct xfs_buf			*agbp;
> +	xfs_agnumber_t			agno;
> +	union xfs_btree_cur_private	priv;
> +};
> +
> +/* Btree-in-inode cursor information */
> +struct xfs_btree_cur_ino {
> +	struct xfs_inode	*ip;
> +	int			allocated;
> +	short			forksize;
> +	char			whichfork;
> +	char			flags;
> +#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)
> +#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
> +};
> +

Are all of the per-field comments dropped intentionally? These are
mostly self-explanatory, so either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  /*
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
> @@ -209,21 +227,9 @@ typedef struct xfs_btree_cur
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
>  	int		bc_statoff;	/* offset of btre stats array */
>  	union {
> -		struct {			/* needed for BNO, CNT, INO */
> -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> -			xfs_agnumber_t	agno;	/* ag number */
> -			union xfs_btree_cur_private	priv;
> -		} bc_ag;
> -		struct {			/* needed for BMAP */
> -			struct xfs_inode *ip;	/* pointer to our inode */
> -			int		allocated;	/* count of alloced */
> -			short		forksize;	/* fork's inode space */
> -			char		whichfork;	/* data or attr fork */
> -			char		flags;		/* flags */
> -#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
> -#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
> -		} bc_ino;
> -	};				/* per-btree type data */
> +		struct xfs_btree_cur_ag	bc_ag;
> +		struct xfs_btree_cur_ino bc_ino;
> +	};
>  } xfs_btree_cur_t;
>  
>  /* cursor flags */
> 

