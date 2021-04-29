Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95180C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9156145B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhD2HyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhD2HyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 03:54:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3556DC06138B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:53:18 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 10so2990504pfl.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=xQhZLzsnoApo3FK0REI6SwHP5uWoZkJFu2Z6k7dzgSQ=;
        b=kYGiZ05CAiQTvey5wZtfXmwbet4E6p8v6mjN7B7LhNBF3hUG8GW19WaMsXUmGf1gNL
         k3ZMg7TiSFnrQtwov1VPEHXo29fvTZECRKP6nukTV2rQ9uMvl5purn+LKthRXeXOfe6z
         Lbg+6mIsis1G/uy9BfVDOshVH0PBoDlGAP4LZO8qlbo+l1Pcx6Cv37tfofw6seONLGGw
         0705B65QiSD0Y8lTRyegXQdH+PTzw1+l/tme9Epo8QUhvRkUFGUN9zeJvjVTY3YEWm6h
         BPvq3c4PgN2q0SAptxvJ8qC6TIlBTbD86RS5ju3fN0sJ9+VdTVE5Tvo3HSsIth6RRbr1
         gBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=xQhZLzsnoApo3FK0REI6SwHP5uWoZkJFu2Z6k7dzgSQ=;
        b=joZ9VGjaf0dlQ69zSTQ7fLGUrSHetL7Lgp78l2UjvmKKBFvu774oYuJtnm4Ott5VA8
         y0oz5yc4Zhj2it9DQyecCyCzoN7blj3QOO5kkXvK4WhDwbwj+IeHWFREMcTYxZW8dC09
         C8foPk+tctAq9nylLax0zzfR8m0QI4xZrlKYUMWUyYUMXrJHcr7oKEXGl9XpzUHZx3sc
         XBg+XMoKNjvUuNGXLd1pjgfFoCuT6K81y7Q/zWeN/EazFZs91h16KNljTh00gcM90+xr
         hArxwiwqieTnYr8hAwdll6Lp1T+DK3Q4iAlVCtF6ILsP+cLwivkx85meYC+fxbUwdHhh
         59HQ==
X-Gm-Message-State: AOAM53261XQtmDwc2tKnJvlQOrT08VA+Sq6Dw1zq4irIhUnUfRL2WaEZ
        qM4CgVSrs2zrZLF6wHphiWZkLE/3Lxg=
X-Google-Smtp-Source: ABdhPJxhl8XXT/ibdg4bDkb++7SYRIzIjLkZseBws5LkoeukuR+IykMPg5SI3PC29yhjwGJ8WiJHHQ==
X-Received: by 2002:a63:e044:: with SMTP id n4mr31132011pgj.47.1619682797733;
        Thu, 29 Apr 2021 00:53:17 -0700 (PDT)
Received: from garuda ([122.179.68.135])
        by smtp.gmail.com with ESMTPSA id i10sm6776881pjj.16.2021.04.29.00.53.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Apr 2021 00:53:17 -0700 (PDT)
References: <20210428080919.20331-1-allison.henderson@oracle.com> <20210428080919.20331-11-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v18 10/11] xfs: Add delay ready attr remove routines
In-reply-to: <20210428080919.20331-11-allison.henderson@oracle.com>
Date:   Thu, 29 Apr 2021 13:23:15 +0530
Message-ID: <87fsz9a5n8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Apr 2021 at 13:39, Allison Henderson wrote:
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

Sorry, My previous response to this patch was incorrectly formatted. Fixing it
now.

The error handling issues pointed out in the previous version of the this
patch have been fixed.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

--
chandan
