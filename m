Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966480AbeFSQTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 12:19:12 -0400
Date: Tue, 19 Jun 2018 09:18:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180619161819.GD21698@magnolia>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "swadmin - levigo.de" <swadmin@levigo.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 02:27:29PM +0200, swadmin - levigo.de wrote:
> Hi @all
> I have a problem with mounting a large XFS filesystem which takes about
> 8-10 minutes.
> 
> 
> 
> :~# df -h /graylog_data
> Filesystem                       Size  Used Avail Use% Mounted on
> /dev/mapper/vgdata-graylog_data   11T  5.0T  5.1T  50% /graylog_data
> 
> ----
> 
> :~# xfs_info /dev/mapper/vgdata-graylog_data
> meta-data=/dev/mapper/vgdata-graylog_data isize=512    agcount=40805,
> agsize=65792 blks

41,000 AGs is a lot of metadata to load.  Did someone growfs a 1G fs
into a 11T fs?

--D

>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=2684612608, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> ----
> 
> :~# strace -f mount /dev/mapper/vgdata-graylog_data /graylog_data >
> /root/mount 2>&1
> 
> [...]
> 
> stat("/sbin/mount.xfs", 0x7ffe36bcfe80) = -1 ENOENT (No such file or
> directory)
> stat("/sbin/fs.d/mount.xfs", 0x7ffe36bcfe80) = -1 ENOENT (No such file
> or directory)
> stat("/sbin/fs/mount.xfs", 0x7ffe36bcfe80) = -1 ENOENT (No such file or
> directory)
> getuid()                                = 0
> geteuid()                               = 0
> getgid()                                = 0
> getegid()                               = 0
> prctl(PR_GET_DUMPABLE)                  = 1
> stat("/run", {st_mode=S_IFDIR|0755, st_size=720, ...}) = 0
> lstat("/run/mount/utab", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> open("/run/mount/utab", O_RDWR|O_CREAT|O_CLOEXEC, 0644) = 3
> close(3)                                = 0
> mount("/dev/mapper/vgdata-graylog_data", "/graylog_data", "xfs",
> MS_MGC_VAL, NULL
> 
> 
> [here is where the 10 minutes happen]
> 
> 
> ) = 0
> --- SIGWINCH {si_signo=SIGWINCH, si_code=SI_KERNEL} ---
> close(1)                                = 0
> close(2)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
> 
> [Now the mount is ok]
> 
> 
> can anyone help me or know a kind of these problem. What else to try out?
> 
> BR
> Sascha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
