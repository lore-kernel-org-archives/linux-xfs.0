Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACB9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 22:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiC1W2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiC1W2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0070F75238
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648506417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4r+xgnGJx/b4/Cx9lAdMzvmtx05rZM/Scae8k5L4axo=;
        b=dMkNSn2l9XRskmpVHN1Uk8PeJLmevIYzEAKxFYlX1q483nMwIWYqtjNTPQwud/2r5vNm52
        NLF4f3foLlcHK59Ynw/M/PGwgkbpAOmbZGe7C1Ofz4Ck6Ni3xgG3Cm5FSlzViPFPUmVN5C
        ZfZOxH5SORPf+dx9D9S6DCKIkKN/RPU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-FminZxHAPDGGLYCbUlsUlw-1; Mon, 28 Mar 2022 18:26:56 -0400
X-MC-Unique: FminZxHAPDGGLYCbUlsUlw-1
Received: by mail-ej1-f70.google.com with SMTP id jx2-20020a170907760200b006dfc374c502so7385307ejc.7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4r+xgnGJx/b4/Cx9lAdMzvmtx05rZM/Scae8k5L4axo=;
        b=qxSNXN6PMVwOtsQAEiJCE+MjGg9Fi7ddZikglhNTASQmOLr55uqy4izaaf3wt0DRWL
         I487ZF5xLJux9z9B3VfG0jzd0wKOcGQAiOEF+vNNZWb6FL26ySJi3UB+cTf4rq5/xUrJ
         pB7Y1WPV4FiuSUzo7DHcuAADGf1AHJq6ZUe6luwGctG49t8zVuHli1Fa3139KzbxIXcB
         Aca+WD9GrqHFrHGA8SK0ZW3cUYcK9rxhdVlOYJ68XVGyBd7eaNwqKMUxu96mNsJBjN99
         A8Eq8WuFSBCjmyI6jfkMT4AKY1ui7GiymkALrOCnRhJ1RH/gapAtXk8P16yl7LhrNAgf
         kq9w==
X-Gm-Message-State: AOAM533dItU01ObYqhRqdBJf6uJaETCJeSRvkcu0nX8bDtMvy+3o7CSt
        z9iMdRy7uaKD145t6X9A76H2t2yXo7O41wszd09d9kIHiNqAgpw6u90oCT5yovFz7/OURA/0Vp7
        m2uuj9bpl33SwGDLfbYMXD5cOSKsM1c00A6azurz5q54bZsDHedMzGxCkJQd2stSPi/2OHkc=
X-Received: by 2002:aa7:dbd0:0:b0:416:633c:a0cc with SMTP id v16-20020aa7dbd0000000b00416633ca0ccmr76950edt.349.1648506415256;
        Mon, 28 Mar 2022 15:26:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd8/qoVqByWsWkRHOYcDEQFyLwj3EokG3qau2iRU9bTnp5jSBCKgpx1uZagtJCAgicP+44vQ==
X-Received: by 2002:aa7:dbd0:0:b0:416:633c:a0cc with SMTP id v16-20020aa7dbd0000000b00416633ca0ccmr76918edt.349.1648506415002;
        Mon, 28 Mar 2022 15:26:55 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm7722360edd.33.2022.03.28.15.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 15:26:54 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 0/5] xfsprogs: optimize -L/-U range calls for xfs_quota's dump/report
Date:   Tue, 29 Mar 2022 00:24:58 +0200
Message-Id: <20220328222503.146496-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_quota's 'report' and 'dump' commands have -L and -U
arguments for restricting quota querying to the range of
UIDs/GIDs/PIDs. The current implementation is using XFS_GETQUOTA to
get every ID in specified range. It doesn't perform well on wider
ranges. The XFS_GETNEXTQUOTA is used only when upper limit is not
specified.  Also, the fallback case (UIDs from /etc/passwd) doesn't
take into account range
restriction and outputs all users with quota.

First 3 patches do minor refactoring to split acquisition and
printing of the quota information. This is not that necessary, but
makes it easier to manipulate with acquired data.

The 4th one replaces XFS_GETQUOTA based loop with XFS_GETNEXTQUOTA
one. The latter returns ID of the next user/group/project with
non-empty quota. The ID is then used in further call.

The last patch adds range checks for fallback case when
XFS_GETNEXTQUOTA is not avaliable.

The fallback case will be also executed in case that empty range is
specified (e.g. -L <too high>), but will print nothing.

Andrey Albershteyn (5):
  xfs_quota: separate quota info acquisition into get_quota()
  xfs_quota: create fs_disk_quota_t on upper level
  xfs_quota: split get_quota() and report_mount()/dump_file()
  xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
  xfs_quota: apply -L/-U range limits in uid/gid/pid loops

 quota/report.c | 319 ++++++++++++++++++++++++-------------------------
 1 file changed, 156 insertions(+), 163 deletions(-)

-- 
2.27.0

