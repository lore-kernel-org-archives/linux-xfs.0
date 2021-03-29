Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4BFC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 08:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F13C619B5
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 08:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhC2Ipj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhC2Iog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 04:44:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD78C061762
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 01:44:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y32so7828191pga.11
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 01:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=biUaQuNraSftTF+NJdGSy8vb1esmcyqzKzYDs2KIJik=;
        b=oaQX2OInwguJVkYsGYB4TCXKK+A6X0WMxhr47u7VdzKMQ0P3J9oItCIbDIA2YIQb1l
         R06BGK3PhoVOOiUADnq8rBE1zefTPpWp8BBWm7QjDxwgKZsE/ecymJBYhLFBQyfl3Xcg
         KecX7ql3anJ7vP+GjGtd4whbIT5rwYLmYE50g7K2NwUcrg4wyufpSHg23KMVdAAus6KH
         xDxeYtY0ukpHckatTWJZtzrzdNRZb+1OU2QBqPoUI07wnbjmF8wp3bP2CIvmAugjYxC4
         Awq+j/+HBLihTrZi4q0Vvk6aWPJBHGmly1cEJiPXd6vsBoIG8JAb9KBiCTgflOrFxQPA
         CK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=biUaQuNraSftTF+NJdGSy8vb1esmcyqzKzYDs2KIJik=;
        b=nyCXg9Rbq054IOzibLaHmUji9bgZDpHhwZdmww3zjPpqQBEPWAXLhEtMTgxEG21woY
         V0rOLTXdwgyJC9enAAbzP8E+fN9ycPGyHtIlvfBsevjHiHjHVdiFHWoxenzJv7C+bWd4
         DrQiBs+Geen9Y6QgQsLTlU/1n1Z4kltZpr/eGf2JtZEdDeYxA1YyWuwltKS8YkbsBfB6
         RHSOAeFbnx78nIaGO6e5B+FT8H2Oe/n9fl1x9aP+4ImA4DCufOcD5o6GzFPkjP7L76ci
         z8v2sNS37PfPRH3gfnCgHa5nw1irSFPV8uD1FmAhLbUb7oRK2jBfOYwElosCLw4bjlgV
         BtRg==
X-Gm-Message-State: AOAM531Z+dERWo/xpbN5mf3ITkSYxXKzfA0VD34FKGOC3dbSINyKwmtt
        u2FdXuzXWqqls6oey0xIND/kSldAGZg=
X-Google-Smtp-Source: ABdhPJxRY6rhoNGn989RHbUXs+P5quYjfR7rrRDQbhc1zDmFqHRod0P8uCFMJfKkmD1ZOdF4IAAgOw==
X-Received: by 2002:a05:6a00:8c:b029:1f4:25ee:af4 with SMTP id c12-20020a056a00008cb02901f425ee0af4mr23969420pfj.71.1617007475395;
        Mon, 29 Mar 2021 01:44:35 -0700 (PDT)
Received: from garuda ([122.171.151.73])
        by smtp.gmail.com with ESMTPSA id t18sm17307421pfq.147.2021.03.29.01.44.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 01:44:34 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-2-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 01/11] xfs: Reverse apply 72b97ea40d
In-reply-to: <20210326003308.32753-2-allison.henderson@oracle.com>
Date:   Mon, 29 Mar 2021 14:14:32 +0530
Message-ID: <87k0pqbb7z.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:02, Allison Henderson wrote:
> Originally we added this patch to help modularize the attr code in
> preparation for delayed attributes and the state machine it requires.
> However, later reviews found that this slightly alters the transaction
> handling as the helper function is ambiguous as to whether the
> transaction is diry or clean.  This may cause a dirty transaction to be
> included in the next roll, where previously it had not.  To preserve the
> existing code flow, we reverse apply this commit.

Indeed, In the mainline kernel, __xfs_attr_rmtval_remove() invokes
xfs_defer_finish() when the last remote block mapping has been removed. Also,
xfs_trans_roll_inode() is invoked before invoking xfs_attr_refillstate().

Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

--
chandan
