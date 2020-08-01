Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A2EC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60176206E9
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gY98KJ8U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgHAI23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Aug 2020 04:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAI22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 04:28:28 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7C0C06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2020 01:28:28 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so15606327pfm.4
        for <linux-xfs@vger.kernel.org>; Sat, 01 Aug 2020 01:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJDYuK1wUTL2xIWPuPBP+pMTbwNyCjjXu16LIGHXwjM=;
        b=gY98KJ8UwafJBwlCzJ0Ib4PYaChwrnh5tL4bXZ1euMPUYHhSiadrsU61TMyUbtefXn
         tvcueh/8QclPOjxWvFzmzb3nWiC9EQMZULiY5o0jWaCUzFXwy1IGId55jDQZPaeZSkys
         iXEWQTEPIpOMRdAWM3M5wsWoeCD0HbX0YJ1Um12Y5DC45ZDwTq1h6JwyAgVHVpMJodl9
         cnkZ3513ADsCKTKLEoXvFRzF+bi7SppUfzim7QGcEiW60JzACtEReb8nm4pnAUUmLTTS
         BT3TUie88O2kNwAW4heBT1NuhpW04RY0d6ArZhkPy7SchRgxcoCLViKLy6rBOAGoPHGq
         u5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJDYuK1wUTL2xIWPuPBP+pMTbwNyCjjXu16LIGHXwjM=;
        b=hdzXxINyz3rd9IsOsEy68XdkNDBWzs5G3JeWAovx0QDav6+S2rA61iasonYgugDD7L
         KwtFflWxdEVm67hDM5269855JFJaJXEqbB+TzdCACnFJUdCHF9e3cgIQqRBYeglfJLsb
         SgX4fFXq/MwQWSob+dwrHLDMyTo0UFwSlQ47L2tj4XPZ3sal1i1RkDFe2WHtCD99CDdV
         ONLG+Z99G49lIEyL18zWdL+A1eek1DSr9WpTYNYlVJ9W1O7jVSmjo8VGql9ps7nIbifs
         YJzSbyTltUs7vueZC2TlCyka5UJMU4FE4kXcD+WuDWhhNVTWA1LxGa3+95TVPUQpe2HZ
         viZw==
X-Gm-Message-State: AOAM533ZnB/iG5ulB9aqV9d7QSW43jxmEDQkKkuIgUHiTq7/JDNE35ch
        QWpAWdKBfbXdfhlOiT5Fe12xWGKi
X-Google-Smtp-Source: ABdhPJzAR68wkwGIFD6ks6OOtpX2VwIjLNTsogwdFW3bAALx5UE+y2b3XcJY1khbeyszTq0cL17wEA==
X-Received: by 2002:a63:b55a:: with SMTP id u26mr6512051pgo.403.1596270507693;
        Sat, 01 Aug 2020 01:28:27 -0700 (PDT)
Received: from localhost.localdomain ([122.182.254.175])
        by smtp.gmail.com with ESMTPSA id 127sm13433380pgf.5.2020.08.01.01.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 01:28:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH RESEND 0/2] Bail out if transaction can cause extent count to overflow
Date:   Sat,  1 Aug 2020 13:58:01 +0530
Message-Id: <20200801082803.12109-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the xattr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This patchset adds a new helper function
(i.e. xfs_trans_resv_ext_cnt()) to check for overflow of the per-inode
data and xattr extent counters and invokes it before starting an fs
operation (e.g. creating a new directory entry). With this patchset
applied, XFS detects counter overflows and returns with an error
rather than causing a silent corruption.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v0.

PS: I am planning to write the code which extends data/xattr extent
counters from 32-bit/16-bit to 64-bit/32-bit on top of these patches.

 fs/xfs/libxfs/xfs_attr.c       | 33 ++++++++++--
 fs/xfs/libxfs/xfs_bmap.c       |  7 +++
 fs/xfs/libxfs/xfs_trans_resv.c | 33 ++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 fs/xfs/xfs_bmap_item.c         | 12 +++++
 fs/xfs/xfs_bmap_util.c         | 40 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  7 ++-
 fs/xfs/xfs_inode.c             | 96 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c             | 19 +++++++
 fs/xfs/xfs_reflink.c           | 35 +++++++++++++
 fs/xfs/xfs_rtalloc.c           |  4 ++
 fs/xfs/xfs_symlink.c           | 18 +++++++
 12 files changed, 301 insertions(+), 4 deletions(-)

-- 
2.27.0

