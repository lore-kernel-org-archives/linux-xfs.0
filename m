Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA76C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B570123A34
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJBVh3yo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVPWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:22:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVPWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600788140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OU0Y0VB9wYWiPdMkauJ2qYCVP84YBiBGt8DDw7eaPdk=;
        b=YJBVh3yo06dRNNaDfDkDMjM4rvxjhPOMaleb6DIls25T4LmXcGZuDbr1z1RzZdWXiBQi3L
        MK0BlQHFuDOrX5PRHWszcYbQV5eXHj7ZX/aN32wUW+HRY7jn8u8q/R7v5cnGOQyVo5n6JQ
        IY6Nkt4Vl8X3a0vA56m+HK8GE2io5GI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-l-Ns0kfUMrabRHdJLmjdJQ-1; Tue, 22 Sep 2020 11:22:19 -0400
X-MC-Unique: l-Ns0kfUMrabRHdJLmjdJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC13F64083;
        Tue, 22 Sep 2020 15:22:17 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27A8A1A7D2;
        Tue, 22 Sep 2020 15:22:14 +0000 (UTC)
Date:   Tue, 22 Sep 2020 11:22:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200922152212.GB2175303@bfoster>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
 <20200917051341.9811-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917051341.9811-2-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 01:13:40PM +0800, Gao Xiang wrote:
