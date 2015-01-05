Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 64F317F51
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 21:52:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53FED8F8033
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 19:52:30 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 23TIchOjeG9BTGDO
	for <xfs@oss.sgi.com>; Sun, 04 Jan 2015 19:52:26 -0800 (PST)
Message-ID: <54AA0A93.2010204@hardwarefreak.com>
Date: Sun, 04 Jan 2015 21:52:51 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm>
In-Reply-To: <1806495.BCZcrVVEOf@shtub-cm>
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
To: Hillel Lubman <shtetldik@gmail.com>, xfs@oss.sgi.com

On 01/04/2015 06:56 PM, Hillel Lubman wrote:
...
> Looking around I saw some references that it's preferable to use sector
> size (sectsz) of 4 KB when creating XFS partitions on hybrid (512e)
> advanced format hard drives and also some mentions of making that a
> default in mkfs.xfs. However I noticed that my current mkfs.xfs (3.2.1)
> used with current Debian testing (Linux 3.16.0) still uses 512 B sectors
> by default.
...
> Can you please clarify what after all is the recommended sector size for
> such drives and why isn't it a default in mkfs.xfs (since supposedly
> defaults are generally recommended optimal settings unless you have some
> special use case).
...

XFS sectsz is unimportant with these drives.  What matters is that any
partitions you create start and end on 4KB boundaries.  This will
prevent adjacent hardware sector RMW internal to the drive.  XFS writes
in 4KB filesystem blocks on Linux.  As long as the fsblocks are aligned
to the 4KB hardware sectors there's nothing more you can do to avoid
performance penalties with these drives.

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
