Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA2F77D11
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 06:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CD88AC001
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 04:24:07 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id Mn7mF98Qljus71Nf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2016 04:24:05 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id i5so25725978wmg.2
	for <xfs@oss.sgi.com>; Mon, 01 Aug 2016 04:24:05 -0700 (PDT)
Received: from dinulap (dev155.demoshop.ro. [5.2.129.155])
	by smtp.gmail.com with ESMTPSA id
	v203sm16585448wmv.2.2016.08.01.04.24.02 for <xfs@oss.sgi.com>
	(version=TLS1 cipher=DES-CBC3-SHA bits=112/168);
	Mon, 01 Aug 2016 04:24:03 -0700 (PDT)
Message-ID: <37A306C32B7B409DB062BB807061728D@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<83306f91-6bc3-258b-19a8-68e60317de43@sandeen.net>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
Date: Mon, 1 Aug 2016 14:24:02 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


----- Original Message ----- 
From: "Eric Sandeen" <sandeen@sandeen.net>
To: <xfs@oss.sgi.com>
Sent: Saturday, July 30, 2016 12:49 AM
Subject: Re: partition 100% full No space left on device. looks like xfs 
iscorrupted or a bug



> Can you include full contents of /proc/mounts?
>
> If you have something bind-mounted or similar, it will hide it from "du" 
> traversal.
>
> -Eric
>

Yes, see below:
# cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=32873088k,nr_inodes=8218272,mode=755 0 
0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 
0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 
0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup 
rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups 
                                               -agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup 
rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 
0
cgroup /sys/fs/cgroup/perf_event cgroup 
rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 
0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 
0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 
0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 
0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 
0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/mapper/centos-root / xfs 
rw,relatime,attr2,inode64,logbsize=256k,sunit=512,swidth=512,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs 
rw,relatime,fd=28,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
/dev/mapper/centos-home /home xfs 
rw,relatime,attr2,inode64,logbsize=256k,sunit=512,swidth=512,noquota 0 0
/dev/sda1 /boot xfs 
rw,relatime,attr2,inode64,logbsize=256k,sunit=512,swidth=512,noquota 0 0
tmpfs /run/user/0 tmpfs rw,nosuid,nodev,relatime,size=6576812k,mode=700 0 0 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
