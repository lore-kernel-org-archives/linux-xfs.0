Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21FFC43334
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jun 2022 08:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiFDIit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Jun 2022 04:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiFDIis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Jun 2022 04:38:48 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640E212AD6
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 01:38:47 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id v1so7278281qtx.5
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jun 2022 01:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1LihM+Ed0lXj6/oBu9fnclUnOG/bYBirQLVSGmYcHM=;
        b=kLp48wa8pUqvWH6iY7rmQU/7XQIVkvKcM2RSKqzOLZOqABq0vVBADGrGCJOrVAcrX6
         yKeHP2ksmpLo3OWRsro+P4F9Kdc6GFwdGnAgTZVUj+NgYDZ2m65z7LRpT6sEL7kfJIuD
         2TQWPPPCw/HWYllAfrATZwAmZOPYQjPH3VqohNV7GgsmGSiM8/Q57TKDAA3IzBEMJyEq
         qEeYb+AWCj+Jypeo84onQkvnAje8Y8n+NYH+gClw4a6qVhpRp5CdYZnukgpMAWd+0eI0
         +XH/oxScUzL2Dbo6sLHWJLjOSpNs5PKXZq8ZOgWTPPgnFDhjsBXuGzn8ma8jjhuZrXLc
         eOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1LihM+Ed0lXj6/oBu9fnclUnOG/bYBirQLVSGmYcHM=;
        b=0TmUNOP9jVJKXjKV3F4NjSESC/F6/5THvyA/wLOcRgBV/h9+QJbuNyMHyw3HbtjY9P
         70okdPmixhnE0iWUkFZfJ030mEpLeegVuAwErwdBVF7uVXDQ99340P+RSzSttFg4YoXW
         LvQOZhWv1xRkZ5DVbN73jvrwd3vnoQrPJVtgOagh9rweYm6sjSctXOA+xRbIolpYzco3
         coMp02kUSxMKwTaeo1V8Aj/EtDNEbQkEhUMuOYUC6HjPm7OmqjejHlFVaZiv1bIZ78a5
         26Ud7EbQrCky1hYRv6j2MRQW/4DZ1F/9q/gW98iSsoUle32q77os4uJAffMFMnPSruFy
         HE7A==
X-Gm-Message-State: AOAM531RPUCT7VaQ5BV+PhUbuvkGgQpF7sQY10jHwGgl9Yz0GBrdbGJw
        qxnry7aW8ZWcU/SaiVR/5axAmXN19iZNkjQmY+M=
X-Google-Smtp-Source: ABdhPJzBFlqG1ZHRsUyvIOCc+qfD8ue/FM4iLIYHKc3d2M71Ej7IFsB3cS2VMEdtkkI5K7TLFx8YNxfMWVb6HO7Mgp4=
X-Received: by 2002:ac8:4e52:0:b0:304:86c8:7b26 with SMTP id
 e18-20020ac84e52000000b0030486c87b26mr10916337qtw.684.1654331926479; Sat, 04
 Jun 2022 01:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
In-Reply-To: <20220603184701.3117780-1-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 4 Jun 2022 11:38:35 +0300
Message-ID: <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <lrumancik@google.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> From: Leah Rumancik <lrumancik@google.com>
>
> This first round of patches aims to take care of the easy cases - patches
> with the Fixes tag that apply cleanly. I have ~30 more patches identified
> which will be tested next, thanks everyone for the various suggestions
> for tracking down more bug fixes. No regressions were seen during
> testing when running fstests 3 times per config with the following configs:

Hi Leah!

I'll let the xfs developers comment on the individual patches.
General comments about stable process and collaboration.

Some of the patches in this series are relevant to 5.10 and even apply
cleanly to 5.10 (see below).
They are in my queue but I did not get to test them thoroughly yet,
because I am working chronologically.

To avoid misunderstanding with stable maintainers, when you post to
stable, please make sure to state clearly in the cover letter that those
patches have only been tested on 5.15.y and should only be applied
to 5.15.y.
I know you have 5.15 in subject, but I would rather be safe than sorry.

Luis has advised me to post up to 10 patches in each round.
The rationale is that after we test and patches are applied to stable
regressions may be detected and reported by downstream users.

Regressions will be easier to bisect if there are less fixes in every
LTS release. For this reason, I am holding on to my part 2 patches
until 5.10.120 is released. LTS releases are usually on weekly basis
so the delay is not much.

I don't think that this series is terribly big, so I am fine with you
posting it at one go, but please consider splitting it pre 5.16
and post 5.16 or any other way that you see fit when you post
to stable, but let's wait for xfs developers review - if they tell you to
drop a few patches my comment will become moot ;-)

[...]

For the record:

> Brian Foster (1):
>   xfs: punch out data fork delalloc blocks on COW writeback failure
In my queue

>
> Darrick J. Wong (7):
>   xfs: remove all COW fork extents when remounting readonly
>   xfs: only run COW extent recovery when there are no live extents
Only first one is in my queue - needed backporting

>   xfs: prevent UAF in xfs_log_item_in_current_chkpt
In my queue

>   xfs: only bother with sync_filesystem during readonly remount
In my queue

>   xfs: use setattr_copy to set vfs inode attributes
In my queue - needed backporting

>   xfs: don't include bnobt blocks when reserving free block pool
>
> Dave Chinner (4):
>   xfs: check sb_meta_uuid for dabuf buffer recovery
In my queue

>
> Rustam Kovhaev (1):
>   xfs: use kmem_cache_free() for kmem_cache objects
In my queue

>
> Yang Xu (1):
>   xfs: Fix the free logic of state in xfs_attr_node_hasname
In my queue - needed backporting

Thanks,
Amir.
