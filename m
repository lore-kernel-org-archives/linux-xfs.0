Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 00:25:31 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5F7PQWt029597
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 00:25:28 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <46723DC4.1080107@sgi.com>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070612014452.GK86004887@sgi.com>  <46723DC4.1080107@sgi.com>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 17:24:39 +1000
Message-Id: <1181892279.30716.1.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Johan Andersson <johan@e-626.net>, xfs@oss.sgi.com

On Fri, 2007-06-15 at 17:20 +1000, Timothy Shimmin wrote:
> 
> I don't know about a "long way" (longer to fully supported, yes)
> Firstly, I need to move its hooks out of linux-2.6/xfs_iops.c which
> were 
> referring to xfs inodes (instead of vnodes) probably back where they
> were in
> xfs_vnodeops.c.
> 
> Nathan, did you have some other suggestion than this - unfortunately,
> I haven't looked at this code (until recently) for a while. 

Geez, that takes me back - hummm, I seem to remember a possibly-iget-
related performance issue?  Not much else, sorry (it _is_ beer o'clock
on a Friday arvo after all...).

cheers.

--
Nathan
