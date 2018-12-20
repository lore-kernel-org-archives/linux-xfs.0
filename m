Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47948 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731085AbeLTQKo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 11:10:44 -0500
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
Date: Thu, 20 Dec 2018 10:10:42 -0600
MIME-Version: 1.0
In-Reply-To: <20181220131305.2a84b717@lud1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>, linux-xfs@vger.kernel.org

On 12/20/18 9:13 AM, Luciano ES wrote:
> I have a new drive for backups. 
> I copied everything over and now I have this problem:
> 
> Filesystem      Size  Used 	 Avail 	Use% 	Mounted on
> /dev/sda1   	931G  914G   18G  	99% 	/xx
> /dev/sdb1   	931G  920G   11G  	99% 	/xxbkp
> 
> So 914GB from the old drive expand and become 920GB. The new drive 
> is supposed to be the same size, but for some reason it can't 
> really hold it all. I will be forced to waste precious gigabytes.
> 
> I tried to format the new one exactly like the old one, but 
> it was not possible:
> 
> $ xfs_info /xx
> meta-data=/dev/sda1     isize=256    agcount=8, agsize=30506944 blks
>          =              sectsz=4096  attr=2, projid32bit=1
>          =              crc=0        finobt=0 spinodes=0 rmapbt=0
>          =              reflink=0
> data     =              bsize=4096   blocks=244055552, imaxpct=25
>          =              sunit=0      swidth=0 blks
> naming   =version 2     bsize=4096   ascii-ci=0 ftype=0
> log      =internal      bsize=4096   blocks=119167, version=2
>          =              sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none          extsz=4096   blocks=0, rtextents=0
> 
> 
> $ xfs_info /xxbkp
> meta-data=/dev/sdb1     isize=512    agcount=8, agsize=61013888 blks
>          =              sectsz=512   attr=2, projid32bit=1
>          =              crc=1        finobt=1 spinodes=1 rmapbt=0
>          =              reflink=0
> data     =              bsize=2048   blocks=488111104, imaxpct=25
>          =              sunit=0      swidth=0 blks
> naming   =version 2     bsize=4096   ascii-ci=0 ftype=1
> log      =internal      bsize=2048   blocks=238335, version=2
>          =              sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none          extsz=4096   blocks=0, rtextents=0
> 
> 
> I guess at least part of the problem is CRC enabled in the second 
> one. So, is there anything I can do to make all the data fit in the 
> new drive?

Well, you have larger inodes on xxbkp for starters.  If you want,

# mkfs.xfs -m crc=0,finobt=1 -i sparse=0 -n ftype=0

should get you the same geometry.  This is all documented in the mfks.xfs
manpage, btw.

But beware that copying sparse files w/o maintaining sparseness (for example)
will also consume more space.  If you want a nothing less than a bit-for-bit
copy, use dd.  ;)

-Eric
