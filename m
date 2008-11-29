Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mATN3PGN030222 for <xfs@oss.sgi.com>; Sat, 29 Nov 2008 17:03:26 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A100616241F5
	for <xfs@oss.sgi.com>; Sat, 29 Nov 2008 15:03:24 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 9w3Ey3A53Gtbd2tU for
	<xfs@oss.sgi.com>; Sat, 29 Nov 2008 15:03:24 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: hangs with MTRR_SANITIZER? - no, something else
Date: Sun, 30 Nov 2008 00:02:45 +0100
References: <200811252244.14718.Martin@Lichtvoll.de>
	<200811282339.24197.Martin@lichtvoll.de>
	<200811290824.38750.Martin@lichtvoll.de>
	(sfid-20081129_083903_406893_57EEF7DC)
In-Reply-To: <200811290824.38750.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811300002.45669.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org

Am Samstag 29 November 2008 schrieb Martin Steigerwald:
> Hi!
>
> CC'd to linux-kernel mailinglist, as that might be something that goes
> beyond any possible TuxOnIce or XFS issues. I know I am using TuxOnIce
> which is not part of the mainline kernel. And I am even using an
> inofficial patch - which I will use again unchanged for the non
> MTRR_SANITIZER kernel, in order to know whether its the MTRR_SANITIZER
> thing. And anyway before knowing whether it might be MTRR_SANITIZER
> related I need to run the non MTRR_SANITIZER kernel for at least a week
> and have quite some hibernate cycles. If someone else had issues with
> MTRR_SANITIZER I would like to hear about it. Also if someone thinks I
> am completely off track on trying to track this down I appreciate a
> hint.

Ok, its not MTRR_SANITIZER. It hung again on hibernate, again before any 
serious hibernating work has started. I will add debug output to my 
pre-hibernate script as it might hang already in there, maybe while 
disabling the network. I want to know whether it hangs before calling the 
hibernate script or after it. I think I will go for the latest official 
hibernate patch instead of using the inofficial one, although I am not 
convinced that it makes much of a difference. Lets see.

The syncs I added to my pre-hibernate seemed to help. KDE configuration is 
intact. As a safeguard I rsync ~/.kde to a backup directory before 
hibernating anyway.

Lets see what ideas I have to continue that Sherlock Holmes game ;)

I am puzzled that it only happens on my ThinkPad T42, not on the T23 and 
neither on the Dell workstation - till now.

Goodnight ;-),
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
