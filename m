Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A49BEB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 20:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjFWUZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 16:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjFWUZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 16:25:57 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AE61FF2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 13:25:56 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-440b54708f2so404111137.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 13:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687551955; x=1690143955;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=78ryu5ChD2L8KL7RpQE4GxzB7WCdzU1gzKtWqlckM0s=;
        b=s4U8XfblJea/GTn1p1f6a4BT12MB569HBglOXNHNwKSl1iXJDXHWfoACjEZqAss0Kw
         OZwXzq9cIzeHe8a1gr/aMJsnS47LeLfRfXcqY6pV58gR53mwVmvkFeP5KkJzqnc91pbI
         K1QRjGFyeJVUQ0f/035rNDxuN8m7pVad06rS1mez+1ztHhM7lWhYN7uAAxboipSMkIur
         q/9+vcn3r9gFQEJifUN6bmPjnpTx5upitjJsEDGmPAfwinwe/yoQ+42cpiqku5lER8Cw
         ki4zMdTdo1tLoctjTUSDIjdRGcAhC2tt46u+9Lx1CULpTUeOxyC0/mr9IV40B0ZB0mBa
         h06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687551955; x=1690143955;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78ryu5ChD2L8KL7RpQE4GxzB7WCdzU1gzKtWqlckM0s=;
        b=eBst+Y05GDCQaepBHyI+b515HWmD33o6er0BWTdWm+fUf4AcX24USyt/rR6AgMPmWm
         YGgy9PkJvB9qjTq3zhHcsoHS5qigoNbIYu+uDA0VaaSAs5FJZR5Y1QjLgh8drTiolHLW
         qm3m0hNsMNoFDpL6IYq2kZ8Q4vn4iEFNpzBQzWRYJA80qcqx1619+yawdcLDNJwG9221
         sSq+h5c9k7xtnsH6i9RVeX/7fwM3pDsIthmXqna2/w3ab7BhO8iywHi042Rq47mBu6FB
         fB+8CWUDa0PtqsUnL0NWpsaatA4QtFm42+F66J7vb/H8fdT5laI2GFgBL/R+lUN8WBnI
         0o4Q==
X-Gm-Message-State: AC+VfDz079QSgd9dxz5/jVoDz6Y+d6ZpO52oMmSwmR7LRhW6I+ZucuY/
        CQCI7+sNxRdRT94EsbgkNdpnOS4b9dlCGlq9k8zqK6iUIiY=
X-Google-Smtp-Source: ACHHUZ5nk68hb+oFlSJs5dyxGl0mCSlPsTXRPE1rflmkg4lkSM5WzrYlvq7oa/c/ZdSYSD3V86lLb4LFb2x/WBGoyQY=
X-Received: by 2002:a67:f799:0:b0:43f:4779:49b9 with SMTP id
 j25-20020a67f799000000b0043f477949b9mr12347690vso.11.1687551955151; Fri, 23
 Jun 2023 13:25:55 -0700 (PDT)
MIME-Version: 1.0
From:   Fernando CMK <ferna.cmk@gmail.com>
Date:   Fri, 23 Jun 2023 17:25:44 -0300
Message-ID: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
Subject: xfs_rapair fails with err 117. Can I fix the fs or recover individual
 files somehow?
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Scenario

opensuse 15.5, the fs was originally created on an earlier opensuse
release. The failed file system is on top of a mdadm raid 5, where
other xfs file systems were also created, but only this one is having
issues. The others are doing fine.

xfs_repair and xfs_repair -L both fail:

Phase 6 - check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - traversing filesystem ...
       - traversal finished ...
       - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
       - 16:15:34: verify and correct link counts - 42 of 42
allocation groups done
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
stripe width (17591899783168) is too large
Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
xfs_repair: Releasing dirty buffer to free list!
xfs_repair: Refusing to write a corrupt buffer to the data device!
xfs_repair: Lost a write to the data device!

fatal error -- File system metadata writeout failed, err=117.  Re-run
xfs_repair.

I ran xfs_repair multiple times, but I always get the same error.

Is there any way to fix the above?

I tried xfs_db on an image file I created from the file system, and I
can  see individual paths  and file "good":

xfs_db> path /certainpath
xfs_db> ls
10         1550204032         directory      0x0000002e   1 . (good)
12         1024               directory      0x0000172e   2 .. (good)
25         1613125696         directory      0x99994f93  13 .AfterShotPro (good)


Is there a way to extract files from the file system image without
mounting the fs ? Or is there a way to mount the file system
regardless of its state?

Trying a regular mount, with or withour -o norecovery, I get:
mount: /mnt: mount(2) system call failed: Structure needs cleaning.




Regards.
