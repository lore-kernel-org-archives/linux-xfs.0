Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABFCC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 05:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E06E61090
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 05:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhDSFQN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 01:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhDSFQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 01:16:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013C2C06174A
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 22:15:44 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c3so3588166pfo.3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 22:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ZD23xcE74qdyqHoJuyjfhlN00TcEglL9s1WTVfK38ww=;
        b=ZtlGYNHRoxASd4JIF4f6LslVVdbLhepXiKxSm41uVK5rfRLP6uAGoCn5PgMv0FB5L9
         rHEyIiUVHbMMOMPtyGiV1fnO04sM2bfWTZJsgeBgjrfWOPPR4aJa/JjwH9pz69KE/723
         jVncWJjVRChP+Ejti5ZpJASV/Hn5/M17QrzG1opm/N+uaWDDngvdFenVHaH6JqWlqQDA
         ZXO9Js/zVXgyFegkooi6zUCLoKdEeVvSNTMniRyBwJL3x+j+8GjN8ou2G0MOuWZ6BAUJ
         DvePX1mpFGM2z7CuBBVZjrnHYPuBa9vKInOGWUNSxfmGOft6N8xvY7YjNQ2iPHpxCmUs
         7qjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ZD23xcE74qdyqHoJuyjfhlN00TcEglL9s1WTVfK38ww=;
        b=kUTPGKlJAAlYLbp6DUcxwLaAVC1EI3eXOfcr2D1cYvn0lFyVVC4yWGb/fWbgXmA4RU
         Gu3/+7Qtz2rjXZ69jBCWrTGa9tPf47/i3fde3jWkj2LcVHaDPF3Qhobs49Nesz5S8lRb
         r/q935WHckXHumAbFTgSw85sKoXonlUVWgp/bQ3NYyaOai73EKYFwN+sP1Hm92GjMErn
         JfvhnLdAPGobPZsUOm69tyK8UdE1CucucrHG3bFgT8LFT8n2iHczw5dX0NM+VrYG+HFa
         ulFdFj+J+hBxomkS9X4M4G9x1x+l40vx/SUisduDssGBN/kLsTF+AXGAqe4eT01bIkHz
         BdVA==
X-Gm-Message-State: AOAM530RhA1ydHNfmhkPbTQ2N2WSTwUgcKq9P9AiP47uPvKcHP36ajml
        WgRNtcLa1ufbGxZYbDXRVq0EH3lJyYw=
X-Google-Smtp-Source: ABdhPJxfuvf5S19aYcJq0V9/tExNNOEl97b+aJBi5cyoNr+JEjqioxPuAlBY8IhCAbJlfu2Fh2zJrg==
X-Received: by 2002:a63:4281:: with SMTP id p123mr10134196pga.420.1618809343259;
        Sun, 18 Apr 2021 22:15:43 -0700 (PDT)
Received: from garuda ([122.179.111.183])
        by smtp.gmail.com with ESMTPSA id j3sm10507190pfc.49.2021.04.18.22.15.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 18 Apr 2021 22:15:42 -0700 (PDT)
References: <20210416092045.2215-1-allison.henderson@oracle.com> <20210416092045.2215-6-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
In-reply-to: <20210416092045.2215-6-allison.henderson@oracle.com>
Date:   Mon, 19 Apr 2021 10:45:40 +0530
Message-ID: <87o8eaj1mr.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Apr 2021 at 14:50, Allison Henderson wrote:
> This patch separate xfs_attr_node_addname into two functions.  This will
> help to make it easier to hoist parts of xfs_attr_node_addname that need
> state management
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fff1c6f..d9dfc8d2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> @@ -1062,6 +1063,25 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>
> +	error = xfs_attr_node_addname_clear_incomplete(args);
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +	return retval;

I think the above code incorrectly returns -ENOSPC when the user is performing
an xattr rename operation and the call to xfs_attr3_leaf_add() resulted in
returning -ENOSPC,
1. xfs_attr3_leaf_add() returns -ENOSPC.
2. xfs_da3_split() allocates a new leaf and inserts the new xattr into it.
3. If the user was performing a rename operation (i.e. XFS_DA_OP_RENAME is
   set), we flip the "incomplete" flag.
4. Remove the old xattr's remote blocks (if any).
5. Remove old xattr's name.
6. If "error" has zero as its value, we return the value of "retval". At this
   point in execution, "retval" would have -ENOSPC as its value.

--
chandan
