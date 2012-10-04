Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94McAON231593 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 17:38:10 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id YKNXgxTOCu7Ux6oH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 15:39:36 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q94MdWKR024102 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 15:39:35 -0700
Message-ID: <506E1025.8050605@tlinx.org>
Date: Thu, 04 Oct 2012 15:39:33 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs_freeze same as umount?   How is that helpful?
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
In-Reply-To: <CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Greg Freemyer wrote:
> Conceptually it is typically:
> - quiesce system
----
	Um... it seems that this is equivalent to being
able to umount the disk?

When I tried xfs_freeze / fs_freeze got fs-busy -- same as I would
if I tried to umount it.

I thought the point of xfs_freeze was to allow it to be brought to
a consistent state without unmounting it?

Coincidentally, after trying a few freezes, the system froze.

Last message in log was 'fetchmail' (that might have been writing a
log to /home), had hung for 120 seconds...

That was all she wrote before the entire system 'froze'...


So shouldn't xfs_freeze work without having to to shut down every
process on it?  If not, then how is it different than umount?





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
