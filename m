Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBRDwOHC022854 for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 07:58:24 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A64A5A5957B
	for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 05:58:23 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id j0BBgFTtLa2mJ97m for
	<xfs@oss.sgi.com>; Sat, 27 Dec 2008 05:58:23 -0800 (PST)
Date: Sat, 27 Dec 2008 08:58:22 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Message-ID: <20081227135822.GI6284@josefsipek.net>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
	<495410F4.5010508@ziu.info>
	<alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
	<20081227133824.GH6284@josefsipek.net>
	<alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Sat, Dec 27, 2008 at 08:53:21AM -0500, Justin Piszcz wrote:
> Why bother partitioning?  I also run a Linux SW RAID1 on the host, as you 
> know the drive letters can change when working on a server.
>
> Example: Before I created the array (RAID-6), my disks were /dev/sda,  
> /dev/sdb and /dev/sdc (spare), the RAID-6 was /dev/sdd.  After reboot,  
> /dev/sdd became /dev/sda and /dev/sd[a-c] became /dev/sd[b-d].
>
> In lilo.conf I had:
> raid-extra-boot="/dev/sda,/dev/sdb"
>
> If I ran LILO and forgot to fix the lilo.conf to reflect the new drive  
> mappings:
> raid-extra-boot="/dev/sdb,/dev/sdc"
>
> I could be at risk of ruining the partition?

Hrm...interesting point. LILO could mess up the superblock in sector 0.

> I try to avoid such situations when possible, to be safe.

:)

I don't know how LILO would handle it, but I would try to use
/dev/disk/by-*/* instead of the rather unstable /dev/sd* names.

Just my 0.02 cents.

Jeff.

-- 
Keyboard not found!
Press F1 to enter Setup

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
