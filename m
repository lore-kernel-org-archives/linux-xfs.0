Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63147ECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46CCF2086A
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfJORHN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:07:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbfJORHN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:07:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 641C218C4282;
        Tue, 15 Oct 2019 17:07:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BCF110027A9;
        Tue, 15 Oct 2019 17:07:12 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:07:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: move the locking from xlog_state_finish_copy to
 the callers
Message-ID: <20191015170711.GE36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-4-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Tue, 15 Oct 2019 17:07:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:43PM +0200, Christoph Hellwig wrote:
> This will allow optimizing various locking cycles in the following
> patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4f5927ddfa40..860a555772fe 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1967,7 +1967,6 @@ xlog_dealloc_log(
>  /*
>   * Update counters atomically now that memcpy is done.
>   */
> -/* ARGSUSED */
>  static inline void
>  xlog_state_finish_copy(
>  	struct xlog		*log,
> @@ -1975,16 +1974,11 @@ xlog_state_finish_copy(
>  	int			record_cnt,
>  	int			copy_bytes)
>  {
> -	spin_lock(&log->l_icloglock);
> +	lockdep_assert_held(&log->l_icloglock);
>  
>  	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
>  	iclog->ic_offset += copy_bytes;
> -
> -	spin_unlock(&log->l_icloglock);
> -}	/* xlog_state_finish_copy */
> -
> -
> -
> +}
>  
>  /*
>   * print out info relating to regions written which consume
> @@ -2266,7 +2260,9 @@ xlog_write_copy_finish(
>  		 * This iclog has already been marked WANT_SYNC by
>  		 * xlog_state_get_iclog_space.
>  		 */
> +		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> +		spin_unlock(&log->l_icloglock);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  		return xlog_state_release_iclog(log, iclog);
> @@ -2277,11 +2273,11 @@ xlog_write_copy_finish(
>  
>  	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
>  		/* no more space in this iclog - push it. */
> +		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  
> -		spin_lock(&log->l_icloglock);
>  		xlog_state_want_sync(log, iclog);
>  		spin_unlock(&log->l_icloglock);
>  
> @@ -2504,7 +2500,9 @@ xlog_write(
>  
>  	ASSERT(len == 0);
>  
> +	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	spin_unlock(&log->l_icloglock);
>  	if (!commit_iclog)
>  		return xlog_state_release_iclog(log, iclog);
>  
> -- 
> 2.20.1
> 
