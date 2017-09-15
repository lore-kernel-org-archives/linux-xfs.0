Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:44130 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdIOJnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 05:43:06 -0400
Received: by mail-wr0-f171.google.com with SMTP id v109so1365752wrc.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2017 02:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 15 Sep 2017 11:42:44 +0200
Message-ID: <CACj3i73fYBdBNJPn+VNR90ERW+sdMUmNbEGt-Q9Q6z95=hi0qQ@mail.gmail.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 30, 2017 at 1:50 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> Future work will be to split the xfs_mkfs.c file into a file per
> module (i.e. seperate files for CLI parsing, mkfs formating,
> validation+calculation and, finally, one for config file support),
> but otherwise the majority of the factoring work is now complete.
>
> Comments, flames, etc all welcome.
>

In my review, I didn't saw any issues. It works, it certainly looks
way better than what I was trying to do, and I didn't notice any
regression, although my testing was not as thorough as Chandan's. It
seems that everybody likes these changes, so is there anything that
prevents it to be merged once xfstests are updated as well?

And thinking about the future, I wonder if there is any point in
making the suboption tables into one hierarchical like I wanted
before. The main reason for my attempt was to allow cross-option
conflicts and the mentioned changes also added conditional conflicts.
But now with validate_sb_features() containing almost all these
conflicts, I'm not sure if it would help or if it would rather make it
more complex and obscure.

Cheers,
Jan
