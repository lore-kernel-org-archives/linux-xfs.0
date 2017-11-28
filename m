Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21667 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752229AbdK1WdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 17:33:20 -0500
Date: Tue, 28 Nov 2017 14:33:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 10/13] fstests: crash consistency fsx test using
 dm-log-writes
Message-ID: <20171128223308.GC21412@magnolia>
References: <1504638680-25682-1-git-send-email-amir73il@gmail.com>
 <1504638680-25682-11-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi_SjKCJ97Knvh4S6UiD3jskHEqDja7wwc+-mXp4CNbEw@mail.gmail.com>
 <20171127150439.i4tpt4yhooxnoaiz@destiny>
 <CAOQ4uxiGryFy7GLZUa0EWcbT+50cMfBb8a2dYa1mZ7tEf+UURg@mail.gmail.com>
 <20171128172152.ktvpnwv233govfwl@destiny>
 <CAOQ4uxgeKdZnxXcvt10MG2kT4PTZ4eZH+-v2R0zPJXTcRvONeQ@mail.gmail.com>
 <20171128200035.26kqhetxtemnm7z4@destiny>
 <CAOQ4uxh2OX9Lbnauv-ip5GC_8oCJ38hYsjjvp0+JFGYLqRk7nw@mail.gmail.com>
 <CAOQ4uxhQu-1AK71zg4Ce0cJd+xRt3Gf9zMMVb=Rs00zFuWA3hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhQu-1AK71zg4Ce0cJd+xRt3Gf9zMMVb=Rs00zFuWA3hQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

