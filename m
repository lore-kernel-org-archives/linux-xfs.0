Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB25lFAG019636 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 23:47:15 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 4C6923041B7
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 21:47:11 -0800 (PST)
Received: from [134.15.251.1] (melb-sw-corp-251-1.corp.sgi.com [134.15.251.1])
	by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA27693 for
	<xfs@oss.sgi.com>; Tue, 2 Dec 2008 16:47:07 +1100
Message-ID: <4934CBD6.4040907@sgi.com>
Date: Tue, 02 Dec 2008 16:47:02 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: XFS patch queue & plan for 2.6.29 open season
Reply-To: markgw@sgi.com
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
To: xfs-oss <xfs@oss.sgi.com>


Looks like 2.6.28 will have another two RC's before 2.6.29 opens.
I'm unsure if that means before or after Christmas, but in any case
we need to be ready before Christmas - we will have a massive
pull request (largely but certainly not all due to the commit list held
over from 2.6.28).

Current status:

# The XFS master branch on oss has taken everything in Christoph's 
staging tree
   http://www.kernel.org/pub/linux/kernel/people/hch/xfs/xfs-staging/series

# We're about to take Eric's compat series (12 patches)

# Christoph recently sent out a couple of review pings ;-)
   These need some review please (Niv? or anyone?). In the IRC listing
   below, there are another 15 to 20 or so on the list that need review.

# After that, here's a quote from a public IRC chat late last week:

     <markgw>    that's only 30 patches - there are ~70 more still on 
the mail list
     <hch>    there's still a few more
     <hch>    -staging is the fully reviewd set
     <hch>    I have another about 15 to 20 that need review that I've 
recently posted
     <hch>    Eric has about 20 compat patches
     <hch>    Dave has some patches that he still needs to repost
     <hch>    and I also have some older stuff that needs reposting
     <hch>    and then there's the whole dmapi stuff that needs the 
xfs-dev tree
     <hch>    and once we have that cleared I have another at least 10 
that I haven't bothered (re)posting
     <hch>    and then there's the crc series which isn't for short-term 
commit
     <hch>    I'll have a new version of that too once the dependencies 
are in
     <markgw> ok so we'll just start with the fully reviewed set, then 
take some more and then stop and start testing for .29 candidate push

OK, so the remaining patches are mostly from Christoph, though looks like
Dave may have a few too. These are going to need a refresh against current
master branch (or xfs-dev for DMAPI & kdb). Christoph, would a new 
staging tree
be the best way to proceed, or should we start picking off the mail list?

On-going, *ideally* after a patch series has received final rv and ack,
the developer would post a git URL as the last post to the thread and we'd
just pull from that. I guess that'd be a sort of "xfs-next" collaborative
arrangement - we're all set up for this now (with git/ptools hooks in place
internally, etc).

Thanks

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
