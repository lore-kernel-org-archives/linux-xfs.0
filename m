Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45418 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbeECVW0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 17:22:26 -0400
Subject: Re: [PATCH 8/9] xfs_info: call xfs_db for offline filesystems
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401958146.13048.3834702512829151272.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e7dea090-ae58-d3d8-c9d0-33917e993d16@sandeen.net>
Date: Thu, 3 May 2018 16:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <152401958146.13048.3834702512829151272.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the online filesystem geometry query doesn't work, try using xfs_db
> to see if we can grab the information offline.
> 

I'm slightly concerned that having all-singing, all-dancing tools
that operate on mounted, unmounted, devices, mountpoints, and images
will further encourage people to think that operations on mounted
block devices are Just Fine(tm).

But ... I suppose the convenience is worth it.

...

> diff --git a/man/man8/xfs_info.8 b/man/man8/xfs_info.8
> new file mode 100644
> index 0000000..c4c470d
> --- /dev/null
> +++ b/man/man8/xfs_info.8
> @@ -0,0 +1,95 @@
> +.\" Verbatim blocks taken from openssl req manpage content
> +.de Vb \" Begin verbatim text
> +.ft CW
> +.nf
> +.ne \\$1
> +..
> +.de Ve \" End verbatim text
> +.ft R
> +.fi
> +..
> +
> +.TH xfs_info 8
> +.SH NAME
> +xfs_info, \- display XFS filesystem geometry information

drop the comma pls, or I can do this.

...

> +.BR \-V .
> +.SH "EXAMPLES"
> +
> +Understanding xfs_info output.
> +.PP
> +Suppose one has the following "xfs_info /dev/sda" output:
> +.PP
> +.RS 2
> +.Vb
> +\&meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
> +\&         =              sectsz=512   attr=2
> +\&data     =              bsize=4096   blocks=536869888, imaxpct=5
> +\&         =              sunit=32     swidth=128 blks
> +\&naming   =version 2     bsize=4096
> +\&log      =internal log  bsize=4096   blocks=32768, version=2
> +\&         =              sectsz=512   sunit=32 blks, lazy-count=1
> +\&realtime =none          extsz=524288 blocks=0, rtextents=0
> +.Ve

Should we update this to a more modern version?  *shrug*



