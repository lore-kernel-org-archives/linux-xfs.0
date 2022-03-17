Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6793AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 05:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiCQF5A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 01:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCQF5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 01:57:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DD72E6265
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:32:17 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so3581011plo.9
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhowytCvTlGnoIf/Rsq9wOTm3cPDDmyiEHJ3MOyEvWQ=;
        b=eVxMOGdFnUkf+YMyJZ37xP3iFtKbW7k2mAWmowg9nByci5gN15TPdCXGigsk8EnINZ
         9ct44CNuZZa7FQRQEXwntKZ2K8dbdj4o5Z+Lbf5WyMHqKr/5VXemnYcmSEeRwmU5HBov
         TylIdnafbdQBxECXLOlGSUjTBuMFJZ/gv04LCLq5BMk0uerWI/pVLOg/nRR85Rbp+sBr
         yOnHw4nobyu/bCcRsVIhsw7ci8SGAdJQBfYQClqkYhej9LsQ6wbAie8Mqvr0l/u1pyPp
         FqXIKcLHbW6ATCZWIT3Asvc69Tir9RP6zo3rV3NPKj+0Ei+MrufJu5OsOeSb5vY7plGR
         nowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhowytCvTlGnoIf/Rsq9wOTm3cPDDmyiEHJ3MOyEvWQ=;
        b=DDLY5Nt7OQmvGyxZxnWlopUTQk7qbEQOzGSoIYJJoUoEjM7RaJpwqErmbbwUieQVkt
         /wjjyl9Xom4ZTQSnPV4lMMJps+N5isChyDQ5Y0fVpvzmkJ6XsivQcTM4+dslWCvW25hh
         v89cXYqpRxZCJ1bgDIgSJbeQjvJtfWuhpctO93UldiuA2+tNpTXcynvGJggdcs9Lf5Yj
         Hvy3WfcbcOFPKkMbBvdjZrRNy0pfAgsWlic93qwzkiJqkWL3vvAju+oeNBjdsN1H5IwF
         Do1rdV6KX7NqPJ5Csh1tAHD6wpQ6unt7uD5i1babi/kqSNTNHUSIFgDbVgtE/bJVZ/w8
         i3Ow==
X-Gm-Message-State: AOAM532AwuzPAtsl1/9J3XGvdj2p5/6faB2iSLbG1GnmkI85Y6vd47bD
        ggLjaXg5crry5Q5aFoyDVimA4VPJ5WMSVq/LI44=
X-Google-Smtp-Source: ABdhPJwV6+5IzVTDyWguV66tZUK50Hs4Xd6KNI5ZjcjKiGLajamb/FNrzSeJzEvfDuEfLUdT145EdQ==
X-Received: by 2002:a17:902:bb92:b0:153:4eae:c77e with SMTP id m18-20020a170902bb9200b001534eaec77emr3313633pls.93.1647495136350;
        Wed, 16 Mar 2022 22:32:16 -0700 (PDT)
Received: from banyan.jof.github.beta.tailscale.net ([2600:1700:2f74:11f:a6ae:11ff:fe14:a442])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm5416537pfj.146.2022.03.16.22.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 22:32:15 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v0 2/2] Add XFS messages to printk index
Date:   Wed, 16 Mar 2022 22:32:08 -0700
Message-Id: <a2fd7e312c7cf4e899e44286848abb925d15b122.1647495044.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
References: <0bc6a322d6f9b812b1444b588b5036263f377455.1647495044.git.jof@thejof.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Don't actually merge this.

This just shows the printk format strings that were added to the printk
index after merging the macro wrappers.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
---
 xfs_printks.txt | 320 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 320 insertions(+)
 create mode 100644 xfs_printks.txt

