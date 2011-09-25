Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8PM8ef9081526 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 17:08:40 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4005E18254C
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 15:08:39 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id 44GDC100tAwh7DOW for <xfs@oss.sgi.com>;
	Sun, 25 Sep 2011 15:08:39 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Mon, 26 Sep 2011 00:10:50 +0200
References: <4E1C70AD.1010101@u-club.de> <201109251532.20025.rjw@sisk.pl>
	<4E7FA3C7.5050503@u-club.de>
In-Reply-To: <4E7FA3C7.5050503@u-club.de>
MIME-Version: 1.0
Message-Id: <201109260010.50649.rjw@sisk.pl>
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
To: Christoph <cr2005@u-club.de>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

On Sunday, September 25, 2011, Christoph wrote:
> On 25.09.2011 15:32, Rafael J. Wysocki wrote:
> > On Sunday, September 25, 2011, Christoph wrote:
> >> test results of the patch below:
> >> 
> >> 1. real machine
> >> 
> >> suspends fine but on wakeup, after loading image: hard reset. nvidia
> >> gpu => disabled compitz  => wakeup worked two times.
> > 
> > Hmm, so there's a separate bug related to NVidia I guess.
> 
> Maybe.
> 
> Just made another test: the machine (macbook) woke up, loaded image, thaw.
> It got stuck at vt#1, displaying console with login. Cursor blinking, but
> no (usb) keyboard or network enabled. Bricked?!!
> 
> 
> On the other hand I've got another box with nvidia gpu:
> 
> debian5 32bit
> 2.6.38.2+ #3 SMP Fri Apr 1
> nvidia 260.19.36
> 
> It's up since I compiled the kernel: I use it twice a week and I kept it
> freezed all the time. It was solid rock until today: hard reset on resume.
> WTF? (I remember this version combo was stable on the macbook but the
> kernel lacks a solid wireless driver).

If that's an x86_64 system, there is a known bug causing problems like
this to happen.  There's a patch fixing it, but not conclusive:
http://marc.info/?l=linux-kernel&m=131653513414314&w=2

Thanks,
Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
