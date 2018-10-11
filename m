Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38538 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJLDN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 23:13:27 -0400
Received: by mail-wr1-f45.google.com with SMTP id a13-v6so10984563wrt.5
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 12:44:43 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x203-v6sm17909785wmg.42.2018.10.11.12.44.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:44:41 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH v3 0/2] Try to squash metadump data leaks
Date: Thu, 11 Oct 2018 21:44:22 +0200
Message-Id: <20181011194424.20306-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is the same as v2, but with the correct e-mail address this time. Sorry!

Stefan Ring (2):
  xfs_metadump: Extend zapping to multi fsb dir blocks
  xfs_metadump: Zap more stale data

 db/metadump.c | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 107 insertions(+), 14 deletions(-)

-- 
2.14.4
