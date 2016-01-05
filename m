Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A48E7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 18:23:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17C96304066
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 16:23:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rpjiS8hdt9pOcHmC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 16:23:49 -0800 (PST)
Date: Mon, 4 Jan 2016 16:23:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFCv4 00/22] xfs-documentation: massive cleanups and add v5
	format, reverse-mapping, reflink, and dedupe support
Message-ID: <20160105002318.GG28330@birch.djwong.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
	<20151220152936.GA20135@infradead.org>
	<20151220204657.GT26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220204657.GT26718@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 21, 2015 at 07:46:57AM +1100, Dave Chinner wrote:
> On Sun, Dec 20, 2015 at 07:29:36AM -0800, Christoph Hellwig wrote:
> > On Sat, Dec 19, 2015 at 01:12:08AM -0800, Darrick J. Wong wrote:
> > > This patch set does the following:
> > 
> > I'll review the actual patches once I'll get more time, but maybe it's a
> > good idea to split this series and get all the cleanups and fixes in
> > ASAP and only land the new reverse mapping and reflink bits once the
> > code hits mainline?
> 
> I'll be cherrying picking all the cleanups and fixes out of all the
> various patch series over the next couple days, so that's in effect
> what will happen...

If I did it right, the rmap/reflink content should be contained within their
respective patches.  Let me know if you find mistakes, though.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
