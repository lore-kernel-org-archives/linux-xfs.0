Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GCcssA206373 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 07:38:55 -0500
Received: from mail.uscreen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B934D53D045
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 05:38:53 -0700 (PDT)
Received: from mail.uscreen.net (mail.uscreen.net [62.67.233.10]) by
	cuda.sgi.com with ESMTP id ET0hoi7y3HSuJABC for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2011 05:38:53 -0700 (PDT)
Message-ID: <4E4A64D4.4000005@u-club.de>
Date: Tue, 16 Aug 2011 14:38:44 +0200
From: Christoph <cr2005@u-club.de>
MIME-Version: 1.0
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
References: <4E1C70AD.1010101@u-club.de> <201107262228.12099.rjw@sisk.pl>
	<20110727004543.GE8048@dastard> <201107271135.13297.rjw@sisk.pl>
	<20110810214327.GA9320@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110810214327.GA9320@atrey.karlin.mff.cuni.cz>
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
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Nigel Cunningham <nigel@tuxonice.net>, xfs@oss.sgi.com

On 10.08.2011 23:43, Pavel Machek wrote:
> Hi!
> 
>>>> Why don't you simply submit a patch to do that?
>>>
>>> a) I don't know how to test suspend/hibernate
>>> b) I don't have any hardware I can test it on.


Hi!

I do apologize fmy silence but I've been in a serious productions the last
weeks.

If there any patches to test, let me know. I can run some decent stress tests.

chris


> 
> hibernation should work on any hardware. Just add cmdline parameter
> resume=<your swap> and use echo disk > /sys/power/state.
> 
> suspend is supported on most PCs, and certainly on any notebook. Just
> echo mem > /sys/power/state.
> 									Pavel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
