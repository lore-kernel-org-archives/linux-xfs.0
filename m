Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 16:53:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PNrKdr004566
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:53:20 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8CF3107BA87
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:54:55 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 2aW4zo73flJF260P for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:54:55 -0700 (PDT)
Date: Fri, 26 Sep 2008 09:54:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Speed of rm compared to reiserfs (slow)
Message-ID: <20080925235453.GF27997@disturbed>
References: <48D9FDA1.8050701@gmail.com> <20080925002724.GA27997@disturbed> <48DB48E3.3020104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB48E3.3020104@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 11:16:35AM +0300, Török Edwin wrote:
> On 2008-09-25 03:27, Dave Chinner wrote:
> > On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
> Thanks for the suggestions, the time for rm has improved a bit, but is
> still slower than reiserfs:
> 
> time rm -rf gcc
> 
> real    1m18.818s
> user    0m0.156s
> sys     0m11.777s
> 
> Is there anything else I can try to make it faster?

Buy more disks. ;)

XFS is not really optimised for single disk, metadata intensive,
small file workloads. It scales by being able to keep lots of disks
busy at the same time. Those algorithms don't map to single disk
configs as efficiently as a filesystem that was specifically
designed for optimal performance for these workloads (like
reiserfs). We're working on making it better, but that takes time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
