Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A08C636D7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBRGHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBRGHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:07:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFA14FA80
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YKCDoO1J8rceT8LcUANcINEiZmLpI49PkyoGsZGsFGI=;
        b=HrzOi5YD+gEzbvCu+0aAo7ovpvyN+GWfLcP72eefD5gKKD5g2DFtmn18M2qwbJ7wcGCdti
        QPAj7Yi+eLrbPbSI3oB2wtc6kuNsnWiYFiT4weTcABE4lVQtui0ihWZjKzcCWGdg6XEsUn
        6xfTCOku1DVbPZhOR+GNjIyChfWNewo=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-390-N5DBYueBMSuOCKor3CKJhw-1; Sat, 18 Feb 2023 01:06:17 -0500
X-MC-Unique: N5DBYueBMSuOCKor3CKJhw-1
Received: by mail-pg1-f199.google.com with SMTP id e5-20020a63ee05000000b004fb4f0424f3so119329pgi.14
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKCDoO1J8rceT8LcUANcINEiZmLpI49PkyoGsZGsFGI=;
        b=Nh7n9FEz55ZOKS5IzdbeUOi/JjBLW25uFDv1CHrXVa1H9hGYyApkPhi5NMwTpRHKHD
         u9AUmOJxlgWwuZGmwTrKzDM9YTqICcr0FFAwnEN5WXIf3+0TP6HzkIHJEU/HrSHQHa8I
         fmGAl36/AjG1A8HI6YA6eNhye8HPwvrlfcN0sdWpMoDVXHhvfvL6esy82eKqLdLMLoZF
         e25EVsfmYEAF4ibsNKKPKm2olV/E8iKi6DDfowf0nIz55/7tYmARkrf0at8+VF14i+Bw
         sTpF6suvNCeJmhtzla36I5OLGRxq9k/kN2ypRLu/JNxlW7xz+x7ckqgo6GMSDBBf6a/g
         PlsQ==
X-Gm-Message-State: AO0yUKV3r9NN+bbf8gEJGNFL/8d9e80CbBEuFKCefGc31bTbbPizmPY5
        lW6eZziqcj1HhF+j/NyqNKUw46cE6+oFcwRLys9aRA+0+owplzMiA9g8uyPKkMTUUzn3luQ1Toh
        OTDNHgL7XQ6tWtf5lCVOPjgmLJgEV
X-Received: by 2002:a62:1413:0:b0:5aa:7f17:5907 with SMTP id 19-20020a621413000000b005aa7f175907mr4081861pfu.30.1676700376064;
        Fri, 17 Feb 2023 22:06:16 -0800 (PST)
X-Google-Smtp-Source: AK7set9JSqTxklDHteoQyD6sou5dq8rgX9TBgs4dkIIJyeqsDZGNFsibgZu4N1XuobWWqM4KXJg8vw==
X-Received: by 2002:a62:1413:0:b0:5aa:7f17:5907 with SMTP id 19-20020a621413000000b005aa7f175907mr4081853pfu.30.1676700375673;
        Fri, 17 Feb 2023 22:06:15 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x13-20020aa793ad000000b00582f222f088sm3955936pff.47.2023.02.17.22.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:06:15 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:06:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v24.0 0/2] fstests: online repair of AG btrees
Message-ID: <20230218060611.cffnemaplf7esr35@zlang-mailbox>
References: <Y69Unb7KRM5awJoV@magnolia>
 <167243875241.723308.1395808663517469875.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243875241.723308.1395808663517469875.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:12PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Now that we've spent a lot of time reworking common code in online fsck,
> we're ready to start rebuilding the AG space btrees.  This series
> implements repair functions for the free space, inode, and refcount
> btrees.  Rebuilding the reverse mapping btree is much more intense and
> is left for a subsequent patchset.  The fstests counterpart of this
> patchset implements stress testing of repair.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

LGTM,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-ag-btrees
> ---
>  README            |    3 ++
>  common/fuzzy      |   39 +++++++++++++++++++--------
>  common/rc         |    2 +
>  common/xfs        |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/725     |   37 +++++++++++++++++++++++++
>  tests/xfs/725.out |    2 +
>  tests/xfs/726     |   37 +++++++++++++++++++++++++
>  tests/xfs/726.out |    2 +
>  tests/xfs/727     |   38 ++++++++++++++++++++++++++
>  tests/xfs/727.out |    2 +
>  tests/xfs/728     |   37 +++++++++++++++++++++++++
>  tests/xfs/728.out |    2 +
>  tests/xfs/729     |   37 +++++++++++++++++++++++++
>  tests/xfs/729.out |    2 +
>  tests/xfs/730     |   37 +++++++++++++++++++++++++
>  tests/xfs/730.out |    2 +
>  tests/xfs/731     |   37 +++++++++++++++++++++++++
>  tests/xfs/731.out |    2 +
>  18 files changed, 382 insertions(+), 13 deletions(-)
>  create mode 100755 tests/xfs/725
>  create mode 100644 tests/xfs/725.out
>  create mode 100755 tests/xfs/726
>  create mode 100644 tests/xfs/726.out
>  create mode 100755 tests/xfs/727
>  create mode 100644 tests/xfs/727.out
>  create mode 100755 tests/xfs/728
>  create mode 100644 tests/xfs/728.out
>  create mode 100755 tests/xfs/729
>  create mode 100644 tests/xfs/729.out
>  create mode 100755 tests/xfs/730
>  create mode 100644 tests/xfs/730.out
>  create mode 100755 tests/xfs/731
>  create mode 100644 tests/xfs/731.out
> 

