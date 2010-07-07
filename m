Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o67Lt0rP259155 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 16:55:00 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB438431E74
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 14:57:50 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id jLr8uVgZQ9GpcBBH for
	<xfs@oss.sgi.com>; Wed, 07 Jul 2010 14:57:50 -0700 (PDT)
Message-ID: <4C34F804.6040004@tlinx.org>
Date: Wed, 07 Jul 2010 14:56:20 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
References: <4C26A51F.8020909@tlinx.org>
	<20100628022744.GX6590@dastard>	<4C2A749E.4060006@tlinx.org>
	<201006302025.20289@zmi.at> <20100630233029.GO24712@dastard>
In-Reply-To: <20100630233029.GO24712@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wed, Jun 30, 2010 at 08:25:20PM +0200, Michael Monnerie wrote:
>> From another Linux ("saturn"), I do an rsync via an rsync-module, 
...
> Are you running rsync locally on saturn
----

Data point:

I have two file systems with corruption -- one recent one had a WinXP
client (as well as a Win7, and linux host), dumping foreign names into
the file system (the Win clients through samba).

However, my "home partition" use to regularly be used to backup the
WinXP's home dir via  **rsync**.


Some of those files were _un_readable on WinXP (like ones containing copyright
symbols / registered trademark symbols, etc) -- but at the time, they
WERE readable on linux.  Now some of those same files are no longer
readable on linux.  Just thought I'd mention that on my 'home' partition,
the corruption is in files that were transfered with rsync.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
