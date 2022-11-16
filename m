Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4864EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 03:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiKPDO4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 22:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKPDOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 22:14:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD8525C
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 19:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58F5BB81BAF
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 03:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00230C433D6;
        Wed, 16 Nov 2022 03:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668568488;
        bh=Lcpvi4ce90kjCI23MhRTsS/wR6NellMrx1usPdZW7XQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+uPmBg+vj9dg/iLcNY7udhP3+lxL1mhywZ3gm/AsDrRj3Pv1wDmrRKPsDPgT6908
         LWIAYeSwiiSfIXWuKWkokZSUvWwl8PFpOac5oTmMjFHZUbWVUl6pKH2OIEIAO+ECgh
         msrsgOlTRSAdZR9r9+UVzJjGArvmq00473WmWTSjskppraLY/2SL8zs4OkpUZFLPOF
         fiYD1X/+xFvfBAWAjmP/s07zHxIVr4++9eK3QwKNgV3E7XFnSdfqLK8VPEd2KkZBFk
         zIZp+w0t23g3AakgTl9+Ix17wAaVGRDxSMnELdEOXddjJX02IWbWfnN5m068ad2tOm
         GTmdOmofoUNEw==
Date:   Tue, 15 Nov 2022 19:14:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Noah Misch <noah@leadboat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: After block device error, FICLONE and sync_file_range() make
 NULs, unlike read()
Message-ID: <Y3RVp74Qf58/Rh2y@magnolia>
References: <20221108172436.GA3613139@rfd.leadboat.com>
 <Y2vZk7Wg0V8SvwxW@magnolia>
 <20221110045452.GB3665013@rfd.leadboat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221110045452.GB3665013@rfd.leadboat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 08:54:52PM -0800, Noah Misch wrote:
> Subject line has my typo: s/sync_file_range/copy_file_range/
> 
> On Wed, Nov 09, 2022 at 08:47:15AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 08, 2022 at 09:24:36AM -0800, Noah Misch wrote:
> > > Scenario: due to a block device error, the kernel fails to persist some file
> > > content.  Even so, read() always returns the file content accurately.
> > 
> > ...reads of the source file?  Or the destination file?  Your script
> > doesn't explicitly sum the source file after the EIO, so I'm guessing
> > the “cat $broken_source | cat > $dest; sum $dest” demonstrates that the
> > page cache of the source file is still ok?
> 
> Reads of the source file.  Yes, I believe the page cache is ok, while on-disk
> state is not okay.
> 
> > > The first FICLONE returns EIO, but every subsequent FICLONE or
> > > copy_file_range() operates as though the file were all zeros.
> > 
> > Note FICLONE != clone_file_range.  FICLONE flushes dirty data to disk
> > and reflinks blocks; clone_file_range has a multitude of behaviors
> > depending on fs.  On XFS, it first will try FICLONE before falling back
> > to pipe copies.
> > 
> > So the first thing is to figure out where the EIO comes from such that
> > FICLONE fails.  Kernel logs would help here, since a dirty data
> > writeback encountering a broken disk will cause FICLONE to fail with EIO
> > but leave the fs running.
> 
> The EIO always correlates with a kernel log entry like this:
> 
> [Mon Nov  7 10:13:40 2022] sunvdc: vdc_tx_trigger() failure, err=-11
> [Mon Nov  7 10:13:40 2022] I/O error, dev vdiskc, sector 1918699264 op 0x1:(WRITE) flags 0x4800 phys_seg 17 prio class 2
> 
> > The second thing would be to step through the system behavior call by
> > call -- what is the state of $dest after the FICLONE call but before the
> > c_f_r.  Is it an empty file with size zero?
> 
> I don't have that detail from the state right after the FICLONE that returned
> EIO.  (I could get it with another test run.  The last test run took 43965s,
> though.)  However, I would guess it's the same as the state when running a
> later FICLONE on the same source file.  The file has size 16777216, is sparse,
> and reads as all NUL bytes.
> 
> > Is the pagecache for the
> > source file still intact?  That will tell us if FICLONE is somehow
> > stamping out files full of zeroes, or if this is a weird c_f_r behavior.
> 
> Yes, pagecache is intact.
> 
> > I wrote the FICLONE behavior in XFS, and AFAIK there isn't a vector by
> > which the $dest file would end up being 16MB all zeroed (but hey, let's
> > simulate this behavior and check anyway).  However, c_f_r is ... a mess,
> > and I wouldn't be surprised if it did something whacky like that.
> 
> One of the steps of the test script uses FICLONE without copy_file_range().
> 
> > > How
> > > feasible is it change FICLONE
> > > and copy_file_range() such that they instead find the bytes that read() finds?
> > > 
> > > - Kernel is 6.0.0-1-sparc64-smp from Debian sid, running in a Solaris-hosted VM.
> > > 
> > > - The VM is gcc202 from https://cfarm.tetaneutral.net/machines/list/.
> > >   Accounts are available.
> > > 
> > > - The outcome is still reproducible in FICLONE issued two days after the
> > 
> > Are you issuing raw FICLONE calls, or cp with reflink again?
> 
> cp with reflink, but it's basically raw FICLONE at that point.  See the
> original post's strace fragment below "FICLONE returns 0 and yields an
> all-zeros file".
> 
> > >   original block device error.  I haven't checked whether it survives a
> > >   reboot.
> > > 
> > > - The "sync" command did not help.
> > > 
> > > - The block device errors have been ongoing for years.  If curious, see
> > >   https://postgr.es/m/CA+hUKGKfrXnuyk0Z24m8x4_eziuC3kLSaCmEeKPO1DVU9t-qtQ@mail.gmail.com
> > >   for details.  (Fixing the sunvdc driver is out of scope for this thread.)
> > >   Other known symptoms are failures in truncate() and fsync().  The system has
> > >   been generally usable for applications not requiring persistence.  I saw the
> > 
> > <cough> Well I guess if you're going to tie my hands from the start...
> 
> Heh.  I won't stop you from fixing the sunvdc driver!  I figured linux-xfs
> would focus on the topic, "given block devices sometimes report errors, how
> should XFS behave?"

