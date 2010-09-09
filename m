Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89Ie1Ie112903 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 13:40:01 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5059B1D85CCE
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 11:40:45 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id HUdhUu85Zni65KuC
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 11:40:45 -0700 (PDT)
Received: by fxm15 with SMTP id 15so1210657fxm.26
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 11:40:44 -0700 (PDT)
Message-ID: <4C892A32.1000404@googlemail.com>
Date: Thu, 09 Sep 2010 20:40:50 +0200
From: Marcus Osdoba <marcus.osdoba@googlemail.com>
MIME-Version: 1.0
Subject: logerrors on armv5te hardware rendering xfs-partition unmountable
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

  Dear mailinglist,

I run a kernel 2.6.35.4 on my SeagateDockStar which is based on the 
sheevaplug (kirkwood armv5te).
Once searching the archive of the this mailinglist, I figured out, that 
there problems in the past with running xfs on CPUs with virtually 
indexed caches (like arm). A series of patches was applied in Febuary 
2010 with the purpose to resolve the problems on arm devices.

With the recent linux kernel I'm using, I still discover errors. I was 
forced to run xfs_repair -l /dev/sdx1 before I could mount the partition 
again.
I was asked by one of the respectable mailinglist members to give the 
complete output of the commands I launched.

Please find below the hardcopy of my terminal output and let me know, 
what debug information do you need and how (and when) this must be obtained.

Thank you and kind regards,
Marcus

$ mkfs.xfs -f /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=4, agsize=19535620 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=78142479, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=38155, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ mount -t xfs /dev/sda1 /data
$ dmesg|tail
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk
SGI XFS with ACLs, security attributes, large block/inode numbers, no 
debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
$ cp /bin/* /data
$ umount /data
$ xfs_logprint /dev/sda1|tail
----------------------------------------------------------------------------
Oper (0): tid: 22e742e6  len: 4  clientid: TRANS  flags: WAS_CONT END
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: 22e742e6  len: 512  clientid: TRANS  flags: none
Left over region from split log item
----------------------------------------------------------------------------
Oper (2): tid: 22e742e6  len: 256  clientid: TRANS  flags: none
xfs_logprint: unknown log operation type (e3cf)
**********************************************************************
* ERROR: data block=66                                                *
**********************************************************************
Bad data in log
$ mount -t xfs /dev/sda1 /data
$ dmesg|tail
SGI XFS with ACLs, security attributes, large block/inode numbers, no 
debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
$ mkdir /data/usr;cp -r /usr /data/usr
$ umount /data
$ xfs_logprint /dev/sda1|tail
xfs_logprint: unknown log operation type (e3cf)
Bad data in log
Oper (0): tid: 22e742e6  len: 4  clientid: TRANS  flags: WAS_CONT END
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: 22e742e6  len: 512  clientid: TRANS  flags: none
Left over region from split log item
----------------------------------------------------------------------------
Oper (2): tid: 22e742e6  len: 256  clientid: TRANS  flags: none
**********************************************************************
* ERROR: data block=66                                                *
**********************************************************************
$ mount -t xfs /dev/sda1 /data
mount: mounting /dev/sda1 on /data failed: Input/output error
$ dmesg|tail
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
XFS: xlog_recover_process_data: bad clientid
XFS: log mount/recovery failed: error 5
XFS: log mount failed
$


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
