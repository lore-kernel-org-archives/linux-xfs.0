Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3113F7F55
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 05:26:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11DCA304062
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 03:26:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	olr7j3LozuR0DPcm for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 03:26:25 -0700 (PDT)
Date: Wed, 19 Aug 2015 20:26:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Message-ID: <20150819102623.GK3902@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
	<20150819080940.GA13130@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150819080940.GA13130@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Jan Tulak <jtulak@redhat.com>

On Wed, Aug 19, 2015 at 01:09:40AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:
> > Hmmm, looks like I accidentally comitted an earlier version of this
> > patch yesterday. Jan, can you send delta patches to what I committed
> > to address more recent review comments? Sorry, my bad.
> 
> Can you revert it for now? I think most of these changes are incorrect
> and should either be dropped for now by disabling fsx or will need
> a major rework.

I'll just rebase the for-next branch, I guess, and remove it
completely from the history. I've got another lockdep fix that needs
to be pushed before it all hits tomorrow's linux-next build, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