On Tue, Nov 28, 2017 at 11:17:01PM +0200, Amir Goldstein wrote:
> On Tue, Nov 28, 2017 at 10:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Tue, Nov 28, 2017 at 10:00 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> >> On Tue, Nov 28, 2017 at 09:32:59PM +0200, Amir Goldstein wrote:
> >>> On Tue, Nov 28, 2017 at 7:21 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> >>> > On Tue, Nov 28, 2017 at 06:48:43PM +0200, Amir Goldstein wrote:
> >>> >> On Mon, Nov 27, 2017 at 5:04 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> >>> >> > On Mon, Nov 27, 2017 at 11:56:58AM +0200, Amir Goldstein wrote:
> >>> >> >> On Tue, Sep 5, 2017 at 10:11 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> >> >> > Cherry-picked the test from commit 70d41e17164b
> >>> >> >> > in Josef Bacik's fstests tree (https://github.com/josefbacik/fstests).
> >>> >> >> > Quoting from Josef's commit message:
> >>> >> >> >
> >>> >> >> >   The test just runs some ops and exits, then finds all of the good buffers
> >>> >> >> >   in the directory we provided and:
> >>> >> >> >   - replays up to the mark given
> >>> >> >> >   - mounts the file system and compares the md5sum
> >>> >> >> >   - unmounts and fsck's to check for metadata integrity
> >>> >> >> >
> >>> >> >> >   dm-log-writes will pretend to do discard and the replay-log tool will
> >>> >> >> >   replay it properly depending on the underlying device, either by writing
> >>> >> >> >   0's or actually calling the discard ioctl, so I've enabled discard in the
> >>> >> >> >   test for maximum fun.
> >>> >> >> >
> >>> >> >> > [Amir:]
> >>> >> >> > - Removed unneeded _test_falloc_support dynamic FSX_OPTS
> >>> >> >> > - Fold repetitions into for loops
> >>> >> >> > - Added place holders for using constant random seeds
> >>> >> >> > - Add pre umount checkpint
> >>> >> >> > - Add test to new 'replay' group
> >>> >> >> > - Address review comments by Eryu Guan
> >>> >> >> >
> >>> >> >> > Cc: Josef Bacik <jbacik@fb.com>
> >>> >> >> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >>> >> >>
> >>> >> >>
> >>> >> >> Josef,
> >>> >> >>
> >>> >> >> As you know, this test is now merged to xfstest as generic/455.
> >>> >> >> I have been running the test for a while on xfs and it occasionally
> >>> >> >> reports inconsistencies which I try to investigate.
> >>> >> >>
> >>> >> >> In some of the reports, it appears that dm-log-writes may be exhibiting
> >>> >> >> a reliability issue (see below).
> >>> >> >>
> >>> >> >
> >>> >> > It's not a reliability issue, its a caching issue.  dm-log-writes is just
> >>> >> > issuing bio's to the log device, and our destructor waits for all pending io
> >>> >> > blocks to complete before exiting, so unless I've missed how dm is destroying
> >>> >> > devices everything should be on disk.
> >>> >> >
> >>> >> > However since we replay in userspace we are going through the blockdevice's
> >>> >> > pagecache, so we could have stale pages left in place which is screwing us up.
> >>> >> > Will you try this patch and see if it fixes the problem?  Thanks,
> >>> >> >
> >>> >> > Josef
> >>> >> >
> >>> >> >
> >>> >> > diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> >>> >> > index 8b80a9ce9ea9..1c502930af5e 100644
> >>> >> > --- a/drivers/md/dm-log-writes.c
> >>> >> > +++ b/drivers/md/dm-log-writes.c
> >>> >> > @@ -545,6 +545,8 @@ static void log_writes_dtr(struct dm_target *ti)
> >>> >> >                    !atomic_read(&lc->pending_blocks));
> >>> >> >         kthread_stop(lc->log_kthread);
> >>> >> >
> >>> >> > +       invalidate_bdev(lc->logdev->bdev);
> >>> >> > +       invalidate_bdev(lc->dev->bdev);
> >>> >> >         WARN_ON(!list_empty(&lc->logging_blocks));
> >>> >> >         WARN_ON(!list_empty(&lc->unflushed_blocks));
> >>> >> >         dm_put_device(ti, lc->dev);
> >>> >>
> >>> >> Josef,
> >>> >>
> >>> >> With your patch OR with my xfstest patch that adds "sync" I did not yet see
> >>> >> another problem of garbage fs after _log_writes_remove.
> >>> >>
> >>> >> I did however, encounter this error (failure to verify read data during fsx)
> >>> >> from scratch/log-writes device (see attached full log).
> >>> >>
> >>> >> I will keep running the test to collect more information.
> >>> >>
> >>> >
> >>> > That failure I'll lay at the feet of whatever fs you are testing ;).  I'm glad
> >>> > my patch fixed the replay problem, I'll send that up.  Thanks,
> >>> >
> >>>
> >>> O oh!. You are implying that xfs fails plain fsx and nobody noticed.
> >>> That is not where I would place my bet.
> >>>
> >>
> >> Why not?  This is one of the only tests that runs multiple threads of fsx at the
> >> same time.  dm-log-writes does nothing special with the actual target disk, it
> >> just clones the bio's as it gets them, sets the bdev for the normal device and
> >> sends them on their way, there's no reason to think we're breaking that.
> >> Furthermore fsx is in normal page cache mode, not O_DIRECT, so it's more likely
> >> something else is going wrong and not dm-log-writes, unless there is so little
> >> memory on the system that we are constantly reading cold-cache.  Thanks,
> >>
> >
> > Very well, I'll run the same test on bare xfs for comparison.
> >
> 
> Well, what do you know.
> xfs crashed and burned after 18 rounds of 455 on test partition.
> Same check fs error I blamed dm-log-writes for.
> 
> Darrick,
> 
> Attached the modified 455 test which runs fsx on test partition
> and full log (+ dmesg with nothing of interest AFAICT).
> xfs code is 4.14.0-rc8 + your patch
> "xfs: log recovery should replay deferred ops in order"
> 
> The test was run on a 100G partition on a spinning disk.
> 
> Let me know what you think.

