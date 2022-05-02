Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F4BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 15:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385651AbiEBPGr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiEBPGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 11:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF3EA1114E
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 08:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651503796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x9rJOpkRL7hRigdGOPAVgb1iYg+cegvBAtmdolkhsck=;
        b=ah/gJvgPyfljOuAOYhVmsKlFKF0v4ZgyKbi5opwaRt2YCSxw67bo7m6goiPZhw8g/qPEVk
        5V/deiXuhA6Js4ep1PD1sknpmigcalcI7wrYytNfAwB6zj/gwtA+4LS71k/i0jqtB6a0SF
        Md2y0PIMdKFshz68RzuRGIUeWxV7deo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-2UzeXLEFMQKnlKlFOC5-cg-1; Mon, 02 May 2022 11:03:15 -0400
X-MC-Unique: 2UzeXLEFMQKnlKlFOC5-cg-1
Received: by mail-wr1-f69.google.com with SMTP id t17-20020adfa2d1000000b0020ac519c222so5368419wra.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 May 2022 08:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9rJOpkRL7hRigdGOPAVgb1iYg+cegvBAtmdolkhsck=;
        b=8Ak1+03DSDxT/h28WaX83vjwl7Kc4PFXK8j/k7Jjhmr5+pkTA8aAF+VGhBHsHalEPx
         NWI4bpDzpQVkeb6M4ItxGPVS7R34ylq/1K7vIU38w9/CN4eoDSd1W6paA/6TDAuOLPjE
         uoNb4VznX4sAyI+3WBD5tYaLodiYz2TPD9oM8YMj2W3bhFiGgU3YvHa6K95rMhm266V0
         x43tXIwvs8a1eML88g8ScFliK0RsFsilm88dDl6qrApQehnVGoVTA3zows6ilF97FTkx
         KvM1SW74UMZUOWxKNlhm7dGp7RKRy0myDxdxqPP5Zz2jiDPdmab+LfGGc71M+YX9D4tk
         8UYg==
X-Gm-Message-State: AOAM530yAMEK0/qwqjDERVuFH9usPHRMAdTMXQAnGIF5uzPWehzo+l0j
        NCyc7rjORN6U4Evis5+AR+eT0aV/Huz3xzuSeVYHURl2OG9s8QnSppOrzwQIxJUuaJeG34kR8iE
        qa6q4PSwZ7BbxhkdEI6l29llgk+7Mf2iNc15wXdZggfvX1e5xZoASRCu+cCIzLcvybtZo1K8=
X-Received: by 2002:a05:6000:2ae:b0:20c:57b6:32e1 with SMTP id l14-20020a05600002ae00b0020c57b632e1mr7980295wry.285.1651503794142;
        Mon, 02 May 2022 08:03:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2nOSx7jE3C0M73rlgXdtQ/6GeGVbc/hDQY7J/Ozq2wPkMckx1XDi9ORVoZQ7oiO3/5KxfzA==
X-Received: by 2002:a05:6000:2ae:b0:20c:57b6:32e1 with SMTP id l14-20020a05600002ae00b0020c57b632e1mr7980279wry.285.1651503793865;
        Mon, 02 May 2022 08:03:13 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b0039429bfebeasm198794wms.2.2022.05.02.08.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 08:03:13 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 0/5] xfsprogs: optimize -L/-U range calls for xfs_quota's dump/report
Date:   Mon,  2 May 2022 17:02:03 +0200
Message-Id: <20220502150207.117112-1-aalbersh@redhat.com>
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

