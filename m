Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Oct 2008 00:09:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A79g1G014768
	for <linux-xfs@oss.sgi.com>; Fri, 10 Oct 2008 00:09:42 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C4B113DB7E7
	for <linux-xfs@oss.sgi.com>; Fri, 10 Oct 2008 00:11:22 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id ttQtZTCt0uP2I9Ug for <linux-xfs@oss.sgi.com>; Fri, 10 Oct 2008 00:11:22 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [RFC, PATCH 0/7] XFS: dynamic busy extent tracking
Date: Fri, 10 Oct 2008 09:11:18 +0200
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> <200810092017.33042.Martin@lichtvoll.de> <20081009223328.GI9597@disturbed> (sfid-20081010_090018_216466_C5ADA5AA)
In-Reply-To: <20081009223328.GI9597@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100911.19345.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

Am Freitag 10 Oktober 2008 schrieben Sie:
> On Thu, Oct 09, 2008 at 08:17:32PM +0200, Martin Steigerwald wrote:
> > Hi Dave,

[...]

> > A student in the Linux Performance Tuning course I hold this week
> > compared this with ext3, even with the improved mkfs.xfs options (but
> > without lazy-count=1, cause mkfs.xfs from Debian Etch is too old) and
> > even with noop as IO scheduler. AFAIR XFS took roughly 3-4 times as
> > long as Ext3, I did not note the exact numbers. This was with 2.6.25.
> > I can repeat the test locally with 2.6.26.5 if wanted.
>
> Yes, that's par for the course. XFS journals transactions almost
> immediately, whereas ext3 gathers lots of changees in memory and
> checkpoints infrequently. Hence XFS writes a lot more to the
> journal and is hence slower. The dynamic extent tracking is a
> necessary step to moving the XFS journalling to a more
> checkpoint-like setup which would perform much less journal
> I/O and hence run substantially faster....
>
> See the asynchronous transaction aggregation section here:
>
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Jou
>rnal_Overhead

Thanks for the info Dave.

I still have your three mails about future improvements on XFS on my 
reading list. I just read a bit of the first one.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
