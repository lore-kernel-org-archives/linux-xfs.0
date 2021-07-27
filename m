Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45499C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 04:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255506109D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 04:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbhG0Epd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 00:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhG0Epc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 00:45:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500E0C061757;
        Mon, 26 Jul 2021 21:45:32 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l19so16162925pjz.0;
        Mon, 26 Jul 2021 21:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=MvHn3DsxO6LcgsiELBLzk58v37eYJc5mw2066XWhaL8=;
        b=Ge6b72aHP8zcJyQ2iKjI+dCp8iSLqVgBnq6yfNLdrxaYKIm+9lU07N+HEdwpAyj2kv
         fILzXGvDaun+sT6yV3nGt9vaf+Zbi6RUlck4g4e109+X2zmPKdkK2K7P3kaDDBJEI7d4
         zSDNpyv7akf/RxqHCb0LVEoyqObsg4fsllGz9j0fHtYYE7/0mrf0JBohZEd26Smo+6OX
         E9nDiK/tGFQxHdB4Mqi27447SGNdqbXPyjpEYkPteWiccEvsgkt+CV18yDsmaJnu8WMo
         0l6tjHpCPN9XGbiUaYug7RTLZW7JqkQGY1BygjhxgEhZCGuIMGyjwJMW4b1W3RWexiHK
         6wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=MvHn3DsxO6LcgsiELBLzk58v37eYJc5mw2066XWhaL8=;
        b=oSXXyqeenqwXwMXOU/bzTQxkAR3Lf/4O/RMH5wplXCvUXRD6T56VZ5/rr9GB9RD9hP
         bs7VYWr2/sbHIRk8m18CEklal4hgHe0THqmOvnXQetXWDC6JUl4/2QxzDB8Db0Rrvfd0
         kzGqSGf5WO1sR1OmmHfAK8yJnpEADzQqo8O3IGC+XPMHCmQgQ5yyjvmV81ntbGy2abRJ
         0ADHElVSkNJ67Kye8W8IVEYEjeoZP/1FSywICNomtiDLStIcnR/Ea/H+9XlHv3Y2yz3D
         Z05zktUEem05UvP0xHzhEHx1gWmY3DwmTizV9+zsbE8H0G6bbnHF0Lfobd/aAXRoqrc0
         qp8w==
X-Gm-Message-State: AOAM532gMUR+Y4xUc08p+dBgnnd2pk+KqeBJzPSLoat1n59Vbo5lzlRg
        GX56uNz7R0wGmcyakeklOENDVbT/KTk=
X-Google-Smtp-Source: ABdhPJx/SkaCIQqP8z411XshysimP5vHI7MX1YIRp2aPkjiPeu2oSooOpqyC6GEJK/3htPVOqHe57w==
X-Received: by 2002:a17:90b:1645:: with SMTP id il5mr20155428pjb.113.1627361131689;
        Mon, 26 Jul 2021 21:45:31 -0700 (PDT)
Received: from garuda ([122.171.185.191])
        by smtp.gmail.com with ESMTPSA id v10sm1795617pfg.160.2021.07.26.21.45.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Jul 2021 21:45:31 -0700 (PDT)
References: <20210726064313.19153-1-chandanrlinux@gmail.com> <20210726064313.19153-3-chandanrlinux@gmail.com> <20210726171916.GV559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is enabled
In-reply-to: <20210726171916.GV559212@magnolia>
Date:   Tue, 27 Jul 2021 10:15:27 +0530
Message-ID: <87fsw0fjq0.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Jul 2021 at 22:49, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 12:13:13PM +0530, Chandan Babu R wrote:
>> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
>> 1. $mkfs_cmd
>> 2. $MKFS_OPTIONS
>> 3. $extra_mkfs_options
>>
>> The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
>> reflink or rmapbt feature. The failure occurs because the test tries to create
>> a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
>> will construct and invoke an mkfs command line without including the value of
>> $MKFS_OPTIONS.
>>
>> To prevent such silent failures, this commit causes the test to exit if it
>> detects either reflink or rmapbt feature being enabled.
>
> Er, what combinations of mkfs.xfs and MKFS_OPTIONS cause this result?
> What kind of fs configuration comes out of that?

With MKFS_OPTIONS set as shown below,

export MKFS_OPTIONS="-m reflink=1 -b size=1k"

_scratch_do_mkfs() invokes mkfs.xfs with both realtime and reflink options
enabled. Such an invocation of mkfs.xfs fails causing _scratch_do_mkfs() to
ignore the contents of $MKFS_OPTIONS while constructing and invoking mkfs.xfs
once again.

This time, the fs block size will however be set to 4k (the default block
size). At the beginning of the test we would have obtained the block size of
the filesystem as 1k and used it to compute the size of the realtime device
required to overflow realtime bitmap inode's max pseudo extent count.

Invocation of xfs_growfs (made later in the test) ends up succeeding since a
4k fs block can accommodate more bits than a 1k fs block.

>
> Eventually, the plan is to support rmap[1] and reflink[2] on the
> realtime device, at which point this will have to be torn out and a
> better solution found.
>
> --D
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink
>

--
chandan
