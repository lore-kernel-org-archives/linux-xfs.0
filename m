Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q639AVhe075651
	for <linux-xfs@oss.sgi.com>; Tue, 3 Jul 2012 04:10:31 -0500
Received: from zhbdzmsp-smta15.bluewin.ch (zhbdzmsp-smta15.bluewin.ch
	[195.186.99.132]) by cuda.sgi.com with ESMTP id
	MyjjgcKDqPBXuHeU for <linux-xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 02:10:29 -0700 (PDT)
Message-ID: <1341306631.5374.12.camel@hoferr-desktop.hofer.rummelring>
Subject: Re: Use whole disk
From: Ramon Hofer <ramonhofer@bluewin.ch>
Date: Tue, 03 Jul 2012 11:10:31 +0200
In-Reply-To: <4FF2B183.1050304@hardwarefreak.com>
References: <jsu88p$t01$1@dough.gmane.org> <4FF2B183.1050304@hardwarefreak.com>
Mime-Version: 1.0
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
To: stan@hardwarefreak.com
Cc: linux-xfs@oss.sgi.com

On Die, 2012-07-03 at 03:46 -0500, Stan Hoeppner wrote:
> On 7/3/2012 2:50 AM, Ramon Hofer wrote:
> > Hi all
> 
> Hi Ramon, welcome to XFS.
> 
> > I hope this is the right place to ask this:
> 
> It is.  But I could have answered this, and any of your XFS questions,
> off list as well. ;)

Yes, I know.
But I didn't want to abuse you as my personal question answering
machine ;-)


> > I wanted to use a 2 TB disk (as mythtv recordings drive) with the xfs 
> > filesystem. Until now I had jfs but I wanted to switch it.
> > 
> > Since I have two drives of the same type I formatted the new drive with 
> > xfs and copied the recordings onto it. Today I saw that I created the 
> > filesystem over the disk instead of the partition:
> 
> Had you already put a partition on the disk?

Yes, I have.


> > ~# mkfs.xfs /dev/sdk
> 
> If yes, did mkfs.xfs throw a warning about overwriting the partition table?

Yes, it did. And I was confused because I thought the warning was
because the disk was in the md9 raid before. But since I have
overwritten the raid partition now I realize that the warning was about
the partition I created afterwards...


> > These are my two disks:
> > 
> > /dev/sdi1      jfs    1.9T  1.9T  3.9G 100% /mnt/recordings
> > /dev/sdk       xfs    1.9T  1.9T  3.3G 100% /mnt/recordings_temp
> > 
> > Is it ok to use the disk instead of the partition or why do I have to 
> > create the filesystem on a partition?
> 
> It's not necessary to put a partition on the disk before formatting with
> XFS.  And in fact, when using Advanced Format drives, it's much easier
> to make sure XFS is sector aligned by directly formatting the disk.
> 
> Partitioning an AF drive to get proper sector alignment can be tricky.
> If you don't get proper sector alignment of the partition, you end up
> with a read/modify/write cycle when a filesystem block is modified.
> This reduces the performance of the drive significantly.  For a write
> mostly mythTV recording drive this probably isn't critical.  But if you
> can avoid the misaligned sector problem it's best to do so.  And you
> easily can by directly formatting the disk device.

So it's better to directly format the disk and not the partition.

I will redo that :-)


Cheers
Ramon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
