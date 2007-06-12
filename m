Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 00:11:11 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5C7B5Wt023491
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 00:11:06 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5C7B5Wt027819
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 03:11:05 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5C7B5WG031148
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 01:11:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5C78ud2015801
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 01:11:05 -0600
Date: Tue, 12 Jun 2007 11:46:52 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070612061652.GA6320@amitarora.in.ibm.com>
References: <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512080157.GF85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Sat, May 12, 2007 at 06:01:57PM +1000, David Chinner wrote:
> On Fri, May 11, 2007 at 04:33:01PM +0530, Suparna Bhattacharya wrote:
> > On Fri, May 11, 2007 at 08:39:50AM +1000, David Chinner wrote:
> > > All I'm really interested in right now is that the fallocate
> > > _interface_ can be used as a *complete replacement* for the
> > > pre-existing XFS-specific ioctls that are already used by
> > > applications.  What ext4 can or can't do right now is irrelevant to
> > > this discussion - the interface definition needs to take priority
> > > over implementation....
> > 
> > Would you like to write up an interface definition description (likely
> > man page) and post it for review, possibly with a mention of apps using
> > it today ?
> 
> Yeah, I started doing that yesterday as i figured it was the only way
> to cut the discussion short....
> 
> > One reason for introducing the mode parameter was to allow the interface to
> > evolve incrementally as more options / semantic questions are proposed, so
> > that we don't have to make all the decisions right now. 
> > So it would be good to start with a *minimal* definition, even just one mode.
> > The rest could follow as subsequent patches, each being reviewed and debated
> > separately. Otherwise this discussion can drag on for a long time.
> 
> Minimal definition to replace what applicaitons use on XFS and to
> support poasix_fallocate are the thre that have been mentioned so
> far (FA_ALLOCATE, FA_PREALLOCATE, FA_DEALLOCATE). I'll document them
> all in a man page...

Hi Dave,

Did you get time to write the above man page ? It will help to push
further patches in time (eg. for FA_PREALLOCATE mode).

The idea I had was to push the patch with bare minimum functionality
(FA_ALLOCATE and FA_DEALLOCATE modes) and parallely finalize on other
new mode(s) based on the man page you planned to provide.

Thanks!
--
Regards,
Amit Arora

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
