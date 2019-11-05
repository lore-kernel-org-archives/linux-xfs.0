Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE7FC49EAD
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 09:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9591121D7C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 09:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTON8c/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfKEJd0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 04:33:26 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:42602 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbfKEJdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 04:33:25 -0500
Received: by mail-wr1-f41.google.com with SMTP id a15so20455904wrf.9
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 01:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LUzt8R5HrGpYPOZMEfl9oGPvkl6VG3pyisyNaU3H8qQ=;
        b=CTON8c/RquHZNuzKjyw1iy3WcaGbMzXDYUS4R55AKDr/J+sl62zZY/cDs/18W1nEut
         60GFuN5qgi7SuK5da0bAi3qRK1Th6NgvDq9WvQUDD0QO39trxtdf90QVO1FCQfoTqD8H
         S+MsmosMN8dGmdAfT2Zg6zCGjU6LcX+gPFpBgk2BPLpqSHr83UcVXeMqX/kWGDNURZFD
         EajxSLUZBsWuXBO2CZQEz6RUN5RAiB+1+BrWD+xaePnN1HVE4YbbxfVlqR4u+fOqIw2f
         752WywB99CZDjHud4Fokvrj2sT5N0JNBqEOLWkbi0AQds1SXBu3Dceq8BS5TvZUEwhej
         gADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LUzt8R5HrGpYPOZMEfl9oGPvkl6VG3pyisyNaU3H8qQ=;
        b=kNxpP1V0ZY+iursgnbwVlXEXJSKEnnOLKvvBEIWWvorewsusF3a3f5Iuv+/EJQ2mHS
         c3lVn3gZg7xQ98Fm3XgQgnDCyM3Fx03MRWv+PK53YhSE4+D5JFTNHnKM74h44OrpFgNo
         RexAJdJ+tJETe0zn29L1kUPG/UGEq3GKX1wnaiIUIdvJCpPJTBkD/EG0tkNLLuQTCZPx
         jfGXGQpsfqQph8Awe1sB0f79RZt93AaGmyIWKqVIfXr7Wn2WzPhTgLYgvJ5MVj5nrK02
         eGYZpBvbPEaua9b/bFIyWMrGKcB8wVWxNyMZYu2iNYJ+60m0VBzNTwMk6IJPiCe+0aYG
         Q6bw==
X-Gm-Message-State: APjAAAVzHwOsWoqW0Ts5LcgzSYoO8Ucwug/IpA9KYEiWtjBEO6d3RebH
        gCSkHdpZ//4uHI9tbTlMQGehrkE003i3HJ2HzgY=
X-Google-Smtp-Source: APXvYqwenHRZZp8/h28kMWzbEN1h2SQfXy4PWAAu2yGT8YZXOlaZgn/Efi7+T4fDUiD8JXnILtOsPcHZV/7O+y2QpQU=
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr26833119wrs.63.1572946402825;
 Tue, 05 Nov 2019 01:33:22 -0800 (PST)
