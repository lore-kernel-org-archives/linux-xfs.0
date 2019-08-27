Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E3CC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031DD217F5
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfH0MmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:42:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfH0MmB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 08:42:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C3F13082132;
        Tue, 27 Aug 2019 12:42:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB8323CCE;
        Tue, 27 Aug 2019 12:41:59 +0000 (UTC)
Date:   Tue, 27 Aug 2019 08:41:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 06/15] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20190827124158.GE10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652198915.2607.7532914515862448103.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156652198915.2607.7532914515862448103.stgit@fedora-28>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 27 Aug 2019 12:42:00 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:59:49AM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  180 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 98 insertions(+), 82 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 754d2ccfd960..7cdda17ee0ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -442,89 +535,12 @@ xfs_parseargs(
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
> -	}
> -
> -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx->dswidth)) {
> -		xfs_warn(mp,
> -	"sunit and swidth options incompatible with the noalign option");
> -		return -EINVAL;
> -	}
> -
> -#ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> -		xfs_warn(mp, "quota support not available in this kernel.");
> -		return -EINVAL;
> -	}
> -#endif
> -
> -	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
> -		xfs_warn(mp, "sunit and swidth must be specified together");
> -		return -EINVAL;
> -	}
> -
> -	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> -		xfs_warn(mp,
> -	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> -			ctx->dswidth, ctx->dsunit);
> -		return -EINVAL;
> +			goto done;
>  	}
>  
> +	ret = xfs_validate_params(mp, ctx, false);
>  done:

This label now directly returns, which means it's not that useful in its
current form. How about we move the validate call below the label
(and perhaps rename the label to validate or some such) and just return
directly from the other user of done?

Brian

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
> -
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
