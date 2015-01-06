Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6ECCE7F56
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 02:35:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BF988F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 00:35:16 -0800 (PST)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id wMj1GsnXLxp0pENj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 00:35:11 -0800 (PST)
Date: Tue, 6 Jan 2015 09:35:07 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
Message-ID: <20150106083507.GA9943@citd.de>
References: <1806495.BCZcrVVEOf@shtub-cm> <54AA0A93.2010204@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54AA0A93.2010204@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Hillel Lubman <shtetldik@gmail.com>, xfs@oss.sgi.com

On 04.01.2015 21:52, Stan Hoeppner wrote:
> On 01/04/2015 06:56 PM, Hillel Lubman wrote:
> ...
> > Looking around I saw some references that it's preferable to use sector
> > size (sectsz) of 4 KB when creating XFS partitions on hybrid (512e)
> > advanced format hard drives and also some mentions of making that a
> > default in mkfs.xfs. However I noticed that my current mkfs.xfs (3.2.1)
> > used with current Debian testing (Linux 3.16.0) still uses 512 B sectors
> > by default.
> ...
> > Can you please clarify what after all is the recommended sector size for
> > such drives and why isn't it a default in mkfs.xfs (since supposedly
> > defaults are generally recommended optimal settings unless you have some
> > special use case).
> ...
> 
> XFS sectsz is unimportant with these drives.  What matters is that any
> partitions you create start and end on 4KB boundaries.  This will
> prevent adjacent hardware sector RMW internal to the drive.  XFS writes
> in 4KB filesystem blocks on Linux.  As long as the fsblocks are aligned
> to the 4KB hardware sectors there's nothing more you can do to avoid
> performance penalties with these drives.

Not in my experience. My first (and lying about it) AF HDD had horrible 
write performance until i re'mkfs.xfs'ed it with 4k sector-size. And yes 
the aligned was 4k.

But that was many years ago and i don't know if newer XFS (IIRC that was 
before delay-log) would behave better. But as all of my storage after 
the first AF HDD was either an AF HDD or a SSD i have been formating 
everything with 4k sector-size for years.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
