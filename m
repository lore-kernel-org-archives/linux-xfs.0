Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED710C4320E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D367D60FC0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhHBVuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231933AbhHBVup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BOu7UuQfKjh13SPM0HFMxDGhOBoWHBUeZ6/wmS2wIDs=;
        b=DuT0ziRfPhSFoprqkFfFj9LjyWsJc55rLq78//z07UWj3qtrVdObpM09McxjDDpFXrhCnt
        jy0hUUx5dBj73eRZIcRtYH1J18t/WU3UkSphUaaNb8yuLnI7Kq6ZgATS5+CJrY04gXm+vQ
        EZ14fTHv4ZFZXJR3QqRK3groaYwPG+g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-Uq8ERJEIN82FlipHUp6FVg-1; Mon, 02 Aug 2021 17:50:27 -0400
X-MC-Unique: Uq8ERJEIN82FlipHUp6FVg-1
Received: by mail-wr1-f69.google.com with SMTP id c5-20020a5d52850000b0290126f2836a61so6918147wrv.6
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BOu7UuQfKjh13SPM0HFMxDGhOBoWHBUeZ6/wmS2wIDs=;
        b=fhbqaQ5++aLX11Hr1/vzDOxoMTqmjVtQtRSFHj0RFWq+Wqv7roV/FhVDAn2mSpnf3r
         6z7b8wOpX+NUERAGLDiNMIprwUclOE8MyaNyr42koAJ6JL+t7ueess612fUjp5bvunoY
         ZJmmOng2peZPLVoAW9FxyETTzb5wXEjQ5yNh8H/y7n9A39K2/4VuTesBrj+L8HusdJD0
         VflnPJosmGCIPxvuCkiF4stN2+X8EJvI3CuoVHJuSUVNwMdVZOls4sLgHVgIllgWophE
         PpFSF8VMGXUX/G+lQdDKkFkBCQSVYDMEpgSuiDepFwfluvsMM4pln2FCQIMbQfkX6OeL
         fhNg==
X-Gm-Message-State: AOAM530vEmS6scVVWaFS8S3TwJ386oZqLdWDSMXweYXVuNJI6TYLbpuj
        1Uml6/reC6bwBgBZht7IID00tfjfLoTw/FHo/NgiklX+JSBmm8G+802Yx55YSubekugx63yWc3p
        4I8WqK6MXHKmVznnTja7vR72a8NUcz5jVAhM4QkHC4F4DILg5bDj4LgMw56IJcA75BccKM1s=
X-Received: by 2002:a5d:518a:: with SMTP id k10mr19681894wrv.400.1627941025846;
        Mon, 02 Aug 2021 14:50:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye4RVqwKRhHnmn9tkg7hYnIiqUrGHyJuDpjdiJ20dNyoAcns2chrQifFk2VGlzUTNYt0JrwQ==
X-Received: by 2002:a5d:518a:: with SMTP id k10mr19681875wrv.400.1627941025570;
        Mon, 02 Aug 2021 14:50:25 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:25 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8] xfsprogs: Drop the 'platform_' prefix
Date:   Mon,  2 Aug 2021 23:50:16 +0200
Message-Id: <20210802215024.949616-1-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Eric recently suggested that removing prefix 'platform_' from function names in xfsprogs could be a good idea.

It seems to be a relict from times when support from other OSes was expected. Since it does not seem to happen it might be a good idea to remove the prefix and thus simplify the codebase a bit.

The core of the changes is in removing 'platform' wrappers around standard linux calls and fixing the passed parameters from pointers to actual values (if appropriate) e.g.

-static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	uuid_copy(*dst, *src);
-}
... 
-		platform_uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
+		uuid_copy(hdr3->uuid, mp->m_sb.sb_meta_uuid);



I attached first WIP version (that builds and passes my limited testing) to show the scope of changes and find consensus about some choices that need to be done:

 * Is renaming platform_defs.h.in -> defs.h.in OK?
 * is renaming libfrog/platform.h -> libfrog/common.h OK, maybe libfrog/libfrog.h is better?
 * Wrapper platform_nproc() defined in/libfrog/linux.c slightly changes the behavior of nproc() is renaming it to libfrog_nproc() OK?
 * What would be best for the reviewer - should I prepare a separate patch for every function rename or should I squash the changes into one huge patch?
 
Thanks! 

