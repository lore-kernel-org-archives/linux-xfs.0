Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2724F7CA6
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 02:12:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC58A304032
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 00:12:08 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id n6Vp3usiCrxvtF2e (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Apr 2016 00:12:05 -0700 (PDT)
Date: Mon, 4 Apr 2016 09:12:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/7] fs: introduce iomap infrastructure
Message-ID: <20160404071203.GA29313@lst.de>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
	<1457989370-6904-3-git-send-email-hch@lst.de>
	<20160404012849.GB11238@dastard> <20160404014706.GC11238@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160404014706.GC11238@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Apr 04, 2016 at 11:47:06AM +1000, Dave Chinner wrote:
> > Patch below fixes the issue, as well as the fact that
> > iomap_page_mkwrite_actor() needs to return the count of bytes
> > "written", not zero on success for iomap_write_segment() to do the
> > right thing on multi-segment writes.
> 
> Hmm - this fix then breaks generic/029. Christoph, can you look into
> these issues?

I've allocated some time for the series this week, I'll also add the
iomap based fiemap implementation from the gfs2 folks while I'm at it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
