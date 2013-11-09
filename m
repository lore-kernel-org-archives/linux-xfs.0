Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6606C7F8E
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 23:23:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 459AA304051
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 21:23:50 -0800 (PST)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	gYlJmNZrsJcaBKL7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Nov 2013 21:23:49 -0800 (PST)
Received: by mail-ie0-f181.google.com with SMTP id ar20so4796734iec.12
	for <xfs@oss.sgi.com>; Fri, 08 Nov 2013 21:23:49 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Nov 2013 13:23:48 +0800
Message-ID: <CAD+1EGPf=ddMP4vdDxkkWnJH2q9fCSa5uTT-eRAxYLAEtPrLwg@mail.gmail.com>
Subject: How to feel the real time feature of XFS from userspace
From: harryxiyou <harryxiyou@gmail.com>
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
To: xfs@oss.sgi.com
Cc: zwu.kernel@gmail.com

Hi all,

I have format block device with XFS as follows.

root@node2:~# mkfs.xfs -f -r rtdev=/dev/sda3 /dev/sda4

meta-data=/dev/sda4              isize=256    agcount=4, agsize=56122440 blks

         =                       sectsz=512   attr=2, projid32bit=0

data     =                       bsize=4096   blocks=224489757, imaxpct=25

         =                       sunit=0      swidth=0 blks

naming   =version 2              bsize=4096   ascii-ci=0

log      =internal log           bsize=4096   blocks=109614, version=2

         =                       sectsz=512   sunit=0 blks, lazy-count=1

realtime =/dev/sda3              extsz=4096   blocks=14865657,
rtextents=14865657


And I also write user-space codes as follows.

root@node2:~/test# cat xfs.c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <xfs/xfs.h>
#include <xfs/xfs_fs.h>

int main(int argc, char **argv) {
int fd;
int xfs_ret = 0;

fd = open("./1", O_RDWR);
if (fd < 0) {
fprintf(stderr, "open error!\n");
return -1;
}
xfs_ret = xfsctl("./1", fd, XFS_IOC_FSGETXATTR, NULL);

return 0;
}


Now, I am wondering how to feel the real time feature of XFS from userspace?
Could anyone please give me some suggestions? Thanks in advance.


-- 
Thanks
Weiwei  Jia (Harry Wei)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
