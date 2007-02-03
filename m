Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 03 Feb 2007 11:05:25 -0800 (PST)
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l13J5Hqw015000
	for <xfs@oss.sgi.com>; Sat, 3 Feb 2007 11:05:19 -0800
Received: from unknown (HELO ulg.ac.be) ([139.165.123.213])
          (envelope-sender <wildcat@espix.org>)
          by serv108.segi.ulg.ac.be (qmail-ldap-1.03) with SMTP
          for <xfs@oss.sgi.com>; 3 Feb 2007 19:37:43 +0100
Date: Sat, 3 Feb 2007 19:37:23 +0100
From: wildcat <wildcat@espix.org>
Subject: XFS "no space left" problem
Message-ID: <20070203183723.GA1652@dunno.espix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi dear list,


I recently migrated a 1.3Tbyte partition from reiserfs to XFS.
As the 1.3Tb partition was full, my idea was to shrink reiserfs
partition of 100Gig at a time, and then grow the XFS one.

This has been working since 1.1To for XFS partition. Now I'm in the
following situation:


/dev/mapper/crypt-data
                      1.2T  1.1T  134G  89% /jail2

dunno jail2 # touch a
dunno jail2 # touch b 
touch: cannot touch `b': No space left on device
dunno jail2 # 


>From there if I delete 'a', I could create a file of any size. but then
will be running
again into the "no space left".

>From here, some people told me of an inodes problem, that I checked
first:
/dev/mapper/crypt-data
                     561850144  158335 561691809    1% /jail2

is outputing from df -i.

umount/remount of the partition doesn't change anything. 


here are some information about the filesystem details:


dunno jail2 # xfs_info /jail2
meta-data=/dev/crypt/data        isize=256    agcount=188,
agsize=1638400 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=306708480,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=12800, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

dunno / # xfs_db /dev/crypt/data 
xfs_db> frag
actual 140099, ideal 134926, fragmentation factor 3.69%
xfs_db> freesp
   from      to extents  blocks    pct
      1       1     801     801   0.00
      2       3       2       5   0.00
     32      63       2      89   0.00
    128     255       3     517   0.00
    256     511       4    1676   0.00
    512    1023       5    3776   0.01
   1024    2047       7   10765   0.03
 262144  524287      23 9200216  26.21
1048576 1638400      16 25888649  73.74
xfs_db> 


I can't think of a Fix solution from here and I'm stuck.

As this box is in production and remotely managed; Go to the
place, take the hard drives and backup/restore is not a solution.

Any help/comment/fix/idea would be very appreciated.
Any additionnal information you need could be asked :)


TIA,
Best regards,



wildcat
