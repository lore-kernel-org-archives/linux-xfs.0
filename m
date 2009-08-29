Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7T7ieKJ206983 for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 02:44:51 -0500
Received: from stlx01.stz-softwaretechnik.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D821E40C1AD
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 00:45:31 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de
	[217.160.223.211]) by cuda.sgi.com with ESMTP id
	qNK6F9mMhqHbugkb for <xfs@oss.sgi.com>;
	Sat, 29 Aug 2009 00:45:31 -0700 (PDT)
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1
	(Debian)) id 1MhIcf-00027b-00
	for <xfs@oss.sgi.com>; Sat, 29 Aug 2009 09:45:17 +0200
Date: Sat, 29 Aug 2009 09:45:07 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: xfs data loss
Message-ID: <20090829074507.GN22826@p15145560.pureserver.info>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA653FA@DU-EXC-MAIL.empa.emp-eaw.ch>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA653FA@DU-EXC-MAIL.empa.emp-eaw.ch>
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
To: xfs@oss.sgi.com

Passerone, Daniele schrieb:
> Dear Eric, all
> During the night also the "twin" partition of the previously affected one
> 
> (/dev/md5) got problems, 
> this time with a clear hardware problem: 
> 
> one of the 20 disks was going on failure (2 devices missing).
> After that, and also after a reboot I cannot mount the partition:
> can't read superblock.


If it's a raid5 and 2 devices are missing, the raid is lost. Or am I
missing something?

Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
