Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Jan 2007 07:55:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0HFtiqw006822
	for <xfs@oss.sgi.com>; Wed, 17 Jan 2007 07:55:45 -0800
Message-ID: <45AE46C2.6090005@sandeen.net>
Date: Wed, 17 Jan 2007 09:54:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: problem with latest xfsprogs progress code
References: <32920.193.203.83.22.1168965042.squirrel@colo.loreland.org> <53858.193.203.83.22.1169031614.squirrel@colo.loreland.org> <45AE2DDF.5000602@gmx.net>
In-Reply-To: <45AE2DDF.5000602@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Klaus Strebel <klaus.strebel@gmx.net>
Cc: jamesb@loreland.org, xfs@oss.sgi.com

Klaus Strebel wrote:

>>> Running 2.8.18 xfs_repair on a largeish (65TB, ~70M inodes) filesystem on
>>> an x86_64 machine gives the following "progress" output:
>>>
>>> 12:15:36: process known inodes and inode discovery - 1461632 of 0 inod
>>> es done
>>> 12:15:36: Phase 3: elapsed time 14 minutes, 32 seconds - processed 100
>>> 571 inodes per minute
>>> 12:15:36: Phase 3: 0% done - estimated remaining time 3364 weeks, 3 da
>>> ys, 7 hours, 30 minutes, 45 seconds
>>>
>>> Is this a known bug?
> Hi James,
> 
> why do you think that this is a bug? You have an almost infinitely large
> filesystem, so the file-system check will also run for an almost
> infinitely long time ;-).
> 
> You see, not all that's possible is really desirable.

Well, while 65TB is impressive*, and repairing it quickly is indeed a
challenge, it probably still should not take 64+ years.  ;-)

Sounds like something is in fact going wrong.

-Eric

*it amuses me to see xfs users refer to nearly 100T as largeISH; clearly
 you all do not suffer from lowered expectations.  :)
