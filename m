Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:05:24 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M45JMm001045
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:05:21 -0800
Date: Thu, 21 Feb 2008 23:05:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch, debug, 1/2] use atomic counters for ktrace buffer
	indexes
Message-ID: <20080222040545.GA16993@infradead.org>
References: <20080218230010.GT155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218230010.GT155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 19, 2008 at 10:00:10AM +1100, David Chinner wrote:
> ktrace_enter() is consuming vast amounts of CPU time
> due to the use of a single global lock for protecting
> buffer index increments. Change it to use per-buffer
> atomic counters - this reduces ktrace_enter() overhead
> during a trace intensive test on a 4p machine from 58%
> of all CPU time to 12% and halves test runtime.

This one is fine.
