Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4AFXJcA072435 for <xfs@oss.sgi.com>; Tue, 10 May 2011 10:33:19 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7B9C1B88278
	for <xfs@oss.sgi.com>; Tue, 10 May 2011 08:33:18 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id HWK7ch1BB0P61Iz0 for
	<xfs@oss.sgi.com>; Tue, 10 May 2011 08:33:18 -0700 (PDT)
Date: Tue, 10 May 2011 17:33:00 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Files appear too big in `du`
Message-ID: <20110510153300.GA5764@citd.de>
References: <20110510105700.GA20307@citd.de> <20110510131705.GE19446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110510131705.GE19446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10.05.2011 23:17, Dave Chinner wrote:
> On Tue, May 10, 2011 at 12:57:00PM +0200, Matthias Schniedermeyer wrote:
> > Hi
> > 
> > 
> > Since a few weeks i'm experiencing an annoying 'thing' where files are 
> > often too big in `du` and directory totals are to high in `ls -l`.
> > 
> > I appears that files, which are in the process of beeing 
> > copied/downloaded/whatever, grow in large chunks ahead of time, while 
> > the actual file-content is beeing copied into the files.
> 
> It's supposed to work like this. It's called speculative allocation
> beyond end of file. XFS has always done this, but we've recently
> made it more aggressive to prevent excessive fragmentation on
> concurrent large file workloads when there is lots of disk space
> free.

OK.

> > And then it 
> > appears that the last chunk isn't shrunk after the process is finished.
> 
> It should be truncated away when the file descriptor is closed and
> the last reference goes away.
>
> > Neither xfs_bmap (Version 3.1.5) nor filefrag show anything beyond the 
> > extent that compromises the actual file-content.
> 
> what is the output of xfs_bmap -vvp on a file that apparently hasn't
> been shrunk? How do you know it hasn't been shrunk? Does it persist

du

> forever in this state, or does doing something like dropping caches
> (echo 3 > /proc/sys/vm/drop_caches) cause the specualtive
> preallocation to disappear?

This works:
sync ; echo 3 > /proc/sys/vm/drop_caches

At least in several tries the `du` output shrunk to the size of the 
original.

> > Any idea how to debug this, or is this a known bug and waiting a few 
> > days for 2.6.39 should fix this?
> 
> It doesn't appear to be doing anything wrong from your description.
> Remember that XFS is optimised for high end storage and server
> configurations and workloads, not typical desktop usage...

I would call it a regression.
I reguarly follow copying/downloading with `du`, the speculative
preallocation makes that more or less useless. Especially downloading 
someting big from the internet which @ 231kb/s isn't exactly fast and 
shows identical `du`s for increasingly longer periods of time.
(Or "--apparent-size" should be made default, but that falls short with 
sparse-files)

IMHO `du`/`ls -l` should not be able to 'see' the speculative 
preallocation.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
