Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0A7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 07:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJNH7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 03:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiJNH7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 03:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FEF317CF
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665734348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aV1MZdaa2mcxHRugDUGYjEYoIozqMcM8HiekL2x7ahU=;
        b=FqRgTBJ+Fi71J2CBDJVTousQgXsgMUMNLmoK+sB9AiqQAxSUvj59pRTdCdH+Xg3yoozCnP
        7qeFNIyUrDNm0YgdWRLDq8MGMaJYzTmwzU+OKgFQX2RPuf0YDAxmy10f3w1QzVcX59h4E7
        Xndeu4USh8SnPnnmvgel4FxoGC6o/fQ=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-pB-rmWD5MGacTbuoDWVMtA-1; Fri, 14 Oct 2022 03:59:07 -0400
X-MC-Unique: pB-rmWD5MGacTbuoDWVMtA-1
Received: by mail-oi1-f200.google.com with SMTP id f16-20020a05680814d000b003506268b99fso1832112oiw.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aV1MZdaa2mcxHRugDUGYjEYoIozqMcM8HiekL2x7ahU=;
        b=pskMoyV9zPEnuhSW81akYn8ThYn22Ir3dKOWuRPPxjsD2aTKolOvmuSE9IQnzlmy00
         AvHrKAJOPzp+pBMJxCoD1b/KKFb3BoRTNlXSypgUdWVh1orgQ+r0ShhgxYvc+a9X6KjT
         yRzMSR/zWBGiax65dcMsyWlklMQ45654DkO74QgmSI6a6aA8Qhe3NCmLtzLkn09pl5dG
         HWCa4HcR7soOHqsW3dofTF5cjDw5G89/xkpLHp09oxGE5Mb8TcXEW5NgPkSIwOQSawED
         tTkBYdNeBL93tvcfK8NFchBnPtp+86TXr+bulQJYiiTiiR0nODZ56T6ONkx08p3Gk/VH
         DVWA==
X-Gm-Message-State: ACrzQf29PvhbYF5bVb6lVfjTklH3XjPu6NZYp/HtpwzRPtEuHhY6Y7wP
        0IYpNY/Ak7vfKjqLw64nwN10JzrXL3MdYKa0wM8Yci+uC3zurCcHyWLpnGXOezhLhriumP6IS5K
        IlqRDKGce4hjj1afdDEWUcu7Sz++9b8nnISGavEl49gJOwcOKEjbRRDaHJW9SF15qpW4g9xI6
X-Received: by 2002:aca:b4c1:0:b0:354:84e1:f8fd with SMTP id d184-20020acab4c1000000b0035484e1f8fdmr1817837oif.191.1665734345981;
        Fri, 14 Oct 2022 00:59:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM76odjntuP8v1msOFIOfXKDedhWdPiuwQA5LgnOY3aViGTBlId7wI5du1yj3XG3n4TM9NhA0Q==
X-Received: by 2002:a17:90b:254a:b0:200:53f:891d with SMTP id nw10-20020a17090b254a00b00200053f891dmr4404641pjb.168.1665734335343;
        Fri, 14 Oct 2022 00:58:55 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id nn13-20020a17090b38cd00b0020b21019086sm8550382pjb.3.2022.10.14.00.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:58:54 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v4 0/4] xfsrestore: fix inventory unpacking
Date:   Fri, 14 Oct 2022 18:58:43 +1100
Message-Id: <20221014075847.2047427-1-ddouwsma@redhat.com>
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
V3
- Fix whitespace and Signed-off-by.
- Make for loop formatting consistent.
- Rename patches to make their intent clearer.
- Add xfsdump: fix on-media inventory stream packing.
- Add descriptions that reproduce the stream problems.
V4
- Rerun testcase in "xfsdump: fix on-media inventory stream packing" description
to avoid confusion.

Donald Douwsma (4):
  xfsrestore: fix on-media inventory media unpacking
  xfsrestore: fix on-media inventory stream unpacking
  xfsdump: fix on-media inventory stream packing
  xfsrestore: untangle inventory unpacking logic

 inventory/inv_stobj.c | 42 +++++++++++++++---------------------------
 restore/content.c     | 13 +++++--------
 2 files changed, 20 insertions(+), 35 deletions(-)

-- 
2.31.1