I wasn't going to fix sunvdc, I'm pretty sure I don't even have access to
the relevant hardware. ;)

That said... people send me a surprising number of bug reports that
start with "My hardware is really flaky..." and end with "...and I want
you to go to extraordinary lengths to work around all of that in
software!"

Apologies for my own defensive reaction, your report merely wanted
"...can we have some non-weird behavior from the page cache?"

> > >   FICLONE problem after the system updated coreutils from 8.32-4.1 to 9.1-1.
> > >   That introduced a "cp" that uses FICLONE.  My current workaround is to place
> > >   a "cp" in my PATH that does 'exec /usr/bin/cp --reflink=never "$@"'
> > > 
> > > 
> > > The trouble emerged at a "cp".  To capture more details, I replaced "cp" with
> > > "trace-cp" containing:
> > > 
> > >   sum "$1"
> > >   strace cp "$@" 2>&1 | sed -n '/^geteuid/,$p'
> > >   sum "$2"
> > > 
> > > Output from that follows.  FICLONE returns EIO.  "cp" then falls back to
> > > copy_file_range(), which yields an all-zeros file:
> > > 
> > >   47831 16384 pg_wal/000000030000000000000003
> > >   geteuid()                               = 1450
> > >   openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
> > >   fstatat64(AT_FDCWD, "pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
> > >   openat(AT_FDCWD, "pg_wal/000000030000000000000003", O_RDONLY) = 4
> > >   fstatat64(4, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
> > >   openat(AT_FDCWD, "/home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003", O_WRONLY|O_CREAT|O_EXCL, 0600) = 5
> > >   ioctl(5, BTRFS_IOC_CLONE or FICLONE, 4) = -1 EIO (Input/output error)
> > >   fstatat64(5, "", {st_mode=S_IFREG|0600, st_size=0, ...}, AT_EMPTY_PATH) = 0
> > >   fadvise64_64(4, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
> > >   copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 16777216
> > >   copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) = 0
> > 
> > Clearly c_f_r thought it had 16MB of *something* to copy here.  It would
> > be interesting to ftrace the xfs reflink calls to find out if it called
> > FICLONE a second time, or if it actually tried a pagecache copy.
> 
> If needed, I can try to get access to do that.
> 
> > >   close(5)                                = 0
> > >   close(4)                                = 0
> > >   _llseek(0, 0, [0], SEEK_CUR)            = 0
> > >   close(0)                                = 0
> > >   close(1)                                = 0
> > >   close(2)                                = 0
> > >   exit_group(0)                           = ?
> > >   +++ exited with 0 +++
> > >   00000 16384 /home/nm/src/pg/backbranch/extra/src/test/recovery/tmp_check/t_028_pitr_timelines_primary_data/archives/000000030000000000000003
> > > 
> > > Subsequent FICLONE returns 0 and yields an all-zeros file.  Test script:
> > > 
> > >   set -x
> > >   broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   dest=$HOME/tmp/discard
> > >   sum "$broken_source"
> > >   : 'FICLONE returns 0 and yields an all-zeros file'
> > >   strace cp --reflink=always "$broken_source" "$dest" 2>&1 | sed -n '/^geteuid/,$p'
> > >   sum "$dest"; rm "$dest"
> > >   : 'copy_file_range() returns 0 and yields an all-zeros file'
> > >   strace -e copy_file_range cat "$broken_source" >"$dest"
> > >   sum "$dest"; rm "$dest"
> > >   : 'read() gets the intended bytes'
> > >   cat "$broken_source" | cat >"$dest"
> > >   sum "$dest"; rm "$dest"
> > > 
> > > Test script output:
> > > 
> > >   + broken_source=t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   + dest=/home/nm/tmp/discard
> > >   + sum t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   49522 16384 t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   + : FICLONE returns 0 and yields an all-zeros file
> > >   + strace cp --reflink=always t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003 /home/nm/tmp/discard
> > >   + sed -n /^geteuid/,$p
> > >   geteuid()                               = 1450
> > >   openat(AT_FDCWD, "/home/nm/tmp/discard", O_RDONLY|O_PATH|O_DIRECTORY) = -1 ENOENT (No such file or directory)
> > >   fstatat64(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", {st_mode=S_IFREG|0600, st_size=16777216, ...}, 0) = 0
> > >   openat(AT_FDCWD, "t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003", O_RDONLY) = 3
> > >   fstatat64(3, "", {st_mode=S_IFREG|0600, st_size=16777216, ...}, AT_EMPTY_PATH) = 0
> > >   openat(AT_FDCWD, "/home/nm/tmp/discard", O_WRONLY|O_CREAT|O_EXCL, 0600) = 4
> > >   ioctl(4, BTRFS_IOC_CLONE or FICLONE, 3) = 0
> > >   close(4)                                = 0
> > >   close(3)                                = 0
> > >   _llseek(0, 0, 0x7feffddf1c0, SEEK_CUR)  = -1 ESPIPE (Illegal seek)
> > >   close(0)                                = 0
> > >   close(1)                                = 0
> > >   close(2)                                = 0
> > >   exit_group(0)                           = ?
> > >   +++ exited with 0 +++
> > >   + sum /home/nm/tmp/discard
> > >   00000 16384 /home/nm/tmp/discard
> > 
> > Curious.  This time the FICLONE actually succeeded.  Can you “filefrag
> > -v $dest” here and show us if the dest file has space mapped to that 16M
> > or if it's sparse?
> 
>   Filesystem type is: 58465342
>   File size of /home/nm/tmp/discard is 16777216 (4096 blocks of 4096 bytes)
>   /home/nm/tmp/discard: 0 extents found
> 
> That is the output for $dest created via FICLONE and also for $dest created by
> copy_file_range().  (The test uses "cat $src >$dest" to test copy_file_range()
> in isolation.)
> 
> For what it's worth, here's the output for the broken source file:
> 
>   Filesystem type is: 58465342
>   File size of t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003 is 16777216 (4096 blocks of 4096 bytes)
>    ext:     logical_offset:        physical_offset: length:   expected: flags:
>      0:        0..    4095:  109234308.. 109238403:   4096:             last,unwritten,eof
>   t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003: 1 extent found
> 
> And for the good copy created by cat source | cat >dest:
> 
>   Filesystem type is: 58465342
>   File size of /home/nm/tmp/discard is 16777216 (4096 blocks of 4096 bytes)
>    ext:     logical_offset:        physical_offset: length:   expected: flags:
>      0:        0..    4095:          0..         0:      0:             last,unknown_loc,delalloc,eof
>   /home/nm/tmp/discard: 1 extent found
> 
> In case it wasn't clear, the original post contained two scripts.  The
> three-line "trace-cp" script was called from my application (PostgreSQL).  It
> caught the evidence of the original EIO that coincided with the block device
> error.  The longer script labeled "test script" is something I run at will,
> getting the same result every time.
> 
> > Waitaminute.  About that 16M of data that's in $broken_source -- was all
> > of that written to the pagecache right before the first call to cp?  I
> > have a theory here that if you did:
> > 
> > 	write(src_fd, <16M of data>) = 16M
> > 	ficlone(dst_fd, src_fd) = -EIO
> > 	copy_file_range(dst_fd, src_fd)
> 
> Essentially yes.  It might have been a few smaller write() calls, not a single
> big one.  In any case, the file originated seconds before the FICLONE.
> 
> > Then what's going on here is that the first write call dirties 16M of
> > pagecache.  The FICLONE does an implied fsync() to flush the dirty data
> > to disk, but that writeback fails.  The pagecache does not respond to
> > writeback failure by redirtying the pages.  After the failed FICLONE,
> > the src_fd file does not have written extents allocated to it -- either
> > it'll be an unwritten extent, or nothing at all.
> > 
> > Then the second c_f_r comes along and tries FICLONE again.  This time
> > the "flush" succeeds because the pages are "clean" so we go ahead with
> > the reflink.  (Thanks, cp, for dropping the EIO!!!)  Reflink only shares
> > written extents, so it extends dst_fd's size without mapping any real
> > space to it.  That's my theory for why you see a $dest file that's 16M
> > and all zeroes.
> > 
> > (Think of FICLONE as a low-level duplicator of disk contents whose only
> > interaction with the page cache is to flush it at the start.)
> > 
> > Then you come along and manually cat $broken_source to $dest, using that
> > odd pipe construction:
> > 
> >    cat "$broken_source" | cat >"$dest"
> > 
> > The introduction of the pipe means that c_f_r immediately goes to the
> > pipe copying fallback, which reads the pagecache to the pipe; and writes
> > the pipe contents to $dest.  Hence this works where everything else
> > fails.
> 
> Those paragraphs are consistent with everything I know about the situation.

Ok, glad I understood what's going on.

> > So I guess the question now is, what do we do about it?  The pagecache
> > maintainers have never been receptive to redirtying pages after a
> > writeback failure; cp should really pass that EIO out to userspace
> > instead of silently eating it; and maaaybe FICLONE should detect EIOs
> > recorded in the file's pagecache and return that, but it won't fix the
> 
> I'd favor having both FICLONE and copy_file_range() "detect EIOs recorded in
> the file's pagecache and return that".  That way, they never silently make a
> bad clone when read() could have provided the bytes constituting a good clone.

So would I, but the longstanding behavior of FICLONE is that it's an
implied fsync, so it's *vital* that calling programs do not drop the EIO
on the floor like cp does.

Another dumb thing about how the pagecache tracks errors is that it sets
a single state bit for the whole mapping, which means that we can't
actually /tell/ userspace which part of their file is now busted.  We
can't even tell if userspace has successfully rewrite()d all the regions
where writeback failed, which leads me to...

Another another dumb thing about how the pagecache tracks errors is that
any fsync-lik operation will test_and_clear_bit the EIO state, which
means that if we find a past EIO, we'll clear that state and return the
EIO to userspace.

We /could/ change FICLONE to flush the dirty pagecache, sample the EIO
status *without* clearing it, and return EIO if it's set.  That's
probably the most unabsurd way to deal with this, but it's unsettling
that even cp ignores errno returns now.  The manpage for FICLONE doesn't
explicitly mention any fsync behaviors, so perhaps "flush and retain
EIO" is the right choice here.

> > underlying problem, which is that the cache thinks its clean after an
> > EIO, and the pagecache forgets about recorded EIOs after reporting them
> > via fsync/syncfs.
> 
> True.
> 
> > If you rebooted the machine at the end of the script, you'd likely see
> > that $broken_source is either empty or also full of zeroes.  Quite
> > possibly $dest would have the contents, since it did manage to get its
> > own copy of the "clean" pagecache data and persist it.
> 
> I agree.  Thanks for the detailed reply.
> 
> > 
> > --D
> > 
> > >   + rm /home/nm/tmp/discard
> > >   + : copy_file_range() returns 0 and yields an all-zeros file
> > >   + strace -e copy_file_range cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 16777216
> > >   copy_file_range(3, NULL, 1, NULL, 9223372035781033984, 0) = 0
> > >   +++ exited with 0 +++
> > >   + sum /home/nm/tmp/discard
> > >   00000 16384 /home/nm/tmp/discard
> > >   + rm /home/nm/tmp/discard
> > >   + : read() gets the intended bytes
> > >   + cat t_028_pitr_timelines_node_pitr_data/pgdata/pg_wal/000000030000000000000003
> > >   + cat
> > >   + sum /home/nm/tmp/discard
> > >   49522 16384 /home/nm/tmp/discard
> > >   + rm /home/nm/tmp/discard
