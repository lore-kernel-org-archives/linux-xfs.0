Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6P9jnwg192078 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 04:45:50 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93EEE13F6D5E
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 02:46:33 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.177]) by cuda.sgi.com with ESMTP id
	UtU9m1f4nQYhT8PC for <xfs@oss.sgi.com>;
	Sat, 25 Jul 2009 02:46:33 -0700 (PDT)
Date: Sat, 25 Jul 2009 02:46:19 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
In-Reply-To: <20090725072617.GA30450@citd.de>
Message-ID: <alpine.DEB.2.01.0907250241170.6426@bogon.housecafe.de>
References: <C68F8010.B953%elbles@sessys.com>
	<alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
	<20090725072617.GA30450@citd.de>
MIME-Version: 1.0
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Sean Elble <elbles@sessys.com>, xfs@oss.sgi.com

On Sat, 25 Jul 2009 at 09:26, Matthias Schniedermeyer wrote:
> >   # losetup -r /dev/loop0 /path/to/IRIXbackup
> >   # hexedit /dev/loop0 ...or whatever tool you'll be using.
> 
> Which has what advantage over directly changing the image?

Sean mentioned the "thrashing of the old disk" and I figured I'd be 
worried not only by that but that the old disk might die anytime soon. So 
I wanted to present an alternative to do the search - I don't know too 
much about his setup, so it's up to him to follow this advice or not.

> Even with just 10MB/s it's less than 4 Minutes for 2GB.
> In comparison it takes over 3 hours to copy a modern 1TB HDD @ 80MB/s.

?? (what kind of comparison is that?)

C.
-- 
BOFH excuse #443:

Zombie processes detected, machine is haunted.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
