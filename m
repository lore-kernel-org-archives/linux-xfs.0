Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ8xTQ5029791 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 02:59:29 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B71BD160355D
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:59:28 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id JFaJ6cXZ5yXuOw9K for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 00:59:28 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Badness in key lookup (length)
Date: Wed, 26 Nov 2008 09:58:55 +0100
References: <200811252302.55944.Martin@Lichtvoll.de>
	<op.uk69gvj73jf8g2@pc-bnaujok.melbourne.sgi.com>
	(sfid-20081126_093725_926184_41341592)
In-Reply-To: <op.uk69gvj73jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811260958.56030.Martin@lichtvoll.de>
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

Am Mittwoch 26 November 2008 schrieb Barry Naujok:
> On Wed, 26 Nov 2008 09:02:55 +1100, Martin Steigerwald
>
> <Martin@lichtvoll.de> wrote:
> > Hi!
> >
> > I also checked my / XFS filesystem after that failed attempt to
> > hibernate via TuxOnIce (see my mail "truncated files"). Well BTW this
> > happened on a ThinkPad T42.
> >
> > While /home was fine, / had some rather minor - it seems - issues.
> > Whether
> > they have been from today or from whenever - I do not know.
>
> [snip]
>
> > My questions:
> >
> > 1) Whats those Badness in key lookup messages? Anything to worry
> > about?
>
> Generally not - the xfsprogs cache indexes read blocks by offset and
> I/O size. It will generate this warning if it encounters a read to the
> same offset with different I/O size. Basically there to tell me that
> there's a scenario where this may happen and should be fixed.

Ah okay. *feeling relieved*

> > 2) Why did xfs_repair -n after I ran xfs_repair yield yet another
> > error "would have reset inode 94530 nlinks from 2 to 3"? Why didn't
> > it appear in the first pass?
>
> There are remote cases where the first pass does not get the nlinks
> quite right - I would have needed a metadump before the first run to
> isolate where it miscounted the nlinks. All problems like this in
> the past have been related to lost+found.

Sorry for not taking it. I try to remember to take it when I stumble about 
another time. I have lost+found available still, but it won't be of much 
help I guess ;-).

> > martin@shambhala:~/Zeit/xfs-probleme-2008-11-25> grep 94530
> > xfsrepair-sda1-repair.txt
> > martin@shambhala:~/Zeit/xfs-probleme-2008-11-25#1>
> >
> > 3) Any idea how these problems occured in the first time?
>
> I think Dave pointed the cause out quite nicely :)

Well okay. Found TuxOnIce to be quite reliable till now. Might just had 
back luck then. Good reassurance to take regular backups regardless of 
what I think how reliable things are ;-).

> PS. Update the email address in your mailer to xfs@oss.sgi.com,
> not xfs-linux@oss.sgi.com.

Did so. Sorry for double posting without cancelling the old posts.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
