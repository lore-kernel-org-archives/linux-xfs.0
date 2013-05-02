Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 914D27F55
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:28:31 -0500 (CDT)
Message-ID: <51828624.2050001@sgi.com>
Date: Thu, 02 May 2013 10:28:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/2] xfs: Don't keep silent if sunit/swidth can not
	be changed via mount
References: <51824DB9.6090401@oracle.com>
In-Reply-To: <51824DB9.6090401@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/02/13 06:27, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> As per the mount man page, sunit and swidth can be changed via
> mount options.  For XFS, on the face of it, those options seems
> works if the specified alignments is properly, e.g.
> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
> # mount | grep sdb1
> /dev/sdb1 on /mnt type xfs (rw,sunit=4096,swidth=8192)
>
> However, neither sunit nor swidth is shown from the xfs_info output.
> # xfs_info /mnt
> meta-data=/dev/sdb1    isize=256    agcount=4, agsize=262144 blks
>           =             sectsz=512   attr=2
> data     =             bsize=4096   blocks=1048576, imaxpct=25
>           =             sunit=0      swidth=0 blks
> 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
> naming   =version 2    bsize=4096   ascii-ci=0
> log      =internal     bsize=4096   blocks=2560, version=2
>           =             sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none         extsz=4096   blocks=0, rtextents=0
>
> The reason is that the alignment can only be changed if the relevant
> super block is already configured with alignments, otherwise, the
> given value is silently ignored.
>
> With this fix, the attempt to mount a storage without strip alignment
> setup on a super block will get an error with a warning in syslog to
> indicate the true cause, e.g.
> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
> 	dmesg | tail  or so
> .......
> XFS (sdb1): cannot change alignment: superblock does not support data
> alignment
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
