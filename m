Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B541380D7
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 10:29:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83CE58F8071
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 08:29:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id b2Mphgt9VhxPcIBy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 08:14:01 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t0QGE0XC024056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 16:14:01 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	t0QGDx0O008806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 16:14:00 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	t0QGDwdB024980 for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 16:13:59 GMT
Message-ID: <54C667F3.8040303@oracle.com>
Date: Mon, 26 Jan 2015 19:14:43 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: maxpct option for small xfs filesystems
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
To: xfs@oss.sgi.com

Hello,

I'm trying to understand the expected behaviour of "maxpct" option in 
case of small xfs filesystem
comparing the maximum percentage defined for this option with the 
percentage of actually allocated
inodes in filesystem, but the result of prepared test case doesn't 
correspond to the expectations:

[root@fedora ~]#mkfs.xfs -f -d size=16m -i maxpct=1 /dev/sdb2
[root@fedora ~]# mount /dev/sdb2 /mnt/scratch/
[root@fedora ~]# mount | grep scratch
/dev/sdb2 on /mnt/scratch type xfs 
(rw,relatime,seclabel,attr2,inode64,noquota)
[root@fedora ~]# xfs_info /mnt/scratch/
meta-data=/dev/sdb2        isize=256    agcount=1, agsize=4096 blks
                  =                       sectsz=512   attr=2, projid32bit=1
                  =                       crc=0        finobt=0
data          =                       bsize=4096   blocks=4096, imaxpct=1
                  =                       sunit=0      swidth=0 blks
naming     =version 2        bsize=4096   ascii-ci=0 ftype=0
log            =internal           bsize=4096   blocks=853, version=2
                  =                       sectsz=512   sunit=0 blks, 
lazy-count=1
realtime    =none               extsz=4096   blocks=0, rtextents=0

then trying to fill filesystem with lot of empty files until enospc 
obtained and break the loop:

[root@fedora ~]# for i in {0..100000}; do str=$(mktemp 
--tmpdir=/mnt/scratch tmp.XXXXXXXXXX); echo $str; done

filesystem is full with created files:

[root@fedora ~]# df -Th | grep scratch
/dev/sdb2      xfs        13M   13M  148K  99% /mnt/scratch

and from the number of actually created inodes:

[root@fedora ~]# xfs_db -c "blockget -n" -c "ncheck" /dev/sdb2 | wc -l
40512

it's calculated the space allocated for file inodes 9.9Mb (40512*256b 
inode size) that is about 77% of filesystem
space instead of defined maximum with maxpct=1% or even default 25% value.

Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
