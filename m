Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B27C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 05:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiI1Fxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiI1Fx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 01:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5DA10FE06
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664344408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uf+u19nhI2iiuTuqcPH1L7lStf0jB8sO9GDxYPITTSM=;
        b=UXWzKvlnN4Z4hmarnUCKCTsytAjCc2fiXHnk6U6PmbvPYmZP72orUj5fP577gjIQu5f6Kq
        pTf1pzJn7t1TDHZ+bYt8UHHlWI3/QS5wVIfcvvLrTgyZD5G1TDgXoNe/qZJCG11VLKV40Y
        QsqYKIQtd35ZZtEE56+LmvCSmsn3pu4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-_1BZcB4yObu5U1jdLvPZ_Q-1; Wed, 28 Sep 2022 01:53:25 -0400
X-MC-Unique: _1BZcB4yObu5U1jdLvPZ_Q-1
Received: by mail-pg1-f198.google.com with SMTP id s15-20020a63524f000000b0043891d55a30so6847263pgl.16
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=uf+u19nhI2iiuTuqcPH1L7lStf0jB8sO9GDxYPITTSM=;
        b=YeNNPXTeZPKmAoRHLSxK1vBuLKfWYFtUj495/tShaeIxK+N9RjNFY8+ESRRe0/PYxp
         tiwicnk7NWWfjHQD75oQ7Y429Wdr1qN2/WBRsjsoZX7pEtNPMx7x4/i1cNj8ms12WKp1
         w+BAihynA4Qe+wdoZ1Cj4NxhvDOlyWbN7JWFfcBSrSHL1DinJIKiXLgaRhV+5sF9VgKo
         GcyhXTs9Lg7aQU4aNrYXDAAXv581bloWNwRJYV8RKSsm8HgZbCZIWmZKMim36aAnSMIZ
         Wdb0puk8732uRtlhIu8uG2CC1ZNALaXuyqzG0c0jdNIQ7em0VeQzPjVJcCskhrqqSwbI
         YuFA==
X-Gm-Message-State: ACrzQf2NMHVWZUH+zzGTe3y3+r/6zfMx2IOpxoYG4WS5pxCU3wRogEmC
        /fVOPaT8Tqwm3acJj3pZ4nv9lSCd+gSQLl/EBZS4G5WH44iENXRlh04iK3//Q2X4rNrVWrQiVYS
        kUKYL/uxCJIYilMVqiJ0MrCiSEGu6IrkQFWWRBF6HQDhb+ZUiAHholrMedvlOOX74x7J3W7ja
X-Received: by 2002:a63:191d:0:b0:434:4bb3:e016 with SMTP id z29-20020a63191d000000b004344bb3e016mr28436125pgl.133.1664344404520;
        Tue, 27 Sep 2022 22:53:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4mgPLDfLlYR6zX5wHVCHewVMTmTE7Stfc+4IU1dNPxUaWa7CX3vFgN3BCm+6TFR830xr4CLQ==
X-Received: by 2002:a63:191d:0:b0:434:4bb3:e016 with SMTP id z29-20020a63191d000000b004344bb3e016mr28436110pgl.133.1664344404185;
        Tue, 27 Sep 2022 22:53:24 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id o129-20020a62cd87000000b005544229b992sm2912971pfg.22.2022.09.27.22.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 22:53:23 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2 0/3] xfsrestore: fix inventory unpacking
Date:   Wed, 28 Sep 2022 15:53:04 +1000
Message-Id: <20220928055307.79341-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When xfsrestore reads its inventory from tape it fails to convert the media
record on bigendian systems, if the online inventory is unavailable this results
in invalid data being writen to the online inventory and failure to restore
non-directory files.

The series fixes the converstion and related issues.

---
v2
- Seperate out cleanup and content.c changes, fix whitespace.
- Show a full reproducer in the first patch.

Donald Douwsma (3):
  xfsrestore: fix inventory unpacking
  xfsrestore: stobj_unpack_sessinfo cleanup
  xfsrestore: untangle inventory unpacking logic

 inventory/inv_stobj.c | 40 ++++++++++++++--------------------------
 restore/content.c     | 13 +++++--------
 2 files changed, 19 insertions(+), 34 deletions(-)

-- 
2.31.1

