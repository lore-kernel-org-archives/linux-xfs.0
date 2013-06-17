Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0993929DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:49:41 -0500 (CDT)
Date: Mon, 17 Jun 2013 17:49:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 2/2] xfs: Don't keep silent if sunit/swidth can not
	be changed via mount
Message-ID: <20130617224940.GK20932@sgi.com>
References: <51824DB9.6090401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51824DB9.6090401@oracle.com>
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
Cc: Dave Chinner <dchinner@redhat.com>, Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 02, 2013 at 07:27:53PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
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
>          =             sectsz=512   attr=2
> data     =             bsize=4096   blocks=1048576, imaxpct=25
>          =             sunit=0      swidth=0 blks
> 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
> naming   =version 2    bsize=4096   ascii-ci=0
> log      =internal     bsize=4096   blocks=2560, version=2
>          =             sectsz=512   sunit=0 blks, lazy-count=1
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
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
> 	dmesg | tail  or so
> .......
> XFS (sdb1): cannot change alignment: superblock does not support data
> alignment
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Mark Tinguely <tinguely@sgi.com>
> Cc: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
