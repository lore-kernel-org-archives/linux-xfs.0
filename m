Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9261C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 14:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354575AbiDTOxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 10:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiDTOxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 10:53:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D0F31A385
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SHAw/nkW7zop0IaDrIjG7cO7ulQBq+OCA2EpzDuVt40=;
        b=Wofbq3FD+UC5szC1Q6q4/kHtB80GwXLthRU2fNtge+BFv0w1w++wBwGz4e0cjt+hI3192w
        H5VL2XQT9iOWmte36B00twXfRflk43nk/38mNfgo3rj81Jl9wTtz3oz9y5KXOfXHGfymT3
        Ia++q6ODANonnsUGRwvrRHwsTTZRszg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-R9fG7U5XNC2KLG2MczR5RQ-1; Wed, 20 Apr 2022 10:50:51 -0400
X-MC-Unique: R9fG7U5XNC2KLG2MczR5RQ-1
Received: by mail-ed1-f69.google.com with SMTP id dk2-20020a0564021d8200b0041d789d18bcso1323044edb.21
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 07:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SHAw/nkW7zop0IaDrIjG7cO7ulQBq+OCA2EpzDuVt40=;
        b=F/tOrj0LHUEqRXvgZrLaygQ2tIjxVQJ2rswNmYYsKzGCIrDp2apX8Brxw9PbkSqZDs
         BYtVNIaA5kg2V4b9V6vPINQvDecwwl7uz7ZUqhDt4Nzzeo2iQdvOGtovF0XHIIrnB1yT
         8Kv5y/ypqq8PYFVoyXowFJOBQ9XB5N2gdWMd2jkgDIJ5ck/pHqt31S4nqC6VbaG3U05Y
         wZaYoT0lPQJO5N2kKu15SUpsI8xcuYPBNLlvNL/fqOSRe9Ek7Izb8yMJXyK7cz+vBjeh
         JwJgCvyRXLzxi/82+EhjZhXs/61FE/xharJCVPYYF0eotIw6QLy7E9M30VD2LrvSRzss
         Wxxw==
X-Gm-Message-State: AOAM5321TkdFxlztIFlvAMPCWAfRD7vQasWsNXabtLSRyW5InGpIoBS/
        ep0xwDuY+qVs8jYtx6NHG8QZK5/3DS2YIKOu3WOdi6TP6h18Bcj4dxdgxmpjSQxscgf8eKM9hpq
        PHvltVJyguAUEbGSRSoMuYwHNuINIHphXOrOROLRQ3W0jfZsRhUzjEtCyremu/TRA4YVHA00=
X-Received: by 2002:a50:d613:0:b0:41d:71bb:4af3 with SMTP id x19-20020a50d613000000b0041d71bb4af3mr23768222edi.99.1650466250245;
        Wed, 20 Apr 2022 07:50:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUNLh5ifsN23rIYrAADkNqeXnLZBl9nSTxQ7iDhuzqrtPmaAmUM/RSRAMspJW+t1JPKwSDtQ==
X-Received: by 2002:a50:d613:0:b0:41d:71bb:4af3 with SMTP id x19-20020a50d613000000b0041d71bb4af3mr23768200edi.99.1650466249936;
        Wed, 20 Apr 2022 07:50:49 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm9935622edt.92.2022.04.20.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:50:49 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 0/5] xfsprogs: optimize -L/-U range calls for xfs_quota's dump/report
Date:   Wed, 20 Apr 2022 16:45:03 +0200
Message-Id: <20220420144507.269754-1-aalbersh@redhat.com>
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

Andrey Albershteyn (5):
  xfs_quota: separate quota info acquisition into get_dquot()
  xfs_quota: separate get_dquot() and dump_file()
  xfs_quota: separate get_dquot() and report_mount()
  xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
  xfs_quota: apply -L/-U range limits in uid/gid/pid loops

 quota/report.c | 323 ++++++++++++++++++++++++-------------------------
 1 file changed, 160 insertions(+), 163 deletions(-)

-- 
2.27.0

