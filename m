Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 02:07:45 -0700 (PDT)
Received: from amsfep13-int.chello.nl (amsfep17-int.chello.nl [213.46.243.15] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2F97a6p027218
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 02:07:40 -0700
From: clflush <clflush@chello.be>
Subject: Re: Questions about XFS
Date: Thu, 15 Mar 2007 10:07:32 +0100
References: <200703131440.56678.clflush@chello.be> <1173890016.20671.11.camel@localhost.localdomain> <45F8CAEA.3050408@list.rakugaki.org>
In-Reply-To: <45F8CAEA.3050408@list.rakugaki.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Disposition: inline
Message-Id: <200703151007.32630.clflush@chello.be>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Taisuke Yamada <tyamadajp@list.rakugaki.org>
Cc: xfs@oss.sgi.com

>From what I know, and correct me if I'm wrong, XFS relies on the application 
side to do the right job but real world experience shows us that *a lot* of 
applications out there behave badly and cannot be trusted hence if something 
happens, XFS cannot "correct" the problem leaving you with headaches behind 
depending on how much data you lost/corrupted and the importance of it. IMHO, 
XFS *should* do some effort at assuring integrity to minimize the bad 
behavior of badly written applications out there. I know that XFS wasn't 
written for PC class hardware in the first place, but most people do not read 
enough to understand XFS and use it on their desktops/laptops because to be 
honest Linux doesn't really have a good file system, and XFS out of all 
available file systems, is the best in performance and scalability terms. 

On the one hand you have the old Ext3 FS which doesn't perform very well in 
many areas but IMO is a lot safer to work on (doesn't loose data that easily 
compared to XFS - and I'm talking from experience here because I use both 
file systems and I lost much more on the XFS system than on the Ext3 one) and 
on the other hand you have this excellent XFS file system with its clean 
layout and awesome performance + fancy features like GRIO, extents, allocate 
on flush, real time volumes, etc *but* is not "safe" enough to work with if 
you have unreliable hardware and/or a lot of power outage issues  - I've 
never lost data on Ext3 during a power outage but already lost 2 times data 
on XFS

Just my $0.02


On Thursday 15 March 2007 05:26:18 you wrote:
> From end-user's POV, this infamous XFS behavior is somewhat
> taken as XFS's inferiority compared to other filesystems.
> Even with "bad" applications (ex. firefox), this rarely happens
> on others, so regardless of what's on the FAQ, people logically
> concludes that the fault belongs to XFS anyway.
>
> So, what is the correct way to do IO?
> Is what firefox (and other bad apps) doing is so obvious(ly buggy),
> that it'll be acknowledged as a bug once reported? Or is it simply
> a mismatch between application expectation and XFS behavior,
> requiring a non-(obvious|generic) fix?
>
> Although I'm not a filesystem developer, I'm pretty impressed with
> XFS and willing to file a report/patch to those "buggy" apps if the
> issue is explainable to other app developers.
>
> >> was to press the reset button on the computer. After the reboot, when I
> >> opened Firefox again, I noticed that all my bookmarks were gone. Those
> >> bookmarks were imported from my desktop machine a few days after I
> >> configured the new server.
> >
> > This is a firefox bug - I've seen it before (on my mother's machine).
> >
> > It's due to firefox not doing the correct thing with IO on the bookmarks
> > file.
