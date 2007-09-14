Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 02:50:07 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E9o14p009786
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 02:50:03 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 904F4302557A
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 11:27:31 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qQjtE9b0gnb7 for <linux-xfs@oss.sgi.com>;
	Fri, 14 Sep 2007 11:27:31 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 6F3B13025570
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 11:27:31 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 6D943F0A253A2
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 11:27:18 +0200 (CEST)
Date: Fri, 14 Sep 2007 11:27:21 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20070914092712.GA31997@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan> <20070914084125.GA31074@apartia.fr> <20070914091032.GE734179@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914091032.GE734179@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 07:10:32PM +1000, David Chinner wrote:
> 
> Can you tell us the output of 'xfs_info <mntpt>'?

sylla:~# xfs_info /
meta-data=/dev/root              isize=256    agcount=41, agsize=15252656 blks
         =                       sectsz=4096  attr=1
data     =                       bsize=4096   blocks=610178720, imaxpct=25
         =                       sunit=16     swidth=80 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=327680 blocks=0, rtextents=0

> Also, get the inode number of the bad directory (ls -i) and then
> run:
> 
> # xfs_db -r -c "inode <inode_num>" -c "p" <device of fs>

sylla:/lost+found# xfs_db -r -c "inode 1879629858" -c "p" /dev/md1
core.magic = 0x494e
core.mode = 040755
core.version = 1
core.format = 2 (extents)
core.nlinkv1 = 2
core.uid = 0
core.gid = 0
core.flushiter = 9
core.atime.sec = Tue Aug  1 20:49:16 2006
core.atime.nsec = 000000000
core.mtime.sec = Fri Sep 14 09:25:29 2007
core.mtime.nsec = 589593557
core.ctime.sec = Fri Sep 14 09:25:29 2007
core.ctime.nsec = 589593557
core.size = 8192
core.nblocks = 3
core.extsize = 0
core.nextents = 2
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.gen = 0
next_unlinked = null
u.bmx[0-1] = [startoff,startblock,blockcount,extentflag] 0:[0,117476868,2,0] 1:[8388608,125865476,1,0]

> So we can see what the state of the inode is?
> 
> BTW, what problem led you to running xfs_repair in the first
> place (i.e.  what led to lost+found getting populated)?

The infamous 2.6.17.1 corruption.

Thanks,
