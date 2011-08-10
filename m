Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ALhVL1210297 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:43:32 -0500
Received: from artax.karlin.mff.cuni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5A6618A2E93
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 14:43:28 -0700 (PDT)
Received: from artax.karlin.mff.cuni.cz (artax.karlin.mff.cuni.cz
	[195.113.26.195]) by cuda.sgi.com with ESMTP id
	cGxEdMEj5VWGDO8s for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 14:43:28 -0700 (PDT)
Date: Wed, 10 Aug 2011 23:43:27 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
Message-ID: <20110810214327.GA9320@atrey.karlin.mff.cuni.cz>
References: <4E1C70AD.1010101@u-club.de> <201107262228.12099.rjw@sisk.pl>
	<20110727004543.GE8048@dastard> <201107271135.13297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107271135.13297.rjw@sisk.pl>
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
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph <cr2005@u-club.de>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Nigel Cunningham <nigel@tuxonice.net>, xfs@oss.sgi.com

Hi!

> > > Why don't you simply submit a patch to do that?
> > 
> > a) I don't know how to test suspend/hibernate
> > b) I don't have any hardware I can test it on.

hibernation should work on any hardware. Just add cmdline parameter
resume=<your swap> and use echo disk > /sys/power/state.

suspend is supported on most PCs, and certainly on any notebook. Just
echo mem > /sys/power/state.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
