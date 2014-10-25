Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1765C7F51
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 02:05:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBBDC304032
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 00:05:27 -0700 (PDT)
Received: from mail-qa0-f50.google.com (mail-qa0-f50.google.com
	[209.85.216.50]) by cuda.sgi.com with ESMTP id 2OtNwgwd55Dskk4x
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 25 Oct 2014 00:05:25 -0700 (PDT)
Received: by mail-qa0-f50.google.com with SMTP id cs9so1863729qab.23
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 00:05:24 -0700 (PDT)
Message-ID: <544B4BB3.5030009@gmail.com>
Date: Sat, 25 Oct 2014 03:05:23 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfsdump not work in 3.17
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
	<543F3C9A.4060603@sandeen.net> <5447BC4C.3050408@gmail.com>
In-Reply-To: <5447BC4C.3050408@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

On 10/22/14 10:16, Michael L. Semon wrote:
> On 10/15/14 23:33, Eric Sandeen wrote:
>> On 10/15/14 9:31 PM, Tommy Wu wrote:
>>> Hi!
>>>
>>>     xfsdump 3.1.4
>>>     xfsprogs 3.2.1
>>>     linux kerenl 3.17/3.17.1
>>>
>>
>> ...
>>
>>>     It just create  a small dump file, and if I run the same xfsdump again (or umount the filesystem), it will hang, like:
>>>
>>> fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l 0 -o -J -F - /dev/vg/root | gzip > test.gz
>>> /sbin/xfsdump: using file dump (drive_simple) strategy
>>> /sbin/xfsdump: version 3.1.4 (dump format 3.0)
>>> /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
>>> /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
>>> /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
>>> /sbin/xfsdump: session label: ""
>>> /sbin/xfsdump: ino map phase 1: constructing initial dump list
>>>
>>>
>>>     switch back to kernel 3.16, the same command work fine.
>>>
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693
>>
>> addresses the small backup file, and
>>
>> [PATCH] xfs: bulkstat doesn't release AGI buffer on error
>>
>> (on the list) most likely addresses the hang, I think.
>>
>> -Eric
>
> Thanks!  I'm still looking for that one good recipe to fix xfsdump in my i686
> Pentium 4 dungeon here, currently using yesterday morning's git kernel +
> xfs-oss/for-next.  The test dataset is a basic slackware-current setup,
> regular kernel source, -stable kernel source, on v5-superblock/finobt XFS
> (mkfs.xfs -m crc=1,finobt=1 ...).  The dataset uses about 7 GB of disk space.
>
> This letter is half-baked thoughts, only here to express the idea "don't think
> you're out of the woods yet!" in some primitive manner.
>
> The first patch seems to get rid of the earliest xfsdump premature SUCCESS, the
> one where xfsdump ran for less than 10 seconds and left a dump file of less than
> 1 MB.  BTW, in the commit message and to `git log xfs-oss/for-next`, the commit
> message for the patch starts "caused a regression in xfs_inumbers" but does not
> mention which commit caused the regression.
>
> With the second patch applied, the dump size increases to about 1 decimal GB
> before exiting, same size in three different runs.
>
> I think I tried the patch "xfs: Check error during inode btree iteration in
> xfs_bulkstat()"--no other similar patches in my mailing list patchset download--
> and xfsdump dumped up to 1.2 decimal GB, same size in two different runs.
>
> These patches are being run through xfstests as I work, so there's nothing
> there to report yet.
>
> It was only this morning that I got tar to complete a system backup without
> asserting in some way (hangcheck timer expires, stack varies), and the last
> oops got into that uncomfortable xfs_dir3_leaf area.  Should this happen
> again, I'll either post some traces or the output of `xfsdump -v 3 ...`  I was
> rushed into work today and couldn't grab the logs.
>
> Should `xfsdump -v 3 ...` report SUCCESS for one code and an error for the
> second return code, that second code has been "unknown error."  I've never run
> xfsdump at -v 3 before and don't know if that is normal.
>
> The rest is still being fleshed out.  tar seems to be OK, so long as xfsdump
> has not been invoked beforehand.  tar has not been run enough times to get a
> true 1:1 correlation on it, though.  The current goal is to reconstruct the
> filesystem and see if all problems magically go away.  So far, xfs_repair has
> reported no errors on this filesystem.
>
> Thanks!
>
> Michael
>

Update:  I got a patch to resolve a sync (or merge request) issue lower down
in the block layer, so I tried this all again.  With tonight's kernel +
xfs-oss/for-next and a lot of "-v 3" arguments, it went like this:

1) xfsdump'ed my v5/finobt /.  Exit code was SUCCESS, return code was SUCCESS.

2) Did something like `gzip -dc dump.0.gz | xfsrestore -t -`.  Exit code
    was SUCCESS, return code was SUCCESS.

3) Did a `find / -mount -type f -exec md5sum {} \; | tee ~/MD5SUMS`

4) Zeroed /dev/sda4, then made a new FS using
    `mkfs.xfs -m crc=1,finobt=1 /dev/sda4` # (12 GB)

5) xfsrestore'd the v5/finobt / from another partition.  Exit code was
    SUCCESS, return code was SUCCESS.  xfsrestore claimed 19494 directories and
    268540 or 298540 files.  I thought I read 268540 lines for the MD5SUMS file
    and 298540 from the xfsrestore output.  Eyes must be blurring...

6) Tried to reboot into the v5/finobt /.  No /etc/inittab, cannot boot.  In
    fact, if files were restored to /etc, they were nested fairly deeply.

7) From another partition, I ran commands like this:
    find /mnt/v5xfs -mount -type d | wc -l       #  19494 directories
    find /mnt/v5xfs -mount -type f | wc -l       # 118417 files

8) Tried the restore onto a non-XFS filesystem.  Still it restored all
    19494 directories but only 118417 files.

This was somewhat disconcerting to have all that SUCCESS and have it followed
by failure.  I'm rather puzzled that the backups had different results
last time.  AFAIK, writes were completing before block issues were fixed, they
just took an extremely long time when enough I/O was built up.

Anyway, that was an update, and I'll try some tar restore results next time.
tar is fairly demonstrative about errors, though.  If the backup went OK, then
the restore should go OK as well.

Good luck!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
