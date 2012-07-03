Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q638l04l074111
	for <linux-xfs@oss.sgi.com>; Tue, 3 Jul 2012 03:47:01 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Rs852EWw9p3gEqbq
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jul 2012 01:46:59 -0700 (PDT)
Message-ID: <4FF2B183.1050304@hardwarefreak.com>
Date: Tue, 03 Jul 2012 03:46:59 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Use whole disk
References: <jsu88p$t01$1@dough.gmane.org>
In-Reply-To: <jsu88p$t01$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
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
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-xfs@oss.sgi.com

On 7/3/2012 2:50 AM, Ramon Hofer wrote:
> Hi all

Hi Ramon, welcome to XFS.

> I hope this is the right place to ask this:

It is.  But I could have answered this, and any of your XFS questions,
off list as well. ;)

> I wanted to use a 2 TB disk (as mythtv recordings drive) with the xfs 
> filesystem. Until now I had jfs but I wanted to switch it.
> 
> Since I have two drives of the same type I formatted the new drive with 
> xfs and copied the recordings onto it. Today I saw that I created the 
> filesystem over the disk instead of the partition:

Had you already put a partition on the disk?

> ~# mkfs.xfs /dev/sdk

If yes, did mkfs.xfs throw a warning about overwriting the partition table?

> These are my two disks:
> 
> /dev/sdi1      jfs    1.9T  1.9T  3.9G 100% /mnt/recordings
> /dev/sdk       xfs    1.9T  1.9T  3.3G 100% /mnt/recordings_temp
> 
> Is it ok to use the disk instead of the partition or why do I have to 
> create the filesystem on a partition?

It's not necessary to put a partition on the disk before formatting with
XFS.  And in fact, when using Advanced Format drives, it's much easier
to make sure XFS is sector aligned by directly formatting the disk.

Partitioning an AF drive to get proper sector alignment can be tricky.
If you don't get proper sector alignment of the partition, you end up
with a read/modify/write cycle when a filesystem block is modified.
This reduces the performance of the drive significantly.  For a write
mostly mythTV recording drive this probably isn't critical.  But if you
can avoid the misaligned sector problem it's best to do so.  And you
easily can by directly formatting the disk device.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
