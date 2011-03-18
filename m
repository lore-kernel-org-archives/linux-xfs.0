Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IFuvnA042587 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:57:02 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C81DB01D20
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 08:59:52 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	BMDR8eSdeox0SmD8 for <xfs@oss.sgi.com>;
	Fri, 18 Mar 2011 08:59:52 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 16:59:46 +0100
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
In-Reply-To: <30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
MIME-Version: 1.0
Message-Id: <201103181659.46558.arnd@arndb.de>
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
To: Tim Soderstrom <tim@moocowproductions.org>
Cc: Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Friday 18 March 2011, Tim Soderstrom wrote:

> > 
> > However, after some amount of time, the errors occur below, is this USB
> > stick failing?  Since it has no SMART, is there any other way to verify
> > the 'health' of a USB stick?
> 
> What prompted you to go with XFS over, say, ext2? The journal will generally
> cause quite a bit more writes onto your USB device. I use ext2 on my CF card 
> in my NAS for that reason (the spinning media is on XFS of course). I know
> that's not an answer to your problem but thought I would add it as a suggestion :)

Using ext2 on flash media instead of ext3 or other file systems is
recommended a lot, but the situation is actually much more complex.
In https://lwn.net/Articles/428584/, I explain how these things work
under the cover. For a drive that can only have very few erase blocks
open, using a journaled file system will always mean thrashing, but
for drives with more open erase blocks, it's probably better to
use a journal than not.

I still need to do simulations to figure out how this exactly
ends up on various file systems, and I had not considered XFS
so far.

Getting back to the rogiinal question, I'd recommend testing the
stick by doing raw accesses instead of a file system. A simple

dd if=/dev/sdX of=/dev/zero iflag=direct bs=4M

will read the entire stick and report any errors. The corresponding

dd of=/dev/zero of=/dev/sdX oflag=direct bs=4M

writes the entire stick. Some media won't report errors on write,
though, so this might not help you at all.

I'm also interested in results from flashbench
(git://git.linaro.org/people/arnd/flashbench.git, e.g. like
http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html)
That might help explain how the stick failed.

	Arnd


	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
