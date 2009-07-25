Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6PAMYPC193820 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 05:22:34 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4528B3856D6
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 03:23:18 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id HKOOuThqEEJGMoFI for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 03:23:18 -0700 (PDT)
Date: Sat, 25 Jul 2009 12:22:58 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
Message-ID: <20090725102258.GA1121@citd.de>
References: <C68F8010.B953%elbles@sessys.com>
	<alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
	<20090725072617.GA30450@citd.de>
	<alpine.DEB.2.01.0907250241170.6426@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0907250241170.6426@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Sean Elble <elbles@sessys.com>, xfs@oss.sgi.com

On 25.07.2009 02:46, Christian Kujau wrote:
> On Sat, 25 Jul 2009 at 09:26, Matthias Schniedermeyer wrote:
> > >   # losetup -r /dev/loop0 /path/to/IRIXbackup
> > >   # hexedit /dev/loop0 ...or whatever tool you'll be using.
> > 
> > Which has what advantage over directly changing the image?
> 
> Sean mentioned the "thrashing of the old disk" and I figured I'd be 
> worried not only by that but that the old disk might die anytime soon. So 
> I wanted to present an alternative to do the search - I don't know too 
> much about his setup, so it's up to him to follow this advice or not.

I meant: What is the advantage of using the a loop-device (of the image) 
instead of directly using the image?

> > Even with just 10MB/s it's less than 4 Minutes for 2GB.
> > In comparison it takes over 3 hours to copy a modern 1TB HDD @ 80MB/s.
> 
> ?? (what kind of comparison is that?)

That you can read/write whole "ancient" discs without having to wait for 
hours?





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
