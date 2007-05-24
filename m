Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 13:51:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4OKpOWt026420
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 13:51:25 -0700
Subject: Re: PARTIAL TAKE 964999 - lazy superblock counters for XFS
References: <20070522075932.E665058CA531@chook.melbourne.sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 May 2007 23:48:16 +0200
In-Reply-To: <20070522075932.E665058CA531@chook.melbourne.sgi.com>
Message-ID: <p73wsyxdhb3.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

dgc@sgi.com (David Chinner) writes:
> 
> The key to removing the contention is to not require the superblock
> fields in question to be locked. We do that by not marking the
> superblock dirty in the transaction. IOWs, we modify the incore
> superblock but do not modify the cached superblock buffer. In short,
> we do not log superblock modifications to critical fields in the
> superblock on every transaction. In fact we only do it just before
> we write the superblock to disk every sync period or just before
> unmount.

Does this mean it will increases performance on small systems too
due to less super block writes or is it purely for large
system scalability?

-Andi
