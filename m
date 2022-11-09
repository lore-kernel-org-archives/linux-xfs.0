Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17801C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 16:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiKIQrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 11:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiKIQrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 11:47:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C2320192
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 08:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B22A561BC2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 16:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138F2C433D7;
        Wed,  9 Nov 2022 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668012436;
        bh=YNzzGzJt10KRIQnjU9KrlYLnVjTo+LrqNeX8K690qgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WGjMW7YYdlU4dmjzm+97+4HLOJ/omGteRjS7r923YL7oSovWAcNMyPxcKf21d2Iyn
         AtbRYMoYqNBNYg/7WOFnPq9zzmCLbF7+zYjS+mxEQ14lpMJGS8CXLa1F9AwgExTOJ+
         2GzwKcUpYChURb6doxAp6kRjMLLOGRw44DSPcgpWDj/gjhigtFIxIr0dfZ8x/7dfve
         AGSvb9UjMC+rKhzEuvLsJXG24eU6BlvVYcbDqrcH7NVZ9MdFa3faRnESdlgMx0Jkww
         zPxfDmEtkuvNjAmw+oPvNJW1hie1w4YS2W5ev6qB9P2rfHn94DaEKy47DbDc3PStNN
         ff1dCfoBpPGeg==
Date:   Wed, 9 Nov 2022 08:47:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Noah Misch <noah@leadboat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <Y2vZk7Wg0V8SvwxW@magnolia>
References: <20221108172436.GA3613139@rfd.leadboat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221108172436.GA3613139@rfd.leadboat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2022 at 09:24:36AM -0800, Noah Misch wrote:
> Scenario: due to a block device error, the kernel fails to persist some file
> content.  Even so, read() always returns the file content accurately.

...reads of the source file?  Or the destination file?  Your script
doesn't explicitly sum the source file after the EIO, so I'm guessing
the “cat $broken_source | cat > $dest; sum $dest” demonstrates that the
page cache of the source file is still ok?

> The first FICLONE returns EIO, but every subsequent FICLONE or
> copy_file_range() operates as though the file were all zeros.

Note FICLONE != clone_file_range.  FICLONE flushes dirty data to disk
and reflinks blocks; clone_file_range has a multitude of behaviors
depending on fs.  On XFS, it first will try FICLONE before falling back
to pipe copies.

So the first thing is to figure out where the EIO comes from such that
FICLONE fails.  Kernel logs would help here, since a dirty data
writeback encountering a broken disk will cause FICLONE to fail with EIO
but leave the fs running.

The second thing would be to step through the system behavior call by
call -- what is the state of $dest after the FICLONE call but before the
c_f_r.  Is it an empty file with size zero?  Is the pagecache for the
source file still intact?  That will tell us if FICLONE is somehow
stamping out files full of zeroes, or if this is a weird c_f_r behavior.

I wrote the FICLONE behavior in XFS, and AFAIK there isn't a vector by
which the $dest file would end up being 16MB all zeroed (but hey, let's
simulate this behavior and check anyway).  However, c_f_r is ... a mess,
and I wouldn't be surprised if it did something whacky like that.

> How
> feasible is it change FICLONE
> and copy_file_range() such that they instead find the bytes that read() finds?
> 
> - Kernel is 6.0.0-1-sparc64-smp from Debian sid, running in a Solaris-hosted VM.
> 
> - The VM is gcc202 from https://cfarm.tetaneutral.net/machines/list/.
>   Accounts are available.
> 
> - The outcome is still reproducible in FICLONE issued two days after the

Are you issuing raw FICLONE calls, or cp with reflink again?

>   original block device error.  I haven't checked whether it survives a
>   reboot.
> 
> - The "sync" command did not help.
> 
> - The block device errors have been ongoing for years.  If curious, see
>   https://postgr.es/m/CA+hUKGKfrXnuyk0Z24m8x4_eziuC3kLSaCmEeKPO1DVU9t-qtQ@mail.gmail.com
>   for details.  (Fixing the sunvdc driver is out of scope for this thread.)
>   Other known symptoms are failures in truncate() and fsync().  The system has
>   been generally usable for applications not requiring persistence.  I saw the

<cough> Well I guess if you're going to tie my hands from the start...

