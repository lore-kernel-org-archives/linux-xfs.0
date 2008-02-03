Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 14:05:33 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m13M5N84021713
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 14:05:26 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F006D7ADE8
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2008 14:05:46 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id bttLAv3VbP1RUvbZ for <xfs@oss.sgi.com>; Sun, 03 Feb 2008 14:05:46 -0800 (PST)
Subject: Re: NFSD on XFS with RT subvolume
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C41021A627E@MSILEXCH01.marvell.com>
References: 
	 <B9FFC3F97441D04093A504CEA31B7C41021A627E@MSILEXCH01.marvell.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 09:05:43 +1100
Message-Id: <1202076343.9463.465.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rabeeh Khoury <rabeeh@marvell.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2008-01-30 at 16:37 +0200, Rabeeh Khoury wrote:
> Hi All,
> 
> Exporting an XFS volume with kernel NFSD when real-time subvolume is
> enabled hangs the kernel.
> 
> I'm using vanilla LK 2.6.22.7; first I create the XFS volume with two
> partitions of 20GB each with extent size of 1MB; then I create a
> subdirectory in the volume and mark it (using xfs_io util) as it belongs
> to the rt subvolume with inheritance flag.
> 
> After mounting that volume through NFSv3 / UDP; and trying a 'dd
> if=/dev/zero of=/mnt/rt/test bs=1M count=1000' the machine running NFSD
> hangs infinitely.

Did you manage to get a stack trace, OOC?  No reason why it shouldn't
work AFAIK.

cheers.

-- 
Nathan
