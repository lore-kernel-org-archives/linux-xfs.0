Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 04:30:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4JBUWGg025900
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 04:30:33 -0700
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53FA8187497
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 04:31:20 -0700 (PDT)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.155]) by cuda.sgi.com with ESMTP id mI19WZSyEFEz6zJI for <xfs@oss.sgi.com>; Mon, 19 May 2008 04:31:20 -0700 (PDT)
Received: by yw-out-1718.google.com with SMTP id 5so1122341ywm.32
        for <xfs@oss.sgi.com>; Mon, 19 May 2008 04:31:19 -0700 (PDT)
Message-ID: <1a4a774c0805190431j31a182bdu61030bbfcc80f41@mail.gmail.com>
Date: Mon, 19 May 2008 13:31:19 +0200
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS filesystem reports as full though it isn't
In-Reply-To: <20080516222755.3e557c00@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516222755.3e557c00@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Fri, May 16, 2008 at 10:27 PM, Emmanuel Florac
<eflorac@intellique.com> wrote:
>
> I have a 64 bits (x86_64) machine running Linux 2.6.22.19 with a 24TB
> XFS filesystem. There are some 15TB of data on it. All is well, no
> error except that I can't create a single file (touch foo : no space
> left on device). I don't understand what can be going wrong...
>
> History : this filesystem was extended (xfs_growfs) from 16TB to 24.
>
>
> Here is the output from xfs_info /dev/vg0/lv0
>
> meta-data=/dev/vg0/lv0           isize=256    agcount=47,
> agsize=137245616 blks =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=6344964096,
> imaxpct=25 =                       sunit=16     swidth=32 blks,
> unwritten=1 naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>         =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=131072 blocks=0, rtextents=0
>
> I fail to see nothing special there however.
>
> The only significant thing I see is that the FS is really close to 16
> TB of allocated data (15.7TB). I tried mounting it with "inode64"
> option with no more loving.
>

On my system I get "no space left on device"  when I reach 99% full
with about 20GB free space left on 2TB partitions.
I also use sunit and swidth for the data section of the xfs
filesystem, and it could be that the XFS system cannot allocate
space according to these parameters ? You seem to be around the
original 16TB limit, and maybe it tries to allocate
from this original disk layout ? (I'm no XFS expert, so please take my
"theories" with a grain of salt)

I recently had two "identical" partitions: A and B, where A was the
master and B was the rsync copy. These had been
written to for several years, and during that period they both have
had the role as master. I suppose the disk usage layout
was different. All of a sudden partition B reported "no space left on
device", even though partition A contained the
same data without any "no space left on device". What I did to get the
B to copy the missing data from partition A was to:
Temporarily move some data away from partition B, then run xfs_fsr on
partition B, then move the data back.
It brought the fragmentation down on partition B, and I could copy the
missing data from partition B.

Christian
