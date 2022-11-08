Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5C6C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 17:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiKHRYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 12:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiKHRYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 12:24:42 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2773EBA7
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 09:24:40 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id c8so10659622qvn.10
        for <linux-xfs@vger.kernel.org>; Tue, 08 Nov 2022 09:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leadboat.com; s=google;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHzWLL+u/UiJB2XFqIHacCz2/roDkwWUvxzh1O9k0JQ=;
        b=UMDPcSJkE6VyCa8h3pJYKE1q/2mpXf5U0BkkdFWBsnICaeNm6Ew6xk4cLI/+dHXOEK
         4ULfO0fEAG7BiFKp6bb7q/uBW2oZaqZ8lFAb3WYa73Xoa5fDQDCewH6Ud4Z0ntc0d6Fp
         MsGMK5UvPWwGIXxSCQar39tPvmv++KovcRgoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHzWLL+u/UiJB2XFqIHacCz2/roDkwWUvxzh1O9k0JQ=;
        b=LHO5L7oCiMHBbRmk4vAdf8pCAYDVces3aFONSg2aSybmT2E1bNItuSxqXtEt1D66GG
         XXyhSznq3EK/o7rZnCi5LpU5rfq9Z3dkk8nNUB/YACrwesPpqg8KcXEQ0FRhg5Cu5WnQ
         w2VqKrmhBmVDVU6aCfKlEQtW62FJM/SZ9Gi9k2B6QpYEhX17wMKr7406fjLCj+6N5t0y
         X5SMqPtkURiKgogBMqXtcwcC6Yspsu5mYa5+MPawjJ/HirjEleRYK6i3uS2szy/S9IL3
         lxaM93SrC7twj+AHMORpsseFh30czWuMo3tR57F+J8ogD64zmvX7MUnpUpn/ZOBSWBYN
         0zRg==
X-Gm-Message-State: ACrzQf1UoCOfJKpce6YXaTDTUTP/cF0Jo8dMOM+1j8qMTgr6EE7YVRqJ
        drB384QwybKLiKNyoB+lHf7NkA3Mj41vHZyY
X-Google-Smtp-Source: AMsMyM4cY+WjP7TieBRGviMYEZwxtOqgNxgp/7c7F7F1NI7Nxh/rzXh9TEqNz45Br2WzuqTQhwMyGg==
X-Received: by 2002:a05:6214:19e3:b0:4b6:8a99:3054 with SMTP id q3-20020a05621419e300b004b68a993054mr50298064qvc.108.1667928278983;
        Tue, 08 Nov 2022 09:24:38 -0800 (PST)
Received: from rfd.leadboat.com ([2600:1702:a20:5750::2e])
        by smtp.gmail.com with ESMTPSA id ga23-20020a05622a591700b00399ad646794sm8525897qtb.41.2022.11.08.09.24.38
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Nov 2022 09:24:38 -0800 (PST)
Date:   Tue, 8 Nov 2022 09:24:36 -0800
From:   Noah Misch <noah@leadboat.com>
To:     linux-xfs@vger.kernel.org
Subject: After block device error, FICLONE and sync_file_range() make NULs,
 unlike read()
Message-ID: <20221108172436.GA3613139@rfd.leadboat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Scenario: due to a block device error, the kernel fails to persist some file
content.  Even so, read() always returns the file content accurately.  The
first FICLONE returns EIO, but every subsequent FICLONE or copy_file_range()
operates as though the file were all zeros.  How feasible is it change FICLONE
and copy_file_range() such that they instead find the bytes that read() finds?

- Kernel is 6.0.0-1-sparc64-smp from Debian sid, running in a Solaris-hosted VM.

- The VM is gcc202 from https://cfarm.tetaneutral.net/machines/list/.
  Accounts are available.

- The outcome is still reproducible in FICLONE issued two days after the
  original block device error.  I haven't checked whether it survives a
  reboot.

- The "sync" command did not help.

