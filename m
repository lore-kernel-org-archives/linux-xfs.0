Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C50207F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 20:36:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3C50304053
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 18:36:11 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HpiiT7brBTguEz9r for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 18:36:06 -0800 (PST)
Date: Tue, 5 Jan 2016 13:36:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/22] xfsdocs: document the operation of the realtime
	device and inodes
Message-ID: <20160105023603.GH19802@dastard>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
	<20151219091351.15558.51417.stgit@birch.djwong.org>
	<20160103134151.GB9144@infradead.org>
	<20160105001450.GF28330@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105001450.GF28330@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 04:14:50PM -0800, Darrick J. Wong wrote:
> On Sun, Jan 03, 2016 at 05:41:51AM -0800, Christoph Hellwig wrote:
> > Looks generally good, although I wonder the take on the realtime device
> > is a bit too positive given that we generally advise people not to use
> > it.
> 
> Last time I tried formatting with a rt device (a month ago) the kernel crashed,
> as soon as I created an inode, so I guess we ought to warn people that this
> feature is severely bitrotted.
> 
> What /is/ the official status of XFS RT?  Most sane distros (looking right at
> you, Ubuntu) disable kernel support, so I guess:
> 
> ------------------------------------------------------------------------
> WARNING: The realtime feature is not well maintained.  Use with caution.
> ------------------------------------------------------------------------

It gets quite a long way through xfstests here before there's
an assert failure in the rt summary locking code. I'm planning on
fixing that when I get a chance and then running xfstests on it
regularly.

I also have patches for xfstests that allow the config section
code to use external devices, which makes it somewhat easier to
have a "forget+test" config....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
