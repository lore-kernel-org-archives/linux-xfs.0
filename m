Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F51C4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F19A652B8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCIFB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhCIFBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:41 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B55C06174A;
        Mon,  8 Mar 2021 21:01:41 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fu20so234227pjb.2;
        Mon, 08 Mar 2021 21:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u5jAB3VlWN/9KmXAwJUhmffuTftHpUzpkLCYTZuII6I=;
        b=pWVq2ee+MrhOo6n968XWOmvBSWxro40a4IDAEpi8a5Net0MnMi6IhXngRcPW+r1SB+
         R2/q6d0LlY5A+RHY2UFQafwj3ULkpMwJ1FSWriqS9GJhnAe+tjNkDQyfXwmOeCN+gGzS
         tISWv5lqynY873RiS90o/7Af49/W/nhrND4zUihIwUYEbmSb1eiTRbAopNTadECLnQO+
         T16Cigw86WAzoihpVk1/emJFdz++YSgPphpTXUEzlsK+pqlO5fIzy0cwc6aNRJhRteQE
         Srdt1fx8djNJVGSW/8sq0a0VoMFdDJ+XAgmrGDQ/07/vHcBlaM6XJHQmTM0CVl8Ixy+Y
         xWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u5jAB3VlWN/9KmXAwJUhmffuTftHpUzpkLCYTZuII6I=;
        b=lnP+2xaOheAH3vQW3WCMcky/1jMPjNzqlRFSnFSGKpGouse4KLEoc910z+iXrYqk4D
         X27gqKJfyy0wqKv6KnVtsJmWdPU5f3vxMTUumgcDfvYmnHFsZ8zRl+469tHzbu2Rgdvz
         oMG0EjTtHxVHLKjdI52tHGjOsWHNXAKHaFM5ytj62qldNbJT1fRaqqSe63trcukltQ6A
         NFaAlKWyhpkpJxH2CyK2Po8WXCi51a7I/SZs0BQAqQF5Vw/DMrNJXDQl1S/SwSp6uYwB
         XQWFyBQlMYZEOEP9OW4JEUK/VOrD1ayXwzvX+C7hUd17KOePTpOgdpdtoHESdRA+CQip
         zAeQ==
X-Gm-Message-State: AOAM53298MSNx0ZKYkaxgbe0e/cNWZVAxxRxhcSpU6fsgVKPlfrf8sjh
        PRLhcGbqz8E4d2cW4m5Y5BDKmtFzpp0=
X-Google-Smtp-Source: ABdhPJwyIYDuaB/58Qo+lUwBotWkCeSM0dxeLPtHFsWqvGSo/OcxvCdaahdU3slUilSY3z95/KTU3w==
X-Received: by 2002:a17:902:ff0d:b029:e4:a497:fdad with SMTP id f13-20020a170902ff0db02900e4a497fdadmr23862011plj.33.1615266100653;
        Mon, 08 Mar 2021 21:01:40 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:40 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 00/13] xfs: Tests to verify inode fork extent count overflow detection
Date:   Tue,  9 Mar 2021 10:31:11 +0530
Message-Id: <20210309050124.23797-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS in Linux-v5.12-rc1 gained support for preventing inode extent
count overflow when performing various filesystem operations. Also,
new error injection tags were added for,
1. Reducing maximum extent count to 10.
2. Allocating only single block sized extents.

The corresponding code for xfsprogs can be obtained from
https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/.

The patches posted along with this cover letter add tests to verify
the correctness of in-kernel inode extent count overflow detection
mechanism.

These patches can also be obtained from
https://github.com/chandanr/xfstests.git at branch
extent-overflow-tests.

Changelog:
V5 -> V6:
  1. Rename xfs_get_fsxattr() helper to _xfs_get_fsxattr().
  2. Add a comment in _check_xfs_filesystem() describing as to why we
     need to invoke syncfs before executing scrub.
  3. Streamline code inside _scratch_get_iext_count() and _xfs_get_fsxattr().


