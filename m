Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 17:22:21 -0700 (PDT)
Received: from mail34.messagelabs.com (mail34.messagelabs.com [216.82.241.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C0MHWt017831
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 17:22:18 -0700
Subject: sunit not working
From: "Salmon, Rene" <Rene.Salmon@bp.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Jun 2007 18:55:34 -0500
Message-Id: <1181606134.7873.72.camel@holwrs01>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi list,

I have a HW raid 5 array with chunck size 256KB and stripe size 2560KB.
Basically a 10+1+1 array. 10 drives, one parity, one spare.

I am trying to create an xfs file system with the appropriate sunit and
width.



# mkfs.xfs -d sunit=512,swidth=5120 -f /dev/mapper/mpath9 
meta-data=/dev/mapper/mpath9     isize=256    agcount=32,
agsize=56652352 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1812874752,
imaxpct=25
         =                       sunit=64     swidth=640 blks,
unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0



As you can see the sunit gets set to 64 upon creation and not 512 like I
asked.  Also if it try to give it some mount options it does the same
thing.

sgi210a:~ # mount -o sunit=512,swidth=5120 /dev/mapper/mpath9 /mnt/   
sgi210a:~ # xfs_info /mnt/
meta-data=/dev/mapper/mpath9     isize=256    agcount=32,
agsize=56652352 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1812874752,
imaxpct=25
         =                       sunit=64     swidth=640 blks,
unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
sgi210a:~ # 




Any ideas?

Last I tried to subscribe to the list by sending email to
ecartis@oss.sgi.com a couple of times but was unsuccessful should I send
email elsewhere to subscribe?



thank you 
Rene
