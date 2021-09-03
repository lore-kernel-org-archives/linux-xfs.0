Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23E1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 03:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D09961057
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 03:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhICDjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 23:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhICDju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 23:39:50 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0008CC061575;
        Thu,  2 Sep 2021 20:38:50 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id i13so3978296ilm.4;
        Thu, 02 Sep 2021 20:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdzoUAonJYu9U4cw8l4yW3yrTM/Nw8zEEc4MWMdvEk8=;
        b=HEqB4iCkleJm7uMY0KtOlkdBdCwmMf+wJWc6Dic8XXpbNmiAJj8528nAx3FIk+oXDV
         q/E2vSPTcjxbP3SuIskaVGfO9DDpnVmwWaNwIxU0QcrbvyV6DAK1/5bdj0VPEFWvOfa3
         GOXg+P0cQwp+JFb3cxWPpfB91s1gPFvpF0NoI02HGitDrpkQ2jZk9lfEtm9jwotL+Y/V
         JIlRJrnzbN9xWffOx0QhT4G+4MC7vTxwPtMhxtCHyP9cHZuRaioq1JelN7UbdbMHQYnr
         Y9x4p8F7q8vDuH/PBUuIUV3bVKCUKVnXhgr5x+1QQg3FVLUmmv+OeDxKb0f8V/dKwSep
         y78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdzoUAonJYu9U4cw8l4yW3yrTM/Nw8zEEc4MWMdvEk8=;
        b=FzYS1+d9zlX4GjwLwjyuB4S5yDNDtEJiym2dpMlU2POaLEzRhXDieZb//jAkSWuzkg
         VbtDKH/u7COgzVCmyDEQXSjPD0NAPlcC6tojYJXdQbtb14m4dOEk96mhmMAjGlhFG23K
         RKLkpCuyCwu39z1PRbnnfcn0OLVRAlp3I3P6hjfsALlOEE7LR2o55BZB+ZxTvhdg3Pu7
         ZWfOPt1ClyAFR9/KRPPlHESlTG5qM9z/SAi9+uq3NekFLEw3OiZzALM/k6Su+sW4KdF+
         6sVxsqmhxeMB+/XeXMf1bwC84ClTcYQs5d2xitNqGgw51BcA143E/u0ntvUXGuNWLF5V
         NGsg==
X-Gm-Message-State: AOAM530rgz0Q8qeyycWWb6JCkWuByFp1c9KUyFITvzM56OztNorIZZNB
        byOpto5o47HOoRu2PZeUBp6LkI7wbF3SSLlTNjaBEQJXjho=
X-Google-Smtp-Source: ABdhPJxcYTh2WiYUY1kujVKPbe1PdQk7iCNavCC5U7StINntIicX9oa6Mbc3wgzrrrCLVXgw6L2tNozvNOtcQWCq2fc=
X-Received: by 2002:a05:6e02:788:: with SMTP id q8mr1031402ils.137.1630640330439;
 Thu, 02 Sep 2021 20:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <163062674313.1579659.11141504872576317846.stgit@magnolia> <163062677608.1579659.1360826362143203767.stgit@magnolia>
In-Reply-To: <163062677608.1579659.1360826362143203767.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Sep 2021 06:38:38 +0300
Message-ID: <CAOQ4uxit3G=0o3nXVFvW740v6Xi-pSn5uHsgKdOvH4ybc+3jKw@mail.gmail.com>
Subject: Re: [PATCH 6/8] tools: make sure that test groups are described in
 the documentation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/include/buildgrouplist b/include/buildgrouplist
> index d898efa3..489de965 100644
> --- a/include/buildgrouplist
> +++ b/include/buildgrouplist
> @@ -6,3 +6,4 @@
>  group.list:
>         @echo " [GROUP] $$PWD/$@"
>         $(Q)$(TOPDIR)/tools/mkgroupfile $@
> +       $(Q)$(TOPDIR)/tools/check-groups $(TOPDIR)/doc/group-names.txt $@

I would like to argue against checking groups post mkgroupfile
and for checking groups during mkgroupfile

> diff --git a/tools/check-groups b/tools/check-groups
> new file mode 100755
> index 00000000..0d193615
> --- /dev/null
> +++ b/tools/check-groups
> @@ -0,0 +1,35 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# Make sure that all groups listed in a group.list file are mentioned in the
> +# group description file.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +       echo "Usage: $0 path_to_group_names [group.list files...]"
> +       exit 1
> +fi
> +
> +groups_doc_file="$1"
> +shift
> +
> +get_group_list() {
> +       for file in "$@"; do
> +               while read testname groups; do
> +                       test -z "${testname}" && continue
> +                       test "${testname:0:1}" = "#" && continue
> +
> +                       echo "${groups}" | tr ' ' '\n'
> +               done < "${file}"
> +       done | sort | uniq
> +}
> +
> +ret=0
> +while read group; do
> +       if ! grep -q "^${group}[[:space:]]" "${groups_doc_file}"; then
> +               echo "${group}: group not mentioned in documentation." 1>&2

This message would have been more informative with the offending
test file.

Now after you crunched all the test files into group.list files and
all the group.list files into a unique group set, this is too late.
But this same check during generate_groupfile() would have
been trivial and would allow reporting the offending test.

While we are on the subject of generate_groupfile(), can you please
explain the rationale behind the method of extracting the test file
groups by executing the test with GENERATE_GROUPS=yes?
As opposed to just getting the list of groups on the stop from the file
using grep?

Thanks,
Amir.
