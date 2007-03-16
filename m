Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 04:31:28 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GBVM6p020213
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 04:31:24 -0700
Date: Fri, 16 Mar 2007 07:30:28 -0400
From: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Subject: Re: Strange XFS issue on tiny-NAS ARM NFS server
In-Reply-To: <20070315225959.GO6095633@melbourne.sgi.com>
References: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com>
 <45F85BFA.1070505@sandeen.net>
 <EXNANE01yeKzGZuNY1S000000cb@exnane01.hq.netapp.com>
 <EXNANE01pH71yEXUIEA000000d3@exnane01.hq.netapp.com>
 <20070315225959.GO6095633@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <EXNANE01FRaqbC8wSA1000000db@exnane01.hq.netapp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Talpey, Thomas" <Thomas.Talpey@netapp.com>, xfs@oss.sgi.com

At 06:59 PM 3/15/2007, David Chinner wrote:
>On Thu, Mar 15, 2007 at 07:34:37AM -0400, Talpey, Thomas wrote:
>> Evidently that was not the only compiling issue (surprise):
>> 
>> ><6>attempt to access beyond end of device
>> ><6>sda3: rw=2, want=2574098408, limit=154272195...
>That's a long way past the end of the partition.
>
>Tom, did you run xfs_repair on that filesystem after
>running with a busted compiler? Who knows how
>it broke stuff on disk.....

No, this was a freshly rebuilt ~80GB xfs. I was running a test on
it over NFS which wrote and read 500MB files repeatedly. And, it
ran for quite some time before failing. I haven't had a chance to
track it down at all.

Tom.
