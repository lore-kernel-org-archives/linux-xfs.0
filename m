Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB8EC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9276F61104
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhDBH77 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbhDBH76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:59:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192D9C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:59:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v10so3155195pfn.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 00:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=GTuEZ6sohiWbkTzVKIacKyOSd8aC34F3MHMklGcid7Q=;
        b=Nv7YzL5o1dOzBQF97PZFkHZmrzWHsn9n1Okzrn7WfbsyWuBpFvJUdeVUow2+CPK3Ck
         M5aKzgBTWsgTOqDU9z1phhCLqIx3sd+pTaZjMz260frUG2NLMkbAJX6cLvpZpCOPDgaX
         KwZPZ0gP51zlWqeXEtASn5k1RAj0bJ02AqL4oPcTknGFqN5yAgvG+4G43NZjWwGZ7qcu
         9WlW7q8jZS3m0DCfBvfUmGjgBDK1tzgXLxe/fUC6Bw2PKjKT0AafZzpfGYvb6PRvN6vr
         p8TkY4ZuH3n2TcHcsIGyM7ZULbh616+vfUHF31ekLHMNd61n4BHThC/QNLy6CNl/pDJl
         +Aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=GTuEZ6sohiWbkTzVKIacKyOSd8aC34F3MHMklGcid7Q=;
        b=FUhML9Ji+C/9RZbDZpzyIfPzSZMYrm0DYG3Kibo/QVr0QvJxCQIVFL5AsV0aBWL0aY
         09ZlUW6+tEfndU4vjyPrmzOfaoJkclvkwYjKrDCZjFgV+RcLmx73FSa4ECRmygFNB/HU
         qoeikMcLzohmU3+gEfJq+uuCh65llTOfPsEYiMfj31D6dgPcAkhTtopKsl1/NcjYrhvV
         eDzZsmarIpvmoYXwe3e385Uv8klbXlmDQcCJEpYullQslPRH0FttKyn62eiN4lxnQXRZ
         MmBSaSs9GzarTd8D/pTD9+MkED7DNZETACLlGEvsbnqDOYLxku9rfV8UCI51OlwH2PSU
         reAA==
X-Gm-Message-State: AOAM532QxSL6ZZxocvaDAjyAENPlXd2VH80xrBmgTMuAJ8IJoeACrq9+
        VYow5NW3DBoPKCQg+y7SOw3Ow+YwDsI=
X-Google-Smtp-Source: ABdhPJxik/UdnbLuPx7/2vHAn76UBbGfb9lB5r96fC7GuyjwvTLtZ5XyOfsYPpMYYRg6jQrEqCth2g==
X-Received: by 2002:a63:fc59:: with SMTP id r25mr10857607pgk.305.1617350397356;
        Fri, 02 Apr 2021 00:59:57 -0700 (PDT)
Received: from garuda ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id l10sm6842534pfc.125.2021.04.02.00.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Apr 2021 00:59:57 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-11-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 10/11] xfs: Add delay ready attr remove routines
In-reply-to: <20210326003308.32753-11-allison.henderson@oracle.com>
Date:   Fri, 02 Apr 2021 13:29:54 +0530
Message-ID: <87o8ex6rr9.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args is merged with
> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> This new version uses a sort of state machine like switch to keep track
> of where it was when EAGAIN was returned. A new version of
> xfs_attr_remove_args consists of a simple loop to refresh the
> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> flag is used to finish the transaction where ever the existing code used
> to.
>
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> version __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
>
> xfs_attr_rmtval_remove itself is still in use by the set routines (used
> during a rename).  For reasons of preserving existing function, we
> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> used and will be removed.
>
> This patch also adds a new struct xfs_delattr_context, which we will use
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.  See xfs_attr.h for a more
> detailed diagram of the states.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 206 +++++++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h        | 125 ++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-

[...]

>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	**state)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		**state = &dac->da_state;
> +	int				error;
>
>  	error = xfs_attr_node_hasname(args, state);
>  	if (error != -EEXIST)
>  		return error;
> +	error = 0;
>
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> @@ -1204,10 +1233,13 @@ int xfs_attr_node_removename_setup(
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_leaf_mark_incomplete(args, *state);
>  		if (error)
> -			return error;
> +			goto out;
>
> -		return xfs_attr_rmtval_invalidate(args);
> +		error = xfs_attr_rmtval_invalidate(args);
>  	}
> +out:
> +	if (error)
> +		xfs_da_state_free(*state);
>
>  	return 0;

If the call to xfs_attr_rmtval_invalidate() returned a non-zero value, the
above change would cause xfs_attr_node_removename_setup() to incorrectly
return success.

>  }
> @@ -1232,70 +1264,114 @@ xfs_attr_node_remove_cleanup(
>  }
>

--
chandan
