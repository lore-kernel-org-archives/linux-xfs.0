Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7SCVh2E261759 for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 07:31:44 -0500
Received: from nm5.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 13FBF12148E
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 05:31:41 -0700 (PDT)
Received: from nm5.bullet.mail.sg1.yahoo.com (nm5.bullet.mail.sg1.yahoo.com
	[115.178.12.249]) by cuda.sgi.com with SMTP id Zr0K0aMvnxb9Oghv
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 05:31:41 -0700 (PDT)
Message-ID: <1314534700.48540.YahooMailClassic@web77701.mail.sg1.yahoo.com>
Date: Sun, 28 Aug 2011 20:31:40 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: xfsrestore Does Only Only Partial Restore
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
To: xfs@oss.sgi.com

Hi,

This is the very first time I tried doing a xfsrestore of a back up and I hit some serious trouble.

I had openSUSE 11.1 (kernel 2.6.27) on my Acer notebook.  I did a xfsdump of /home to a WD My Passport external USB hard drive with XFS on it.

I installed openSUSE 11.4 (kernel 2.6.37), then tried to do xfsrestore from the WD USB drive.  The dump file is 121 GB.

I tried two times on two different days, but each time the xfsrestore would stop writing at the exact same point, 49 GB and say success at the end.

I then copied the dump file to one hard drive on my desk top, and did a dump to another hard drive, to /tmp/mnt3.  I get back identical messages:

chingl@optimus:~> df
  Filesystem           1K-blocks      Used Available Use% Mounted on
  rootfs               104878048  42063828  62814220  41% /
  devtmpfs               1021032       480   1020552   1% /dev
  tmpfs                  1027960      1064   1026896   1% /dev/shm
  /dev/sda2            104878048  42063828  62814220  41% /
  /dev/sda3            863017248 730313100 132704148  85% /home
  /dev/sdb2             73363456   6071484  67291972   9% /tmp/mnt2
  /dev/sdb3            869382652  50612736 818769916   6% /tmp/mnt3
  chingl@optimus:~> df -h
  Filesystem            Size  Used Avail Use% Mounted on
  rootfs                101G   41G   60G  41% /
  devtmpfs              998M  480K  997M   1% /dev
  tmpfs                1004M  1.1M 1003M   1% /dev/shm
  /dev/sda2             101G   41G   60G  41% /
  /dev/sda3             824G  697G  127G  85% /home
  /dev/sdb2              70G  5.8G   65G   9% /tmp/mnt2
  /dev/sdb3             830G   49G  781G   6% /tmp/mnt3
  chingl@optimus:~> cd archive/rat
  chingl@optimus:~/archive/rat> ll
  total 126638256
  -rw-r--r-- 1 chingl users 129677563808 Aug 18 14:41 rat18Aug2011
  chingl@optimus:~/archive/rat>
{>
(>optimus:~ # xfsrestore -f /home/chingl/archive/rat/rat18Aug2011 /tmp/mnt3
  xfsrestore: using file dump (drive_simple) strategy
  xfsrestore: version 3.0.1 (dump format 3.0) - Running single-threaded
  xfsrestore: searching media for dump
  xfsrestore: examining media file 0
  xfsrestore: dump description:
  xfsrestore: hostname: rat
  xfsrestore: mount point: /home
  xfsrestore: volume: /dev/sdb3
  xfsrestore: session time: Thu Aug 18 12:57:36 2011
2>xfsrestore: level: 0
  xfsrestore: session label: "rat_18Aug2011"
  xfsrestore: media label: "rat18Aug2011"
  xfsrestore: file system id: f3b08587-cf98-4b7b-99b0-dc9d4e77b631
  xfsrestore: session id: d8069cd0-a092-4fb2-b378-0eda33474aae
  xfsrestore: media id: 96370000-6e2c-40eb-9c3c-93ca42de7524
  xfsrestore: searching media for directory dump
  xfsrestore: reading directories
  xfsrestore: 90820 directories and 539579 entries processed
  xfsrestore: directory post-processing
1>xfsrestore: restoring non-directory files
9>xfsrestore: attempt to read 1008286921 bytes failed: end of recorded data
  xfsrestore: user quota information written to '/tmp/mnt3/xfsdump_quotas'
7>xfsrestore: group quota information written to '/tmp/mnt3/xfsdump_quotas_group'
4>xfsrestore: use 'xfs_quota' to restore quotas
  xfsrestore: restore complete: 2522 seconds elapsed
  xfsrestore: Restore Status: SUCCESS
  optimus:~ #

I downloaded xfsdump-3.0.5.tar.gz, did a build, and tried to do a restore using the newly built xfsrestore:

chingl@optimus:~/testdump> df -h
  Filesystem            Size  Used Avail Use% Mounted on
  rootfs                101G   41G   60G  41% /
  devtmpfs              998M  480K  997M   1% /dev
  tmpfs                1004M  1.1M 1003M   1% /dev/shm
  /dev/sda2             101G   41G   60G  41% /
  /dev/sda3             824G  697G  127G  85% /home
  /dev/sdb2              70G  5.8G   65G   9% /tmp/mnt2
  /dev/sdb3             830G   49G  781G   6% /tmp/mnt3
  chingl@optimus:~/testdump> df
  Filesystem           1K-blocks      Used Available Use% Mounted on
  rootfs               104878048  42063828  62814220  41% /
  devtmpfs               1021032       480   1020552   1% /dev
  tmpfs                  1027960      1064   1026896   1% /dev/shm
  /dev/sda2            104878048  42063828  62814220  41% /
  /dev/sda3            863017248 730313900 132703348  85% /home
  /dev/sdb2             73363456   6071484  67291972   9% /tmp/mnt2
  /dev/sdb3            869382652  50612640 818770012   6% /tmp/mnt3
  chingl@optimus:~/testdump>
  
{>
  optimus:/home/chingl/archive/rat # /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore -f ./rat18Aug2011 /tmp/mnt3
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: using file dump (drive_simple) strategy
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: version 3.0.5 (dump format 3.0) - Running single-threaded
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: searching media for dump
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: examining media file 0
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: dump description:
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: hostname: rat
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: mount point: /home
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: volume: /dev/sdb3
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session time: Thu Aug 18 12:57:36 2011
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: level: 0
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session label: "rat_18Aug2011"
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: media label: "rat18Aug2011"
3>/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: file system id: f3b08587-cf98-4b7b-99b0-dc9d4e77b631
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: session id: d8069cd0-a092-4fb2-b378-0eda33474aae
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: media id: 96370000-6e2c-40eb-9c3c-93ca42de7524
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: searching media for directory dump
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: reading directories
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: 90820 directories and 539579 entries processed
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: directory post-processing
  /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore: restoring non-directory files
  xfsrestore: content.c:7510: restore_extent_group: Assertion `ehdr.eh_type == 4' failed.
(>Aborted
2>optimus:/home/chingl/archive/rat #


Could some one please assist to enlighten me what is going on, why does the restoration fail?  The xfsdump session looked OK.

Is there any way I can extract back my /home back up?  This is my only back up copy.  i have two other xfsdump dump files taken earlier, I have not tried those.

Is xfsdump and xfsrestore really robust for dump to regular file, or should I have done a tar instead?

Thank you.

GL

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
