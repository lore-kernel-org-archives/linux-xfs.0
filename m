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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21965C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF96665210
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCHPvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCHPvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:23 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E1C06174A;
        Mon,  8 Mar 2021 07:51:23 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t29so7310346pfg.11;
        Mon, 08 Mar 2021 07:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6mjWYIMogNxuJMCYiyQXysGIFgAPuM6rxYlJwDtj6bI=;
        b=ur7f++TEUfG1BwwqLtPgRwXoKmswn/rGIoaV2Ouqgr0UjBMH7Qo4v805Scc1M+NchL
         raaZ0BTzzZnJ/k5pvGacv/kTvN/wSQ8PgjZbVqn4TFem5eXPH3RlizmUDsiwUwKCrVO2
         l99ZrXa/Xf6UUdygb1Gz7QdaB+KDmwaF+pa4x84dH3dBYd64SPqJFRKLFDRhfNnzCDPI
         2KpXr2FZJ/DqQyB7Gyn6DT13tfyUqqXZXHgyHLdqg5bm5r+VJbidpN+QoOax+Ibmdy1a
         frLpQm+mJwGVjFRWMGy+DuEd6hhqsOv7TPHFnEOtmCHQpkq7Uawvj3Zlm5VIKbILkP3F
         3afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6mjWYIMogNxuJMCYiyQXysGIFgAPuM6rxYlJwDtj6bI=;
        b=ouGbtakP20V7yfzAh3nt89KLlcnD9pxKrcnsKwtVpo6a+e1KgDzWQSAWxsjBWLFU5q
         GVCUpUB6a1KIr8/K6hJ63Ljhu9KZ3/vjja9Lm1rJU6+C8m/OFbVOdB+/yCAvwT0W/8q2
         QgpMmvG1+r2rB9p4yd1wmjBwEHtaR4Cq5qw6rI4+OUaFYIImIOZ+nIMf/FLD1nR6PO8o
         SdgpAAAxDYsjc7+F+00+iaVtUFsY5lH0dSX9eR+jqHJGWkrVc2zKjEVYOo1CnjmjP3KT
         nDIuWK1FYpG9qQKR7WRSZv8zn9DmGdTBa6XYTjr3fGMtN+z2XivyPolU7q4iJSowQMDy
         2DAA==
X-Gm-Message-State: AOAM53169ESS1GgKkgj6aYhjoBo61al3EhWKEAR/GaZOrcPmkN/EHu2q
        MHxI9WlGtVyz36fYDSxCb5oFuxdG7fo=
X-Google-Smtp-Source: ABdhPJxIMbPWRtA3e2Y3oOQfFgO15ebaitjLqlcNnWZOXlCtmJTeRQY868mogP3cE2iA6QzNzYgyJw==
X-Received: by 2002:a05:6a00:1a01:b029:1da:a7ee:438f with SMTP id g1-20020a056a001a01b02901daa7ee438fmr22185061pfv.77.1615218682943;
        Mon, 08 Mar 2021 07:51:22 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:22 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 00/13] xfs: Tests to verify inode fork extent count overflow detection
Date:   Mon,  8 Mar 2021 21:20:58 +0530
Message-Id: <20210308155111.53874-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patchset at
https://lore.kernel.org/linux-xfs/20210110160720.3922965-1-chandanrlinux@gmail.com/T/
added support for XFS to detect inode extent count overflow when
performing various filesystem operations. The patchset also added
new error injection tags for,
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

 common/xfs        |  36 +++++++++
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
 22 files changed, 1339 insertions(+)
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

