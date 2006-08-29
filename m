Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 18:10:02 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7T19lDW002930
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 18:09:48 -0700
Received: by py-out-1112.google.com with SMTP id x31so2420182pye
        for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 18:09:16 -0700 (PDT)
From: "gert wohlgemuth" <wohlgemuth@ucdavis.edu>
Subject: accidently deleted files from directory
Date: Mon, 28 Aug 2006 17:05:30 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <44f384c5.270c085b.5896.ffff9b29@mx.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi and thx for your help,

I'm running a gentoo box and using xfs as file system.

On the weekend it happens that I accidentally deleted 1 TB of data (rm -rdf
/mnt/lcq). We have no backup of the data (internal reasons of the
university...) and it would be nice to get the data somehow back.

After the delete the first step was to unmount the partion and this are the
info's from the xfs_check program.

meta-data=/mnt/lcq               isize=256    agcount=32, agsize=9154978
blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=292959296, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

after I did a cat /dev/sda1 | less I could see that some data are still
exist and are not overwritten. So I think "all" what I have todo is some how
get the journal back.

Is there anyway or is all hope lost?

Thx gert

p.s. pleace CC me (wohlgemuth@ucdavis.edu) because I'm not a member of this
mailing list.
