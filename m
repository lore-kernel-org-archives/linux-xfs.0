Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E48C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B59764DD1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhA1HmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 02:42:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhA1HjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 02:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611819458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xi2q2oJXYtMCJAx0yftpfct6LzF3DFFwsDEt6sw1V5k=;
        b=ernB5Bca7ftAnUupE1NcMlIkfb3ePdJ92OhpwIL++UmLFIhg2DhEYKFTsGBG92ymIZ8Gz4
        v+nSWRAAYrQuZgqsfih4Fq7uIOSwc+hWD2Hcser3DY59r/dzK5AA94H+BSR02Dl8U6voFW
        TUUyMhbl3p8N4oprYlzLqh457DcVUHk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-bIyT45x4MIS7se2sEBTPIA-1; Thu, 28 Jan 2021 02:37:37 -0500
X-MC-Unique: bIyT45x4MIS7se2sEBTPIA-1
Received: by mail-pj1-f72.google.com with SMTP id hg20so2878247pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xi2q2oJXYtMCJAx0yftpfct6LzF3DFFwsDEt6sw1V5k=;
        b=KmY0z7oAFCMqJ9Q/5zyg9IW8/kmaX00e+NoKscy9J+1BI5RJlWgGuPZuFcHdJSwR3N
         5dhGXqshOqu32M+aPV8CTMGtZVKdZWIUQt+PkNHulHPthbWu7+Xym78sU1gCz+fkjBxu
         CSEuinL7YWB1dmDhwb3epKVDAC20H2YEXbInJj/OOAWxCm2YJ57fKBcgnjkNgcmoN85E
         oZ0/xJ/zyudYf6InfA8MdqVTeer0+dcuXscmeb3w3SyphvZ2bUsyM0wX1NQi0WPjBCLz
         D60YZ3aDAfb6CTv79P2KugHo9+ZHvfE7A2xBfpgt5nsupDC+3oH5hbVemH4p1n6GcJ3N
         gQ9A==
X-Gm-Message-State: AOAM533UU77pS9x83SRV/clOp7bg39rpo1sI49i77gu1eWjogqxHs4C9
        c7h2zDueQVN24O8KI5qtB/p4AgFnrn4WPt1QGLNW03B5f/q/lkT/AYLT6+a3JFAP15plicF6cx8
        BCwiGLHThPh3buxEzvuC+WY7JVXZUqOpL16d4+nfr9rKQwVuH7eLZbaJHLwa/FgIkZB3f660I
X-Received: by 2002:a63:6c85:: with SMTP id h127mr15382380pgc.158.1611819456110;
        Wed, 27 Jan 2021 23:37:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyi/YtTCFxhGAIOkxQJaZn8M11Q6y1f2p9aGn3PWKjmB/6mwLaxPHeLkHcoqOmmI2sg2SGVIw==
X-Received: by 2002:a63:6c85:: with SMTP id h127mr15382368pgc.158.1611819455885;
        Wed, 27 Jan 2021 23:37:35 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id n12sm4734897pff.29.2021.01.27.23.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 23:37:35 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 0/2] xfsprogs: xfs_logprint misc log decoding issues
Date:   Thu, 28 Jan 2021 18:37:06 +1100
Message-Id: <20210128073708.25572-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've been seeing confusing superblock transactions in logprint, this is
an attempt to resolve them and make debugging misc buffer updates easier.

Before

$ xfs_logprint -o xfs.image
----------------------------------------------------------------------------
Oper (2): tid: c32589f8  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: c32589f8  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 6360863066640355328  ifree: 262144  fdblks: 0  frext: 0
----------------------------------------------------------------------------

After

$ xfs_logprint -o xfs.image
----------------------------------------------------------------------------
Oper (2): tid: c32589f8  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: c32589f8  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer:
icount: 64  ifree: 61  fdblks: 259564  frext: 0
 0 42534658   100000        0      400        0        0        0        0
 8 84a2ced5 974f8da4 8fd4b0b3 9a870a19        0  4000200        0 80000000
10        0 81000000        0 82000000  1000000      100  4000000        0
18    a0000    2a4b4 10000001        0        0        0  408090c 19000010
20        0 40000000        0 3d000000        0 ecf50300        0        0
28 ffffffff ffffffff ffffffff ffffffff        0  2000000        0        0
30        0  1000000 8a020000 8a020000        0        0        0        0
38        0        0        0        0        0        0        0        0
40        0        0        0        0        0        0        0        0
48        0        0        0        0        0        0        0        0
50        0        0        0        0        0        0        0        0
58        0        0        0        0        0        0        0        0

----------------------------------------------------------------------------

Donald Douwsma (2):
  xfs_logprint: print misc buffers when using -o
  xfs_logprint: decode superblock updates correctly

 logprint/log_misc.c      | 41 ++++++++++++----------------------------
 logprint/log_print_all.c | 25 +++++++++++-------------
 2 files changed, 23 insertions(+), 43 deletions(-)

-- 
2.27.0

