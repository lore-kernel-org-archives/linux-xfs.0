Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n86909ci130156 for <xfs@oss.sgi.com>; Sun, 6 Sep 2009 04:00:24 -0500
Received: from mx2.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF23815ED773
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 02:00:33 -0700 (PDT)
Received: from mx2.empa.ch (mx2.empa.ch [152.88.7.32]) by cuda.sgi.com with
	ESMTP id xWdx8bKjZlDWp9Jb for <xfs@oss.sgi.com>;
	Sun, 06 Sep 2009 02:00:33 -0700 (PDT)
Received: from eaw-exc-hub1.eawag.wroot.emp-eaw.ch (localhost [127.0.0.1])
	by mx2.empa.ch (Spam & Virus Firewall) with ESMTP id A4A986D3C7
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 11:00:30 +0200 (CEST)
Received: from eaw-exc-hub1.eawag.wroot.emp-eaw.ch (eaw-exc-hub1.emp-eaw.ch
	[152.88.5.116]) by mx2.empa.ch with ESMTP id VTcEZtgb7rd0J5xR
	for <xfs@oss.sgi.com>; Sun, 06 Sep 2009 11:00:30 +0200 (CEST)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Sun, 6 Sep 2009 11:00:29 +0200
Subject: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308D8CAB6D@DU-EXC-MAIL.empa.emp-eaw.ch>
Content-Language: it-IT
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> [ ... ]




Hi Peter, thank you for your long message. Some of the things you suppose,

though, may not be exact. I'll try to give you some new element.



>But there was apparently a power "event" of some sort, and IIRC
>the system stopped working, and there were other signs that the
>block layer had suffered damage

DP> 2) /dev/md5, a 19+1 RAID 5, that could not mount
DP> anymore...lost superblock.

PG> The fact that were was apparent difficulty means that the
PG> automatic "resync" that RAID5 implementatioqns do if only 1 drive
PG> has been lost did not work, which is ominous.



PG> With a 19+1 RAID5 with 2 devices dead you have lost around 5-6%
PG> of the data; regrettably this is not 5-6% of the files, but most
PG> likely 5-6% of most files (and probably quite a bit of XFS metadata).

Up to now I found no damage in any file of md5 after recovery with

the mdadm --assemble --assume-clean.

Just an example: a MB-sized tar.gz file, compression of a postscript file,

uncompressed perfectly and was visualized in a perfect way by ghostview.

Moreover, a device died (a different one) yesterday, and in the messages I have:

Sep 4 11:00:44 ipazia-sun kernel: Badness in mv_start_dma at drivers/ata/sata_mv.c:651

Sep 4 11:00:44 ipazia-sun kernel:

Sep 4 11:00:44 ipazia-sun kernel: Call Trace: <ffffffff88099f96>{:sata_mv:mv_qc_issue+292}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff88035600>{:scsi_mod:scsi_done+0} <ffffffff8807b214>{:libata:ata_scsi_rw_xlat+0}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff8807727b>{:libata:ata_qc_issue+1037} <ffffffff88035600>{:scsi_mod:scsi_done+0}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff8807b214>{:libata:ata_scsi_rw_xlat+0} <ffffffff8807b4a9>{:libata:ata_scsi_translate+286}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff88035600>{:scsi_mod:scsi_done+0} <ffffffff8807d549>{:libata:ata_scsi_queuecmd+315}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff88035a6d>{:scsi_mod:scsi_dispatch_cmd+546}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff8803b06d>{:scsi_mod:scsi_request_fn+760} <ffffffff801e8aff>{elv_insert+230}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff801ed890>{__make_request+987} <ffffffff80164059>{mempool_alloc+49}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff801eaa13>{generic_make_request+538} <ffffffff8018b629>{__bio_clone+116}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80147d5d>{keventd_create_kthread+0} <ffffffff801ec844>{submit_bio+186}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80275ae8>{md_update_sb+270} <ffffffff802780bb>{md_check_recovery+371}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80147d5d>{keventd_create_kthread+0} <ffffffff880f6f61>{:raid5:raid5d+21}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80279990>{md_thread+267} <ffffffff80148166>{autoremove_wake_function+0}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80147d5d>{keventd_create_kthread+0} <ffffffff80279885>{md_thread+0}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80148025>{kthread+236} <ffffffff8010bea6>{child_rip+8}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff80147d5d>{keventd_create_kthread+0} <ffffffff80147f39>{kthread+0}

