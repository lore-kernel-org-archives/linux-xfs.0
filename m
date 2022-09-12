Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21627C6FA82
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 14:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiILO26 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiILO25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 10:28:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56EF2E6BD
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662992935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dfvKF/00GpoLhFGKR4pAHuz0DVL0IIQc5mYA7NWMjnA=;
        b=Qer7FNXSK18Mfa4UthiFWikcoEdLsfPhPf4pef1wDdYbGE4WRO0FZ8R10RiTChu3J53utN
        7eJjo1wT+iv3k511Yp1C7G728xElp5ClvwSCSZgcTO7FmgG1t2PicAY+DzTjSfZ7vBDOI+
        P4GkGOuDJ90N+znUVPmohZH88F4mgqc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-LZL7s07IMWSP7LLSi9dCOw-1; Mon, 12 Sep 2022 10:28:54 -0400
X-MC-Unique: LZL7s07IMWSP7LLSi9dCOw-1
Received: by mail-ej1-f70.google.com with SMTP id oz30-20020a1709077d9e00b0077239b6a915so3311605ejc.11
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 07:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=dfvKF/00GpoLhFGKR4pAHuz0DVL0IIQc5mYA7NWMjnA=;
        b=0nyijkl05nEgz2i407N1Z20nTG6rAa91AMOfMOwP+lUNyKsse+qytkp84wFxWAryEG
         peMcrFrBOKyMmQvoc9TLXbby/o6DMGsySj+K+pRgObxm4zeQ2awbApVsIk/FI/jfRkn/
         90CJxm39uw2cDkJ+CbbOwXLw6/UgXk8LwWVn4ckbPYIfzHtQkrbjy7sjjbjZJLq6GWYQ
         x0RByoPnyHU3yWJnX7Co0Hau4vAuSbrlMOYtovMEJcQgRn5RCNd9Hk6iO1M+22r825Z5
         A/Ht8awGlmBNRo/8qYkmzzx2m+KrNKk/7WYIzQXgtu1zGtrxMyKCGRKMIzaKF5OqPGn9
         eA7A==
X-Gm-Message-State: ACgBeo1lb2/8QHvo3a2+Y43wX7PM2o0p/+ius6s5P9/9sMjcAtceBCY9
        EqiRT2a8N18ZmXukamnz+MbCDii9Wrl1xX7RNSYV7qkXM6rHgVoWGc9mKvB+cjXxQ6LwLLaoyvh
        noeiqJfdJE6TMYu9xXIKgOLTD1tJPa4To86PtsWdd3ujTnMdXR2HAiV583HnFhskhhGjl8PM=
X-Received: by 2002:a17:907:2cca:b0:77d:6542:d912 with SMTP id hg10-20020a1709072cca00b0077d6542d912mr3878727ejc.528.1662992933198;
        Mon, 12 Sep 2022 07:28:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6JUPnk/x4MZ3Xqb2QdbcN3RIlClEHhlcWqCmJW721Yco2R5E8lZ5vge1VztU1qf3638QsdBg==
X-Received: by 2002:a17:907:2cca:b0:77d:6542:d912 with SMTP id hg10-20020a1709072cca00b0077d6542d912mr3878710ejc.528.1662992932940;
        Mon, 12 Sep 2022 07:28:52 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ep19-20020a1709069b5300b0073093eaf53esm4487097ejc.131.2022.09.12.07.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:28:52 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cmaiolino@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND PATCH v3 0/5] xfsprogs: optimize -L/-U range calls for xfs_quota's dump/report
Date:   Mon, 12 Sep 2022 16:28:18 +0200
Message-Id: <20220912142823.30865-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

RESEND as it got lost somewhere between releases in May.

The xfs_quota's 'report' and 'dump' commands have -L and -U
arguments for restricting quota querying to the range of
UIDs/GIDs/PIDs. The current implementation is using XFS_GETQUOTA to
get every ID in specified range. It doesn't perform well on wider
ranges. Also, the fallback case (UIDs from /etc/passwd) doesn't take
into account range restriction and outputs all users with quota.

First 3 patches do minor refactoring to split acquisition and
outputting of the quota information. This is not that necessary, but
makes it easier to manipulate with acquired data.

The 4th one replaces XFS_GETQUOTA based loop with XFS_GETNEXTQUOTA
one. The latter returns ID of the next user/group/project with
non-empty quota. The ID is then used for further call.

The last patch adds range checks for fallback case when
XFS_GETNEXTQUOTA is not available.

The fallback case will be also executed in case that empty range is
specified (e.g. -L <too high>), but will print nothing.

Changes from v1:
Darrick J. Wong:
- Renamed get_quota() -> get_dquot()
Christoph Hellwig:
- Formatting: if() with tab, operators without spaces, long lines
- Replace 'fs_disk_quota_t' with 'struct fs_disk_quota'
- Merge and then split patch 2 & 3, so dump_file() and
  report_mount() are in separate patches
Changes from v2:
- Get rid of oid parameter

Andrey Albershteyn (5):
  xfs_quota: separate quota info acquisition into get_dquot()
  xfs_quota: separate get_dquot() and dump_file()
  xfs_quota: separate get_dquot() and report_mount()
  xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
  xfs_quota: apply -L/-U range limits in uid/gid/pid loops

 quota/report.c | 343 ++++++++++++++++++++++++-------------------------
 1 file changed, 168 insertions(+), 175 deletions(-)

-- 
2.27.0

