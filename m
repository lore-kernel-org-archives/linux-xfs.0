Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAF6C7EE23
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 21:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjEaVaf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 17:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjEaVae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 17:30:34 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD501A5
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 14:30:07 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-ba1815e12efso77115276.3
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685568603; x=1688160603;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=97KPdziRgY2DYFT+BtnYBVgMhbdu7cgPl6xNPpa2Mtc=;
        b=ZMlIR6r29VRr9aPfahQu8lYD82h2FIiOGPzrFUa09mcWC2K+mXkMQ1z/e5nz+eb0Nb
         EupGWHH0yxZCAqjxPOhCaZ1lvnUCg6lUKaGlcqHVCd6vSOFwfcLmn7DvOr+ckWUDDVbg
         k6gay445tXjauyST+6RAdM2qGExFJYUXHOHAnFaOmfT378MkDeSehx9XhWpu3GRf5d6R
         gyfd8hgBVxRmfu8bhGUMxh5ay2XPfPs2fARNgJiKZricXd2yrWhyReqItXqfYQa93RfR
         v6d7D0ydVN/f/0dRJfFlWfC2HJ15Kif0VYzsuisdlFWKNTsNRfX5twhUlPIynbJZvN2p
         VT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685568603; x=1688160603;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97KPdziRgY2DYFT+BtnYBVgMhbdu7cgPl6xNPpa2Mtc=;
        b=M4/EoJlBC/e/h3t2CfvEBBnEHfF8S1D0QT3BJczplTPeaoqkctVgDj+7JAMiiIQ4Sa
         MFusOq4CLeS6/J0H/6lmvHZqghJr+CQ67RbmtUivYqL0NF9XbYGUECOb0FGWts8MTCq8
         bPTUHTinXCYrndwOfT9x2DdkEULeLvQbHnOBjHdHfd/xkoLMPVb/YvVO45IcRSwtbQdv
         Mdnr+xiCnTzZth95HIlBEnhBJPycdx6tJQpRkjC9GOhJmWe2tdPZEt3lXG/ST8xkofOt
         sQ3kwEhKBCoeE2q87CTQHtMx/R0mdCtHqNDGn3Qqdo3wkmcybw6w2Hi9cX3mY8+jHlID
         5n6w==
X-Gm-Message-State: AC+VfDyUZtXbcMssAudUc6VjZnhznYoi0/WQGxbUBGZRnDGeCNQEpaq7
        N9eDBbjFl7Vhdz/PRsrwXEyay8evgODyjm0lBmC9jDQfX2Q=
X-Google-Smtp-Source: ACHHUZ4XxD+GSH67zRFn5T3Hv/33KFE7h6jt5m3P8YZYCJTrF2FjEa+6ttycdtJbUhxibE7YzS5tbZbRK3Gohm9yXCc=
X-Received: by 2002:a25:6e0a:0:b0:bb1:76ca:d1ff with SMTP id
 j10-20020a256e0a000000b00bb176cad1ffmr2042198ybc.20.1685568603480; Wed, 31
 May 2023 14:30:03 -0700 (PDT)
MIME-Version: 1.0
From:   Jianan Wang <wangjianan.zju@gmail.com>
Date:   Wed, 31 May 2023 14:29:52 -0700
Message-ID: <CAMj1M42L6hH9weqroQNaWu_SG+Yg8NrAuzgNO1b8jiWPJ2M-5A@mail.gmail.com>
Subject: Question on the xfs inode slab memory
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I have a question regarding the xfs slab memory usage when operating a
filesystem with 1-2 billion inodes (raid 0 with 6 disks, totally
18TB). On this partition, whenever there is a high disk io operation,
like removing millions of small files, the slab kernel memory usage
will increase a lot, leading to many OOM issues happening for the
services running on this node. You could check some of the stats as
the following (only includes the xfs related):

#########################################################################
Active / Total Objects (% used):  281803052 / 317485764 (88.8%)
Active / Total Slabs (% used): 13033144 / 13033144 (100.0%)
Active / Total Caches (% used): 126 / 180 (70.0%)
Active / Total Size (% used): 114671057.99K / 127265108.19K (90.1%)
Minium / Average / Maximum Object : 0.01K / 0.40K / 16.75K

OBJS               ACTIVE      USE     OBJ SIZE     SLABS
OBJ/SLAB    CACHE SIZE    NAME
78207920      70947541      0%       1.00K           7731010
 32            247392320K     xfs_inode
59945928      46548798      0%       0.19K           1433102
 42              11464816K     dentry
25051296      25051282      0%       0.38K           599680
  42            9594880K         xfs_buf
#########################################################################

The peak slab memory usage could spike all the way to 100GB+.

We are using Ubuntu 18.04 and the xfs version is 4.9, kernel version is 5.4

#########################################################################
Linux# cat /etc/*-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.5 LTS"
NAME="Ubuntu"
VERSION="18.04.5 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.5 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic

Linux# sudo apt list | grep xfs
libguestfs-xfs/bionic-updates 1:1.36.13-1ubuntu3.3 amd64
nfs-ganesha-xfs/bionic 2.6.0-2 amd64
obexfs/bionic 0.11-2build1 amd64
x11-xfs-utils/bionic 7.7+2build1 amd64
xfsdump/bionic 3.1.6+nmu2 amd64
xfslibs-dev/bionic 4.9.0+nmu1ubuntu2 amd64
xfsprogs/bionic,now 4.9.0+nmu1ubuntu2 amd64 [installed]
xfstt/bionic 1.9.3-3 amd64
xfswitch-plugin/bionic 0.0.1-5ubuntu5 amd64

Linux# uname -a
Linux linux-host 5.4.0-45-generic #49~18.04.2-Ubuntu SMP Wed Aug 26
16:29:02 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
#########################################################################

Is there any potential way to limit the slab memory increase for a
node as a whole, or the only thing we could do is to reduce the
filesystem inode or iops usage?

Thanks in advance!
Jianan Wang
