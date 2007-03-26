Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 17:01:14 -0700 (PDT)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2Q0196p006266
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 17:01:10 -0700
From: Neil Brown <neilb@suse.de>
Date: Mon, 26 Mar 2007 10:01:01 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.3389.655835.610940@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from David Chinner on Sunday March 25
References: <17923.11463.459927.628762@notabene.brown>
	<1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local>
	<17923.35118.139991.252734@notabene.brown>
	<20070325031927.GG32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Sunday March 25, dgc@sgi.com wrote:
> On Fri, Mar 23, 2007 at 07:00:46PM +1100, Neil Brown wrote:
> > 
> > Why no barriers on an external log device??? Not important, just
> > curious.
> 
> because we need to synchronize across 2 devices, not one, so issuing
> barriers on an external log device does nothing to order the metadata
> written to the other device...

Right, of course.  Just like over a raid0.

So you must have code to wait for all writes to the main device before
writing the commit block on the journal.   How hard is it to fall-back
to that if the barrier fails?

NeilBrown
