Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6ED557F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 10:25:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E933DAC003
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 08:25:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dLNn0fYq0TJrFnrP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 08:25:25 -0700 (PDT)
Date: Thu, 26 Mar 2015 11:25:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: mkfs error: "existing superblock read failed: Inappropriate
	ioctl for device"
Message-ID: <20150326152522.GA38652@bfoster.bfoster>
References: <55140956.1050108@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55140956.1050108@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 26, 2015 at 04:27:50PM +0300, Alexander Tsvetkov wrote:
> Hello,
> 
> I have the following error message: "existing superblock read failed:
> Inappropriate ioctl for device"
> after attempt to make xfs image with "mkfs.xfs -f -m crc=1 -d
> file=1,name=xfs.fs,size=32m":
> 
> "meta-data=xfs.fs                 isize=256    agcount=2, agsize=4096 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=8192, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal log           bsize=4096   blocks=853, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> existing superblock read failed: Inappropriate ioctl for device"
> 
> Filesystem is created and mounted as usually, xfs_repair passes, no messages
> in the system log.
> Configuration: Fedora 20 x86_64 on vbox, kernel 4.0.0-rc5, xfsprogs version
> 3.2.2.
> 

This appears to come from zero_old_xfs_structures() where we try and
zero out any old data structures on the target device. pread() of the
superblock returns 0, because we open the target with O_CREAT|O_TRUNC if
it is a file (e.g., the file size is 0 so any reads will return 0). It's
not an error, so I suspect the error string there is stale from a
previous operation. Indeed, from strace:

...
ioctl(3, BLKDISCARD, {0, 7ffc2904a180}) = -1 ENOTTY (Inappropriate ioctl for device)
...
write(2, "existing superblock read failed:"..., 64existing superblock read failed: Inappropriate ioctl for device
) = 64
...

I'll send a patch in a bit, but the short of it is that this is
harmless. The side effect is we skip out of the function that zeroes old
metadata, but the file has already been truncated and thus effectively
zeroed out.

Brian

> Thanks,
> Alexander Tsvetkov
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
