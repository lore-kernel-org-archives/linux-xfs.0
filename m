Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53069Fk232003 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 19:06:09 -0500
Received: from mail-px0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1FEB49968E
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 17:06:08 -0700 (PDT)
Received: from mail-px0-f174.google.com (mail-px0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	36Cgm6jJf8ypFULg for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 17:06:08 -0700 (PDT)
Received: by pxi15 with SMTP id 15so911270pxi.5
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 17:06:08 -0700 (PDT)
Message-ID: <4DE8256C.10706@philkarn.net>
Date: Thu, 02 Jun 2011 17:06:04 -0700
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
In-Reply-To: <19943.56524.969126.59978@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 6/2/11 11:56 AM, Peter Grandi wrote:

> Disclaimer: some smart people I know built knowingly a similar
> and fortunately much smaller collection of RAID6 sets because
> that was the least worst option for them, and since they know
> that it will not fill up before they can replace it, they are
> effectively short-stroking all those 2TB drives (I still would
> have bought ERC ones if possible) so it's cooler than it looks.

What do you mean by "short stroking"? That the data (and head motions)
stay in one part of the disk? I haven't been using XFS that long and I'm
no expert on it, but I've noticed that it seems to distribute files
pretty evenly across an entire disk. Even without the inode64 option,
only the inodes are kept at the beginning; the data can be anywhere.

The only way I can think of to confine the activity on a lightly-loaded
XFS file system to one part of a disk (e.g., to reduce average seek
times and to stay in the faster outer area of the drive) is to create
partitions that initially span only part of the disk, then grow them
later as needed. Is that what you mean?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
