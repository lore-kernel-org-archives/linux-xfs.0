Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBRDcQLb022027 for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 07:38:26 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DB1C4A20E
	for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 05:38:25 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id JCnaY7o9ffiXGA0w for
	<xfs@oss.sgi.com>; Sat, 27 Dec 2008 05:38:25 -0800 (PST)
Date: Sat, 27 Dec 2008 08:38:24 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Message-ID: <20081227133824.GH6284@josefsipek.net>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
	<495410F4.5010508@ziu.info>
	<alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
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

On Thu, Dec 25, 2008 at 06:46:37PM -0500, Justin Piszcz wrote:
> On Fri, 26 Dec 2008, Michal Soltys wrote:
> >> I am not worried about the filesystem as the defaults usually get it right 
> >> but with parted, this is the first time I had to use it for home use and 
> >> with RAID-6 I am noticing slower performance with 15 disks (1 is a spare) 
> >> in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 
> >> raptor150s in RAID-6 (but I had used fdisk there).
> >> 
> >> Justin.
> >> 
> >
> > For best effect - partition should start at 1920th sector (stripe width
> > boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
> > case. Parted shows the values normally - from the beginning of the volume, 0 
> > based.
> >
> >
> > ps.
> >
> > I dropped some of CCs.
> 
> Thanks.

It looks like you made why big partition. Why bother with partitioning at
all? If you just use the whole device, you _will_ be aligned properly if you
tell mkfs.xfs about the stripe unit/width.

Josef 'Jeff' Sipek.

-- 
All science is either physics or stamp collecting.
		- Ernest Rutherford

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
