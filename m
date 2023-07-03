Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255B2EB64D9
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 01:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjGCBLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Jul 2023 21:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGCBLs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jul 2023 21:11:48 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A641F127
        for <linux-xfs@vger.kernel.org>; Sun,  2 Jul 2023 18:11:47 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b5f362f4beso3377042a34.2
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jul 2023 18:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688346706; x=1690938706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ8ve3w1RO7wyY4IHhberb2Hp7vGcFQ8dx2MR0LJbeo=;
        b=KpSbnW60ZNnHrwETl+BOz8+1R9c1cC1jRWM1j04sNWTLfgATUnNZHzoSEaOEj7ZIO6
         kU8r+Y4bGf5XW1vOrgNquBxmmWgQ24BUkNPJ7XjrWpmjYsFHxROYV6g9iU8fipuu/PHU
         4FfEISHsApoYq2Rw2/poN7tDwJ3oIf4uUtz7GCInU+Gpw+Ug5gzMJfa8RVBXMkDXiXma
         ojmbWxDw+O0LIAo2YPmEvD0sFhI4cuigLOS+3qL3zY8Y5UV1Psb86m/PtLOSMKK0V4zj
         Rqnfub6Q8BKcEtHyul4uk3PDuC8Z65J1EaVYJN4jNR2pPa+WtnnPagqrtEf1/4OXo0nC
         IQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688346706; x=1690938706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQ8ve3w1RO7wyY4IHhberb2Hp7vGcFQ8dx2MR0LJbeo=;
        b=YrIO7F7T2qLZJ5aopjwYEJ4n5Qe8aoQOgjRc6rFsRuJWrHAQRVWQXxsZV+bqtjCtxX
         jWI2MXICkoteyQSzK5CxAn9dsa+MMAJrqe9bnSTeDFX8v8o2sCzhhp7Z/ib4D/sx5Qnf
         cMczX+Hy7qntUS2bBygNs7DOTD0Xyzxv37+62CT8IyAxtw4jNm8ISzX5e1uiO59dSAbw
         /PJZfXxSWPli2NVUY58c0E0hZAv6dKsGzGR0rnWnRMgZrwEm3UcPTd5YE+gmdNe5Zk5J
         LNvWKUfrjX9oCtnIjUT5/wYuFM763JckCjjmR0pYGz98PSo54mz82ZrWI2EIsXmtaP1O
         i3og==
X-Gm-Message-State: ABy/qLazGgiukqsLMflJvUwKkjUzeWZQ4CXdo4R7CNh9GecNgnJB1+DK
        yUttrabv6D2iRxpC3VY6G6BbUg==
X-Google-Smtp-Source: APBJJlHteR6aUjFLNXUpU7/MP7fYO+GzVME2fFjqXbH1uEiEpek6rgBp+Bemx6RDMmIlKuwmK4P4YQ==
X-Received: by 2002:a05:6358:cc2f:b0:134:cb65:fbbe with SMTP id gx47-20020a056358cc2f00b00134cb65fbbemr5727724rwb.13.1688346706560;
        Sun, 02 Jul 2023 18:11:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id g24-20020a170902869800b001b531e8a000sm13981944plo.157.2023.07.02.18.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jul 2023 18:11:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qG86Q-001QUr-2T;
        Mon, 03 Jul 2023 11:11:42 +1000
Date:   Mon, 3 Jul 2023 11:11:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: AGI length should be bounds checked
Message-ID: <ZKIgTqtIb3WBoPZv@dread.disaster.area>
References: <20230702162555.GL11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230702162555.GL11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 02, 2023 at 09:25:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Similar to the recent patch strengthening the AGF agf_length
> verification, the AGI verifier does not check that the AGI length field
> is within known good bounds.  This isn't currently checked by runtime
> kernel code, yet we assume in many places that it is correct and verify
> other metadata against it.
> 
> Add length verification to the AGI verifier.  Just like the AGF length
> checking, the length of the AGI must be equal to the size of the AG
> specified in the superblock, unless it is the last AG in the filesystem.
> In that case, it must be less than or equal to sb->sb_agblocks and
> greater than XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs
> operation will allow to exist.
> 
> There's only one place in the filesystem that actually uses agi_length,
> but let's not leave it vulnerable to the same weird nonsense that
> generates syzbot bugs, eh?
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c  |   72 ++++++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_alloc.h  |    3 ++
>  fs/xfs/libxfs/xfs_ialloc.c |   24 +++++++--------
>  3 files changed, 60 insertions(+), 39 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
