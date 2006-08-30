Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 06:52:36 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7UDqMDW021376
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 06:52:26 -0700
Received: from agami.com ([192.168.168.133])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k7UDpluu019345
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 06:51:48 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k7UDpgPm012894
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 06:51:42 -0700
Message-ID: <44F597F9.6020803@agami.com>
Date: Wed, 30 Aug 2006 19:21:53 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: catch22: xfs_repair fails, tells me to mount, which fails
References: <20060830082411.GA9986@lapse.madduck.net>
In-Reply-To: <20060830082411.GA9986@lapse.madduck.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: martin f krafft <madduck@madduck.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Hi Martin,
           In this particular case, the log written is corrupted. That's 
why, forcing to make the inode going corrupt would not help. The real 
issue is why log content is not valid.
        By any chance, did you saw any disk I/O error ? If there is no 
disk I/O error scenario, following information would be more useful.

1. /usr/sbin/xfs_logprint -s 0 -D <device>
2. /usr/sbin/xfs_logprint -d <device>


You can try mounting with -L option but the risk is:
"
   ERROR: The filesystem has valuable metadata changes in a log which 
needs to
   be replayed.  Mount the filesystem to replay the log, and unmount it 
before
   re-running xfs_repair.  If you are unable to mount the filesystem, 
then use
   the -L option to destroy the log and attempt a repair.
   Note that destroying the log may cause corruption -- please attempt a 
mount
   of the filesystem before doing this.
"
martin f krafft wrote:
> Hi,
> 
> this morning I woke up to a system without /home, the reason being:
> 
>   piper:~# mount /dev/mapper/vg0-home                                       [308]
>   mount: Unknown error 990
>   piper:~# dmesg | tail -20                                              [32,309]
>   Starting XFS recovery on filesystem: dm-0 (logdev: internal)
>   Filesystem "dm-0": xfs_inode_recover: Bad inode magic number, dino ptr = 0xffff810028a6bd00, dino bp = 0xffff81002851d140, ino = 33629
>   Filesystem "dm-0": XFS internal error xlog_recover_do_inode_trans(1) at line 2352 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff88307729
> 
>   Call Trace: <ffffffff8830753c>{:xfs:xlog_recover_commit_trans+4198}
>         <ffffffff80231360>{submit_bio+184} <ffffffff88307729>{:xfs:xlog_recover_process_data+466}
>         <ffffffff883081c6>{:xfs:xlog_do_recovery_pass+585} <ffffffff883096f4>{:xfs:xlog_recover+243}
>         <ffffffff88305b2f>{:xfs:xfs_log_mount+1310} <ffffffff8830b671>{:xfs:xfs_mountfs+2116}
>         <ffffffff880a0076>{:libata:ata_exec_command+0} <ffffffff8020bcdc>{_atomic_dec_and_lock+57}
>         <ffffffff883119ac>{:xfs:xfs_mount+1900} <ffffffff88320bb0>{:xfs:xfs_fs_fill_super+126}
>         <ffffffff802bc01d>{get_filesystem+18} <ffffffff802b530c>{sget+850}
>         <ffffffff802b4c65>{set_bdev_super+0} <ffffffff802b4c74>{test_bdev_super+0}
>         <ffffffff802b5dec>{bd_claim+24} <ffffffff802b5996>{get_sb_bdev+239}
>         <ffffffff88320b32>{:xfs:xfs_fs_fill_super+0} <ffffffff802b5605>{do_kern_mount+157}
>         <ffffffff802bd86e>{do_mount+1676} <ffffffff8022b2c2>{mntput_no_expire+25}
>         <ffffffff802075bb>{find_get_page+33} <ffffffff80212173>{filemap_nopage+387}
>         <ffffffff8020878d>{__handle_mm_fault+1276} <ffffffff8020a699>{do_page_fault+1151}
>         <ffffffff80249b1f>{sys_mount+138} <ffffffff80259b0e>{system_call+126}
>   XFS: log mount/recovery failed: error 990
>   XFS: log mount failed
> 
> When I try to run xfs_repair, I get:
> 
>   piper:~# xfs_repair /dev/mapper/vg0-home                                  [310]
>   Phase 1 - find and verify superblock...
>   Phase 2 - using internal log
>           - zero log...
>   ERROR: The filesystem has valuable metadata changes in a log which needs to
>   be replayed.  Mount the filesystem to replay the log, and unmount it before
>   re-running xfs_repair.  If you are unable to mount the filesystem, then use
>   the -L option to destroy the log and attempt a repair.
>   Note that destroying the log may cause corruption -- please attempt a mount
>   of the filesystem before doing this.
> 
> I have already tried the xfs_db method of the "dir2" faq entry,
> trying to delete that offending inode, but setting core.mode = 0 for
> that inode did not do anything.
> 
> I do not have enough space around to xfsdump those 250Gb, nor would
> I know how, given that I cannot mount the filesystem and xfsdump
> works on mounted filesystems only.
> 
> I've had really bad experiences with XFS lately [0], but I am not
> giving up just yet. This time around, I guess I can wait a bit and
> try to get things fixed.
> 
> 0. http://blog.madduck.net/geek/2006.08.09-through-with-xfs
> 
> Would you have any idea what I should do?
> 
