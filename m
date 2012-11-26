Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQDfWtP198032 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 07:41:32 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AirF7OCmM2idi06x for
	<xfs@oss.sgi.com>; Mon, 26 Nov 2012 05:43:47 -0800 (PST)
Date: Mon, 26 Nov 2012 14:43:40 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
In-Reply-To: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1211261442490.18234@localhost>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Mon, 26 Nov 2012, Ryan Wang wrote:

> Date: Mon, 26 Nov 2012 08:00:05 +0800
> From: Ryan Wang <openspace.wang@gmail.com>
> To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
> Subject: How to run xfstests against multipath disks on SuSE?

Maybe cc xfstests developers as well ?

xfs@oss.sgi.com added to cc.

> 
> Hello,
> 
> I tried to kick off xfstests on multipath device, e.g I set
> TEST_DEV="/dev/mapper/mpatha", which is a symlink
> to "/dev/dm-0". I run mkfs on mpatha beforehand.
> 
> When I run "./check 001", it said:
> "
> common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED ext4 filesystem
> "
> 
> The I checked the script common.rc, and found that it uses
> df to determine the filesystem type and it uses the realpath
> "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> shows "devtmpfs" instead of "ext4" for /dev/dm-0.
> 
> I run "mount" and found that devtmpfs is mount on /dev/ on opensuse
> ***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /somedir",
> df still showed devtmpfs.
> 
> Any ideas to kick off the xfstests?
> 
> thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
