Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f173.google.com ([209.85.222.173]:38410 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbeLTPNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 10:13:10 -0500
Received: by mail-qk1-f173.google.com with SMTP id a1so1181402qkc.5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 07:13:10 -0800 (PST)
Received: from lud1.home ([189.115.213.104])
        by smtp.gmail.com with ESMTPSA id j36sm4296771qtk.15.2018.12.20.07.13.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Dec 2018 07:13:08 -0800 (PST)
Date: Thu, 20 Dec 2018 13:13:05 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: Same size drive has less usable space
Message-ID: <20181220131305.2a84b717@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I have a new drive for backups. 
I copied everything over and now I have this problem:

Filesystem      Size  Used 	 Avail 	Use% 	Mounted on
/dev/sda1   	931G  914G   18G  	99% 	/xx
/dev/sdb1   	931G  920G   11G  	99% 	/xxbkp

So 914GB from the old drive expand and become 920GB. The new drive 
is supposed to be the same size, but for some reason it can't 
really hold it all. I will be forced to waste precious gigabytes.

I tried to format the new one exactly like the old one, but 
it was not possible:

$ xfs_info /xx
meta-data=/dev/sda1     isize=256    agcount=8, agsize=30506944 blks
         =              sectsz=4096  attr=2, projid32bit=1
         =              crc=0        finobt=0 spinodes=0 rmapbt=0
         =              reflink=0
data     =              bsize=4096   blocks=244055552, imaxpct=25
         =              sunit=0      swidth=0 blks
naming   =version 2     bsize=4096   ascii-ci=0 ftype=0
log      =internal      bsize=4096   blocks=119167, version=2
         =              sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none          extsz=4096   blocks=0, rtextents=0


$ xfs_info /xxbkp
meta-data=/dev/sdb1     isize=512    agcount=8, agsize=61013888 blks
         =              sectsz=512   attr=2, projid32bit=1
         =              crc=1        finobt=1 spinodes=1 rmapbt=0
         =              reflink=0
data     =              bsize=2048   blocks=488111104, imaxpct=25
         =              sunit=0      swidth=0 blks
naming   =version 2     bsize=4096   ascii-ci=0 ftype=1
log      =internal      bsize=2048   blocks=238335, version=2
         =              sectsz=512   sunit=0 blks, lazy-count=1
realtime =none          extsz=4096   blocks=0, rtextents=0


I guess at least part of the problem is CRC enabled in the second 
one. So, is there anything I can do to make all the data fit in the 
new drive?

TIA

-- 
Luciano ES
>>
