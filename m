Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBCNblAF024737 for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 17:37:49 -0600
Received: from smtp4.clear.net.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE196171F3
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 15:37:41 -0800 (PST)
Received: from smtp4.clear.net.nz (smtp4.clear.net.nz [203.97.37.64]) by
	cuda.sgi.com with ESMTP id aVan8AG2t7UoUSe9 for
	<xfs@oss.sgi.com>; Fri, 12 Dec 2008 15:37:41 -0800 (PST)
Received: from kereru.site ([202.0.57.237])
	by smtp4.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0KBS006UPDJ2PW10@smtp4.clear.net.nz> for xfs@oss.sgi.com;
	Sat, 13 Dec 2008 12:06:39 +1300 (NZDT)
Date: Sat, 13 Dec 2008 12:06:29 +1300
From: Volker Kuhlmann <list0570@paradise.net.nz>
Subject: Re: Intel X25-E running Linux using XFS
In-reply-to: <20081212185803.GE11974@elf.ucw.cz>
Message-id: <20081212230629.GA2791@paradise.net.nz>
MIME-version: 1.0
Content-disposition: inline
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
	<20081212185803.GE11974@elf.ucw.cz>
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
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

Hi guys, can you take smartmontools-database-owner@lists.sourceforge.net
out of cc please? The list owner can't help with your discussion ;) Did
you mean smartmontools-database@.. ? Though that list is for collecting
hard disk data.

HTH,

Volker (list admin)



On Sat 13 Dec 2008 07:58:03 NZDT +1300, Pavel Machek wrote:

> 
> 
> Hi!
> 
> > Due to the 100k write cycle lifetime, I will not be performing any more 
> > benchmarks on the SSD itself, such benchmarks are available on  
> > techreport.com but just wanted to send out the smart data for the  
> > smartmontools list and point out it is working with linux+ich7+xfs.
> >
> > Overall, whenever I do anything now its just like the entire machine is
> > sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
> >
> > The techreport benchmarks are here:
> > http://techreport.com/articles.x/15931
> 
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?
> 
> Flashes I seen (USB / SD) developed bad sectors in that case, and
> ext2/ext3 can't handle that. (And I don't think xfs can handle that
> either).
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
Volker Kuhlmann			is list0570 with the domain in header
http://volker.dnsalias.net/	Please do not CC list postings to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
