Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1D237CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 16:31:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3C918F8040
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 14:31:38 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6Wo7kuHEPyJlPbZe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 14:31:37 -0800 (PST)
Date: Thu, 28 Jan 2016 14:31:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160128223131.GD6431@birch.djwong.org>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160128205333.GF20038@birch.djwong.org>
	<20160128211056.GA27287@lst.de>
	<20160128215853.GC6431@birch.djwong.org>
	<20160128220255.GA28202@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128220255.GA28202@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 11:02:55PM +0100, Christoph Hellwig wrote:
> On Thu, Jan 28, 2016 at 01:58:53PM -0800, Darrick J. Wong wrote:
> > Aw, snap, I knew I'd forgotten something.  Yep, we'll need that... I think
> > xfs_end_io_direct_write will have to sniff out the error status from "size"
> > and either remap or discard the CoW allocations as appropriate.
> 
> I'd rather fix the direct I/O code to give us that information directly
> (pun intended).  I'll add that to my short term todo list as it seems
> useful for the existing code as well.

Ok.

As for the generic/154... the code on github is sadly not very bisectable,
other than to say that until yesterday I was still tacking new code onto
the end of the patchset.

That said, I was seeing occasional hangs in generic/154 (I needed to roll
the transactions between key parts of wrapping up a CoW) and they seem to
have gone away, so it's possible that I've fixed it already.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
