Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119DEC4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 12:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbjKBMsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345965AbjKBMsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 08:48:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00E012F;
        Thu,  2 Nov 2023 05:48:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5862C433C9;
        Thu,  2 Nov 2023 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698929300;
        bh=6xeGbI1L+DfUU9h5pLLEoRq/boiO9OMP2yYIoh7hJ5I=;
        h=From:To:Cc:Subject:Date:From;
        b=O1jJwRfjZruxvUj0hqU9Y6g/JHMxGzSFXyKuDtSiTkl5uO2K/T8mc8cJfC2HE10CL
         9S1wFbm92AJPptjq5Nu35AHGU/AUiqx1MstMHyp0TAiZG+dO6g+Ey2EnBJGPT/Ko4v
         sGyu4v9lWaYhm1Bc0D5RqkUWg5xFhwTBLTWMgb1UHXr1+Z/dCAlTz2QS+umODv2TKS
         b0g6rS3KovF9ytieekI+cgGqWHVsrOVY5QhkUicDxaNKUK3zK+DNs+QXUceKFgXOZD
         z+FW7pRJcQFz/2f5pOGgyOK9vGDpRCurMpTkLIgg6TMQGZOF/HLlnUw/8Cjq4Vylqm
         h74Wn0BteriEw==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     brauner@kernel.org
Cc:     viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, linux-xfs@vger.kernel.org,
        dchinner@fromorbit.com
Subject: [BUG REPORT] next-20231102: generic/311 fails on XFS with external log
Date:   Thu, 02 Nov 2023 18:06:10 +0530
Message-ID: <87bkccnwxc.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

generic/311 consistently fails when executing on a kernel built from
next-20231102.

The following is the fstests config file that was used during testing.

export FSTYP=xfs

export TEST_DEV=/dev/loop0
export TEST_DIR=/mnt/test
export TEST_LOGDEV=/dev/loop2

export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt/scratch
export SCRATCH_LOGDEV=/dev/loop3

export USE_EXTERNAL=yes

export MKFS_OPTIONS="-f -m crc=1,reflink=1,rmapbt=1, -i sparse=1 -lsize=1g"


The following is the contents obtained from 311.out.bad.

QA output created by 311
Running test 1 buffered, normal suspend
Random seed is 1
ee6103415276cde95544b11b2675f132
device-mapper: suspend ioctl on flakey-logtest  failed: Device or resource busy
Command failed.
failed to suspend flakey-logtest


Git bisect revealed the following to be the first bad commit,

abcb2b94cce4fb7a8f84278e8da4d726837439d1
Author:     Christian Brauner <brauner@kernel.org>
AuthorDate: Wed Sep 27 15:21:16 2023 +0200
Commit:     Christian Brauner <brauner@kernel.org>
CommitDate: Sat Oct 28 13:29:24 2023 +0200

bdev: implement freeze and thaw holder operations

The old method of implementing block device freeze and thaw operations
required us to rely on get_active_super() to walk the list of all
superblocks on the system to find any superblock that might use the
block device. This is wasteful and not very pleasant overall.

Now that we can finally go straight from block device to owning
superblock things become way simpler.

Link: https://lore.kernel.org/r/20231024-vfs-super-freeze-v2-5-599c19f4faac@kernel.org
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>

--
Chandan
