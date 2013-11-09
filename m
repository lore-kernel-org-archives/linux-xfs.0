Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 37CC87F84
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 03:24:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE84E304043
	for <xfs@oss.sgi.com>; Sat,  9 Nov 2013 01:24:29 -0800 (PST)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	X0emFNoizYywrFRP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Nov 2013 01:24:25 -0800 (PST)
Received: by mail-ie0-f176.google.com with SMTP id x13so2217296ief.7
	for <xfs@oss.sgi.com>; Sat, 09 Nov 2013 01:24:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527DEB69.8050502@oracle.com>
References: <CAD+1EGPf=ddMP4vdDxkkWnJH2q9fCSa5uTT-eRAxYLAEtPrLwg@mail.gmail.com>
	<527DEB69.8050502@oracle.com>
Date: Sat, 9 Nov 2013 17:24:24 +0800
Message-ID: <CAD+1EGNxBnSSXGqi7edgdu7uquOOiPWVd7v-avRrJxzKhSY_UQ@mail.gmail.com>
Subject: Re: How to feel the real time feature of XFS from userspace
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, xfs@oss.sgi.com

On Sat, Nov 9, 2013 at 3:59 PM, Jeff Liu <jeff.liu@oracle.com> wrote:

Hi Jeff Liu,

Thanks for your reply ;-)

> Mount your realtime device at first:
> mount -o rtdev=/dev/sda3 /dev/sda4 /mount_point
>
> Then you need to mark the attribute bit set with XFS_XFLAG_REALTIME via xfsctl(3)
> after file creation before writing any data to the file, hence your demo code
> would looks like:
>
> struct fsxattr  attr;
>
> attr.fsx_xflags |= XFS_XFLAG_REALTIME;
> xfs_ret = xfsctl(target_file_path, fd, XFS_IOC_FSSETXATTR, &attr);
> ...

Yeah, it's right. I have mounted as you said and changed my codes as follows.

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <xfs/xfs.h>
#include <xfs/xfs_fs.h>

#define F_PATH "./rtxfs.txt"
#define EXTSIZE (0x00001000U)

int main(int argc, char **argv) {
int fd;
int ret = 0;
struct fsxattr fsxattr;

fd = open(F_PATH, O_RDWR|O_CREAT, 0666);
if (fd < 0) {
fprintf(stderr, "open error!\n");
return -1;
}
fsxattr.fsx_xflags = XFS_XFLAG_REALTIME;
fsxattr.fsx_extsize = EXTSIZE;
if (xfsctl(F_PATH, fd, XFS_IOC_FSSETXATTR, &fsxattr)) {
fprintf(stderr, "Set XFS attributes error!\n");
ret = -1;
goto out;
}
out:
close(fd);
return ret;
}

>
> I would suggest you take a look at the source of xfs_rctp(8) at xfsprogs to get
> more info.

xfs_rtcp really helps me a lot.

>
> BTW, I remember Dave once mentioned that the realtime feature on Linux is not widely
> tested and not recommended for production use.
>

However, I am wondering, now, I have created a XFS real-time file
named "rtfs.txt" and how I
could do some real-time stuffs on this file, which is different from
other common files.



-- 
Thanks
Weiwei  Jia (Harry Wei)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
