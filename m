Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF09E7F5E
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:30:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC3D5304039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:30:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id midUnWrcuYYHcLW1 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:30:28 -0800 (PST)
Message-ID: <54ACC472.4010104@sandeen.net>
Date: Tue, 06 Jan 2015 23:30:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm> <54AC1511.1060908@sandeen.net>
	<2511571.nTXGg0tW6M@shtub-cm>
In-Reply-To: <2511571.nTXGg0tW6M@shtub-cm>
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
To: Hillel Lubman <shtetldik@gmail.com>
Cc: xfs@oss.sgi.com

On 1/6/15 11:17 PM, Hillel Lubman wrote:

> I see. Indeed, on the drive where I get sectsz as 512 by default, blockdev --getss --getpbsz reports:
> 
> 512
> 512

what kind of drive is this; is it usb, SATA, or ?

> However hdparm -I reports:
> 
> Logical Sector size: 512 bytes
> 
> Physical Sector size: 4096 bytes
> 
> So is it still worthwhile making sectsz 4 KB explicitly instead of
> using mkfs.xfs default in such case? And on a side note, since there
> is a more reliable way to figure that info out, may be mkfs.xfs
> should rather use that?
>

a) probably can't hurt
b) probably doesn't matter ;)

c) not sure why there are 2 different answers.  Knowing what kind of drive
it is would be good; mkfs.xfs just uses whatever blkid says.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
