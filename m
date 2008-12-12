Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBCIuxX6010384 for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 12:57:00 -0600
Received: from atrey.karlin.mff.cuni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A2AE15F69
	for <xfs@oss.sgi.com>; Fri, 12 Dec 2008 10:56:55 -0800 (PST)
Received: from atrey.karlin.mff.cuni.cz (atrey.karlin.mff.cuni.cz
	[195.113.26.193]) by cuda.sgi.com with ESMTP id
	svMD94rEFocIzOuM for <xfs@oss.sgi.com>;
	Fri, 12 Dec 2008 10:56:55 -0800 (PST)
Date: Fri, 12 Dec 2008 19:58:03 +0100
From: Pavel Machek <pavel@suse.cz>
Subject: Re: Intel X25-E running Linux using XFS
Message-ID: <20081212185803.GE11974@elf.ucw.cz>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
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
Cc: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>


Hi!

> Due to the 100k write cycle lifetime, I will not be performing any more 
> benchmarks on the SSD itself, such benchmarks are available on  
> techreport.com but just wanted to send out the smart data for the  
> smartmontools list and point out it is working with linux+ich7+xfs.
>
> Overall, whenever I do anything now its just like the entire machine is
> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>
> The techreport benchmarks are here:
> http://techreport.com/articles.x/15931

Actually I'd like to know... how does it behave during powerfails
while it is being written to?

Flashes I seen (USB / SD) developed bad sectors in that case, and
ext2/ext3 can't handle that. (And I don't think xfs can handle that
either).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