- The block device errors have been ongoing for years.  If curious, see
  https://postgr.es/m/CA+hUKGKfrXnuyk0Z24m8x4_eziuC3kLSaCmEeKPO1DVU9t-qtQ@mail.gmail.com
  for details.  (Fixing the sunvdc driver is out of scope for this thread.)
  Other known symptoms are failures in truncate() and fsync().  The system has
  been generally usable for applications not requiring persistence.  I saw the
  FICLONE problem after the system updated coreutils from 8.32-4.1 to 9.1-1.
  That introduced a "cp" that uses FICLONE.  My current workaround is to place
  a "cp" in my PATH that does 'exec /usr/bin/cp --reflink=never "$@"'


The trouble emerged at a "cp".  To capture more details, I replaced "cp" with
"trace-cp" containing:

  sum "$1"
  strace cp "$@" 2>&1 | sed -n '/^geteuid/,$p'
  sum "$2"

Output from that follows.  FICLONE returns EIO.  "cp" then falls back to
copy_file_range(), which yields an all-zeros file:

  47831 16384 pg_wal/000000030000000000000003
  geteuid()                               = 1450
  openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
  fstatat64(AT_FDCWD, "pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
  openat(AT_FDCWD, "pg_wal/000000030000000000000003", O_RDONLY) = 4
  fstatat64(4, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
  openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_WRONLY|O_CREAT|O_EXCL, 0600) = 5
  ioctl(5, BTRFS_IOC_CLONE or FICLONE, 4) = -1 EIO (Input/output error)
  fstatat64(5, "", {st_mode=S_IFREG|0600, st_size=0, ...}, AT_EMPTY_PATH) = 0
  fadvise64_64(4, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
  copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 16777216
  copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 0
  close(5)                                = 0
  close(4)                                = 0
  _llseek(0, 0, [0], SEEK_CUR)            = 0
  close(0)                                = 0
  close(1)                                = 0
  close(2)                                = 0
  exit_group(0)                           = ?
  +++ exited with 0 +++
  00000 16384 /home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003

Subsequent FICLONE returns 0 and yields an all-zeros file.  Test script:

  set -x
  broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  dest=$HOME/tmp/discard
  sum "$broken_source"
  : 'FICLONE returns 0 and yields an all-zeros file'
  strace cp --reflink=always "$broken_source" "$dest" 2>&1 | sed -n '/^geteuid/,$p'
  sum "$dest"; rm "$dest"
  : 'copy_file_range() returns 0 and yields an all-zeros file'
  strace -e copy_file_range cat "$broken_source" >"$dest"
  sum "$dest"; rm "$dest"
  : 'read() gets the intended bytes'
  cat "$broken_source" | cat >"$dest"
  sum "$dest"; rm "$dest"

Test script output:

  + broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  + dest=/home/nm/tmp/discard
  + sum t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  49522 16384 t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  + : FICLONE returns 0 and yields an all-zeros file
  + strace cp --reflink=always t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003 /home/nm/tmp/discard
  + sed -n /^geteuid/,$p
  geteuid()                               = 1450
  openat(AT_FDCWD, "/home/nm/tmp/discard", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
  fstatat64(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
  openat(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", O_RDONLY) = 3
  fstatat64(3, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
  openat(AT_FDCWD, "/home/nm/tmp/discard", O_WRONLY|O_CREAT|O_EXCL, 0600) = 4
  ioctl(4, BTRFS_IOC_CLONE or FICLONE, 3) = 0
  close(4)                                = 0
  close(3)                                = 0
  _llseek(0, 0, 0x7feffddf1c0, SEEK_CUR)  = -1 ESPIPE (Illegal seek)
  close(0)                                = 0
  close(1)                                = 0
  close(2)                                = 0
  exit_group(0)                           = ?
  +++ exited with 0 +++
  + sum /home/nm/tmp/discard
  00000 16384 /home/nm/tmp/discard
  + rm /home/nm/tmp/discard
  + : copy_file_range() returns 0 and yields an all-zeros file
  + strace -e copy_file_range cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 16777216
  copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 0
  +++ exited with 0 +++
  + sum /home/nm/tmp/discard
  00000 16384 /home/nm/tmp/discard
  + rm /home/nm/tmp/discard
  + : read() gets the intended bytes
  + cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
  + cat
  + sum /home/nm/tmp/discard
  49522 16384 /home/nm/tmp/discard
  + rm /home/nm/tmp/discard
