Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 10:49:24 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4CHn2fB010718
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 10:49:04 -0700
Subject: Re: Review: Concurrent Multi-File Data Streams
References: <20070511003606.GB85884050@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 May 2007 20:46:19 +0200
In-Reply-To: <20070511003606.GB85884050@sgi.com>
Message-ID: <p73sla1ev7o.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner <dgc@sgi.com> writes:
> 
> The following patch survives XFSQA with timeouts set to minimum,
> default, 500s and maximum. The patch has not had a great
> deal of low memory testing, and the object cache may need a shrinker
> interface to work in low memory conditions.
> 
> Comments?

It seems to be an optimization for a relatively small number of streams. When you
do a large number on average you should get similar readahead benefits
from round robing the streams over some AGs vs keeping it in a single AG,
right? 

The fallback to AG 0 if nstreams>AGs seems pretty lousy. Wouldn't it be better 
to do the normal XFS allocation algorithm then?  I think right now it will
go into low space mode in this case, which might give worse results.

Also centisecs is a really ugly unit whose use should be probably not propagated.

-Andi