V4 -> V5:
  1. Introduce and use new helper to extract an inode's fsxattr fields.
  2. Issue syncfs() call before executing xfs_scrub.
  3. Invoke syncfs before executing xfs_scrub.
  4. Use _scratch_xfs_get_metadata_field() helper to obtain on-disk data
     structure values.
  5. Declare local variables in _scratch_get_iext_count().
  6. Use _reflink and _reflink_range helpers instead of using xfs_io directly.
  7. Set realtime extent size to 4k with FS block size is less than 4k.
  8. Mark test as "not run" when synthetically constructed realtime fs fails to
     mount.
  9. Update copyright year.

V3 -> V4:
  1. Rebase on fstests' latest master branch.

V2 -> V3:
  1. Kernel's max pseudo extent count is once again set to 10. Hence
     change the tests back to using 10 as the maximum extent count.
  2. The following tests associated with directories have been removed
     since directory remove and rename operations are not expected to
     fail (with -EFBIG error code) in low inode extent count
     scenarios:
     - Populate source directory and mv one entry to destination
       directory.
     - Populate a directory and remove one entry.

V1 -> V2:
  1. Obtain extent count for inodes accessible through filesystem path
     names via "xfs_io -c 'stat' ..." command line. This gets rid of
     unmount/mount cycles from most of the tests.
  2. Use _fill_fs() to consume free space of a filesystem.
  3. Use _scratch_inject_error() helper to enable/disable error tags.
  4. Use sizeof(struct xfs_dqblk) to calculate number of quotas inside
     one filesystem block.
  5. Write once to every block of the quota inode instead of
     sequentially filling up each block.
  6. Use _get_file_block_size() for tests involving regular files.
  7. Modify tests to suit the new pseudo max extent count of 35.
  8. Replace xfs_io with $XFS_IO_PROG.
  9. Remove code that extended a realtime file since this takes the
     same path as direct I/O to a regular file.
  10. For xattr, do not execute test script when block size is < 4k.
  11. Add code to test if removing an xattr from a full attribute fork
      succeeds.
  12. Add code to test if removing a file whose attribute fork is full
      succeeds.
  13. Add code to test if removing a entry from a full directory
      succeeds.
  14. Add code to test if removing a full directory succeeds.
  15. Writing to unwritten extents: Integrate buffered and direct I/O
      tests into a for loop.
  16. Writing to a shared extent test: Add test to check funshare
      operation.
  17. Use _scale_fsstress_args() to scale values for "-p" and "-n"
      arguments for fsstress.

Chandan Babu R (13):
  _check_xfs_filesystem: sync fs before running scrub
  common/xfs: Add a helper to get an inode fork's extent count
  common/xfs: Add helper to obtain fsxattr field value
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when growing realtime bitmap/summary
    inodes
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Stress test with bmap_alloc_minlen_extent error tag enabled

 common/xfs        |  40 ++++++++++
 tests/xfs/528     | 171 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  20 +++++
 tests/xfs/529     | 124 +++++++++++++++++++++++++++++++
 tests/xfs/529.out |  11 +++
 tests/xfs/530     |  83 +++++++++++++++++++++
 tests/xfs/530.out |  19 +++++
 tests/xfs/531     | 139 +++++++++++++++++++++++++++++++++++
 tests/xfs/531.out |  18 +++++
 tests/xfs/532     | 182 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/532.out |  17 +++++
 tests/xfs/533     |  84 +++++++++++++++++++++
 tests/xfs/533.out |  11 +++
 tests/xfs/534     | 104 ++++++++++++++++++++++++++
 tests/xfs/534.out |  12 +++
 tests/xfs/535     |  81 +++++++++++++++++++++
 tests/xfs/535.out |   8 ++
 tests/xfs/536     | 105 ++++++++++++++++++++++++++
 tests/xfs/536.out |  13 ++++
 tests/xfs/537     |  84 +++++++++++++++++++++
 tests/xfs/537.out |   7 ++
 tests/xfs/group   |  10 +++
 22 files changed, 1343 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out
 create mode 100755 tests/xfs/532
 create mode 100644 tests/xfs/532.out
 create mode 100755 tests/xfs/533
 create mode 100644 tests/xfs/533.out
 create mode 100755 tests/xfs/534
 create mode 100644 tests/xfs/534.out
 create mode 100755 tests/xfs/535
 create mode 100644 tests/xfs/535.out
 create mode 100755 tests/xfs/536
 create mode 100644 tests/xfs/536.out
 create mode 100755 tests/xfs/537
 create mode 100644 tests/xfs/537.out

-- 
2.29.2

