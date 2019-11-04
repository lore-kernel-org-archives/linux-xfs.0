Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A82CA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE8C20842
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQh8nJFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKDP3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:29:13 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40294 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDP3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:29:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id r4so12394803pfl.7;
        Mon, 04 Nov 2019 07:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tR/G1cw6My9b6LBDZY3DodOYiK7b6P71z9TI2bVO9Aw=;
        b=SQh8nJFvgCHLM9OQfUl1GG789Tu6P4ItfwgkSA5dqhWo2J+PtrCpzIRcORkBCWOhmB
         hu1kxEU3OgxkwLMGyXg71+mTKUw+Oyy5zSdO+4h+Q7eHk5zX/WKJTPlYnAhlQ1JD20kF
         re1LFFU03hRnIy4cA/cU5otC0LoGGtGSk4lTMrtKCclslqAAvVVb8xwvK0/Rzx4sIXI2
         MTlxGpN99cqvRp1M/hz9yGC1y3fOvpCc2o4pXu6Tx1JZ5xlRCbo/as20mXhA6rKyZ/3e
         2dKNwxUMNG8wyzKhTHrCCErKrjZIWnXhrwl9845bFvkmh1GTw4k3bJzzzpSGEhxvzrsh
         hqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tR/G1cw6My9b6LBDZY3DodOYiK7b6P71z9TI2bVO9Aw=;
        b=AEkjqfUkicjW21zsObr3avxZY+FnljZjSSatT9X71Lbm2Io2HkNC5pHLNG5OiklX/Z
         6Sa9ePTCDn7cog/gO53imkAqau7LQ7ZDTOgz63CU+pnadzEoAj+MAUa+wZ0qAB9/nsr4
         XGQYPC0Ej+dPLIbb61SQQvUFrGMRPVJn9rJyNm/lnSrlAWp34Juzzk145vE2anjCRwpi
         rp365WiTJsHXXUQTa9YJe96Jk9Emrxu3EGlqU1yAGfQ5juMP2GeSSp9njKSk8u3ZQn/3
         6vuSZqHrPirN7blTT3MwIZY4DYhXHzImq6iSWyEquJT5EszFkZJzrZ1X57Z0eNIRdnba
         pNjw==
X-Gm-Message-State: APjAAAW5gQRqHWWP56eqOxyzET2kbb9pFSpVnjQr+uZHG9f34aBNgoR8
        ptyvuMHUbtxdscRLsQiUtJQ=
X-Google-Smtp-Source: APXvYqy8NW0OXO6pEAde1bAc8ksKTv+SEByBxXc08jfzcuis7YOsFT0gXVbyzOOpxaulnzIQi6iYUA==
X-Received: by 2002:a65:5c0a:: with SMTP id u10mr9943472pgr.315.1572881352301;
        Mon, 04 Nov 2019 07:29:12 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id v16sm10535645pje.1.2019.11.04.07.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 07:29:11 -0800 (PST)
Date:   Mon, 4 Nov 2019 23:29:02 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: verify that xfs_growfs can operate on mounted
 device node
Message-ID: <20191104152902.GC8664@desktop>
References: <1253fd24-a0ef-26ca-6ff9-b3b7a451e78a@redhat.com>
 <20191103152446.GA8664@desktop>
 <fc635655-1feb-6a31-197b-cea9d0daf855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc635655-1feb-6a31-197b-cea9d0daf855@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 07:49:39PM -0600, Eric Sandeen wrote:
> On 11/3/19 9:24 AM, Eryu Guan wrote:
> > On Tue, Oct 29, 2019 at 12:53:48PM -0500, Eric Sandeen wrote:
> >> The ability to use a mounted device node as the primary argument
> >> to xfs_growfs will be added back in, because it was an undocumented
> >> behavior that some userspace depended on.  This test exercises that
> >> functionality.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> diff --git a/tests/xfs/148 b/tests/xfs/148
> >> new file mode 100755
> >> index 00000000..357ae01c
> >> --- /dev/null
> >> +++ b/tests/xfs/148
> >> @@ -0,0 +1,100 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 148
> >> +#
> >> +# Test to ensure xfs_growfs command accepts device nodes if & only
> >> +# if they are mounted.
> >> +# This functionality, though undocumented, worked until xfsprogs v4.12
> >> +# It was added back and documented after xfsprogs v5.2
> > 
> > I'm testing with xfsprogs from for-next branch, which is v5.3.0-rc1
> > based xfs_growfs, but I still see failures like
> > 
> >      === xfs_growfs - check device node ===
> >     +xfs_growfs: /dev/loop0 is not a mounted XFS filesystem
> >      === xfs_growfs - check device symlink ===
> >     +xfs_growfs: /mnt/test/loop_symlink.21781 is not a mounted XFS filesystem
> >      === unmount ===
> > 
> > If it's already fixed, would you please list the related commits in
> > commit log as well?
> 
> I haven't merged the fix yet.

Ah, that explains. I saw "It was added back and documented after
xfsprogs v5.2", so I expected it to be PASS when testing with v5.3-rc1.

> 
> If you like I can resend the test when it's merged.
> 

Either way is fine, as long as the fix is referenced somewhere (either
in commit log or in test description, and refer to the patch summary if
it's not merged yet).

Thanks,
Eryu