Pavel Reichl (8):
  xfsprogs: Rename platform_defs.h.in -> defs.h.in
  xfsprogs: Rename platform.h -> common.h
  xfsprogs: remove platform_uuid_compare()
  xfsprogs: remove platform_{test_xfs_fd,path,fstatfs}
  xfsprogs: Rename platform_getoptreset -> getoptreset
  xfsprogs: remove all platform_ prefixes in linux.h
  xfsprogs: Remove platform_ prefixes in libfrog/common.h
  xfsprogs: remove platform_ from man xfsctl man page

 .gitignore                                |  2 +-
 Makefile                                  | 10 ++--
 configure.ac                              |  2 +-
 copy/xfs_copy.c                           | 26 +++++-----
 db/command.c                              |  2 +-
 db/fprint.c                               |  2 +-
 db/sb.c                                   | 14 ++---
 debian/rules                              |  4 +-
 fsr/xfs_fsr.c                             |  8 +--
 growfs/xfs_growfs.c                       |  2 +-
 include/Makefile                          |  4 +-
 include/{platform_defs.h.in => defs.h.in} |  8 +--
 include/libxfs.h                          |  2 +-
 include/linux.h                           | 62 ++++-------------------
 io/bmap.c                                 |  2 +-
 io/bulkstat.c                             |  2 +-
 io/cowextsize.c                           |  2 +-
 io/crc32cselftest.c                       |  2 +-
 io/encrypt.c                              |  2 +-
 io/fiemap.c                               |  2 +-
 io/fsmap.c                                |  2 +-
 io/fsync.c                                |  2 +-
 io/init.c                                 |  4 +-
 io/label.c                                |  2 +-
 io/log_writes.c                           |  2 +-
 io/open.c                                 |  4 +-
 io/stat.c                                 |  2 +-
 io/sync.c                                 |  2 +-
 libfrog/avl64.c                           |  2 +-
 libfrog/bitmap.c                          |  2 +-
 libfrog/common.h                          | 26 ++++++++++
 libfrog/convert.c                         |  2 +-
 libfrog/crc32.c                           |  2 +-
 libfrog/fsgeom.c                          |  2 +-
 libfrog/linux.c                           | 30 +++++------
 libfrog/paths.c                           |  2 +-
 libfrog/paths.h                           |  2 +-
 libfrog/platform.h                        | 26 ----------
 libfrog/projects.h                        |  2 +-
 libfrog/ptvar.c                           |  2 +-
 libfrog/radix-tree.c                      |  2 +-
 libfrog/topology.c                        |  8 +--
 libfrog/util.c                            |  2 +-
 libhandle/handle.c                        |  2 +-
 libhandle/jdm.c                           |  2 +-
 libxcmd/command.c                         |  4 +-
 libxcmd/help.c                            |  2 +-
 libxcmd/input.c                           |  2 +-
 libxcmd/quit.c                            |  2 +-
 libxfs/init.c                             | 34 ++++++-------
 libxfs/libxfs_io.h                        |  2 +-
 libxfs/libxfs_priv.h                      |  5 +-
 libxfs/rdwr.c                             |  6 +--
 libxfs/xfs_ag.c                           |  6 +--
 libxfs/xfs_attr_leaf.c                    |  2 +-
 libxfs/xfs_attr_remote.c                  |  2 +-
 libxfs/xfs_btree.c                        |  4 +-
 libxfs/xfs_da_btree.c                     |  2 +-
 libxfs/xfs_dir2_block.c                   |  2 +-
 libxfs/xfs_dir2_data.c                    |  2 +-
 libxfs/xfs_dir2_leaf.c                    |  2 +-
 libxfs/xfs_dir2_node.c                    |  2 +-
 libxfs/xfs_dquot_buf.c                    |  2 +-
 libxfs/xfs_ialloc.c                       |  4 +-
 libxfs/xfs_inode_buf.c                    |  2 +-
 libxfs/xfs_sb.c                           |  6 +--
 libxfs/xfs_symlink_remote.c               |  2 +-
 libxlog/util.c                            |  8 +--
 logprint/log_misc.c                       |  2 +-
 man/man3/xfsctl.3                         |  9 +---
 mdrestore/xfs_mdrestore.c                 |  4 +-
 mkfs/xfs_mkfs.c                           | 22 ++++----
 quota/free.c                              |  2 +-
 repair/agheader.c                         | 16 +++---
 repair/attr_repair.c                      |  2 +-
 repair/dinode.c                           |  8 +--
 repair/phase4.c                           |  6 +--
 repair/phase5.c                           |  6 +--
 repair/phase6.c                           |  2 +-
 repair/prefetch.c                         |  2 +-
 repair/scan.c                             |  4 +-
 repair/slab.c                             |  2 +-
 repair/xfs_repair.c                       |  8 +--
 scrub/common.c                            |  2 +-
 scrub/descr.c                             |  2 +-
 scrub/disk.c                              |  6 +--
 scrub/fscounters.c                        |  2 +-
 scrub/inodes.c                            |  2 +-
 scrub/xfs_scrub.c                         |  2 +-
 spaceman/health.c                         |  2 +-
 spaceman/init.c                           |  2 +-
 91 files changed, 235 insertions(+), 281 deletions(-)
 rename include/{platform_defs.h.in => defs.h.in} (95%)
 create mode 100644 libfrog/common.h
 delete mode 100644 libfrog/platform.h

-- 
2.31.1