Sep 4 11:00:44 ipazia-sun kernel: <ffffffff8010be9e>{child_rip+0}

Sep 4 11:01:44 ipazia-sun kernel: ata42: Entering mv_eng_timeout

Sep 4 11:01:44 ipazia-sun kernel: mmio_base ffffc20001000000 ap ffff8103f8b4c488 qc ffff8103f8b4cf68 scsi_cmnd ffff8101f7e556c0 &cmnd ffff8101f7e5571c

Sep 4 11:01:44 ipazia-sun kernel: ata42: no sense translation for status: 0x40

Sep 4 11:01:44 ipazia-sun kernel: ata42: translated ATA stat/err 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00

Sep 4 11:01:44 ipazia-sun kernel: ata42: status=0x40 { DriveReady }

Sep 4 11:01:44 ipazia-sun kernel: end_request: I/O error, dev sdap, sector 976767935

Sep 4 11:01:44 ipazia-sun kernel: RAID5 conf printout:

(...)




DP> The resync of the /dev/md5 was performed, the raid was again
DP> with 20 working devices,

PG> The original 20 devices or did you put in 2 new blank hard drives?
PG> I feel like that 2 blank drives went in, but then later I read
PG>that all [original] 20 drives could be read for a few MB at the
PG>beginning.



No. No blank drives went in. And I always used the original 20 devices.

I therefore suspect that the "broken devices" indication, since it is repeatedly found

in the last weeks, and always for different devices/filesystems, has to do with the RAID controller,

and not with a specific device failure-.




PG>Well, I can try to explain the bits that maybe are missing.

PG>* Almost all your problems are block layer problems. Since XFS
PG>  assumes error free block layer, it is your task to ensure that
PG>  the black layer is error free. Which means that almost all the
PG>  work that you should have done was to first ensure that the
PG>  block layer is error free, byt testing fully each drive and
PG>  then putting together the array. It is quite likely that none
PG>  of the issues that your have reported has much to do with XFS.


Couild have to do with the raid controller layer?



PG>* This makes it look like that the *filesystem* is fine, even if
PG> quite a bit of data in each file has been replaced. XFS wisely
PG>  does nothing for the data (other than avoiding to deliberately
PG>  damage it) -- if your application does not add redundancy or
PG>  checksums to the data, you have no way to reconstruct it or even
PG>  check whether it is damaged in case of partial loss.

Well, a binary file with 5% data loss would simply not work.

But I have executables on this filesystem, and they run!

PG > * 2 or more in each of the 20 disk arrays is damaged in the same
PG >offsets, and full data recovery is not possible.



PG>* Somehow 'xfs_repair' managed to rebuild the metadata of
PG>  '/dev/md5' despite a loss of 5-6% of it, so it looks
PG>  "consistent" as far as XFS is concerned, but up to 5-6% of
PG>  each file is essentially random, and it is very difficult to
PG>  know where the random part are.

I don't see any element to support this - at present.

PG>* With '/dev/md4' 'xfs_repair' the 5-6% metadata lost was in
PG>  more critical parts of the filesystem, so the metadata for
PG>  half of the files is gone. Of the remaining files, up to
PG>  5-6% of their data is random.

Half of the file was gone already before repair, and it remains gone after,

and for the remaining files, I have no sign of randomness.



Summarizing, it may well be that the devices are broken but I suspect, again, a failure in the controller.

Could it be?

I contacted Sun and they asked me output of Siga, ipmi, etc.

DAniele




________________________________

 *   Previous message: xfs data loss <http://oss.sgi.com/pipermail/xfs/2009-September/042515.html>
 *   Next message: [PATCH 2/4] xfs: make sure xfs_sync_fsdata covers the log <http://oss.sgi.com/pipermail/xfs/2009-September/042516.html>
 *   Messages sorted by: [ date ]<http://oss.sgi.com/pipermail/xfs/2009-September/date.html#42539> [ thread ]<http://oss.sgi.com/pipermail/xfs/2009-September/thread.html#42539> [ subject ]<http://oss.sgi.com/pipermail/xfs/2009-September/subject.html#42539> [ author ]<http://oss.sgi.com/pipermail/xfs/2009-September/author.html#42539>

________________________________
More information about the xfs mailing list<http://oss.sgi.com/mailman/listinfo/xfs>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
