Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6KtVii009995 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 14:55:32 -0600
Received: from rn-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D9AB16D428F
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 12:55:30 -0800 (PST)
Received: from rn-out-0910.google.com (rn-out-0910.google.com
	[64.233.170.187]) by cuda.sgi.com with ESMTP id
	tYJoBFh3jTeldeKL for <xfs@oss.sgi.com>;
	Sat, 06 Dec 2008 12:55:30 -0800 (PST)
Received: by rn-out-0910.google.com with SMTP id 56so663657rnw.8
	for <xfs@oss.sgi.com>; Sat, 06 Dec 2008 12:55:30 -0800 (PST)
Message-ID: <f73f7ab80812061255t25924931u8c9a3367e8b8159c@mail.gmail.com>
Date: Sat, 6 Dec 2008 15:55:29 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	<493A5E62.1020508@msgid.tls.msk.ru>
	<alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
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
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Dec 6, 2008 at 7:11 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece, my
> entire system used ~100-120watts with all 12 velociraptors on a 650 watt PSU
> (now moved into a test system).

You should actually break it down further than that.  During system
development recently, the company I work for was using some 350W PSUs
with funny connectors patched in place of the standard molex to drive
the 5V power for some small embedded system testbeds and their drives.
 We were hard-power-cycling the systems by unplugging them from the
bus and we kept having problems with the *other* embedded board
resetting when we did so.  Turns out the "350W" PSU was only rated to
supply 100W to the 5V leads, and our 55W systems (40W for board and
15W for drive) were a little too far past the edge.

In addition, most hard drives, motherboards, etc have circuits powered
separately from the 3.3V, 5V, and 12V busses.  If your *load* is
balanced too heavily on one or the other of the supplies, you can see
extremely weird problems.  When the 12V-powered spindle and
spindle-controller on your HDD loses power but the 5V-powered SATA or
SAS interface does not, its internal state machine gets all kinds of
messed up.  If you can get ahold of one, I'd recommend finding an
oscilliscope to hook up to the 5V and 12V lines into those drives.

Cheers,
Kyle Moffett

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
