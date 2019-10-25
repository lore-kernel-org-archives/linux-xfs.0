Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5826FCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 19:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26CB020679
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 19:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfJYTSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:18:07 -0400
Received: from sandeen.net ([63.231.237.45]:44914 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfJYTSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Oct 2019 15:18:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 301421726A;
        Fri, 25 Oct 2019 14:17:14 -0500 (CDT)
Subject: Re: [PATCH 6/7] xfs: clean up setting m_readio_* / m_writeio_*
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
References: <20191025174026.31878-1-hch@lst.de>
 <20191025174026.31878-7-hch@lst.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <258d888c-e359-c264-33c3-910ebbd37bac@sandeen.net>
Date:   Fri, 25 Oct 2019 14:18:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191025174026.31878-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/25/19 12:40 PM, Christoph Hellwig wrote:
> Fill in the default _log values in xfs_parseargs similar to other
> defaults, and open code the updates based on the on-disk superblock
> in xfs_mountfs now that they are completely trivial.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_mount.c | 36 +++++-------------------------------
>  fs/xfs/xfs_super.c |  5 +++++
>  2 files changed, 10 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9800401a7d6f..bae53fdd5d51 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -425,35 +425,6 @@ xfs_update_alignment(xfs_mount_t *mp)
>  	return 0;
>  }
>  
> -/*
> - * Set the default minimum read and write sizes unless
> - * already specified in a mount option.
> - * We use smaller I/O sizes when the file system
> - * is being used for NFS service (wsync mount option).
> - */
> -STATIC void
> -xfs_set_rw_sizes(xfs_mount_t *mp)
> -{
> -	xfs_sb_t	*sbp = &(mp->m_sb);
> -	int		writeio_log;
> -
> -	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
> -		if (mp->m_flags & XFS_MOUNT_WSYNC)
> -			writeio_log = XFS_WRITEIO_LOG_WSYNC;
> -		else
> -			writeio_log = XFS_WRITEIO_LOG_LARGE;
> -	} else {
> -		writeio_log = mp->m_writeio_log;
> -	}
> -
> -	if (sbp->sb_blocklog > writeio_log) {
> -		mp->m_writeio_log = sbp->sb_blocklog;
> -	} else {
> -		mp->m_writeio_log = writeio_log;
> -	}
> -	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
> -}
> -
>  /*
>   * precalculate the low space thresholds for dynamic speculative preallocation.
>   */
> @@ -718,9 +689,12 @@ xfs_mountfs(
>  		goto out_remove_errortag;
>  
>  	/*
> -	 * Set the minimum read and write sizes
> +	 * Update the preferred write size based on the information from the
> +	 * on-disk superblock.
>  	 */
> -	xfs_set_rw_sizes(mp);
> +	mp->m_writeio_log =
> +		max_t(uint32_t, mp->m_sb.sb_blocklog, mp->m_writeio_log);
> +	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - mp->m_sb.sb_blocklog);
>  
>  	/* set the low space thresholds for dynamic preallocation */
>  	xfs_set_low_space_thresholds(mp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1467f4bebc41..83dbfcc5a02d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -405,6 +405,11 @@ xfs_parseargs(
>  				XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
>  			return -EINVAL;
>  		}
> +	} else {
> +		if (mp->m_flags & XFS_MOUNT_WSYNC)
> +			mp->m_writeio_log = XFS_WRITEIO_LOG_WSYNC;
> +		else
> +			mp->m_writeio_log = XFS_WRITEIO_LOG_LARGE;
>  	}

Ok let's see, by here, if Opt_allocsize was specified, we set
mp->m_writeio_log to the specified value, else if Opt_wsync was set, we 
set m_writeio_log to XFS_WRITEIO_LOG_WSYNC (14), otherwise we default to
XFS_WRITEIO_LOG_LARGE (16).  So that's it for parseargs.

AFAICT we can't escape parseargs w/ writeio_log less than PAGE_SHIFT
(i.e. page size).

Then in xfs_mountfs, you have it reset to the max of sb_blocklog and
m_writeio_log.  i.e. it gets resized iff sb_blocklog is greater than
the current m_writeio_log, which has a minimum of page size.

IOWS, it only gets a new value in mountfs if block size is > page size.

Which is a little surprising and nonobvious and it makes me wonder
if you're intentionally future-proofing here, or if that's just weird.
:)

-Eric


>  	return 0;
> 
