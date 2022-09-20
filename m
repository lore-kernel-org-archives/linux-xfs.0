Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3DFC6FA82
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 20:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiITUiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITUiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 16:38:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB95475FEF
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q3so4313653pjg.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=45OjGTFhXvFHok8A6cXeQsWY1uywmeaG42xZ214cljU=;
        b=Db4WolTGlgr94pnUMq7krQHXWZM7OIVmoPME5v7ZpIQO9MDq0NbYpZpdL2CfGeu4it
         fHOCw6ixYJS1brZom0PaePIO1vZXctPvYVLU8FoFWwpTFsX970gdItpK9VoV9atftXJc
         miTWsbGPjvzmwmAH2/bAtcF9fy3/Q6DtpujTvcBOoMmO/bPbciS5kW0E4BblF4ToLM0/
         kYKFKxEublTW6E0SbeTCsyxhk6R/ecOgs4biPEjoFw5H4pgBh5maL/psP5lX09OrAG+P
         DPKFdBQbcZy9B2hhxVX3/q68JSXz39hiBuMkmzYvfOqs+ox1CkBBnQNe42EAjsLfOixu
         7cCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=45OjGTFhXvFHok8A6cXeQsWY1uywmeaG42xZ214cljU=;
        b=S+KBU2UJ3x4FWS2GZnNgsXclk5KCvm29Xe4FlkjvKjHOG9JoQkAwKZVnvWewZ4hkLx
         veBsegaAHkilfwobx9ot0kfsO3sRE7k67ZOBB8YBEzzEbjgBkAeOHXvysR26WTPZq06Y
         bJbODhV2DxZbQeiXiaY547L0Cc55+v6cnnbk9Lq6mT0BbRm7KKcMSEdrqMQ3bcZDWY0g
         X/N5UeYbsF2Ui+El16d86eZn2LhVJ/1VB+P6KJHSZd0ouCTcTClHHIqpnr+Jb758yLv0
         3gtoYjCUCA9Jbxq3RzHdIBosnyR5Qw6RBiHHvWdLYHY+42Cb/lufRMq/zs+eiMkQGwcr
         m9jQ==
X-Gm-Message-State: ACrzQf3ybGnv1pkH/UKrcEPP5sjZNqNJfSUxgWM7upzLuqSiJyUSI2lC
        PMdyAFxb3CzA/YgQbJMAQSbII7jlwrU=
X-Google-Smtp-Source: AMsMyM7epNXMOD4/5mRI4cXQfG9pXBw3pOyDrQFIqRn9rbuPRKl7D08UI+6QY3UZHnNY0KcDNavJyQ==
X-Received: by 2002:a17:902:ed4d:b0:178:9702:71fd with SMTP id y13-20020a170902ed4d00b00178970271fdmr1357268plb.162.1663706285404;
        Tue, 20 Sep 2022 13:38:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6d85:bae2:555b:c2bf])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00177c488fea5sm365963plg.12.2022.09.20.13.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 13:38:04 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 0/3] xfs stable candidate patches (part 5)
Date:   Tue, 20 Sep 2022 13:37:47 -0700
Message-Id: <20220920203750.1989625-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

These patches correspond to the last two patches from the 5.10 series
[1]. These patches were postponed for 5.10 until they were tested on
5.15. I have tested these on 5.15 (40 runs of the auto group x 4
configs).

Best,
Leah

[1] https://lore.kernel.org/linux-xfs/20220901054854.2449416-1-amir73il@gmail.com/

Brian Foster (1):
  xfs: fix xfs_ifree() error handling to not leak perag ref

Dave Chinner (2):
  xfs: reorder iunlink remove operation in xfs_ifree
  xfs: validate inode fork size against fork format

 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c            | 22 ++++++++++++----------
 2 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

