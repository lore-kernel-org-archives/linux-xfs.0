Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF9FC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 06:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjEaGlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 02:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjEaGlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 02:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5178713D
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685515246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xPGHtZ5KYlutL4cDDh9CUUcPZjV+YU48VxYweAUPNxw=;
        b=a2wjmC+JDhqf27tTh368XrcEvMrgATmxHp+qDyqSmW8AqiMZAlYNdEXK+G5Vq1MuSjT2it
        EFppNXj21ADv7ote258euQugcgcDJYnePjtHuDyHrIkctNXNImMfmZULg3m5aHH27eaoRS
        U3tR1bpxNjliphw1MiEYhzP4kYsEIpo=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-bq9EQ_UkP2SA_iKTYMEiOg-1; Wed, 31 May 2023 02:40:44 -0400
X-MC-Unique: bq9EQ_UkP2SA_iKTYMEiOg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-565a336caa0so115659577b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685515244; x=1688107244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xPGHtZ5KYlutL4cDDh9CUUcPZjV+YU48VxYweAUPNxw=;
        b=WFCRx69ikzkvbBeJGVmIL00u2gnAP3vXjzIx5a5oMjV1vTxVDsU5LiFF2PNj3PvXfB
         wwvVGktsrQt5Fkp2sYdinFkr0bIbEW6dn1Tmg8mYBe+ydJHkFiSg+Wa8L0sbehJDSRwH
         wTfqJJDr1cfz1K/XxX8hQ3lRRw1IGB7vQoqqWLbINs2gtBqzwQople6yj2biH1A1SuRt
         5PQJAQo31Ty58EJNjw2mh8mycoZVzuqWYLD6YtgP2EalHzu/E0nFfUn+XWLkxH563pIF
         nirHdHodZDPU9Hp4Mq0U8paHfqgW9QpSfi2zl5nlEy8OBsI7P6LawVwPDKD7+SnL1yv8
         XqPQ==
X-Gm-Message-State: AC+VfDw232N/Hy1zxM/AZW9XjO0hDmQyBIQLZZ3lgc7QL54uHXYe81A2
        hqIBZKo4Hv02fVqIJScL+XG1Cw3EvRYsbHTbbdosyOvJKbDezQ0lzekqh2vRycypz02mMDUSccc
        4QjVudzVBkJDjnNs01o7Moxaw9y8T+NAZXWVd/QD9sOSZMt0ZE40BpBiptTHgGko2xARQyCrgDa
        kaxu7T
X-Received: by 2002:a81:7d41:0:b0:568:be91:c2b1 with SMTP id y62-20020a817d41000000b00568be91c2b1mr5373694ywc.9.1685515243854;
        Tue, 30 May 2023 23:40:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6bcsGpvF1Bl3ayhl7HxtmbHann/hAubRhYrKX5w3t5a1/p/ALmGDh/fZ8ChClZtdTZIOu/qQ==
X-Received: by 2002:a81:7d41:0:b0:568:be91:c2b1 with SMTP id y62-20020a817d41000000b00568be91c2b1mr5373682ywc.9.1685515243550;
        Tue, 30 May 2023 23:40:43 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id g19-20020aa78193000000b0064d566f658esm2635220pfi.135.2023.05.30.23.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:40:42 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 0/2] xfstests/xfsprogs xfs_repair progress reporting test
Date:   Wed, 31 May 2023 16:40:23 +1000
Message-Id: <20230531064024.1737213-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A while ago I was working on a test for xfs_repair's progress reporting. Due to
some inconsistency in the the progress reporting output the test would
occasionally fail and was never merged.

https://lore.kernel.org/linux-xfs/eebaff94-d73d-2b0d-b433-dab3fb42602d@redhat.com/

This came back and bit me when I noticed it was still broken in a specific
downstream release.

While I could just filter the odd xfs repair output I think it makes sense to
try and make the xfs_repair more consistent. A delay of 38ms seems to hit this
regularly for me on a dual processor vm with the current fstests/common/populate.

- Don

Donald Douwsma (2):
  fstests: add test for xfs_repair progress reporting
  xfs_repair: always print an estimate when reporting progress

-- 
2.39.3

