Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586E8C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34762207FF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 15:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389961AbfJDPv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389954AbfJDPv5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Oct 2019 11:51:57 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC8F630084AD;
        Fri,  4 Oct 2019 15:51:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14CBF5D9DC;
        Fri,  4 Oct 2019 15:51:56 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:51:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 08/17] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20191004155154.GC7208@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009836177.13858.17631367285427216767.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009836177.13858.17631367285427216767.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 04 Oct 2019 15:51:56 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:01PM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  147 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 94 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7fd3975d5523..7008355df065 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -441,15 +533,6 @@ xfs_parseargs(
>  			return ret;
>  	}
>  
> -	/*
> -	 * no recovery flag requires a read-only mount
> -	 */
> -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> -		return -EINVAL;
> -	}
> -

Is there a reason that various checks above this one are replicated in
the helper and not removed from xfs_parseargs()? Either way, it looks
like this code goes away anyways:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
>  	    (ctx->dsunit || ctx->dswidth)) {
>  		xfs_warn(mp,
> @@ -477,51 +560,9 @@ xfs_parseargs(
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
> +	ret = xfs_validate_params(mp, &context, false);
>  
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
