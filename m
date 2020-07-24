Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4632FC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217A520714
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/U4sdbd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgGXGNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:13:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbgGXGNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 02:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595571227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hOs/+Z1TAprZ/Tr3hSwuV2KPK7EvslyeXlcmX5gxBNA=;
        b=i/U4sdbdxkZU3PnNpR4Dx5YEFbhY+1uI4zqSzSnqfMNfH8iRB0cqTPuGygI41gRj4oK2Fc
        nRXEFR3ZRt6LCEgBDAwfu/M++sdBFCrQVbTJcykxaUSd017+Rp2nRw2/xHciSG9sNLYhSa
        Ga/E025dHM2o1JOJ5EO9H5i43VINWTs=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-yGcp9yKaM4qZzJQKdbXnvA-1; Fri, 24 Jul 2020 02:13:45 -0400
X-MC-Unique: yGcp9yKaM4qZzJQKdbXnvA-1
Received: by mail-pf1-f200.google.com with SMTP id y73so5614007pfb.8
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 23:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hOs/+Z1TAprZ/Tr3hSwuV2KPK7EvslyeXlcmX5gxBNA=;
        b=GoCvWDezKmwdcarjly4jkK+cf+5agrWDDPNJ8zQhuDUPSv+MfB0jpY0R0X84/r5SYo
         fMSrIX9EVBL8qc5+k/0P7bPHRX9kcvBkXVI/0W/araPXtb3shuHLqeprBLLbFlAbEUau
         ylviUdfsKitKDxIKGNRPQ0qTn/Kp906k4dofPd3g8wDiSL7w4I2LZmvicNiUT4FBdsmM
         Pn2jE3uoZ4IGJ7JuuIQYd6ap4POqtJPgePUaqRGy4ITOPW2TeUrq1B+ohKUEOSLov95d
         rvTbfR4V6HlmH9+iD7Hq+3vSq1xvsPdSOPBtsK/fh6IaIkWPPR4U/GCk+jxcGHflqrdt
         C/9g==
X-Gm-Message-State: AOAM533aUfhOLRKHZaB4tZGZiYUzK/xSpDkydBytQV7daC8oa+mCo8F5
        SFT+jtF0SIprUf+MmzXVrT/faItm6tEXCHT4yxsyzIe8bdeawWTOtq/yz4GCvEwymzrbTc8HoZC
        FHq9mNhB6+gIdcBO3RsyE
X-Received: by 2002:a63:aa42:: with SMTP id x2mr7079274pgo.361.1595571223770;
        Thu, 23 Jul 2020 23:13:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJKF6Xj727ZmWeXsPgIaavEOv8Ii5bc5PStndkuwrWLZdG/c0i+xZXaJePH4++tCqwxLOc5g==
X-Received: by 2002:a63:aa42:: with SMTP id x2mr7079254pgo.361.1595571223426;
        Thu, 23 Jul 2020 23:13:43 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n15sm4899232pjf.12.2020.07.23.23.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 23:13:42 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 0/3] xfs: more unlinked inode list optimization v2
Date:   Fri, 24 Jul 2020 14:12:56 +0800
Message-Id: <20200724061259.5519-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200707135741.487-1-hsiangkao@redhat.com>
References: <20200707135741.487-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi forks,

Sorry for long delay these days due to my work ineffective, this is RFC
v2 of this patchset addressing previous constructive comments...

This RFC patchset mainly addresses the thoughts [*] and [**] from Dave's
original patchset,
https://lore.kernel.org/r/20200623095015.1934171-1-david@fromorbit.com

In short, it focues on the following ideas mentioned by Dave:
 - use bucket 0 instead of multiple buckets since in-memory double
   linked list finally works;

 - avoid taking AGI buffer and unnecessary AGI update if possible, so
   1) add a new lock and keep proper locking order to avoid deadlock;
   2) insert a new unlinked inode from the tail instead of head;

In addition, it's worth noticing 3 things:
 - xfs_iunlink_remove() should support old multiple buckets in order
   to keep old inode unlinked list (old image) working when recovering.

 - (but) OTOH, the old kernel recovery _shouldn't_ work with new image
   since the bucket_index from old xfs_iunlink_remove() is generated
   by the old formula (rather than keep in xfs_inode), which is now
   fixed as 0. So this feature is not forward compatible without some
   extra backport patches;

 - a tail xfs_inode pointer is also added in the perag, which keeps 
   track of the tail of bucket 0 since it's mainly used for xfs_iunlink().

 - the old kernel recovery shouldn't work with new image since
     its bucket_index from old kernel is 

The git tree is also available at
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git tags/xfs/iunlink_opt_v2

Gitweb:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/iunlink_opt_v2

Some limited test for debugging only is done (mainly fsstress and manual
power-cut tests) and it's worth noticing that when I tested fsstress for
much longer time, it showed the following kernel message twice and it
haven't been reproduced again for about 3 days, and I have no idea what's
wrong over the current logic, so it could be better to send out the patchset
first and go on reproducing with extra debugging prints added...

[ 7884.930106] XFS (sda): bad inode magic/vsn daddr 111232 #0 (magic=5050)
[ 7884.930988] XFS (sda): Metadata corruption detected at xfs_buf_ioend+0x11a/0x190, xfs_inode block 0x1b280 xfs_inode_buf_verify
[ 7884.932418] XFS (sda): Unmount and run xfs_repair
[ 7884.933154] XFS (sda): First 128 bytes of corrupted metadata buffer:
[ 7884.934253] 00000000: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.935495] 00000010: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.936752] 00000020: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.937761] 00000030: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.939336] 00000040: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.940914] 00000050: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.942382] 00000060: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.943513] 00000070: 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50  PPPPPPPPPPPPPPPP
[ 7884.945006] XFS (sda): metadata I/O error in "xfs_imap_to_bp+0x61/0xd0" at daddr 0x1b280 len 32 error 117
[ 7884.952066] XFS (sda): xfs_do_force_shutdown(0x1) called from line 312 of file fs/xfs/xfs_trans_buf.c. Return address = ffffffff983ea7e0
[ 7884.952494] sda: writeback error on inode 20695, offset 770048, sector 1970864
[ 7884.954353] XFS (sda): I/O Error Detected. Shutting down filesystem
[ 7884.956566] sda: writeback error on inode 117946, offset 2347008, sector 612424
[ 7884.956802] XFS (sda): Please unmount the filesystem and rectify the problem(s)
[ 7884.958943] XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -117
fsstress: check_cwd failure
[ 7884.963475] XFS (sda): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0

Comments and directions are welcomed. :)

Thanks,
Gao Xiang


Changes since v1:
 - show some number of reduced AGI buffer modification (Darrick);
 - add comments about pag_unlinked_mutex, pag_unlinked_tail (Darrick);
 - avoid touching xfs_iunlink_update_bucket() logic (Dave);
 - spilt "xfs: don't access AGI on unlinked inodes if it can" into 2 patches (Dave);
 - add xfs_iunlink_insert_lock/xfs_iunlink_remove_lock/xfs_iunlink_unlock to
   make the code easy to follow (Dave).

Gao Xiang (3):
  xfs: arrange all unlinked inodes into one list
  xfs: introduce perag iunlink lock
  xfs: insert unlinked inodes from tail

 fs/xfs/xfs_inode.c       | 202 ++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_log_recover.c |   5 +
 fs/xfs/xfs_mount.c       |   2 +
 fs/xfs/xfs_mount.h       |   6 ++
 4 files changed, 159 insertions(+), 56 deletions(-)

-- 
2.18.1

