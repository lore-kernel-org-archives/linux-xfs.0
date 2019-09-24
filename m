Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A118C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EFFE2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 14:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbfIXOh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfIXOh4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 10:37:56 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1D3F190C019;
        Tue, 24 Sep 2019 14:37:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08CA61001B08;
        Tue, 24 Sep 2019 14:37:54 +0000 (UTC)
Date:   Tue, 24 Sep 2019 10:37:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 07/16] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20190924143753.GB17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933135854.20933.15258576633425282851.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933135854.20933.15258576633425282851.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 24 Sep 2019 14:37:55 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:38PM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  148 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 94 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6792d46fa0be..cfda58dd3822 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -356,6 +356,97 @@ xfs_parse_param(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_validate_params(
> +	struct xfs_mount        *mp,
> +	struct xfs_fs_context   *ctx,
> +	bool			nooptions)
> +{
> +	if (nooptions)
> +		goto noopts;
> +
> +	/*
> +	 * no recovery flag requires a read-only mount
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx->dswidth)) {

Long line ^.

> +		xfs_warn(mp,
> +	"sunit and swidth options incompatible with the noalign option");
> +		return -EINVAL;
> +	}
> +
...
> @@ -447,16 +538,7 @@ xfs_parseargs(
>  		ret = xfs_parse_param(&fc, &param);
>  		kfree(param.string);
>  		if (ret < 0)
> -			return ret;
> -	}
> -
> -	/*
> -	 * no recovery flag requires a read-only mount
> -	 */
> -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> -		return -EINVAL;
> +			goto done;

Isn't this supposed to just return the error?

Brian

>  	}
>  
>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> @@ -486,51 +568,9 @@ xfs_parseargs(
>  	}
>  
>  done:
> -	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> -		/*
> -		 * At this point the superblock has not been read
> -		 * in, therefore we do not know the block size.
> -		 * Before the mount call ends we will convert
> -		 * these to FSBs.
> -		 */
> -		mp->m_dalign = ctx->dsunit;
> -		mp->m_swidth = ctx->dswidth;
> -	}
> -
> -	if (mp->m_logbufs != -1 &&
> -	    mp->m_logbufs != 0 &&
> -	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> -	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> -		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> -			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> -		return -EINVAL;
> -	}
> -	if (mp->m_logbsize != -1 &&
> -	    mp->m_logbsize !=  0 &&
> -	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> -	     !is_power_of_2(mp->m_logbsize))) {
> -		xfs_warn(mp,
> -			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> -			mp->m_logbsize);
> -		return -EINVAL;
> -	}
> +	ret = xfs_validate_params(mp, &context, false);
>  
> -	if (ctx->iosizelog) {
> -		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> -		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> -			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> -				ctx->iosizelog, XFS_MIN_IO_LOG,
> -				XFS_MAX_IO_LOG);
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_readio_log = ctx->iosizelog;
> -		mp->m_writeio_log = ctx->iosizelog;
> -	}
> -
> -	return 0;
> +	return ret;
>  }
>  
>  struct proc_xfs_info {
> 
