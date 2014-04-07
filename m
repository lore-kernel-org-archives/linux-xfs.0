Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD0127FC8
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 17:57:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E116304039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 15:57:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Fmtm3vRS4bBWwPM9 for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 15:57:12 -0700 (PDT)
Date: Tue, 8 Apr 2014 08:57:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [FAQ v2] XFS speculative preallocation
Message-ID: <20140407225710.GC27017@dastard>
References: <20140407153906.GC48184@bfoster.bfoster> <53430375.3060203@sgi.com>
	<20140407214527.GA43531@bfoster.bfoster> <534324D0.3080701@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534324D0.3080701@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Apr 07, 2014 at 05:21:04PM -0500, Mark Tinguely wrote:
> On 04/07/14 16:45, Brian Foster wrote:
> >On Mon, Apr 07, 2014 at 02:58:45PM -0500, Mark Tinguely wrote:
> >>On 04/07/14 10:39, Brian Foster wrote:
> >>>XFS speculatively preallocates post-EOF blocks on file extending writes
> >>>in anticipation of future extending writes. The size of a preallocation
> >>>is dynamic and depends on the runtime state of the file and fs.
> >>>Generally speaking, preallocation is disabled for very small files and
> >>			vague what is very small?   ^^^
> >>...
> >
> >I originally pointed out 64k, but that and other heuristic details that
> >are subject to change were purged in v2. I'm personally not against
> >including something that indicates the default and the notion that it's
> >subject to change. I don't feel too strongly about it either way.
> >Thoughts appreciated.
> 
> 
> I think the details are good since everyone has a different idea on
> "very small". The FAQ can be changed with the code. You can expect
> the TOT FAQ to represent Linux 3.0-stable.

What's that supposed to mean? The FAQ on the xfs.org website does
not represent a specific release. It is supposed to contain the most
up-to-date information we have about various topics. If there's
something specific to a kernel version we need to mention, then
that's explicitly stated in the FAQ entry....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