>   FICLONE problem after the system updated coreutils from 8.32-4.1 to 9.1-1.
>   That introduced a "cp" that uses FICLONE.  My current workaround is to place
>   a "cp" in my PATH that does 'exec /usr/bin/cp --reflink=never "$@"'
> 
> 
> The trouble emerged at a "cp".  To capture more details, I replaced "cp" with
> "trace-cp" containing:
> 
>   sum "$1"
>   strace cp "$@" 2>&1 | sed -n '/^geteuid/,$p'
>   sum "$2"
> 
> Output from that follows.  FICLONE returns EIO.  "cp" then falls back to
> copy_file_range(), which yields an all-zeros file:
> 
>   47831 16384 pg_wal/000000030000000000000003
>   geteuid()                               = 1450
>   openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
>   fstatat64(AT_FDCWD, "pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
>   openat(AT_FDCWD, "pg_wal/000000030000000000000003", O_RDONLY) = 4
>   fstatat64(4, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
>   openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_WRONLY|O_CREAT|O_EXCL, 0600) = 5
>   ioctl(5, BTRFS_IOC_CLONE or FICLONE, 4) = -1 EIO (Input/output error)
>   fstatat64(5, "", {st_mode=S_IFREG|0600, st_size=0, ...}, AT_EMPTY_PATH) = 0
>   fadvise64_64(4, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
>   copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 16777216
>   copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 0

Clearly c_f_r thought it had 16MB of *something* to copy here.  It would
be interesting to ftrace the xfs reflink calls to find out if it called
FICLONE a second time, or if it actually tried a pagecache copy.

>   close(5)                                = 0
>   close(4)                                = 0
>   _llseek(0, 0, [0], SEEK_CUR)            = 0
>   close(0)                                = 0
>   close(1)                                = 0
>   close(2)                                = 0
>   exit_group(0)                           = ?
>   +++ exited with 0 +++
>   00000 16384 /home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003
> 
> Subsequent FICLONE returns 0 and yields an all-zeros file.  Test script:
> 
>   set -x
>   broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   dest=$HOME/tmp/discard
>   sum "$broken_source"
>   : 'FICLONE returns 0 and yields an all-zeros file'
>   strace cp --reflink=always "$broken_source" "$dest" 2>&1 | sed -n '/^geteuid/,$p'
>   sum "$dest"; rm "$dest"
>   : 'copy_file_range() returns 0 and yields an all-zeros file'
>   strace -e copy_file_range cat "$broken_source" >"$dest"
>   sum "$dest"; rm "$dest"
>   : 'read() gets the intended bytes'
>   cat "$broken_source" | cat >"$dest"
>   sum "$dest"; rm "$dest"
> 
> Test script output:
> 
>   + broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   + dest=/home/nm/tmp/discard
>   + sum t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   49522 16384 t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   + : FICLONE returns 0 and yields an all-zeros file
>   + strace cp --reflink=always t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003 /home/nm/tmp/discard
>   + sed -n /^geteuid/,$p
>   geteuid()                               = 1450
>   openat(AT_FDCWD, "/home/nm/tmp/discard", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
>   fstatat64(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
>   openat(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", O_RDONLY) = 3
>   fstatat64(3, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
>   openat(AT_FDCWD, "/home/nm/tmp/discard", O_WRONLY|O_CREAT|O_EXCL, 0600) = 4
>   ioctl(4, BTRFS_IOC_CLONE or FICLONE, 3) = 0
>   close(4)                                = 0
>   close(3)                                = 0
>   _llseek(0, 0, 0x7feffddf1c0, SEEK_CUR)  = -1 ESPIPE (Illegal seek)
>   close(0)                                = 0
>   close(1)                                = 0
>   close(2)                                = 0
>   exit_group(0)                           = ?
>   +++ exited with 0 +++
>   + sum /home/nm/tmp/discard
>   00000 16384 /home/nm/tmp/discard

Curious.  This time the FICLONE actually succeeded.  Can you “filefrag
-v $dest” here and show us if the dest file has space mapped to that 16M
or if it's sparse?

Waitaminute.  About that 16M of data that's in $broken_source -- was all
of that written to the pagecache right before the first call to cp?  I
have a theory here that if you did:

	write(src_fd, <16M of data>) = 16M
	ficlone(dst_fd, src_fd) = -EIO
	copy_file_range(dst_fd, src_fd)

Then what's going on here is that the first write call dirties 16M of
pagecache.  The FICLONE does an implied fsync() to flush the dirty data
to disk, but that writeback fails.  The pagecache does not respond to
writeback failure by redirtying the pages.  After the failed FICLONE,
the src_fd file does not have written extents allocated to it -- either
it'll be an unwritten extent, or nothing at all.

Then the second c_f_r comes along and tries FICLONE again.  This time
the "flush" succeeds because the pages are "clean" so we go ahead with
the reflink.  (Thanks, cp, for dropping the EIO!!!)  Reflink only shares
written extents, so it extends dst_fd's size without mapping any real
space to it.  That's my theory for why you see a $dest file that's 16M
and all zeroes.

(Think of FICLONE as a low-level duplicator of disk contents whose only
interaction with the page cache is to flush it at the start.)

Then you come along and manually cat $broken_source to $dest, using that
odd pipe construction:

   cat "$broken_source" | cat >"$dest"

The introduction of the pipe means that c_f_r immediately goes to the
pipe copying fallback, which reads the pagecache to the pipe; and writes
the pipe contents to $dest.  Hence this works where everything else
fails.

So I guess the question now is, what do we do about it?  The pagecache
maintainers have never been receptive to redirtying pages after a
writeback failure; cp should really pass that EIO out to userspace
instead of silently eating it; and maaaybe FICLONE should detect EIOs
recorded in the file's pagecache and return that, but it won't fix the
underlying problem, which is that the cache thinks its clean after an
EIO, and the pagecache forgets about recorded EIOs after reporting them
via fsync/syncfs.

If you rebooted the machine at the end of the script, you'd likely see
that $broken_source is either empty or also full of zeroes.  Quite
possibly $dest would have the contents, since it did manage to get its
own copy of the "clean" pagecache data and persist it.

--D

>   + rm /home/nm/tmp/discard
>   + : copy_file_range() returns 0 and yields an all-zeros file
>   + strace -e copy_file_range cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 16777216
>   copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 0
>   +++ exited with 0 +++
>   + sum /home/nm/tmp/discard
>   00000 16384 /home/nm/tmp/discard
>   + rm /home/nm/tmp/discard
>   + : read() gets the intended bytes
>   + cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
>   + cat
>   + sum /home/nm/tmp/discard
>   49522 16384 /home/nm/tmp/discard
>   + rm /home/nm/tmp/discard
