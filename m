Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19H9GTm258636 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 11:09:16 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC181FF5D3
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 09:08:38 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id mEtYXFhdoLONsVwF for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2009 09:08:38 -0800 (PST)
Message-ID: <49906313.9060501@sandeen.net>
Date: Mon, 09 Feb 2009 11:08:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Accesing data on (old) XFS devices
References: <54506.39868.qm@web34506.mail.mud.yahoo.com>
In-Reply-To: <54506.39868.qm@web34506.mail.mud.yahoo.com>
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
To: Martin Mielke <m_mlk@yahoo.com>
Cc: xfs@oss.sgi.com

Martin Mielke wrote:
> Hi all,
> 
> I have 2 SCSI disks which were used on an (old) Silicon Graphics running on IRIX 6.5.x
> I need to recover the data from those disks, dump them somewhere else and forget about the SGI disks...
> 
> OpenSUSE 11 sees the devices correctly and with fdisk I can see the partitions:
> 
> --
> # fdisk -l /dev/sda
> 
> Disk /dev/sda (SGI disk label): 255 heads, 63 sectors, 4865 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
> 1: /dev/sda1  boot        66      2213  34510368   a  SGI xfs
> 2: /dev/sda2  swap         1        65   1048576   3  SGI raw
> 9: /dev/sda3               0         0      4096   0  SGI volhdr
> 11: /dev/sda4               0      2213  35563040   6  SGI volume
> ----- Bootinfo -----
> Bootfile: /unix
> ----- Directory Entries -----
> 0: sash       sector    2 size  273408
> 1: ide        sector  536 size  249856
> 2: symmon     sector 1024 size 1113600
> 
> 
> # fdisk -l /dev/sdd
> 
> Disk /dev/sdd (SGI disk label): 255 heads, 63 sectors, 9729 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
> 3: /dev/sdd1               1        16    262144   3  SGI raw
> 4: /dev/sdd2              17        32    262144   3  SGI raw
> 5: /dev/sdd3              33       293   4194304   3  SGI raw
> 6: /dev/sdd4             294       555   4194304   3  SGI raw
> 7: /dev/sdd5             556       816   4194304   3  SGI raw
> 8: /dev/sdd6             817      1077   4194304   3  SGI raw
> 9: /dev/sdd7               0         0      4096   0  SGI volhdr
> 11: /dev/sdd8               0      2213  35563040   6  SGI volume
> ----- Bootinfo -----
> Bootfile: /unix
> ----- Directory Entries -----
> 
> --
> 
> I added the following to /etc/raw:
> --
> raw1:sdd1
> raw2:sdd2
> raw3:sdd3
> raw4:sdd4
> raw5:sdd5
> raw6:sdd6
> --

You shouldn't need to play games w/ raw devices, I think.

I'd try:

# file -s /dev/sdd?
# file -s /dev/sda?

and see which partitions claim to hold xfs filesystems (I can't recall
offhand how the sgi partitioning works...)

Those *should* just mount right up.  If they have dirty irix-format
logs, you'll need to either mount (to replay the log) & unmount cleanly
under irix, or zap it with xfs_repair -L

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