I didn't even get /that/ far; with 4.15-rc1 and a vanilla g/455 I see
immediately:

[18395.236285] run fstests generic/457 at 2017-11-28 14:15:49
[18395.561112] XFS (sdf): Unmounting Filesystem
[18395.752713] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[18395.753469] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[18395.754259] XFS (sdf): Mounting V5 Filesystem
[18395.757525] XFS (sdf): Ending clean mount
[18395.796992] XFS (sdf): Unmounting Filesystem
[18395.949561] XFS (dm-0): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[18395.950316] XFS (dm-0): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[18395.951103] XFS (dm-0): Mounting V5 Filesystem
[18395.954946] XFS (dm-0): Ending clean mount
[18396.132701] XFS (dm-0): Unmounting Filesystem
[18396.309939] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[18396.310913] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[18396.311798] XFS (sdf): Mounting V5 Filesystem
[18396.330304] XFS (sdf): Starting recovery (logdev: internal)
[18396.334996] XFS (sdf): Metadata corruption detected at xfs_inode_buf_verify+0xc4/0x330 [xfs], xfs_inode block 0x80
[18396.336389] XFS (sdf): Unmount and run xfs_repair
[18396.336945] XFS (sdf): First 64 bytes of corrupted metadata buffer:
[18396.337679] ffffc90004080000: 00 4e 41 ed 03 01 00 00 00 00 00 00 00 00 00 00  .NA.............
[18396.338647] ffffc90004080010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
[18396.339576] ffffc90004080020: 00 00 00 00 00 00 00 00 5a 1d e0 16 0b 69 8a 10  ........Z....i..
[18396.340341] ffffc90004080030: 5a 1d e0 16 0b 69 8a 10 00 00 00 00 00 00 00 06  Z....i..........
[18396.341091] XFS (sdf): bad inode magic/vsn daddr 128 #0 (magic=4e)
[18396.341754] XFS (sdf): metadata I/O error: block 0x80 ("xlog_recover_do..(read#2)") error 117 numblks 32
[18396.343131] XFS (sdf): log mount/recovery failed: error -117
[18396.343852] XFS (sdf): log mount failed

Off by one in the inode verifier... am I supposed to have Josef's patch?

Also, fwiw I don't see any test failures (or interesting output) with
your modified 455:

[19344.527290] run fstests generic/455 at 2017-11-28 14:31:38
[19344.948061] XFS (pmem4): Unmounting Filesystem
[19345.098299] XFS (dm-0): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[19345.099328] XFS (dm-0): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[19345.100427] XFS (dm-0): Mounting V5 Filesystem
[19345.105724] XFS (dm-0): Ending clean mount
[19345.476248] XFS (dm-0): Unmounting Filesystem
[19346.055840] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[19346.057092] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[19346.057883] XFS (pmem4): Mounting V5 Filesystem
[19346.059640] XFS (pmem4): Ending clean mount
[19346.084019] XFS (pmem4): Unmounting Filesystem
[19346.492297] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[19346.492950] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[19346.493865] XFS (pmem4): Mounting V5 Filesystem
[19346.495732] XFS (pmem4): Ending clean mount
[19346.556181] XFS (pmem4): Unmounting Filesystem
[19346.780951] XFS (pmem3): Unmounting Filesystem
[19346.857051] XFS (pmem3): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[19346.858352] XFS (pmem3): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[19346.859053] XFS (pmem3): Mounting V5 Filesystem
[19346.861319] XFS (pmem3): Ending clean mount
[19346.940162] XFS (pmem3): Unmounting Filesystem
[19346.980932] XFS (pmem3): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[19346.981640] XFS (pmem3): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[19346.982359] XFS (pmem3): Mounting V5 Filesystem
[19346.984765] XFS (pmem3): Ending clean mount
[19347.204449] XFS (pmem3): Unmounting Filesystem

I think it's supposed to cycle more than that, right?

--D

> 
> Amir.




