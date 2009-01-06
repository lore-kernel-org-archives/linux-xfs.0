Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n069B99j001801 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 03:11:10 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D6EC64A4C
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 01:11:07 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.181]) by cuda.sgi.com with ESMTP id
	ZzTHrt3CLW7Cc482 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 01:11:07 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id j5so4402668wah.4
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 01:11:07 -0800 (PST)
Message-ID: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
Date: Tue, 6 Jan 2009 11:11:07 +0200
From: "Gergely Soos" <sogerc1@gmail.com>
Subject: need help to repair XFS partition
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_173123_1462380.1231233067453"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

------=_Part_173123_1462380.1231233067453
Content-Type: multipart/alternative;
	boundary="----=_Part_173124_5728548.1231233067454"

------=_Part_173124_5728548.1231233067454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings

I heard that people compliment XFS for being the fastest FS these days so I
thought I give it a try.
What I did was that I converted my old 107GB FAT32 partition to XFS (I
created an XFS over it) and I wanted to use it as /home
Everything went as it should, I moved the files from my old /home then I
restarted (cleanly!) under windows.
When I got back from windows I was no longer able to mount the XFS
partition.
xfs_repair only said that the superblock is invalid and attempts to find
secondary superblocks but all candidates fail.
So I created a file on another computer with the exact same size as the
partition on my computer and created an XFS on it.
Then I extracted the first 512 bytes and copied to my HDD using dd. But it
complained about the UUID so I corrected it using khexedit.
Then xfs_db complained that it cannot find the root inode so I wrote a
little perl script to search it.
You can find it in myxfs.tar.bz2. It seems that it found the root inode
because after I corrected the address using khexedit
xfs_db started complaining about the realtime bitmap inodes, so I corrected
those too (using inode numbers rootino+1 and rootino+2).
And this is where I'm stuck.
The mount still fails, dmesg says that it cannot find the root inode,
xfs_repair says the same old thing, xfs_check says a lot of things,
most of them are messages like this: can't seek in filesystem at bb <some
numbers> or: ag bad magick number.
That exceeds my knowledge.
Please help me restore the partition, It contains lots of programmes I wrote
over the years and some of them are not backed up,
some of them are, but only an older version. I also have personal stuff on
it like my bill records that I cannot recover from anywhere else.
myxfs.tar.bz2 contains the perl script I mentioned above and the inodes it
found. The one staring with ri is the root inode,
the files starting with sb are the suspected superblocks (I also took one of
those at random and corrected the three inode numbers
with khexedit but the result is the same) and the file backup_bootsect
contains the original superblock that was on the disk after I came back
from windows xp. It does not look like anything to me...
The numbers after ri and sb are the starting address in bytes of the inode
on the disk.
I would also attach the output of xfs_metadump which I created after I
corrected the three inode numbers in the superblock but even bzip-ed
it is more than 3MB and the administrator of this list does not accept it.

Please help,
Gergely

------=_Part_173124_5728548.1231233067454
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings<br><br>I heard that people compliment XFS for being the fastest FS these days so I thought I give it a try.<br>What I did was that I converted my old 107GB FAT32 partition to XFS (I created an XFS over it) and I wanted to use it as /home<br>

Everything went as it should, I moved the files from my old /home then I restarted (cleanly!) under windows.<br>When I got back from windows I was no longer able to mount the XFS partition.<br>xfs_repair only said that the superblock is invalid and attempts to find secondary superblocks but all candidates fail.<br>

So I created a file on another computer with the exact same size as the partition on my computer and created an XFS on it.<br>Then
I extracted the first 512 bytes and copied to my HDD using dd. But it
complained about the UUID so I corrected it using khexedit.<br>
Then xfs_db complained that it cannot find the root inode so I wrote a little perl script to search it.<br>You can find it in myxfs.tar.bz2. It seems that it found the root inode because after I corrected the address using khexedit<br>

xfs_db started complaining about the realtime bitmap inodes, so I
corrected those too (using inode numbers rootino+1 and rootino+2).<br>And this is where I&#39;m stuck.<br>The
mount still fails, dmesg says that it cannot find the root inode,
xfs_repair says the same old thing, xfs_check says a lot of things,<br>
most of them are messages like this: can&#39;t seek in filesystem at bb &lt;some numbers&gt; or: ag bad magick number.<br>That exceeds my knowledge.<br>Please help me restore the partition, It contains lots of programmes I wrote over the years and some of them are not backed up,<br>

some of them are, but only an older version. I also have personal stuff
on it like my bill records that I cannot recover from anywhere else.<br>myxfs.tar.bz2 contains the perl script I mentioned above and the inodes it found. The one staring with ri is the root inode,<br>
the files starting with sb are the suspected superblocks (I also took
one of those at random and corrected the three inode numbers<br>with
khexedit but the result is the same) and the file backup_bootsect
contains the original superblock that was on the disk after I came back<br>
from windows xp. It does not look like anything to me...<br>The numbers after ri and sb are the starting address in bytes of the inode on the disk.<br>I would also attach the output of xfs_metadump which I created after I corrected the three inode numbers in the superblock but even bzip-ed<br>
it is more than 3MB and the administrator of this list does not accept it.<br>
<br>Please help,<br><font color="#888888">Gergely</font>

------=_Part_173124_5728548.1231233067454--

------=_Part_173123_1462380.1231233067453
Content-Type: application/x-bzip2; name=myxfs.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpmc7caz0
Content-Disposition: attachment; filename=myxfs.tar.bz2

QlpoOTFBWSZTWTgWKfQACE3///////3//////////////////P93/fv//u7v
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
kDgWKfQ=

------=_Part_173123_1462380.1231233067453
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_173123_1462380.1231233067453--
