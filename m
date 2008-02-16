Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 20:10:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G4ALwK025769
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:10:23 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D5BBE369A9
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:10:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YxV1235eBnHOE4NK for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:10:45 -0800 (PST)
Message-ID: <47B66223.4080604@sandeen.net>
Date: Fri, 15 Feb 2008 22:10:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Differences in mkfs.xfs and xfs_info output.
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
In-Reply-To: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: xfs@oss.sgi.com

Jan Derfinak wrote:
> Hello.
> 
> I found following problem with xfs_info (xfs_grows -p xfs_info) command:
> 
> # mkfs.xfs -f /dev/loop0     
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # mount /dev/loop0 /mnt/usb
> # xfs_info /mnt/usb
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Can somebody explain the difference in attr and lazy-count parameters?
> Which output is the right one?

...

> features2 = 0


Looks like neither XFS_SB_VERSION2_ATTR2BIT nor
XFS_SB_VERSION2_LAZYSBCOUNTBIT is in fact set.

You're on x86_64 aren't you...

This reminds me of an email I sent in 2006....

> If you do a fresh mkfs.xfs on x86_64, with -i attr=2, and dump out the
> superblock (or look at it with xfs_db) you will find that although the
> versionnum says that there is a morebits bit, the features2 flag is 0.
> 
> if you dd/hexdump the superblock, you will find the attr2 flag, but at
> the wrong offset.
> 
> This is because the xfs_sb_t struct is padded out to 64 bits on 64-bit
> arches, and the xfs_xlatesb() routine and xfs_sb_info[] array take this
> padding to mean that the last item is 4 bytes bigger than it is, and
> treats sb_features2 as 8 bytes not four.  This then gets endian-flipped out...

which is exactly what is (still) going on.

if you hexdump out the filesystem that was made you'll see:

....
          sbqf  sv vn inode_algn   sbunit      sbwidth
000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00
|................|
          bl sl lgss     logsunit  features2   (nothing)
000000c0  00 00 00 00 00 00 00 01  00 00 00 00 00 00 00 08
|................|

that "08" out in no mans land is what would *like* to be features2 - and
if it were, it'd give you attr2.  Urk.

-Eric