MIME-Version: 1.0
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion>
In-Reply-To: <20191105085446.abx27ahchg2k7d2w@orion>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Tue, 5 Nov 2019 09:32:56 +0000
Message-ID: <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
Subject: Re: Tasks blocking forever with XFS stack traces
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Tue, 5 Nov 2019 at 08:54, Carlos Maiolino <cmaiolino@redhat.com> wrote:
>
> Hi.
>
> On Tue, Nov 05, 2019 at 07:27:16AM +0000, Sitsofe Wheeler wrote:
> > Hi,
> >
> > We have a system that has been seeing tasks with XFS calls in their
> > stacks. Once these tasks start hanging with uninterruptible sleep any
> > write I/O to the directory they were doing I/O to will also hang
> > forever. The I/O they doing is being done to a bind mounted directory
> > atop an XFS filesystem on top an MD device (the MD device seems to be
> > still functional and isn't offline). The kernel is fairly old but I
> > thought I'd post a stack in case anyone can describe this or has seen
> > it before:
> >
> > kernel: [425684.110424] INFO: task kworker/u162:0:58843 blocked for
> > more than 120 seconds.
> > kernel: [425684.110800]       Tainted: G           OE
> > 4.15.0-64-generic #73-Ubuntu
> > kernel: [425684.111164] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > kernel: [425684.111568] kworker/u162:0  D    0 58843      2 0x80000080
> > kernel: [425684.111581] Workqueue: writeback wb_workfn (flush-9:126)
> > kernel: [425684.111585] Call Trace:
> > kernel: [425684.111595]  __schedule+0x24e/0x880
> > kernel: [425684.111664]  ? xfs_map_blocks+0x82/0x250 [xfs]

<snip>
> >
> > Other directories on the same filesystem seem fine as do other XFS
> > filesystems on the same system.
>
> The fact you mention other directories seems to work, and the first stack=
 trace
> you posted, it sounds like you've been keeping a singe AG too busy to alm=
ost
> make it unusable. But, you didn't provide enough information we can reall=
y make
> any progress here, and to be honest I'm more inclined to point the finger=
 to
> your MD device.

Let's see if we can pinpoint something :-)

> Can you describe your MD device? RAID array? What kind? How many disks?

RAID6 8 disks.

> What's your filesystem configuration? (xfs_info <mount point>)

meta-data=3D/dev/md126             isize=3D512    agcount=3D32, agsize=3D43=
954432 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1 spinodes=3D0 r=
mapbt=3D0
         =3D                       reflink=3D0
data     =3D                       bsize=3D4096   blocks=3D1406538240, imax=
pct=3D5
         =3D                       sunit=3D128    swidth=3D768 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

> Do you have anything else on your dmesg other than these two stack traces=
? I'd
> suggest posting the whole dmesg, not only what you think is relevant.

Yes there's more. See a slightly elided dmesg from a longer run on
https://sucs.org/~sits/test/kern-20191024.log.gz .

>
> Better yet:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F

Note most of the following was gathered from the currently not-hanging syst=
em:

kernel: was 4.15.0-64-generic from Ubuntu 18.04 but we're now testing
5.0.0-32-generic

xfsprogs version: xfs_repair version 4.9.0
CPUs: 80
cat /proc/meminfo
MemTotal:       791232512 kB
MemFree:        616987432 kB
MemAvailable:   781352708 kB
Buffers:            5520 kB
Cached:         113300540 kB
SwapCached:            0 kB
Active:         28385760 kB
Inactive:       85358040 kB
Active(anon):     436084 kB
Inactive(anon):     3476 kB
Active(file):   27949676 kB
Inactive(file): 85354564 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      31248380 kB
SwapFree:       31248380 kB
Dirty:               688 kB
Writeback:             0 kB
AnonPages:        436396 kB
Mapped:           206652 kB
Shmem:              6944 kB
KReclaimable:   56047960 kB
Slab:           58126044 kB
SReclaimable:   56047960 kB
SUnreclaim:      2078084 kB
KernelStack:       22240 kB
PageTables:        17552 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    426864636 kB
Committed_AS:    4147112 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
Percpu:            61760 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:     3245828 kB
DirectMap2M:    100208640 kB
DirectMap1G:    702545920 kB

cat /proc/mounts
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs
rw,nosuid,relatime,size=3D395591264k,nr_inodes=3D98897816,mode=3D755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D79123252k,mode=3D755 0 0
/dev/mapper/vgsys-root / xfs rw,relatime,attr2,inode64,noquota 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime =
0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=3D755 0 0
cgroup /sys/fs/cgroup/unified cgroup2
rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0
cgroup /sys/fs/cgroup/systemd cgroup
rw,nosuid,nodev,noexec,relatime,xattr,name=3Dsystemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup
rw,nosuid,nodev,noexec,relatime,net_cls,net_prio 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 =
0
cgroup /sys/fs/cgroup/rdma cgroup rw,nosuid,nodev,noexec,relatime,rdma 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetl=
b 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup
rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/perf_event cgroup
rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freeze=
r 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset =
0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,device=
s 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory =
0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs
rw,relatime,fd=3D38,pgrp=3D1,timeout=3D0,minproto=3D5,maxproto=3D5,direct,p=
ipe_ino=3D66154
0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime,pagesize=3D2M 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
tmpfs /tmp tmpfs rw,nosuid,nodev 0 0
/dev/md0 /boot ext2 rw,relatime 0 0
/dev/md126 /localdata xfs
rw,relatime,attr2,inode64,sunit=3D1024,swidth=3D6144,noquota 0 0
/dev/md126 /var/lib/docker xfs
rw,relatime,attr2,inode64,sunit=3D1024,swidth=3D6144,noquota 0 0
/dev/mapper/vgsys-home /home xfs rw,relatime,attr2,inode64,noquota 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
overlay /var/lib/docker/overlay2/c86b0eab253a97ffe75b0661886337322c55838608=
3bcb2d4823446025131b0a/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/XPFD5GLZ7YBMUP7S3=
E6W5OUE6A:/var/lib/docker/overlay2/l/GJVZ2MXOD5AOLUELAEYCSYCXLK:/var/lib/do=
cker/overlay2/l/JEYWOT7MNNHX2DAE4AQ5XO674I:/var/lib/docker/overlay2/l/YAS2Y=
WA4FTAWNEKRAJQY47TQDY,upperdir=3D/var/lib/docker/overlay2/c86b0eab253a97ffe=
75b0661886337322c558386083bcb2d4823446025131b0a/diff,workdir=3D/var/lib/doc=
ker/overlay2/c86b0eab253a97ffe75b0661886337322c558386083bcb2d4823446025131b=
0a/work,xino=3Doff
0 0
overlay /localdata/docker/overlay2/c86b0eab253a97ffe75b0661886337322c558386=
083bcb2d4823446025131b0a/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/XPFD5GLZ7YBMUP7S3=
E6W5OUE6A:/var/lib/docker/overlay2/l/GJVZ2MXOD5AOLUELAEYCSYCXLK:/var/lib/do=
cker/overlay2/l/JEYWOT7MNNHX2DAE4AQ5XO674I:/var/lib/docker/overlay2/l/YAS2Y=
WA4FTAWNEKRAJQY47TQDY,upperdir=3D/var/lib/docker/overlay2/c86b0eab253a97ffe=
75b0661886337322c558386083bcb2d4823446025131b0a/diff,workdir=3D/var/lib/doc=
ker/overlay2/c86b0eab253a97ffe75b0661886337322c558386083bcb2d4823446025131b=
0a/work,xino=3Doff
0 0
nsfs /run/docker/netns/160ed5c707bb nsfs rw 0 0
overlay /var/lib/docker/overlay2/551458a050177ebbc7b7e43646bc5cb645455cb6e9=
a5b1f420dc6b1a4322504d/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/ECXX2YJFYUMBVKTP7=
OTRSAJVWE:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/551458a050177ebbc7b7e43646bc5cb645455cb6e9a5b1f420=
dc6b1a4322504d/diff,workdir=3D/var/lib/docker/overlay2/551458a050177ebbc7b7=
e43646bc5cb645455cb6e9a5b1f420dc6b1a4322504d/work,xino=3Doff
0 0
overlay /localdata/docker/overlay2/551458a050177ebbc7b7e43646bc5cb645455cb6=
e9a5b1f420dc6b1a4322504d/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/ECXX2YJFYUMBVKTP7=
OTRSAJVWE:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/551458a050177ebbc7b7e43646bc5cb645455cb6e9a5b1f420=
dc6b1a4322504d/diff,workdir=3D/var/lib/docker/overlay2/551458a050177ebbc7b7=
e43646bc5cb645455cb6e9a5b1f420dc6b1a4322504d/work,xino=3Doff
0 0
nsfs /run/docker/netns/cc8ad7e2cc51 nsfs rw 0 0
overlay /var/lib/docker/overlay2/77096fc6ca39461683809377f6efa83957e73cdb91=
eb5f08957a64f75d829356/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/S5DDQ53MEAP37J672=
3CYPVDTO6:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/77096fc6ca39461683809377f6efa83957e73cdb91eb5f0895=
7a64f75d829356/diff,workdir=3D/var/lib/docker/overlay2/77096fc6ca3946168380=
9377f6efa83957e73cdb91eb5f08957a64f75d829356/work,xino=3Doff
0 0
overlay /localdata/docker/overlay2/77096fc6ca39461683809377f6efa83957e73cdb=
91eb5f08957a64f75d829356/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/S5DDQ53MEAP37J672=
3CYPVDTO6:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/77096fc6ca39461683809377f6efa83957e73cdb91eb5f0895=
7a64f75d829356/diff,workdir=3D/var/lib/docker/overlay2/77096fc6ca3946168380=
9377f6efa83957e73cdb91eb5f08957a64f75d829356/work,xino=3Doff
0 0
nsfs /run/docker/netns/e892b0d9fdea nsfs rw 0 0
overlay /var/lib/docker/overlay2/77b8012caabd1b32e965ba6258c4a41788a7e86e11=
205ec719d993f30a8e6257/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/2MTUND5M3MS3FZWZC=
ZVXTBIB5K:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/77b8012caabd1b32e965ba6258c4a41788a7e86e11205ec719=
d993f30a8e6257/diff,workdir=3D/var/lib/docker/overlay2/77b8012caabd1b32e965=
ba6258c4a41788a7e86e11205ec719d993f30a8e6257/work,xino=3Doff
0 0
overlay /localdata/docker/overlay2/77b8012caabd1b32e965ba6258c4a41788a7e86e=
11205ec719d993f30a8e6257/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/2MTUND5M3MS3FZWZC=
ZVXTBIB5K:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/77b8012caabd1b32e965ba6258c4a41788a7e86e11205ec719=
d993f30a8e6257/diff,workdir=3D/var/lib/docker/overlay2/77b8012caabd1b32e965=
ba6258c4a41788a7e86e11205ec719d993f30a8e6257/work,xino=3Doff
0 0
nsfs /run/docker/netns/e9d00dfcaa30 nsfs rw 0 0
overlay /var/lib/docker/overlay2/28b0f26ad2c4dd1eccd966d1dc59499be968205a00=
572715db840abbbcc2789d/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/SLHFVMXTCIQY5TYHX=
X3XY2QUTX:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/28b0f26ad2c4dd1eccd966d1dc59499be968205a00572715db=
840abbbcc2789d/diff,workdir=3D/var/lib/docker/overlay2/28b0f26ad2c4dd1eccd9=
66d1dc59499be968205a00572715db840abbbcc2789d/work,xino=3Doff
0 0
overlay /localdata/docker/overlay2/28b0f26ad2c4dd1eccd966d1dc59499be968205a=
00572715db840abbbcc2789d/merged
overlay rw,relatime,lowerdir=3D/var/lib/docker/overlay2/l/SLHFVMXTCIQY5TYHX=
X3XY2QUTX:/var/lib/docker/overlay2/l/E4BBLB3NCC34KONYP23RP7VJ2X:/var/lib/do=
cker/overlay2/l/SVYAOAODE6MEJVAEK2OO4SFF2E:/var/lib/docker/overlay2/l/A7TNW=
2Z7KHULNAU4BDB4GYRJ4A:/var/lib/docker/overlay2/l/SJ637O5BUZNAJSXNT27BO3CQGO=
:/var/lib/docker/overlay2/l/PYVRDDP7ABBFVD3PY2QGTJFQEM:/var/lib/docker/over=
lay2/l/OGFQOLFLSU27UIRKWXRZQ43OAP:/var/lib/docker/overlay2/l/KCOSL4MV3WQXKQ=
ZIZTQNTY4QEU:/var/lib/docker/overlay2/l/YTEXTILIATA6VFSWCQBWUHDY2D:/var/lib=
/docker/overlay2/l/4BAQ5SVXAVZWLTKZ6FH6VHJLWA:/var/lib/docker/overlay2/l/MU=
ZSGTDT2THJSZEPFBG5NFWRGW:/var/lib/docker/overlay2/l/I6BCWJFX34IQ33OMCKNEHUU=
JU5:/var/lib/docker/overlay2/l/IRGYEAIEWEA4UJUYV3KEX3P4TI:/var/lib/docker/o=
verlay2/l/J2PDWFCIYIFMH63PCXDJ6P2V7S:/var/lib/docker/overlay2/l/RC6FRWC3WRM=
RDRMCQM4L6R4VGA:/var/lib/docker/overlay2/l/HJM7E2PHDYPHGWF6RWP7R6OOZI:/var/=
lib/docker/overlay2/l/JI5RMXGTTBAM4NYEDR4FMNWV25:/var/lib/docker/overlay2/l=
/2TKWRPIAHOTDHLTGEYFRN4OUWL:/var/lib/docker/overlay2/l/6KCFDR62MDJOQ3ZA54ID=
NLUI7M:/var/lib/docker/overlay2/l/AN3SVYKAI6L4F54FKFSZMFDPUJ:/var/lib/docke=
r/overlay2/l/YVJF7YEVLHXGC4L27UPEUK47HF:/var/lib/docker/overlay2/l/3NF7EYNT=
MPB7FFNI7POOBKXJPX:/var/lib/docker/overlay2/l/WAA6KYOATJLN6EP2PYYRQWEGOR:/v=
ar/lib/docker/overlay2/l/PHGIYF5LT5FKNUPFVSMEVHWNDU:/var/lib/docker/overlay=
2/l/KY5BSB7LSJPUNYBISCA4KYF7KS:/var/lib/docker/overlay2/l/HYDHRQJPMUKG4AXLI=
VBDPSUXJK:/var/lib/docker/overlay2/l/YI26DO7GTXPYQJSZ6BXHJUV5AR,upperdir=3D=
/var/lib/docker/overlay2/28b0f26ad2c4dd1eccd966d1dc59499be968205a00572715db=
840abbbcc2789d/diff,workdir=3D/var/lib/docker/overlay2/28b0f26ad2c4dd1eccd9=
66d1dc59499be968205a00572715db840abbbcc2789d/work,xino=3Doff
0 0
nsfs /run/docker/netns/2d3a60de14ae nsfs rw 0 0
tmpfs /run/user/2266 tmpfs
rw,nosuid,nodev,relatime,size=3D79123248k,mode=3D700,uid=3D2266,gid=3D501 0=
 0
tmpfs /run/user/2042 tmpfs
rw,nosuid,nodev,relatime,size=3D79123248k,mode=3D700,uid=3D2042,gid=3D501 0=
 0

cat /proc/partitions
major minor  #blocks  name

   8        0  937692504 sda
   8       16  937692504 sdb
   8       32  937692504 sdc
   8       48  937692504 sdd
   8       64  234431064 sde
   8       65     999424 sde1
   8       66          1 sde2
   8       69  233428992 sde5
   8       80  234431064 sdf
   8       81     999424 sdf1
   8       82          1 sdf2
   8       85  233428992 sdf5
   9      126 5626152960 md126
   9        0     998848 md0
   9        1  233297920 md1
   8       96  937692504 sdg
   8      112  937692504 sdh
   8      128  937692504 sdi
   8      144  937692504 sdj
 253        0  104857600 dm-0
 253        1   31248384 dm-1
 253        2   52428800 dm-2

cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath]
[raid0] [raid10]
md1 : active raid1 sdf5[1] sde5[0]
      233297920 blocks super 1.2 [2/2] [UU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

md0 : active raid1 sdf1[1] sde1[0]
      998848 blocks super 1.2 [2/2] [UU]

md126 : active raid6 sdj[6] sdg[3] sdi[2] sdh[7] sdc[4] sdd[0] sda[5] sdb[1=
]
      5626152960 blocks level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
      bitmap: 0/7 pages [0KB], 65536KB chunk

unused devices: <none>

All disks are SATA Micron 5200 SSDs
No Battery Backed Write Cache

Workload:
Mixture of compiles and later on accelerator device I/O through
multiple docker containers. It usually takes days before the problem
is triggered.
I'm afraid I don't have the iostat/vmstat during the time of the
problem recorded

If there's key information missing that I can supply let me know and
I'll try and get it to you.

--
Sitsofe | http://sucs.org/~sits/
