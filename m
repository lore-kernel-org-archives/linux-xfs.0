Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E82C636CC
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Feb 2023 08:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjBKIdr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Feb 2023 03:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKIdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Feb 2023 03:33:46 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE642EC41
        for <linux-xfs@vger.kernel.org>; Sat, 11 Feb 2023 00:33:44 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id x8so8100654vso.2
        for <linux-xfs@vger.kernel.org>; Sat, 11 Feb 2023 00:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676104424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vjAjqBnr5IOMCawSVpFZ3ZojUDyVjWBPSNMSuH1xnHY=;
        b=B3IkCwzuBSXd9WQqWKV2/cA6+kJZ12pu3qQjntgzZ1Uo95KXUO0Ds2tevx3hKnUpzz
         m0d0pC3LrMXo6btxlibemZOZPe4APMyfX9CPc/aOb2CvUQaIib9eIK1qNHTCRA12jYJX
         hJhfhs41TFGa1pN2VRPoLoNrBZFjucT/T/Ou+I9Hp80SrhGYb3Be/+/xo/YOtQpRA2SJ
         nXPImKjlp9E66F3M84SBBDcc65xCWx7kek9K7XXeSubT0WHDQXJNGK12RunrJqrjwh0o
         9x5LSg7Y8dACNDh5NpM2A716TxqLMB4POZmUm52V30vUYaJ31osAMN7Oz0pHA6xYNqci
         JHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676104424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vjAjqBnr5IOMCawSVpFZ3ZojUDyVjWBPSNMSuH1xnHY=;
        b=L1dtJMXnpO1Ak7Hi2gF+10IGEKYCROL9up803Bdh13VCswYgh0XhcMKZH3P6qnT7xq
         +LmQ92hRKToVOutr/iCMsLlfvSsU1IOjqKizcWQNLOdHRXdlxSPYUtxeSXcThHYLorgY
         nce5HprmrXvgf9Ga8foCApnQ1GVBtWOHSS/u41BvA1/PIUjlg9f5uV9ZiKSuwb2wC/VD
         0bVX4bKuiqMMk8cyVi70p43gSnPOBzrnw2Uu8EZpzeZ/XzsbItxgqaJW5hxqrAlggCze
         hJ04iR2IhEiDNzAxXdaHw2MyJiWgkmmuTxcJBUyU7EyAnf24x5y2MZs5oHS6EwvjQ8/f
         U26w==
X-Gm-Message-State: AO0yUKXe1HlUHIxaKVg4m01liMctnC7Kkxj3YrfaZN9Rn7UY8nDYqWdD
        ZWBx/rTwjEu9k2ksFI+CxzZ9SpzjJ93OEICTRN81vuoon7U=
X-Google-Smtp-Source: AK7set8ruG3GmbBq0OWJUHnY232rxaD9PjIXl6uFvWR5DGNly9IWAOBXUcTJ573Sji1mJtbpfXr8qvTJP2vb5GB3QEQ=
X-Received: by 2002:a67:b84a:0:b0:3f1:196c:5ca8 with SMTP id
 o10-20020a67b84a000000b003f1196c5ca8mr3272523vsh.56.1676104423780; Sat, 11
 Feb 2023 00:33:43 -0800 (PST)
MIME-Version: 1.0
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
 <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
 <Y+P6y81Wmf4L66LC@magnolia> <Y+agJxHM3zPR8Qd3@google.com>
In-Reply-To: <Y+agJxHM3zPR8Qd3@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 11 Feb 2023 10:33:32 +0200
Message-ID: <CAOQ4uxjd6ZxZiomehLfzFczyMVJzkXdzDZBf2GhvoCV9O9ZhNQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 10, 2023 at 9:51 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
[...]
> > > I did not push on that until now because SGID test expectations were
> > > a moving target, but since xfstests commit 81e6f628 ("generic: update
> > > setgid tests") in this week's xfstests release, I think that tests should be
> > > stable and we can finally start backporting all relevant SGID fixes to
> > > align the SGID behavior of LTS kernels with that of upstream.
>
> Ooo goody, ok, will do this next.
>
> The following patches are on my radar to look into for this set. I have
> yet to look into dependencies, so the set may grow. If the sgid tests
> still fail after these ptaches, I will continue hunting for more fixes
> to include in this set.
>
>   e014f37db1a2 xfs: use setattr_copy to set vfs inode attributes
>   472c6e46f589 xfs: remove XFS_PREALLOC_SYNC
>   fbe7e5200365 xfs: fallocate() should call file_modified()
>   0b02c8c0d75a xfs: set prealloc flag in xfs_alloc_file_space()
>   2b3416ceff5e fs: add mode_strip_sgid() helper
>   1639a49ccdce fs: move S_ISGID stripping into the vfs_*() helpers
>   ed5a7047d201 attr: use consistent sgid stripping checks
>   8d84e39d76bd fs: use consistent setgid checks in is_sxid()
>
> In addition to the normal regression testing, I will specifically look
> at the following tests for the sgid changes:
>
>   generic/673
>   generic/68[3-7]
>   generic/69[6-7]
>
> I will also do some extra runs on the entire perms group.
>
> Let me know if you think something should be dropped or added.
>

I reckon you will need those dependency prep commits from
Christian's PR [1]:

11c2a8700cdc attr: add in_group_or_capable()
e243e3f94c80 fs: move should_remove_suid()
72ae017c5451 attr: add setattr_should_drop_sgid()

FYI, the ovl commits from this PR are independent fixes that were
already applied to 5.15.y.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20221212112053.99208-1-brauner@kernel.org/
