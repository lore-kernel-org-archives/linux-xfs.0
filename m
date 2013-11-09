Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0D0A7F9D
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 01:58:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C571304051
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 23:58:28 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yVSlc7cvGhWN6Pkz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Nov 2013 23:58:27 -0800 (PST)
Message-ID: <527DEB69.8050502@oracle.com>
Date: Sat, 09 Nov 2013 15:59:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: How to feel the real time feature of XFS from userspace
References: <CAD+1EGPf=ddMP4vdDxkkWnJH2q9fCSa5uTT-eRAxYLAEtPrLwg@mail.gmail.com>
In-Reply-To: <CAD+1EGPf=ddMP4vdDxkkWnJH2q9fCSa5uTT-eRAxYLAEtPrLwg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: harryxiyou <harryxiyou@gmail.com>
Cc: zwu.kernel@gmail.com, xfs@oss.sgi.com

On 11/09/2013 01:23 PM, harryxiyou wrote:

> Hi all,
> 
> I have format block device with XFS as follows.
> 
> root@node2:~# mkfs.xfs -f -r rtdev=/dev/sda3 /dev/sda4
> 
> meta-data=/dev/sda4              isize=256    agcount=4, agsize=56122440 blks
> 
>          =                       sectsz=512   attr=2, projid32bit=0
> 
> data     =                       bsize=4096   blocks=224489757, imaxpct=25
> 
>          =                       sunit=0      swidth=0 blks
> 
> naming   =version 2              bsize=4096   ascii-ci=0
> 
> log      =internal log           bsize=4096   blocks=109614, version=2
> 
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> 
> realtime =/dev/sda3              extsz=4096   blocks=14865657,
> rtextents=14865657
> 
> 
> And I also write user-space codes as follows.
> 
> root@node2:~/test# cat xfs.c
> #include <stdio.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <xfs/xfs.h>
> #include <xfs/xfs_fs.h>
> 
> int main(int argc, char **argv) {
> int fd;
> int xfs_ret = 0;
> 
> fd = open("./1", O_RDWR);
> if (fd < 0) {
> fprintf(stderr, "open error!\n");
> return -1;
> }
> xfs_ret = xfsctl("./1", fd, XFS_IOC_FSGETXATTR, NULL);
> 
> return 0;
> }
> 
> 
> Now, I am wondering how to feel the real time feature of XFS from userspace?
> Could anyone please give me some suggestions? Thanks in advance.

Mount your realtime device at first:
mount -o rtdev=/dev/sda3 /dev/sda4 /mount_point

Then you need to mark the attribute bit set with XFS_XFLAG_REALTIME via xfsctl(3)
after file creation before writing any data to the file, hence your demo code
would looks like:

struct fsxattr	attr;

attr.fsx_xflags |= XFS_XFLAG_REALTIME;
xfs_ret = xfsctl(target_file_path, fd, XFS_IOC_FSSETXATTR, &attr);
...

I would suggest you take a look at the source of xfs_rctp(8) at xfsprogs to get
more info.

BTW, I remember Dave once mentioned that the realtime feature on Linux is not widely
tested and not recommended for production use.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
