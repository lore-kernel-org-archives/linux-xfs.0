Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19Bo9Vw164516
	for <linux-xfs@oss.sgi.com>; Thu, 9 Feb 2012 05:50:10 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id vcEpUxNcDU3S2w6e (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 03:50:05 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RvSVo-0002iM-00
	for linux-xfs@oss.sgi.com; Thu, 09 Feb 2012 12:50:04 +0100
Received: from mcbulge.astrouw.edu.pl ([193.0.88.93])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 09 Feb 2012 12:50:03 +0100
Received: from msz by mcbulge.astrouw.edu.pl with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 09 Feb 2012 12:50:03 +0100
From: Michal Szymanski <msz@astrouw.edu.pl>
Subject: Re: Question: Does XFS journal data or only metadata?
Date: Thu, 9 Feb 2012 11:45:38 +0000 (UTC)
Message-ID: <loom.20120209T122422-618@post.gmane.org>
References: <200502031005.57621.as@cohaesio.com>
	<200502031716.59894.as@cohaesio.com>
	<200502031724.56665.as@cohaesio.com>
	<200502031740.01081.as@cohaesio.com> <4202594B.3030204@xfs.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Steve Lord <lord <at> xfs.org> writes:

> > OK - After looking at the strace I checked the _other_ superblocks. 
> > As I only altered SB0, the other superblocks SB1+ still contains the  
> > old logstart value.
> > 
> > Wrote "logfile 0" to SB 0 - SB 15, and it all works! :)
> > 
> > It this the way to do it, or am I missing something obvious?
> > 
> 
> That is the way to do it, the tools are more picky than they used
> to be about this. Which is why getting the facility built into
> the tools would help a lot - since it would do the fixup of all
> superblocks itself.
> 
> Steve

This is a pretty old thread but I have not found anything newer, so
maybe somebody is still watching.

I went through internal->external log procedure as described here and
linked-to articles a few years  ago and it worked fine. These days I got
into similar problem after reconfiguring a disk which holds the 
external log for a XFS partition. The question to the gurus is
following:

Is it possible to migrate an external log to internal if the XFS
filesystem was originally created without  an internal log, i.e. it was
put on external device straight at mkfs.xfs invocation? 

xfs_growfs still says, after 7 years, at least in the man page, that
-l/-i/-x options are not implemented.  Is it really so?

regards, Michal.

PS. Just to comment on multiple SBs issue. The need for manually rewrite
ALL superblocks' data was  mentioned in the first comment (by Eric
Sandeen) to the excellent HOWTO written by Steve Lord in 
http://oss.sgi.com/archives/xfs/2003-11/msg00683.html 
The thread is titled:
It just begs the question everywhere: how to move a journaling
log to a new device?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
