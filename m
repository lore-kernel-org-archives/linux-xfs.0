Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07E6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 10:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348653AbhLAKtT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 05:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348320AbhLAKtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 05:49:18 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BD5C061574
        for <linux-xfs@vger.kernel.org>; Wed,  1 Dec 2021 02:45:58 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so61903130ybg.9
        for <linux-xfs@vger.kernel.org>; Wed, 01 Dec 2021 02:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UHYcdyWm1JaGYSPdCaksjsmvc0WqcBJjN/tMfuSlkeY=;
        b=o0zhJk6mO//BZO8H+23UW4kI8BZmA/RL6lFMR7nvpff9y1lRHcoBvnccv2fyWiz1lB
         CSxO80PsFFRJUnWJXdRUaDMe8ykZB3K2pgViiddPa0oPtcB1icjpr85f51h6iWofdBo0
         wcJr6uZmZkc7W0pftV3YvC4kRSQg4ZTo+vfDvPanF/8GVrXTj5Dfeo7q7VivFy2MIlDK
         mLAgqh+IGgGZryVxWtKCPFTFtjBorQmbBpGwtYH6leZ5qh9a1m021x09cqFt7RbFt4Cb
         Xvou+7TRMwe71pUifTTPTdOmfd1hnaErsYlhM3vv8rB0QsoqlMeHwq0ORvhHS9tgvmKm
         Aolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=UHYcdyWm1JaGYSPdCaksjsmvc0WqcBJjN/tMfuSlkeY=;
        b=v9305STy+WjJ48YZLFUc89BWmt9y1eHJtMVduiEKhlAIf/ed0nX+aPfLQpPLqPeLXd
         505oY8aJfvZJJNp+X4M3TOzhfeeeizLAPx5oeu7MP0ra/CIjYiIqHcShol0diWugizdk
         Rf2rk+6Ah8p0jS0cNaqfQ3RhavTyHPDJxCPi6VJdxb7M3wVVaRP7ZIKpgLMonMAEOde/
         hl3EWeM11YHH3u/hgJzASsAHUdkOaQytwNlyfo8//vVbUWOL7R3RgRnpAeHErvLwz2O1
         jD3i+0UxScP5Vs4N56n5XoCX9jWpgbjGk2ZG/SwHJ/UhuaEaxeJH6abayfA4/Y6GZQLs
         NOFQ==
X-Gm-Message-State: AOAM5333vET8ZedlnwcP3R8ppWpLasQQmUg/hhgIZq8ffyPh6id45XZu
        fdomw01sxT2Rq/z6xjmOKBvWL1hG7cuhL/FQmnMVj86+6/7+mBy4PwJ7bA==
X-Google-Smtp-Source: ABdhPJy+i9KMwRbcKUi1vGC7OIRSEUdeCJLeY56plMH6vNirRQwJLayBs6kzzuDDEkWBlRC9pN96aA8MoXJrxCfdEyM=
X-Received: by 2002:a25:2a89:: with SMTP id q131mr6952886ybq.436.1638355557296;
 Wed, 01 Dec 2021 02:45:57 -0800 (PST)
MIME-Version: 1.0
From:   Kang Chen <void0red@gmail.com>
Date:   Wed, 1 Dec 2021 18:45:46 +0800
Message-ID: <CANE+tVp9Au=beERRjy9mp90-=5S9ErjEDT=E7i5E3dWvFP928g@mail.gmail.com>
Subject: Why 'fallocate' clear the file's SUID flag?
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I found that the 'xfs_update_prealloc_flags' function is called
during the =E2=80=98fallocate=E2=80=99 syscall and the SUID flag is cleared
when the 'XFS_PREALLOC_INVISIBLE' flag is not set.
I am a beginner and have some questions about it.

1. What does XFS_PREALLOC_INVISIBLE mean and
why should the SUID flag be cleared
when XFS_PREALLOC_INVISIBLE is not set?

2. The behavior of XFS in handling the fallocate syscall is
a bit strange and not quite the same as other file systems,
such as ext4 and btrfs.

Here is an example:
foo is a normal file.
chmod set the SUID and SGID flag.
The last two parameters of fallocate are irrelevant to this problem.
After running, ext4 and btrfs set mode o6000, but xfs set mode o2000.
```
int fd =3D open("foo", 2, 0);
chmod("foo", o6000);
fallocate(fd, 3, 6549, 1334);
fsync(fd);
```

Can you give me some help?

Best wishes.