diff --git a/xfs_printks.txt b/xfs_printks.txt
new file mode 100644
index 000000000000..eebaea142753
--- /dev/null
+++ b/xfs_printks.txt
@@ -0,0 +1,320 @@
+"%sXFS%s: [%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d"
+"%sXFS%s: AAIEEE! Log failed size checks. Abort!"
+"%sXFS%s: Access to block zero in inode %llu start_block: %llx start_off: %llx blkcnt: %llx extent-state: %x"
+"%sXFS%s: AGF corruption. Please run xfs_repair."
+"%sXFS%s: AG %u: Corrupt btree %d pointer at level %d index %d."
+"%sXFS%s: AIL initialisation failed: error %d"
+"%sXFS%s: alignment check failed: sunit(%d) less than bsize(%d)"
+"%sXFS%s: alignment check failed: sunit/swidth vs. agsize(%d)"
+"%sXFS%s: alignment check failed: sunit/swidth vs. blocksize(%d)"
+"%sXFS%s: All device paths lost. Shutting down filesystem"
+"%sXFS%s: Allocated a known in-use inode 0x%llx!"
+"%sXFS%s: Assertion failed: %s, file: %s, line: %d"
+"%sXFS%s: Attempted to mount read-only compatible filesystem read-write."
+"%sXFS%s: bad buffer log item size (%d)"
+"%sXFS%s: Bad inode buffer log record (ptr = %p, bp = %p). Trying to replay bad (0) inode di_next_unlinked field."
+"%sXFS%s: bad magic number"
+"%sXFS%s: bad number of regions (%d) in inode log format"
+"%sXFS%s: bad version"
+"%sXFS%s: Bad XFS transaction clientid 0x%x in ticket %p"
+"%sXFS%s: buffer item dirty bitmap (%u uints) too small to reflect %u bytes!"
+"%sXFS%s:   buf len\t= %d"
+"%sXFS%s:   bytes\t= %d"
+"%sXFS%s: cannot change alignment: superblock does not support data alignment"
+"%sXFS%s: Cannot change stripe alignment; would require moving root inode."
+"%sXFS%s: cannot mount a read-only filesystem as read-write"
+"%sXFS%s: Cannot mount a V5 filesystem as noattr2. attr2 is always enabled for V5 filesystems."
+"%sXFS%s: Cannot mount filesystem with identical rtdev and ddev/logdev."
+"%sXFS%s: Cannot set_blocksize to %u on device %pg"
+"%sXFS%s: Cannot turn on quotas for realtime filesystem"
+"%sXFS%s: Clearing xfsstats"
+"%sXFS%s: Continuing onwards, but if log hangs are experienced then please report this message in the bug report."
+"%sXFS%s: correcting sb_features alignment problem"
+"%sXFS%s: corrupt dinode %llu, (btree extents)."
+"%sXFS%s: corrupt dquot ID 0x%x in log at %pS"
+"%sXFS%s: corrupt dquot ID 0x%x in memory at %pS"
+"%sXFS%s: corrupted root inode %llu: not a directory"
+"%sXFS%s: corrupt inode %Lu ((a)extents = %d)."
+"%sXFS%s: corrupt inode %Lu (bad size %d for local fork, size = %d)."
+"%sXFS%s: corrupt inode %Lu (btree)."
+"%sXFS%s: Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!"
+"%sXFS%s: Corruption detected! Free inode 0x%llx has blocks allocated!"
+"%sXFS%s: Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)"
+"%sXFS%s: Corruption detected in superblock compatible features (0x%x)!"
+"%sXFS%s: Corruption detected in superblock incompatible features (0x%x)!"
+"%sXFS%s: Corruption detected in superblock incompatible log features (0x%x)!"
+"%sXFS%s: Corruption detected in superblock read-only compatible features (0x%x)!"
+"%sXFS%s: Corruption detected. Unmount and run xfs_repair"
+"%sXFS%s: Corruption of in-memory data detected.  Shutting down filesystem"
+"%sXFS%s: Corruption warning: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). Please unmount and run xfs_repair (>= v4.3) to resolve."
+"%sXFS%s: could not allocate realtime summary cache"
+"%sXFS%s:   ctx ticket: %d bytes"
+"%sXFS%s: ctx ticket reservation ran out. Need to up reservation"
+"%sXFS%s:   current res = %d bytes"
+"%sXFS%s: DAX and reflink cannot be used together!"
+"%sXFS%s: DAX enabled. Warning: EXPERIMENTAL, use at your own risk"
+"%sXFS%s: DAX unsupported by block device. Turning off DAX."
+"%sXFS%s: Delaying log recovery for %d seconds."
+"%sXFS%s: Delaying mount for %d seconds."
+"%sXFS%s: device supports %u byte sectors (not %u)"
+"%sXFS%s: dirty log entry has mismatched uuid - can't recover"
+"%sXFS%s: dirty log written in incompatible format - can't recover"
+"%sXFS%s: discard failed for extent [0x%llx,%u], error %d"
+"%sXFS%s: dquot corrupt at %pS trying to replay into block 0x%llx"
+"%sXFS%s: dquot too small (%d) in %s."
+"%sXFS%s: empty log check failed"
+"%sXFS%s: Ending clean mount"
+"%sXFS%s: Ending recovery (logdev: %s)"
+"%sXFS%s: error allocating secondary superblock for ag %d"
+"%sXFS%s: Error %d freeing per-AG metadata reserve pool."
+"%sXFS%s: Error %d recovering leftover CoW allocations."
+"%sXFS%s: Error %d reserving per-AG metadata reserve pool."
+"%sXFS%s: Failed dir/attr init: %d"
+"%sXFS%s: Failed per-ag init: %d"
+"%sXFS%s: Failed post-recovery per-ag init: %d"
+"%sXFS%s: failed to find log head"
+"%sXFS%s: Failed to initialize disk quotas."
+"%sXFS%s: failed to locate log tail"
+"%sXFS%s: Failed to read root inode 0x%llx, error %d"
+"%sXFS%s: failed to read RT inodes"
+"%sXFS%s: Failed to recover intents"
+"%sXFS%s: Failed to remove inode(s) from unlinked list. Please free space, unmount and run xfs_repair."
+"%sXFS%s: failed to write sb changes"
+"%sXFS%s: Failing async write on buffer block 0x%llx. Retrying async write."
+"%sXFS%s:  ... fblk is NULL"
+"%sXFS%s:  fblk %p blkno %llu index %d magic 0x%x"
+"%sXFS%s: Filesystem cannot be safely mounted by this kernel."
+"%sXFS%s: Filesystem can only be safely mounted read only."
+"%sXFS%s: Filesystem has a realtime volume, use rtdev=device option"
+"%sXFS%s: Filesystem has duplicate UUID %pU - can't mount"
+"%sXFS%s: Filesystem has null UUID - can't mount"
+"%sXFS%s: filesystem is marked as having an external log; specify logdev on the mount command line."
+"%sXFS%s: filesystem is marked as having an internal log; do not specify logdev on the mount command line."
+"%sXFS%s: filesystem size mismatch detected"
+"%sXFS%s: file system too large to be mounted on this system."
+"%sXFS%s: File system with blocksize %d bytes. Only pagesize (%ld) or less will currently work."
+"%sXFS%s: First %d bytes of corrupted metadata buffer:"
+"%sXFS%s:     first %d bytes of iovec[%d]:"
+"%sXFS%s:   flags     = 0x%x"
+"%sXFS%s:   flags\t= 0x%lx"
+"%sXFS%s:   GH   cycle = %d, GH   bytes = %d"
+"%sXFS%s: Inode block alignment (%u) must match chunk size (%u) for sparse inodes."
+"%sXFS%s: Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d."
+"%sXFS%s: inode size of %d bytes not supported"
+"%sXFS%s: Internal error %s at line %d of file %s.  Caller %pS"
+"%sXFS%s: Invalid block length (0x%x) for buffer"
+"%sXFS%s: Invalid device [%s], error=%d"
+"%sXFS%s: invalid iclog size (%d bytes), using lsunit (%d bytes)"
+"%sXFS%s: Invalid inode number 0x%Lx"
+"%sXFS%s: Invalid log block/length (0x%llx, 0x%x) for buffer"
+"%sXFS%s: invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]"
+"%sXFS%s: invalid logbufs value: %d [not %d-%d]"
+"%sXFS%s: invalid log iosize: %d [not %d-%d]"
+"%sXFS%s: invalid sparse inode record: ino 0x%llx holemask 0x%x count %u"
+"%sXFS%s: Invalid superblock magic number"
+"%sXFS%s: I/O Error Detected. Shutting down filesystem"
+"%sXFS%s:   iovec[%d]"
+"%sXFS%s: last sector read failed"
+"%sXFS%s:     len\t= %d"
+"%sXFS%s: Log allocation failed: No memory!"
+"%sXFS%s: logbuf size for version 1 logs must be 16K or 32K"
+"%sXFS%s: logbuf size must be greater than or equal to log stripe size"
+"%sXFS%s:   log count = %d"
+"%sXFS%s: log device read failed"
+"%sXFS%s: log has mismatched uuid - can't recover"
+"%sXFS%s: Log inconsistent (didn't find previous header)"
+"%sXFS%s: log I/O error %d"
+"%sXFS%s: Log I/O Error Detected. Shutting down filesystem"
+"%sXFS%s: log item: "
+"%sXFS%s: log item region count (%d) overflowed size (%d)"
+"%sXFS%s:   log items: %d bytes (iov hdrs: %d bytes)"
+"%sXFS%s: log mount failed"
+"%sXFS%s: log mount finish failed"
+"%sXFS%s: log mount/recovery failed: error %d"
+"%sXFS%s: log record CRC mismatch: found 0x%x, expected 0x%x."
+"%sXFS%s: log recovery %s I/O error at daddr 0x%llx len %d error %d"
+"%sXFS%s:   log res   = %d"
+"%sXFS%s: log sector size (0x%x) invalid for configuration."
+"%sXFS%s: Log sector size too large (0x%x > 0x%x)"
+"%sXFS%s: Log sector size too small (0x%x < 0x%x)"
+"%sXFS%s: Log size %d blocks too large, maximum size is %lld blocks"
+"%sXFS%s: Log size %d blocks too small, minimum size is %d blocks"
+"%sXFS%s: log size %lld bytes too large, maximum size is %lld bytes"
+"%sXFS%s: log size mismatch detected"
+"%sXFS%s: Log size out of supported range."
+"%sXFS%s: log stripe unit %u bytes must be a multiple of block size"
+"%sXFS%s: MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!"
+"%sXFS%s: Metadata corruption detected at %pS, %s block 0x%llx"
+"%sXFS%s: metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d"
+"%sXFS%s: Metadata %s detected at %pS, inode 0x%llx %s"
+"%sXFS%s: Metadata %s detected at %pS, %s block 0x%llx %s"
+"%sXFS%s: Mounting V%d Filesystem"
+"%sXFS%s: Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent."
+"%sXFS%s: mounting with \"discard\" option, but the device does not support discard"
+"%sXFS%s:   niovecs\t= %d"
+"%sXFS%s: [no]barrier is deprecated, ignoring. See T54323454."
+"%sXFS%s: no log defined"
+"%sXFS%s: no-recovery mounts must be read-only."
+"%sXFS%s: NULL dquot in %s."
+"%sXFS%s: null uuid in log - IRIX style log"
+"%sXFS%s:   num regions = %u"
+"%sXFS%s: Offline file system operation in progress!"
+"%sXFS%s:   ophdr + reg = %u bytes"
+"%sXFS%s:   ophdrs      = %u (ophdr space = %u bytes)"
+"%sXFS%s: Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x"
+"%sXFS%s: page discard on page %p, inode 0x%llx, offset %llu."
+"%sXFS%s: page discard unable to remove delalloc mapping."
+"%sXFS%s: Per-AG reservation for AG %u failed.  Filesystem may run out of space."
+"%sXFS%s: please mount with%s%s%s%s."
+"%sXFS%s: Please recover the log on a kernel that supports the unknown features."
+"%sXFS%s: Please run xfs_repair to determine the extent of the problem."
+"%sXFS%s: Please unmount the filesystem and rectify the problem(s)"
+"%sXFS%s: Quotacheck: Done."
+"%sXFS%s: Quotacheck: Failed to reset quota flags."
+"%sXFS%s: Quotacheck needed: Please wait."
+"%sXFS%s: Quotacheck: Unsuccessful (Error %d): Disabling quotas."
+"%sXFS%s: quota support not available in this kernel."
+"%sXFS%s: realtime device size check failed"
+"%sXFS%s: realtime mount -- %llu != %llu"
+"%sXFS%s: Refcount BTree record corruption in AG %d detected!"
+"%sXFS%s: reflink not compatible with realtime device!"
+"%sXFS%s: region[%u]: %s - %u bytes"
+"%sXFS%s: remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)"
+"%sXFS%s: resetting quota flags"
+"%sXFS%s: reverse mapping btree not compatible with realtime device!"
+"%sXFS%s: Reverse Mapping BTree record corruption in AG %d detected!"
+"%sXFS%s: ro->rw transition prohibited on norecovery mount"
+"%sXFS%s: ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem"
+"%sXFS%s: RT mount failed"
+"%sXFS%s: %s(0x%x) called from line %d of file %s. Return address = %p"
+"%sXFS%s: %s: agbno >= mp->m_sb.sb_agblocks (%d >= %d)."
+"%sXFS%s: %s: agno >= mp->m_sb.sb_agcount (%d >= %d)."
+"%sXFS%s: %s: attempting to delete a log item that is not in the AIL"
+"%sXFS%s: %s: bad clientid 0x%x"
+"%sXFS%s: %s: Bad directory inode %Lu, ptr %p"
+"%sXFS%s: %s: Bad dir inode log record, rec ptr %p, ino ptr = %p, ino bp = %p, ino %Ld"
+"%sXFS%s: %s: bad flag 0x%x"
+"%sXFS%s: %s: bad header length"
+"%sXFS%s: %s: bad header magic number"
+"%sXFS%s: %s: Bad inode log record length %d, rec ptr %p"
+"%sXFS%s: %s: Bad inode log record, rec ptr %p, dino ptr %p, dino bp %p, ino %Ld, forkoff 0x%x"
+"%sXFS%s: %s: Bad inode log record, rec ptr %p, dino ptr %p, dino bp %p, ino %Ld, total extents = %d, nblocks = %Ld"
+"%sXFS%s: %s: Bad inode log record, rec ptr %p, ino %Ld"
+"%sXFS%s: %s: bad inode %Lu, forkoff 0x%x, ptr %p"
+"%sXFS%s: %s: Bad inode %Lu magic number 0x%x, ptr %p"
+"%sXFS%s: %s: Bad inode magic number, dip = %p, dino bp = %p, ino = %Ld"
+"%sXFS%s: %s: bad length 0x%x"
+"%sXFS%s: %s: Bad regular inode log record, rec ptr %p, ino ptr = %p, ino bp = %p, ino %Ld"
+"%sXFS%s: %s: Bad regular inode %Lu, ptr %p"
+"%sXFS%s: sb_inprogress set after log recovery??"
+"%sXFS%s: %s: bno %u inode %llu"
+"%sXFS%s: SB sanity check failed"
+"%sXFS%s: SB stripe alignment sanity check failed"
+"%sXFS%s: SB stripe unit sanity check failed"
+"%sXFS%s: SB stripe width sanity check failed"
+"%sXFS%s: SB summary counter sanity check failed"
+"%sXFS%s: SB validate failed with error %d."
+"%sXFS%s: %s: couldn't find sync record"
+"%sXFS%s: %s: daddr 0x%llx out of range, EOFS 0x%llx"
+"%sXFS%s: %s: detected corrupt incore inode %Lu, total extents = %d, nblocks = %Ld, ptr %p"
+"%sXFS%s: %s: dir ino %llu needed freesp block %lld for data block %lld, got %lld"
+"%sXFS%s: %s: dquot reclaim failed"
+"%sXFS%s: %s failed (error %d)!"
+"%sXFS%s: %s: failed to clear agi %d. Continuing."
+"%sXFS%s: %s: failed to map pages"
+"%sXFS%s: %s: failed to map pagesn"
+"%sXFS%s: %s Freespace BTree record corruption in AG %d detected!"
+"%sXFS%s: %s: (im_blkno (0x%llx) + im_len (0x%llx)) > sb_dblocks (0x%llx)"
+"%sXFS%s: %s: inconsistent inode count and chunk length"
+"%sXFS%s: %s: inode (0x%llx) bad symlink length (%d)"
+"%sXFS%s: %s: inode 0x%llx format is incompatible for exchanging."
+"%sXFS%s: %s Inode BTree record corruption in AG %d detected!"
+"%sXFS%s: %s: inode (%llu) bad symlink length (%lld)"
+"%sXFS%s: %s: inode != XFS_AGINO_TO_INO() (%llu != %llu)."
+"%sXFS%s: %s: Invalid flag"
+"%sXFS%s: %s: invalid item type (%d)"
+"%sXFS%s:   size\t= %d"
+"%sXFS%s: Skipping superblock stripe alignment update."
+"%sXFS%s: %s: no buf ops on daddr 0x%llx len %d"
+"%sXFS%s: Sparse inode block alignment (%u) must match cluster size (%llu)."
+"%sXFS%s: %s: picked the wrong leaf? reverting original leaf: blk1->index %d"
+"%sXFS%s:   split region headers: %d bytes"
+"%sXFS%s: %s: possible infinite loop (%d iterations)"
+"%sXFS%s: %s required on read-only device."
+"%sXFS%s: %s: Superblock update failed!"
+"%sXFS%s: start block 0x%x block count 0x%x"
+"%sXFS%s: Start block 0x%x, block count 0x%x, references 0x%x"
+"%sXFS%s: Starting recovery (logdev: %s)"
+"%sXFS%s: start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x"
+"%sXFS%s: stripe width (%d) must be a multiple of the stripe unit (%d)"
+"%sXFS%s: %s: unable to clean up ino %lld"
+"%sXFS%s: sunit and swidth must be specified together"
+"%sXFS%s: sunit and swidth options incompatible with the noalign option"
+"%sXFS%s: %s: Unmount LR"
+"%sXFS%s: %s: unmount record failed"
+"%sXFS%s: %s: unrecognised log version (%d)."
+"%sXFS%s: %s: unrecognized type of log operation"
+"%sXFS%s: %s: unsupported chunk length"
+"%sXFS%s: Super block does not support project and group quota together"
+"%sXFS%s: Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits."
+"%sXFS%s: Superblock has unknown compatible features (0x%x) enabled."
+"%sXFS%s: Superblock has unknown incompatible features (0x%x) enabled."
+"%sXFS%s: Superblock has unknown incompatible log features (0x%x) enabled."
+"%sXFS%s: Superblock has unknown read-only compatible features (0x%x) enabled."
+"%sXFS%s: %s(%u) possible memory allocation deadlock in %s (mode:0x%x)"
+"%sXFS%s: %s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)"
+"%sXFS%s: %s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)"
+"%sXFS%s: %s: will fix summary counters at next mount"
+"%sXFS%s: %s: xfs_btree_delete returned error %d."
+"%sXFS%s: %s: xfs_ialloc_read_agi() returned error %d."
+"%sXFS%s: %s: xfs_ialloc_read_agi() returned error %d, agno %d"
+"%sXFS%s: %s: xfs_ifree returned error %d"
+"%sXFS%s: %s: xfs_imap returned error %d."
+"%sXFS%s: %s: xfs_imap_to_bp returned error %d."
+"%sXFS%s: %s: xfs_inobt_get_rec() returned error %d."
+"%sXFS%s: %s: xfs_inobt_lookup() returned error %d."
+"%sXFS%s: %s: xfs_inobt_update returned error %d."
+"%sXFS%s: %s: xfs_trans_commit returned error %d"
+"%sXFS%s: %s: xfs_trans_read_buf() returned error %d."
+"%sXFS%s: symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)"
+"%sXFS%s: Tail block (0x%llx) overwrite detected. Updated to 0x%llx"
+"%sXFS%s:   tail_cycle = %d, tail_bytes = %d"
+"%sXFS%s: The log can not be fully and/or safely recovered by this kernel."
+"%sXFS%s: ticket reservation summary:"
+"%sXFS%s: Torn write (CRC failure) detected at log block 0x%llx. Truncating head block from 0x%llx."
+"%sXFS%s: totally zeroed log"
+"%sXFS%s:   total reg   = %u bytes (o/flow = %u bytes)"
+"%sXFS%s: Transaction log reservation overrun:"
+"%sXFS%s: transaction summary:"
+"%sXFS%s: Transforming an alert into a BUG."
+"%sXFS%s:     type\t= 0x%x"
+"%sXFS%s:   type\t= 0x%x"
+"%sXFS%s: Unable to allocate reserve blocks. Continuing without reserve pool."
+"%sXFS%s: Unable to free reserved block pool. Freespace may not be correct on next mount."
+"%sXFS%s: Unable to update superblock counters. Freespace may not be correct on next mount."
+"%sXFS%s: Uncorrected metadata errors detected; please run xfs_repair."
+"%sXFS%s:   unit res    = %d bytes"
+"%sXFS%s: Unknown buffer type %d!"
+"%sXFS%s: unknown mount option [%s]."
+"%sXFS%s: Unmount and run xfs_repair"
+"%sXFS%s: Unmounting Filesystem"
+"%sXFS%s: User initiated shutdown received. Shutting down filesystem"
+"%sXFS%s: Using a more recent kernel is recommended."
+"%sXFS%s: using DEBUG-only always_cow mode."
+"%sXFS%s: v5 SB sanity check failed"
+"%sXFS%s: Version 5 of Super block has XFS_OQUOTA bits."
+"%sXFS%s: WARNING: partial inode chunk cancellation, skipped icreate."
+"%sXFS%s: WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. Please unmount and run xfs_repair."
+"%sXFS%s: write access unavailable, cannot proceed."
+"%sXFS%s: write error %d updating a secondary superblock near ag %d"
+"%sXFS%s: xfs_attr_quiesce: failed to log sb changes. Frozen image may not be consistent."
+"%sXFS%s: XFS: dquot too small (%d) in %s."
+"%sXFS%s: XFS: NULL dquot in %s."
+"%sXFS%s: xlog_recover_do_icreate_trans: bad agbno"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad agno"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad count"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad icl size"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad isize"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad length"
+"%sXFS%s: xlog_recover_do_icreate_trans: bad type"
+"%sXFS%s: xlog_space_left: head behind tail"
-- 
2.35.1

