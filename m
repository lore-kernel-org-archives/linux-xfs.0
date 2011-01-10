Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AImKBo029101 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 12:48:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21A19FCDD36
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 10:50:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NDLYxPbRhaq9tIXo for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 10:50:32 -0800 (PST)
Date: Mon, 10 Jan 2011 13:50:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: no rw xfs file systems in mtab: /proc/mounts
Message-ID: <20110110185029.GB31325@infradead.org>
References: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
	<4D13648B.8000105@sandeen.net> <4D138457.8020008@gmail.com>
	<20101229130903.GD1035@infradead.org> <4D2B2BD6.60800@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D2B2BD6.60800@gmail.com>
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
To: Honza Fikar <j.fikar@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Jan 10, 2011 at 04:55:02PM +0100, Honza Fikar wrote:
> On 12/29/2010 02:09 PM, Christoph Hellwig wrote:
> > Can you please apply the debug patch below and see what output fsr gives
> > with it?
> 
> the output is:
> 
> #fsr/xfs_fsr -v -d
> fsr: cannot stat /dev/mapper/root
> no rw xfs file systems in mtab: /etc/mtab
> 
> /dev/mapper/root is really missing, even though mount shows:
> 
> /dev/mapper/root on / type xfs
> (rw,noatime,attr2,inode64,logbufs=8,logbsize=256k,noquota)
> 
> maybe it gets lost during initrd?
> 
> easy and dirty fix is ln -s /dev/root /dev/mapper/root

There's no easy way for xfs to work around the fact that a device
listed in /proc/mounts doesn't exist.

This might be a fallout of the big dm naming mess that happened due
to udev's insistance to be the only authority for device names.

I'd recommend to report a bug to your distribution about the
missing device name.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
