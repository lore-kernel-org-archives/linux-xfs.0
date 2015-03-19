Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70E797F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 12:02:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 410D2304051
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:01:57 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	by cuda.sgi.com with ESMTP id 6nZ4UXRDo7OsNEql (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 10:01:54 -0700 (PDT)
Received: from lisa ([84.169.13.194]) by mrelayeu.kundenserver.de (mreue001)
	with ESMTPA (Nemesis) id 0MR7Py-1YxVaI4A5m-00UHw2 for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 18:01:53 +0100
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id D672D1B971B00
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:01:52 +0100 (CET)
Received: from tyrex.lisa.loc ([127.0.0.1])
	by localhost (tyrex.lisa.loc [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id NmFGcxK3tKr9 for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 18:01:51 +0100 (CET)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: xfs write performance issue
Date: Thu, 19 Mar 2015 18:01:50 +0100
Message-ID: <8976870.8vOdNBKrI1@xrated>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'm struggling with a severe write performance problem to a 12TB XFS FS.
The system sports an ancient userspace (openSUSE 11.1), but major parts are 
current, e.g. kernel 3.19.1.

Unfortunately, for historical reasons, it's also 32bit (pae), and I cannot get 
rid of it quickly..

Partition was migrated several times (to higher capacity disks), and the 
filesystem is somewhat aged too:

~# LANG=C xfs_info /dev/sdc1
meta-data=/dev/sdc1              isize=256    agcount=17, agsize=183105406 
blks
         =                       sectsz=512   attr=2, projid32bit=0
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=2929687287, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =Intern                 bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

~# LANG=C parted /dev/sdc
GNU Parted 1.8.8
Using /dev/sdc
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) unit s                                                           
(parted) print                                                            
Model: Areca ARC-1680-VOL#001 (scsi)
Disk /dev/sdc: 23437498368s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End           Size          File system  Name     Flags                 
 1      34s    23437498334s  23437498301s  xfs          primary  , , , , , , , 
, , , , 

(parted) q                                                                

This is on a Areca 1680 RAID 5 set, consisting of:

SLOT 05(0:7) 	Raid Set # 001 	4000.8GB 	Hitachi HUS724040ALE640
SLOT 06(0:6) 	Raid Set # 001 	4000.8GB 	Hitachi HUS724040ALE640
SLOT 07(0:5) 	Raid Set # 001 	4000.8GB 	Hitachi HUS724040ALE640
SLOT 08(0:4) 	Raid Set # 001 	4000.8GB 	HGST HUS724040ALA640 

Volume Set Name 	ARC-1680-VOL#001
Raid Set Name 	Raid Set # 001
Volume Capacity 	12000.0GB
SCSI Ch/Id/Lun 	0/0/3
Raid Level 	Raid 5
Stripe Size 	128KBytes
Block Size 	512Bytes
Member Disks 	4
Cache Mode 	Write Back
Write Protection 	Disabled
Tagged Queuing 	Enabled
Volume State 	Normal

Read performance for a bigger file is about 400 MB/s on average (with flushed 
caches of course..)

~# LANG=C dd if=Django_Unchained.mp4 of=/dev/null bs=1M 
1305+1 records in
1305+1 records out
1369162196 bytes (1.4 GB) copied, 3.32714 s, 412 MB/s

Write performance is disastrous: it's about 1.5 MB/s.

~# LANG=C dd if=Django_Unchained.mp4 of=xxx bs=1M 
482+0 records in
482+0 records out
505413632 bytes (505 MB) copied, 368.816 s, 1.4 MB/s
1083+0 records in
1083+0 records out
1135607808 bytes (1.1 GB) copied, 840.072 s, 1.4 MB/s
1305+1 records in
1305+1 records out
1369162196 bytes (1.4 GB) copied, 1014.87 s, 1.4 MB/s

The question is, what could explain these numbers. Bad alignment? Bad stripe 
size? And what can I do to resolve this - without loosing all my data..

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
