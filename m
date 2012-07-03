Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63BiUNY085758 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 06:44:30 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id h8pRdkwgxxRTLZ79 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 04:44:29 -0700 (PDT)
Date: Tue, 3 Jul 2012 12:44:24 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703114424.GC14154@suse.de>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de> <20120701235458.GM19223@dastard>
	<20120702063226.GA32151@infradead.org>
	<20120702143215.GS14154@suse.de> <20120702193516.GX14154@suse.de>
	<20120703001928.GV19223@dastard> <20120703105951.GB14154@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703105951.GB14154@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Eugeni Dodonov <eugeni.dodonov@intel.com>

On Tue, Jul 03, 2012 at 11:59:51AM +0100, Mel Gorman wrote:
> > Can you run latencytop to see
> > if there is excessive starvation/wait times for allocation
> > completion?
> 
> I'm not sure what format you are looking for.  latencytop is shit for
> capturing information throughout a test and it does not easily allow you to
> record a snapshot of a test. You can record all the console output of course
> but that's a complete mess. I tried capturing /proc/latency_stats over time
> instead because that can be trivially sorted on a system-wide basis but
> as I write this I find that latency_stats was bust. It was just spitting out
> 
> Latency Top version : v0.1
> 
> and nothing else.  Either latency_stats is broken or my config is. Not sure
> which it is right now and won't get enough time on this today to pinpoint it.
> 

PEBKAC. Script that monitored /proc/latency_stats was not enabling
latency top via /proc/sys/kernel/latencytop

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
