Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 03:36:41 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GAaY6p003661
	for <linux-xfs@oss.sgi.com>; Fri, 16 Mar 2007 03:36:36 -0700
Received: from localhost (dslb-084-056-083-057.pools.arcor-ip.net [84.56.83.57])
	by mail.lichtvoll.de (Postfix) with ESMTP id 7CC525ADE6
	for <linux-xfs@oss.sgi.com>; Fri, 16 Mar 2007 11:36:33 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Questions about XFS
Date: Fri, 16 Mar 2007 11:36:31 +0100
References: <200703131440.56678.clflush@chello.be> <45F8CAEA.3050408@list.rakugaki.org> <200703151007.32630.clflush@chello.be>
In-Reply-To: <200703151007.32630.clflush@chello.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200703161136.32234.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 15 März 2007 schrieb clflush:
> From what I know, and correct me if I'm wrong, XFS relies on the
> application side to do the right job but real world experience shows us
> that *a lot* of applications out there behave badly and cannot be
> trusted hence if something happens, XFS cannot "correct" the problem
> leaving you with headaches behind depending on how much data you
> lost/corrupted and the importance of it. IMHO, XFS *should* do some
> effort at assuring integrity to minimize the bad behavior of badly
> written applications out there.

Hello,

as Eric wrote in this thread recent versions of XFS do an effort on 
avoiding these zeros in files:

"On the other hand, there were some changes made to xfs to explicitly 
sync files on close, if they have been truncated, which should help this 
sort of problem.  Depending on what's in OpenSuSE 10.2, that change may 
or may not be in your code..."

> On the one hand you have the old Ext3 FS which doesn't perform very
> well in many areas but IMO is a lot safer to work on (doesn't loose
> data that easily compared to XFS - and I'm talking from experience here
> because I use both file systems and I lost much more on the XFS system
> than on the Ext3 one) and on the other hand you have this excellent XFS
> file system with its clean layout and awesome performance + fancy
> features like GRIO, extents, allocate on flush, real time volumes, etc
> *but* is not "safe" enough to work with if you have unreliable hardware
> and/or a lot of power outage issues  - I've never lost data on Ext3
> during a power outage but already lost 2 times data on XFS

Since 2.6.17.7 and enabled write barriers I didn't loose meta data 
consistency on my laptop anymore and I can tell you that it crashed a lot 
due to my experiments with what not (especially OSS radeon drivers and 
beryl;-). I also had some classical power outages. I usually do not put a 
battery into my laptop if not needed.

And with recent XFS I did not encounter any data losses at all. Might have 
been luck, but before after a crash or power outage Akkregator told me 
sometimes that the file with the newsfeed stuff was corrupted and a 
backup has been restored. I didn't see this dialog since a long time on 
my laptop.

That given I would like to have more safety built into the filesystem 
itself, but at least current ext3 is too ancient technology for me. 
Coming from the Amiga a filesystem with a hard maximum number of inodes 
just doesn't fit my expectations (although original Amiga FFS has lot of 
shortcomings too;-).

The real challenge is to implement safety without serious loss of 
performance. You have more data safety in ext3, but less performance, and 
more performance in XFS, but potential less data safety with badly 
written applications. Not almost every bit of additional performance in 
XFS comes from transferring responsibility of data safety to the 
application, but I believe there is a relationship between safety and 
performance.

Maybe wandering logs / a log structured approach as (partly) seen in 
Reiser 4 and NetApp's WAFL might be a good approach to get more data 
safety without (much) less performance. (Well in the NetApp FAS non 
volatile RAM plays an important role, too.)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
