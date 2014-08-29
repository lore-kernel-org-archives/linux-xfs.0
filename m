Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E90CD7F9A
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 10:02:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77C90AC007
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 08:02:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DVW4VFMM5wjXJtvW for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 08:02:25 -0700 (PDT)
Message-ID: <54009603.9050404@sandeen.net>
Date: Fri, 29 Aug 2014 10:02:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Run out of inodes?
References: <54005108.1020203@inserm.fr>	<20140829114806.GA17610@bfoster.bfoster>
	<5400802C.5050005@inserm.fr>
In-Reply-To: <5400802C.5050005@inserm.fr>
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
To: Samuel Granjeaud <samuel.granjeaud@inserm.fr>, xfs@oss.sgi.com

On 8/29/14, 8:29 AM, Samuel Granjeaud wrote:
> Taking into account the two answers, here is some more information.
> 
> The system is a openfiler installation, v2.3, up-to-date.
> https://www.openfiler.com/community/download
> 
> The problematic system is a backup but the production system uses the same openfiler NAS system. The difference is that there are currently more files on the backup system than the production system; so I guess the problem will appear sooner on the prod sys.
> 
> # xfs_info /dev/vg1_backup/backup
> meta-data=/mnt/vg1_backup/backup isize=256    agcount=80, agsize=58981376 blks
>          =                       sectsz=512
> data     =                       bsize=4096   blocks=4718510080, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> # uname -a
> Linux 2.6.26.8-1.0.11.smp.gcc3.4.x86_64 #1 SMP Sun Jan 11 02:42:55 GMT 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> # xfs_info -V /dev/vg1_backup/backup
> xfs_info version 2.6.25
> 
> # cat /etc/fstab
> ...
> /dev/vg1/pcurrent /mnt/vg1/pcurrent xfs defaults,usrquota,grpquota 0 0
> 
> # cat /etc/mtab
> ...
> /dev/mapper/vg1-pcurrent /mnt/vg1/pcurrent xfs rw,usrquota,grpquota 0 0

<thanks for all the extra info>

> I have no idea concerning the inode64 option. Just tell me how to find it out. I don't think this option was changed: as previously told, removing a few files allows files to be created without error.

You'll want to be using the inode64 mount option for this filesystem; I'm surprised the openfiler folks didn't do this by default.

http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F

add it to fstab for this filesystem, reboot the box (or unmount/mount the filesystem) and all should be well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
