Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Mar 2007 03:07:30 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2IA7M6p005390
	for <linux-xfs@oss.sgi.com>; Sun, 18 Mar 2007 03:07:25 -0700
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: cache+barriers vs cache+nobarriers vs disabled cache+barriers vs disabled cache+nobarriers
Date: Sun, 18 Mar 2007 12:07:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200703151339.36259.Martin@lichtvoll.de>
Message-Id: <20070318101304.BAA2E193E9@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Martin Steigerwald' <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

> > Hello All,
> >
> >
> > After reading http://oss.sgi.com/projects/xfs/faq.html#wcache
> > and some posts on the list I've got the following question:
> >
> > If I have disabled write cache on the disk (hdparm -W0 /dev/hda) and by
> > default FS is mounted with "barrier" enabled, Is there any taste in
> > enabling "barrier"(by default) because write cache is disabled anyway
> > or may be it's a good idea to mount with "nobarriers" in this case?
> 
> Hello Leon!
> 
> It is not needed to enable barriers when write cache is disabled. Enabling
> barriers in this case shouldn't have any visible effect I think.
> 

Thanks for your reply Martin,

My goal is to avoid filesystem corruption at any cost (while trying to use
fastest FS for linux) and according to the FAQ disabling write cache is the
right way to do it. 
Power/Hardware failure may occur in-between the flushes (with write barrier
enabled) so the safe way (I think) is to disable write cache.

It's interesting if there is a significant drop in the performance with
disabled disk "write cache" and XFS filesystem comparing to ext3+enabled
"write cache".

Has anyone some statistics or tests comparing ext3+enabled write cache vs.
xfs+disabled write cache?


Best Regards,
Leon Kolchinsky
