Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA42C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5BC2084C
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 12:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qHT048Z3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbgEZMJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 08:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgEZMJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 08:09:41 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08194C03E96D
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:09:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so20172900qkh.11
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 05:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6YtTvK/ZkraZkVpQc+O243orncscgzmiFeAjuKAVjA=;
        b=qHT048Z3WGkPCRefNIIcIDwJjmQlhTY8c9EeTLw5a43YyH+lHWtsTOaWn21gJMdemk
         JarYZGtq6z295qrIopzEFf6o6zJOHXAUl7uSXmT4vIzr2rCQbrc01X9q7CTzgvGrWFw3
         cbs5rqItEX7djl4zXhPnMA2PX12sPBW+xJ4TdZ7Hv71fUIlwfhvat7ydvtHNl2GooR0Q
         /Wdm/OaFoCNR+kEKKR5Uc/UqMZ7I2kp6jbzNz6Tmk0gPlR4yOaQZRnAJYqlsbFjqqUl7
         CL3yHUCAjQj2Cj6wCSGmOSNHm7AMt/TONzFlTog9rzNrFnWkqBi7kurJVoxL5lADZbT4
         oRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6YtTvK/ZkraZkVpQc+O243orncscgzmiFeAjuKAVjA=;
        b=Nix1HGttHBSvAbcexQsLTHFfydY2/2jBg4GLtCIyiEyfDCj+IkfdinNfXQt9RJWz1i
         jmk6AILvxGmHwdSbpOklor6OSbY7izlPhSlcpWVq2GAte7y1a9DtgSkzb3ti4h1ikZto
         dAtr/sOQCL4QVDFZ2SYmydGifJ7NEGQfaO/7jx3/T25ncJuTt5GJwVWU1tXq46BBuPU3
         8uvGVfLZT6J2ByrKc3nJDRyXvB4JU1LwAvPxHsDKpMYKrdR3NBjt5PvOcprm6QxYVr3S
         lH2ePr/UqCvDzQp5Ppl7GJvXKzK05Gl3+74Dmgpg8jd4iuJ89ninOeaZ4pUAzXXRJWtr
         roWA==
X-Gm-Message-State: AOAM532xXykZ2FgAzxd6FYiv4HI/bualYPWpDmIPSM/p9chp5OnwMEa7
        md24z+VhnPr2oh5iOjHKEbZ3Vsb9Mp6ZTfoLt3oU7g==
X-Google-Smtp-Source: ABdhPJzYERXCmCtYzsOfAOd3xrK+gJoFyAsp+Tq5tCHHrxxPRZvZPbOobKpBO2vqJ8mq7lOlGq5aEbU1RW3R7yOnDWI=
X-Received: by 2002:a05:620a:c89:: with SMTP id q9mr893376qki.256.1590494979960;
 Tue, 26 May 2020 05:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ae2ab305a123f146@google.com> <3e1a0d59-4959-6250-9f81-3d6f75687c73@I-love.SAKURA.ne.jp>
In-Reply-To: <3e1a0d59-4959-6250-9f81-3d6f75687c73@I-love.SAKURA.ne.jp>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 26 May 2020 14:09:28 +0200
Message-ID: <CACT4Y+ap21MXTjR3wF+3NhxEtgnKSm09tMsUnbKy2_EKEgh0kg@mail.gmail.com>
Subject: Re: linux-next build error (8)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:29 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Hello.
>
> This report is already reporting next problem. Since the location seems to be
> different, this might be caused by OOM due to too much parallel compilation.
> Maybe syzbot can detect "gcc: fatal error: Killed signal terminated program cc1"
> sequence and retry with reduced "make -j$NUM" settings.
>
>   gcc: fatal error: Killed signal terminated program cc1
>   compilation terminated.
>   scripts/Makefile.build:272: recipe for target 'fs/xfs/libxfs/xfs_btree.o' failed
>   make[2]: *** [fs/xfs/libxfs/xfs_btree.o] Error 1
>   make[2]: *** Waiting for unfinished jobs....

+linux-next and XFS maintainers

Interesting. This seems to repeat reliably and this machine is not
known for any misbehavior and it always happens on all XFS files.
Did XFS get something that crashes gcc's?

  CC      drivers/hid/hid-uclogic-rdesc.o
  CC      drivers/hid/hid-uclogic-params.o
  CC      drivers/hid/hid-led.o
  CC      drivers/hid/hid-zpff.o
  CC      drivers/hid/hid-zydacron.o
  CC      drivers/hid/wacom_wac.o
  CC      drivers/hid/wacom_sys.o
  CC      drivers/hid/hid-waltop.o
  CC      drivers/hid/hid-wiimote-core.o
  CC      drivers/hid/hid-wiimote-debug.o
  CC      drivers/hid/hid-wiimote-modules.o
  CC      drivers/hid/usbhid/hid-core.o
  CC      drivers/hid/usbhid/hid-pidff.o
  CC      drivers/hid/usbhid/hiddev.o
  AR      drivers/gpu/drm/i915/built-in.a
  AR      drivers/gpu/drm/built-in.a
  AR      drivers/gpu/built-in.a
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_file.o' failed
make[2]: *** [fs/xfs/xfs_file.o] Error 1
  AR      drivers/hid/usbhid/built-in.a
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_fsmap.o' failed
make[2]: *** [fs/xfs/xfs_fsmap.o] Error 1
  AR      drivers/hid/built-in.a
  AR      drivers/built-in.a
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_filestream.o' failed
make[2]: *** [fs/xfs/xfs_filestream.o] Error 1
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_icache.o' failed
make[2]: *** [fs/xfs/xfs_icache.o] Error 1
  AR      fs/ocfs2/built-in.a
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_iops.o' failed
make[2]: *** [fs/xfs/xfs_iops.o] Error 1
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_mount.o' failed
make[2]: *** [fs/xfs/xfs_mount.o] Error 1
gcc: fatal error: Killed signal terminated program cc1
compilation terminated.
scripts/Makefile.build:272: recipe for target 'fs/xfs/xfs_inode.o' failed
make[2]: *** [fs/xfs/xfs_inode.o] Error 1
scripts/Makefile.build:494: recipe for target 'fs/xfs' failed
make[1]: *** [fs/xfs] Error 2
Makefile:1736: recipe for target 'fs' failed
make: *** [fs] Error 2
