Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB06C004C0
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Oct 2023 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjJUQrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Oct 2023 12:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjJUQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2023 12:47:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9127E0
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 09:46:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-53f6ccea1eeso2727379a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 09:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697906815; x=1698511615; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OSjTUcgTd18PHEYhijTK/4fWY0j7UY3vKA/ggDHvC6g=;
        b=dTP1n71rDU+s5s6eyJqPOKZoGZfY4RQ2vNq3HbB9Clx/2szD6ZFQUohgW+DjkXQWB8
         dfFTVK9ABw8nuX2Lz3X6mHrR5G/XCQs4D4lTXs0794SplLsfgkj+D77t2OoHPn8ccUE/
         mEgIka471CJLyB0rv+T0y2bbfblpVKj4NmHZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697906815; x=1698511615;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSjTUcgTd18PHEYhijTK/4fWY0j7UY3vKA/ggDHvC6g=;
        b=OlU3C55Z+J8LLWcpltKyfqdksvMJ/wU8LpteS1TryQvkpzrFuYQ/AwLFye8buRmtPy
         /SgE4OANRaCseCAqB9pZn459gevoi5LW6Co5kJOt6CG9COAspovGwHCvjENKJA98nCTi
         8DfqvlC70rHMfhVbM12eBJiXntN+apJsrHPnoiVL/REqKkxQMeYsRWpGUbdQV8BrYNYl
         eHSlwtpVKnU940325fmYhcaNpzdkNwbGGMGUP8tbuIbbzFTTn4Iz8uVUe9iDAjUu1Dmd
         XqD0LobD1PTnMXi2lix8V0UiRIUHEmbjTMzqFtlrw0sDFpV43sKTsal0Ce1b/ZQXowMn
         dyJQ==
X-Gm-Message-State: AOJu0YyFgM3TrsYfLyaEdvPIna4ZJF8+HJZxhyxqxtj8Lau98rnIUp7X
        jDnWAFotYaLcM0f5tXK704C+Z5QVjsqD3PFT/eIc+9rQ
X-Google-Smtp-Source: AGHT+IGNq9XSzqbaO/7E4iKpyLS0nY+p/m5RzqWpBn+1tKKYwY1l0tjsB5wOJBv2Kc5bNLBEjeB/xA==
X-Received: by 2002:a05:6402:274e:b0:53e:3b8f:8a58 with SMTP id z14-20020a056402274e00b0053e3b8f8a58mr4452344edd.11.1697906815187;
        Sat, 21 Oct 2023 09:46:55 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id dk18-20020a0564021d9200b005402c456892sm130420edb.33.2023.10.21.09.46.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Oct 2023 09:46:54 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-53e2dc8fa02so2734773a12.2
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2023 09:46:54 -0700 (PDT)
X-Received: by 2002:a50:c30a:0:b0:53d:b2c8:6783 with SMTP id
 a10-20020a50c30a000000b0053db2c86783mr3094776edb.14.1697906813973; Sat, 21
 Oct 2023 09:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
In-Reply-To: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 21 Oct 2023 09:46:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
Message-ID: <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     hch@lst.de, jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 20 Oct 2023 at 23:27, Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please pull this branch with changes for iomap for 6.6-rc7.
>
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.

.. and as usual, the branch you point to does not actually exist.

Because you *again* pointed to the wrong tree.

This time I remembered what the mistake was last time, and picked out
the right tree by hand, but *please* just fix your completely broken
scripts or workflow.

> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5

No.

It's pub/scm/fs/xfs/xfs-linux, once again.

                 Linus