> Currently, crafted h_len has been blocked for the log
> header of the tail block in commit a70f9fe52daa ("xfs:
> detect and handle invalid iclog size set by mkfs").
> 
> However, each log record could still have crafted h_len
> and cause log record buffer overrun. So let's check
> h_len vs buffer size for each log record as well.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v3: https://lore.kernel.org/r/20200904082516.31205-2-hsiangkao@redhat.com
> 
> changes since v3:
>  - drop exception comment to avoid confusion (Brian);
>  - check rhead->hlen vs buffer size to address
>    the harmful overflow (Brian);
> 
> And as Brian requested previously, "Also, please test the workaround
> case to make sure it still works as expected (if you haven't already)."
> 
> So I tested the vanilla/after upstream kernels with compiled xfsprogs-v4.3.0,
> which was before mkfs fix 20fbd4593ff2 ("libxfs: format the log with
> valid log record headers") got merged, and I generated a questionable
> image followed by the instruction described in the related commit
> messages with "mkfs.xfs -dsunit=512,swidth=4096 -f test.img" and
> logprint says
> 
> cycle: 1        version: 2              lsn: 1,0        tail_lsn: 1,0
> length of Log Record: 261632    prev offset: -1         num ops: 1
> uuid: 7b84cd80-7855-4dc8-91ce-542c7d65ba99   format: little endian linux
> h_size: 32768
> 
> so "length of Log Record" is overrun obviously, but I cannot reproduce
> the described workaround case for vanilla/after kernels anymore.
> 
> I think the reason is due to commit 7f6aff3a29b0 ("xfs: only run torn
> log write detection on dirty logs"), which changes the behavior
> described in commit a70f9fe52daa8 ("xfs: detect and handle invalid
> iclog size set by mkfs") from "all records at the head of the log
> are verified for CRC errors" to "we can only run CRC verification
> when the log is dirty because there's no guarantee that the log
> data behind an unmount record is compatible with the current
> architecture).", more details see codediff of a70f9fe52daa8.
> 

If I follow correctly, you're saying that prior to commit 7f6aff3a29b0,
log recovery would run a CRC pass on a clean log (with an unmount
record) and this is where the old workaround code would kick in if the
filesystem happened to be misformatted by mkfs. After said commit, the
CRC pass is no longer run unless the log is dirty (for arch
compatibility reasons), so we fall into the xlog_check_unmount_rec()
path that does some careful (presumably arch agnostic) detection of a
clean/dirty log based on whether the record just behind the head has a
single unmount transaction. This function already uses h_len properly
and only reads a single log block to determine whether the target is an
unmount record, so doesn't have the same overflow risk as a full
recovery pass.

Am I following that correctly? If so, the patch otherwise looks
reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> The timeline seems to be:
>  https://lore.kernel.org/r/1447342648-40012-1-git-send-email-bfoster@redhat.com
>  a70f9fe52daa [PATCH v2 1/8] xfs: detect and handle invalid iclog size set by mkfs
>  7088c4136fa1 [PATCH v2 7/8] xfs: detect and trim torn writes during log recovery
>  https://lore.kernel.org/r/1457008798-58734-5-git-send-email-bfoster@redhat.com
>  7f6aff3a29b0 [PATCH 4/4] xfs: only run torn log write detection on dirty logs
> 
> so IMHO, the workaround a70f9fe52daa would only be useful between
> 7088c4136fa1 ~ 7f6aff3a29b0.
> 
> Yeah, it relates to several old kernel commits/versions, my technical
> analysis is as above. This patch doesn't actually change the real
> original workaround logic. Even if the workground can be removed now,
> that should be addressed with another patch and that is quite another
> story.
> 
> Kindly correct me if I'm wrong :-)
> 
> Thanks,
> Gao Xiang
> 
>  fs/xfs/xfs_log_recover.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a17d788921d6..782ec3eeab4d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2878,7 +2878,8 @@ STATIC int
>  xlog_valid_rec_header(
>  	struct xlog		*log,
>  	struct xlog_rec_header	*rhead,
> -	xfs_daddr_t		blkno)
> +	xfs_daddr_t		blkno,
> +	int			bufsize)
>  {
>  	int			hlen;
>  
> @@ -2894,10 +2895,14 @@ xlog_valid_rec_header(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/* LR body must have data or it wouldn't have been written */
> +	/*
> +	 * LR body must have data (or it wouldn't have been written)
> +	 * and h_len must not be greater than LR buffer size.
> +	 */
>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
> +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
>  		return -EFSCORRUPTED;
> +
>  	if (XFS_IS_CORRUPT(log->l_mp,
>  			   blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
> @@ -2958,9 +2963,6 @@ xlog_do_recovery_pass(
>  			goto bread_err1;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, tail_blk);
> -		if (error)
> -			goto bread_err1;
>  
>  		/*
>  		 * xfsprogs has a bug where record length is based on lsunit but
> @@ -2975,21 +2977,18 @@ xlog_do_recovery_pass(
>  		 */
>  		h_size = be32_to_cpu(rhead->h_size);
>  		h_len = be32_to_cpu(rhead->h_len);
> -		if (h_len > h_size) {
> -			if (h_len <= log->l_mp->m_logbsize &&
> -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> -				xfs_warn(log->l_mp,
> +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> +		    rhead->h_num_logops == cpu_to_be32(1)) {
> +			xfs_warn(log->l_mp,
>  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> -					 h_size, log->l_mp->m_logbsize);
> -				h_size = log->l_mp->m_logbsize;
> -			} else {
> -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> -						log->l_mp);
> -				error = -EFSCORRUPTED;
> -				goto bread_err1;
> -			}
> +				 h_size, log->l_mp->m_logbsize);
> +			h_size = log->l_mp->m_logbsize;
>  		}
>  
> +		error = xlog_valid_rec_header(log, rhead, tail_blk, h_size);
> +		if (error)
> +			goto bread_err1;
> +
>  		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
>  		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
>  			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> @@ -3070,7 +3069,7 @@ xlog_do_recovery_pass(
>  			}
>  			rhead = (xlog_rec_header_t *)offset;
>  			error = xlog_valid_rec_header(log, rhead,
> -						split_hblks ? blk_no : 0);
> +					split_hblks ? blk_no : 0, h_size);
>  			if (error)
>  				goto bread_err2;
>  
> @@ -3151,7 +3150,7 @@ xlog_do_recovery_pass(
>  			goto bread_err2;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, blk_no);
> +		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
>  		if (error)
>  			goto bread_err2;
>  
> -- 
> 2.18.1
> 

