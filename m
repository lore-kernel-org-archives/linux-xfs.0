Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BBAC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 11:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DE06128C
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 11:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhFRLJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 07:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhFRLJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 07:09:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D13DC061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 04:07:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h1so4509152plt.1
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 04:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=zArUdYND3WVQ9Xs3/JkNnlPy4k0GnjQcb0sG8F9o6Eg=;
        b=tCv7hM+evzl5jtve67qQQLShuekTquXZiGO4UFFLFbVoGsfHxG7lOvdcCjwG5qpMAH
         jAqrT1jRo6mqeMDLwlFN7M8kx2/eaFb5NZU16UA0wx1Mjdpf8+gk05Tlwf8EJMURtHYH
         myfmb8VSj0jMkMu3q4J8yqWDCvlsXt6tBP512eJN9j5xvIIPVtqHAQg5Cim5lAB+qJ8j
         XjebWwUQoQqp0BerdlztpszFKnzxBFV5jdYXfssXNqK6+3tqFvuk4bqRcpyzGluev4hO
         oHWH/8Dg+R+00L+OSWcSrVcj7/eRhaJ9qp2TJbtBuFmqUkNUE6OTEcR3Ud+wc+LRox7g
         pW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=zArUdYND3WVQ9Xs3/JkNnlPy4k0GnjQcb0sG8F9o6Eg=;
        b=K+pcIh7fWau0nldDjelJ1kT23xOVtpNxocca4cMTenLtJRHppp4Y4sqpr0hog22zO7
         oNrBmfiie1R9KKMwI1mhErUK+dthIjLYWsr5bvS6gYwTvpd/jd9bviGYDuCHzCmqWm4u
         NtdvMGtUCVjTiHB3gx1wb7FLuq9ZdCC1R4g5U9gZ3aPJURfZTKeYb6bg2Soe1dY+XE/N
         t1nL6Am2WHNKTpr+JJHdsOZtd+ORJ8rnMNClqW6OZ8ioOMa88/Q53FdAuj8LTXsWXvbO
         1YXFnOKz9XFUBVFoxDgZFS3+Z7jZtkE748+Ne8XbA7ZBJ4yXoDQpSZt4z/NKR7pLzhPh
         WQnw==
X-Gm-Message-State: AOAM530LlOl0RaLr341BrgQ1o8J+vHq4Y1StdBBfecaGRSm8pkQ9XbqK
        vUs1YpEYl1+dQfPLILjee9m99MUOV38gHQ==
X-Google-Smtp-Source: ABdhPJxMnJDu+7nAgGl78bjVkW2b3wgok6hyPyNFKTbENg7Wkk1qUVmye8b7T2dC1z8ZYd3u7bR+BA==
X-Received: by 2002:a17:902:b095:b029:118:cfad:c536 with SMTP id p21-20020a170902b095b0290118cfadc536mr4168665plr.79.1624014434878;
        Fri, 18 Jun 2021 04:07:14 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id c62sm7937840pfa.12.2021.06.18.04.07.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Jun 2021 04:07:14 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-7-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: simplify the xlog_write_partial calling conventions
In-reply-to: <20210616163212.1480297-7-hch@lst.de>
Date:   Fri, 18 Jun 2021 16:37:11 +0530
Message-ID: <871r8ztork.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> Lift the iteration to the next log_vec into the callers, and drop
> the pointless log argument that can be trivially derived.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 38 +++++++++++++++-----------------------
>  1 file changed, 15 insertions(+), 23 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5d55d4fff63035..4afa8ff1a82076 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2232,14 +2232,11 @@ xlog_write_get_more_iclog_space(
>  /*
>   * Write log vectors into a single iclog which is smaller than the current chain
>   * length. We write until we cannot fit a full record into the remaining space
> - * and then stop. We return the log vector that is to be written that cannot
> - * wholly fit in the iclog.
> + * and then stop.
>   */
> -static struct xfs_log_vec *
> +static int
>  xlog_write_partial(
> -	struct xlog		*log,
> -	struct list_head	*lv_chain,
> -	struct xfs_log_vec	*log_vector,
> +	struct xfs_log_vec	*lv,
>  	struct xlog_ticket	*ticket,
>  	struct xlog_in_core	**iclogp,
>  	uint32_t		*log_offset,
> @@ -2248,8 +2245,7 @@ xlog_write_partial(
>  	uint32_t		*data_cnt)
>  {
>  	struct xlog_in_core	*iclog = *iclogp;
> -	struct xfs_log_vec	*lv = log_vector;
> -	struct xfs_log_iovec	*reg;
> +	struct xlog		*log = iclog->ic_log;
>  	struct xlog_op_header	*ophdr;
>  	int			index = 0;
>  	uint32_t		rlen;
> @@ -2257,9 +2253,8 @@ xlog_write_partial(
>  
>  	/* walk the logvec, copying until we run out of space in the iclog */
>  	for (index = 0; index < lv->lv_niovecs; index++) {
> -		uint32_t	reg_offset = 0;
> -
> -		reg = &lv->lv_iovecp[index];
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		uint32_t		reg_offset = 0;
>  
>  		/*
>  		 * The first region of a continuation must have a non-zero
> @@ -2278,7 +2273,7 @@ xlog_write_partial(
>  					&iclog, log_offset, *len, record_cnt,
>  					data_cnt);
>  			if (error)
> -				return ERR_PTR(error);
> +				return error;
>  		}
>  
>  		ophdr = reg->i_addr;
> @@ -2329,7 +2324,7 @@ xlog_write_partial(
>  					*len + sizeof(struct xlog_op_header),
>  					record_cnt, data_cnt);
>  			if (error)
> -				return ERR_PTR(error);
> +				return error;
>  
>  			ophdr = iclog->ic_datap + *log_offset;
>  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> @@ -2365,10 +2360,7 @@ xlog_write_partial(
>  	 * the caller so it can go back to fast path copying.
>  	 */
>  	*iclogp = iclog;
> -	lv = list_next_entry(lv, lv_list);
> -	if (list_entry_is_head(lv, lv_chain, lv_list))
> -		return NULL;
> -	return lv;
> +	return 0;
>  }
>  
>  /*
> @@ -2450,13 +2442,13 @@ xlog_write(
>  		if (!lv)
>  			break;
>  
> -		lv = xlog_write_partial(log, lv_chain, lv, ticket, &iclog,
> -					&log_offset, &len, &record_cnt,
> -					&data_cnt);
> -		if (IS_ERR_OR_NULL(lv)) {
> -			error = PTR_ERR_OR_ZERO(lv);
> +		error = xlog_write_partial(lv, ticket, &iclog, &log_offset,
> +					   &len, &record_cnt, &data_cnt);
> +		if (error)
> +			break;
> +		lv = list_next_entry(lv, lv_list);
> +		if (list_entry_is_head(lv, lv_chain, lv_list))
>  			break;
> -		}
>  	}
>  	ASSERT((len == 0 && !lv) || error);


-- 
chandan
