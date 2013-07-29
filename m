Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9C467F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 09:33:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29943AC003
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 07:33:53 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	VKfJujlxYFXpWtiI for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 07:33:51 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 4ABD61F00532
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:33:51 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ww3TMJgZby+2 for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:33:47 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 231041F0046E
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:33:47 -0400 (EDT)
Date: Mon, 29 Jul 2013 10:33:47 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <22688573.2526.1375108427119.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F5EB56.5040909@hardwarefreak.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>

> >>> And... all the way back to Jason's original question:
> >>>
> >>> The way that you get the information out of a kernel/kernel RPM to
> >>> determine which XFS version it's running... is? Cause it's clearly
> >>> not obvious to either him or me.
> >>
> >> The "version" of XFS that you are running is that of the
> >> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> >
> > IOWS: There is no spoon. ;)
> 
> Excellent quote Eric, love the Matrix movies.
> 
> I think the problem here is a lack of understanding of the kernel
> development and commit process. AFAIK there's not a single Linux
> subsystem that has a standalone version number or versioning scheme.
> Not the other filesystems, not the USB subsystem, SCSI, ATA, etc. The
> version of each is simply the version of the kernel they are included
> in.
> 
> I've been wondering throughout this thread where anyone got the idea
> that there is an XFS version that can be traced/tracked. Maybe because
> xfsprogs have a version number? The way to track XFS changes from
> kernel to kernel is to look at the commits, as others have already
> stated.

I got it from the fact that Jason was asked -- and when I was working with
Dave a couple weeks ago, *I* was asked -- "which XFS code we had".

Filesystems are one of the few kernel subsystems which "leave tracks", and
for it, therefore, *matters* which version of the code you're running,
and that's why the issue comes up.

There *is* an "XFS version", by inspection of these conversations, and
by general knowledge of how filesystem drivers work.  That it's backwards
compatible isn't really germane to the point that *there are different
versions of the code*.  If those versions matter, than that's why we
version-number things: so the people having problems and the people
providing support can have reasonable, cogent conversations where they
know what the hell they're talking about.

And yes, I *don't* know kernel build practice, cause *I don't work with
those people*.  We're sorta hoping you guys do, and therefore can tell us
*which quantity we're supposed to be trying to find*, so that we can 
answer the questions you ask us while you're trying to help us fix problems
in your code, for free.

If the question is "which GIT version was checked out to build the kernel SRPM
that made the kernel RPM I'm running from", just say that, and if necessary,
we'll go off and look. 

But let's not try to pretend that "there is no version" of the XFS kernel code,
because clearly there is.

If there's no "version number"... well, that's not something I would be bragging
about.

I really do apologize for sounding so combative about this stuff; I'm not really
trying to be, but "things have version numbers" has been best practice for 3 
decades for a reason, and I think it's a pretty good one: avoiding fights like
this.

Cheers,
-- jra

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
