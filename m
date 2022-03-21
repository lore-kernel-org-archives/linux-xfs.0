Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66842C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 22:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiCUWwc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 18:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiCUWwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 18:52:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2D439F02E
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:31:37 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id pv16so32793333ejb.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEtqK72Zw9ibC1HWUR067mDWAJ0KkSMiUJjG7zRfYrM=;
        b=bZrMi3zZ+sK4zSf1J1N0bP6fctrHy3SqLkMfGmurgK8GLtDde7SkzH4KM5rKUkfF2C
         Lm4B5L2tLYBVUZ+VE+2KVhFA0ncn5ESTAw9dJrlncxi6WsFvv8+6UZDtJ4wLSJEBffm8
         lsY+B++L4364u7ESexw5gHgqQyYCWd0zWJswjjo/Am7aBPRumrFZxdk8MpUzvlvg7ZtG
         CrdmufNZP8HvUUDKV0XDk5899KRYgD2DQIh7sWrPxyq00CbB6QLa1b1QkHeEFDD1BT8y
         +8yjMMD7uGOo82KfDVOnAd7wtPBU/Dzlu11KmG9m+Y/MLFQr+o+kAhw3+DWGT3ly99kb
         Un5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEtqK72Zw9ibC1HWUR067mDWAJ0KkSMiUJjG7zRfYrM=;
        b=rT/5pWz0llFICGYFyJg/jj0AfSZ+Nxgis68rKnvwtUiJgWaIuRj+TtP5z8WGTMKXyk
         CTzb8W85c4x67Xz/Wt3dGbzGcnCeIc8z1MC39Orym+pSHPUHQuisqlwHG82+BB38VHJN
         KLDjX89X0+DkJRF8WW3TWg9pq7ueS0A9CfelaWixkz5axDwi8PgzlV8RqhKhKg9/rnw1
         1QGqepCRbEPk7LpMUcO4dmJvBnGEtkjDtSD3HJkVleseJYgZxTXzSM/RgMUvicQjqNZ1
         jUw7aWRsbd0qTh2oeH94EMNm5ZBtXgrGaxk3oLJxc8/VtSV8Bsh+rlbupc7n9tNnKeVJ
         6qHw==
X-Gm-Message-State: AOAM532xlEEJ1sGk0Hh3QXAL60CIoV50c9JK3GOsXT6Uoyp7QK3TvfMU
        6ag7mTALYwNm4V9S146NvxuazVs1d6BUGQuJ32PgxH861ct8H9Pr2IU=
X-Google-Smtp-Source: ABdhPJwnbT+/HirccKoILTERQKJpjWMYGeNrlv+6zQl3JFPHyGcExCZiGbt/bCY187zRJmYIOe+7DWPKpp9Cmh5w5D0=
X-Received: by 2002:a17:906:99c5:b0:6df:8215:4ccd with SMTP id
 s5-20020a17090699c500b006df82154ccdmr23107165ejn.684.1647900199431; Mon, 21
 Mar 2022 15:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
 <20220317231620.GC1544202@dread.disaster.area>
In-Reply-To: <20220317231620.GC1544202@dread.disaster.area>
From:   Jonathan Lassoff <jof@thejof.com>
Date:   Mon, 21 Mar 2022 15:03:08 -0700
Message-ID: <CAHsqw9sZfsNsQs779-hb5wR4H+W+wnHfNV=wo0vT2D6oXZ9t=g@mail.gmail.com>
Subject: Re: [PATCH v0 1/2] Add XFS messages to printk index
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 17 Mar 2022 at 16:16, Dave Chinner <david@fromorbit.com> wrote:
> That's a nasty mess. To begin with, we most definitely do not want
> to have to define log level translations in multiple places so this
> needs to be reworked so the front end macros define everything and
> pass things down to the lower level functions.

I can follow up with a PATCH v1 to do this kernel level deduplication.
I focused my initial attempt at changing as little as possible.

> And, anyway, why can't you just drop printk_index_subsys_emit() into
> the define_xfs_printk_level() macro? The kern_level, the fmt string
> and the varargs are all available there...

The short answer is that the format strings need to be known at
compile time, as this printk index is added into a section of the
resultant ELF binary.

> Anyway, there's more important high level stuff that needs
> explaining first.
>
> This is competely undocumented functionality and it's the first I've
> ever heard about it. There's nothing I can easily find to learn how
> this information being exposed to userspace is supposed to be used.
> The commit message is pretty much information free, but this is a
> new userspace ABI. What ABI constraints are we now subject to by
> exporting XFS log message formats to userspace places?
>
> i.e. Where's the documentation defining the contract this new
> userspace ABI forms between the kernel log messages and userspace?
> How do users know what we guarantee won't or will break, and how do
> we kernel developers know what we're allowed to do once these very
> specific internal subsystem implementation details are exposed to
> userspace?
>
> Hell, how did this stuff even get merged without any supporting
> documentation?

I can't really comment as to the commit history of the printk
indexing, though I think it's a fair criticism that there doesn't
currently seem to be any in-tree Documentation file about the
functionality yet.
The best references I could point to are commit
337015573718b161891a3473d25f59273f2e626b and this LWN article:
https://lwn.net/Articles/857148/

Your concern about ABI commitments is totally valid, and is (to me)
rather ironic in this context. This printk indexing effort was started
so that end user-operators can more reliably capture critical event
data *without* asking developers to commit to anything. The hope here
is that developers can change format strings and parameters at will,
and that from release-to-release end user-operators can compare the
printk index to see if there are any changes in printk index entries
that they care about for their environment.

It is my genuine hope that by merging a change like what I'm proposing
here, that end users can more reliably detect and react to XFS events
without XFS developers needing to know about this or commit to
anything. The only reason this change is needed is because XFS wraps
printk() for its own formatting.
