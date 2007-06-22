Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 23:18:09 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P6I5do031238
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:18:06 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l5MNvLYL008345
	for <xfs@oss.sgi.com>; Fri, 22 Jun 2007 16:57:21 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l5MNvh5N029526
	for <xfs@oss.sgi.com>; Fri, 22 Jun 2007 16:57:43 -0700
Message-ID: <467C620E.4050005@agami.com>
Date: Fri, 22 Jun 2007 16:58:06 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: Reducing memory requirements for high extent xfs files
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com> <4666EC56.9000606@agami.com> <20070606234723.GC86004887@sgi.com>
In-Reply-To: <20070606234723.GC86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


> 
>  > Also, should we consider a file with 1MB extents as
>  > fragmented?  A 100GB file with 1MB extents has 100k extents.
> 
> Yes, that's fragmented - it has 4 orders of magnitude more extents
> than optimal - and the extents are too small to allow reads or
> writes to acheive full bandwidth on high end raid configs....

Fair enough, so multiply those numbers by 100 -- a 10TB file with 100MB
extents.  It seems to me that we can look at the negative effects of
fragmentation in two ways here.  First, (regardless of size) if a file
has a large number of extents, then it is too fragmented.  Second, if
a file's extents are so small that we can't get full bandwidth, then it
is too fragmented.

If the second case were of primary concern, then it would be reasonable
to have 1000s of extents as long as each of the extents were big enough
to amortize disk latencies across a large amount of data.

We've been assuming that a good write is one which can send
2MB of data to a single drive; so with an 8+1 raid device, we need
16MB of write data to achieve high disk utilization.  In particular,
there are flexibility advantages if high extent count files can
still achieve good performance.

   Michael
