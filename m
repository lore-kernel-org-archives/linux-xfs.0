Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 15:28:42 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NMSQG7013386
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:28:26 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id E73678F8115
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:30:09 -0700 (PDT)
Received: from [134.15.251.4] (melb-sw-corp-251-4.corp.sgi.com [134.15.251.4]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id JAA15139 for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 09:30:08 +1100
Message-ID: <490108E6.7060502@sgi.com>
Date: Fri, 24 Oct 2008 09:29:42 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: XFS performance tracking and regression monitoring
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>


We're about to deploy a system+jbod dedicated for performance
regression tracking. The idea is to build the XFS dev branch
nightly, run a bunch of self contained benchmarks, and generate
a progressive daily report - date on the X-axis, with (perhaps)
wallclock runtime on the y-axis.

The aim is to track relative XFS performance on a daily basis
for various workloads on identical h/w. If each workload runs for
approx the same duration, the reports can all share the same
generic y-axis. THe long term trend should have a positive
gradient. Regressions can be date correlated with commits.

Comments, benchmark suggestions? ANyone already running this?
Know of a test harness and/or report generator? Or will we
just roll our own - seems conceptually fairly simple.

Thanks

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
