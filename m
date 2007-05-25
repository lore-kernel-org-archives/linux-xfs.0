Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 23:53:13 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4P6r7Wt012051
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 23:53:10 -0700
Date: Fri, 25 May 2007 08:53:03 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: PARTIAL TAKE 964999 - lazy superblock counters for XFS
Message-ID: <20070525065303.GA8094@one.firstfloor.org>
References: <20070522075932.E665058CA531@chook.melbourne.sgi.com> <p73wsyxdhb3.fsf@bingen.suse.de> <20070524232405.GE85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524232405.GE85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

> If you are running 100 concurrent transactions to your small
> filesystem, then yest, it will also help. But that sort of load
> is usually seen on file servers  or large compute boxes doing lots
> of file manipuations....

But won't you do less sb writes on any workload since the data
is stored elsewhere? 

-Andi
