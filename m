Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EB7CA9EBD
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5D3214DA
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hftY3ZqS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJZLSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:18:48 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:44057 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfJZLSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 07:18:47 -0400
Received: by mail-pf1-f170.google.com with SMTP id q21so3441627pfn.11;
        Sat, 26 Oct 2019 04:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IgFF6zS14hw7SKn8pFRxr4hmemobEBPoxeSD/fMKMg0=;
        b=hftY3ZqSmJgjI+1nNULTIB9eJsyfhL6Ud/gSv5R+iaOoqsUSsj9C5GF9ch+x+2up1w
         Nrk4zwXwVCeBs3pxA5NNdf+DJZYCbAra6NySjK+9y+qB0FIcLrt+PwJyelM8rbr8m4XR
         Q+lU3pe2Rbi/7XAPG9q9+0s2KLPvP+Rp+5GIrkVI2TSVMIGR6SRFCG6yQXzyJQotq1kF
         i0qtEz6o41RGKJNWRQQUOBzP+68MVGs/tdCx+CLudgkAtFWysJOouEZhfo5dWaI6m4YJ
         BRW4hpMhOZ5Qzzwq0mgFBHKRU71JNyjrRp9Q0RQWPOy9pBEtP9jxks8WpKwtsHERcoIt
         ZR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IgFF6zS14hw7SKn8pFRxr4hmemobEBPoxeSD/fMKMg0=;
        b=h/15YPIPxucivQSSonrNEV8dgQn1zpJtLeSdj3JEmU8s7ujKtP0Z31DCJRr4CqZLBl
         aQyhi8ouRqeGfHRxryPcXBvmzuAhX7suFcYcr8QZid6bZPHAHZ/sdTFVnzehGtaI2HmF
         9IWCE6vgs0Tn/1kpkNHXEOiW5l4tBEqmT+MiB5nMxXauiATXlsWWyJX/0Z1W69nPb5f1
         31Xr3e8BlDr1G3LjFJl7qq55PHVr+AtAb9kLpN4lT+MdJjZ56mGan9eIkD2IF0epid8I
         O19bMRYvSbwkt+z3sFxoFiX7gP5I4feUM/BhvvD9hWzE0tl70LgEhQUbXwUZQKFip/We
         td6g==
X-Gm-Message-State: APjAAAXxuzz09zc9kx8suXeAm2zfxi3FcmT6lzXbknrEShNHoe2kVBQ9
        CGGlYjR+i8uLMyDNF0d4Ln3+0I8=
X-Google-Smtp-Source: APXvYqzWYzf/q+nfWwpt5cHngbTowfNwOhMSNvUFuR3wz+FRttvWjvHD+ICTg6mJZ/xcaRlN5aTNTw==
X-Received: by 2002:a63:f95f:: with SMTP id q31mr1868041pgk.6.1572088726906;
        Sat, 26 Oct 2019 04:18:46 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y2sm6104534pfe.126.2019.10.26.04.18.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 04:18:46 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v2 0/4] xfstests: add deadlock between the AGI and AGF with RENAME_WHITEOUT test
Date:   Sat, 26 Oct 2019 19:18:34 +0800
Message-Id: <cover.1572057903.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, so add test to check that whether
the rename() call works well. We add the renameat2 syscall support to
fsstress, and then reproduce the deadlock problem by using fsstress.

Changes for v2:
 - Fix the xattr_count value of the original devnode in
   RENAME_WHITEOUT.
 - Fix the parent ids swap problem in RENAME_EXCHANGE.
 - Add the necessary comments.

kaixuxia (4):
  fsstress: show the real file id and parid in rename_f()
  fsstress: add NOREPLACE and WHITEOUT renameat2 support
  fsstress: add EXCHANGE renameat2 support
  xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT

 ltp/fsstress.c        | 206 ++++++++++++++++++++++++++++++++++++++++----------
 tests/generic/579     |  56 ++++++++++++++
 tests/generic/579.out |   2 +
 tests/generic/group   |   1 +
 4 files changed, 226 insertions(+), 39 deletions(-)
 create mode 100755 tests/generic/579
 create mode 100644 tests/generic/579.out

-- 
1.8.3.1

